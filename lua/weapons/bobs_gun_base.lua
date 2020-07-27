MMM_M9k_IsBaseInstalled = true -- Absolutely avoid global variables like this whenever possible and if there is no way around it, make it as unique as possible.

SWEP.SlotPos = 1

SWEP.Spawnable = false
SWEP.AdminSpawnable = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.DrawAmmo = true
SWEP.DrawCrosshair = true
SWEP.DrawWeaponInfoBox = false
SWEP.BounceWeaponIcon = false

SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = true

SWEP.HoldType = "pistol"

SWEP.Primary.Sound = ""
SWEP.Primary.Cone = 0.2
SWEP.Primary.Recoil = 10
SWEP.Primary.Damage = 10
SWEP.Primary.Spread = .01
SWEP.Primary.NumShots = 1
SWEP.Primary.RPM = 0
SWEP.Primary.ClipSize = 0
SWEP.Primary.DefaultClip = 0

SWEP.Primary.KickUp = 0
SWEP.Primary.KickDown = 0
SWEP.Primary.KickHorizontal = 0
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Ammo = "none"

SWEP.CanReload = false
SWEP.CanIronSights = false

SWEP.AimMul = 0.2
SWEP.LastCurTick = 0

local BannedClasses = { -- These weapons use the gun_base but shouldn't be affected by moving spread
	["m9k_m3"] = true,
	["m9k_browningauto5"] = true,
	["m9k_dbarrel"] = true,
	["m9k_ithacam37"] = true,
	["m9k_mossberg590"] = true,
	["m9k_jackhammer"] = true,
	["m9k_remington870"] = true,
	["m9k_spas12"] = true,
	["m9k_striker12"] = true,
	["m9k_1897winchester"] = true,
	["m9k_1887winchester"] = true,
	["m9k_usas"] = true,
	["m9k_remington1858"] = true,
	["m9k_hk45_admin"] = true,
	["m9k_l85_admin"] = true,
	["m9k_amd65_admin"] = true
}

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	self.OurIndex = self:EntIndex()

	if CLIENT then
		self.WepSelectIcon = surface.GetTextureID(string.gsub("vgui/hud/name","name",self:GetClass()))

		if self.Owner == LocalPlayer() then
			self:SendWeaponAnim(ACT_VM_IDLE)

			if self.Owner:GetActiveWeapon() == self then -- Compat/Bugfix
				self:Equip()
				self:Deploy()
			end
		end
	end
end

function SWEP:Equip()
	if SERVER and not self.Owner:IsPlayer() then
		self:Remove()
		return
	end
end

function SWEP:Deploy()
	self:SetHoldType(self.HoldType)

	local vm = self.Owner:GetViewModel()
	if IsValid(vm) then -- This is required since the code should only run on the server or on the player holding the gun (Causes errors otherwise)
		self.CanReload = false
		self.CanIronSights = false
		self:SendWeaponAnim(ACT_VM_DRAW)

		local Dur = vm:SequenceDuration() + 0.1
		self:SetNextPrimaryFire(CurTime() + Dur)
		self:SetNextSecondaryFire(CurTime() + Dur)

		timer.Remove("MMM_M9k_Deploy_" .. self.OurIndex)
		timer.Create("MMM_M9k_Deploy_" .. self.OurIndex,Dur,1,function()
			if not IsValid(self) or not IsValid(self.Owner) or not IsValid(self.Owner:GetActiveWeapon()) or self.Owner:GetActiveWeapon():GetClass() ~= self:GetClass() then return end
			self.CanIronSights = true
			self.CanReload = true
		end)
	end

	return true
end

function SWEP:PrimaryAttack()
	if self.Owner:WaterLevel() == 3 then -- No weapons may fire underwater
		self:EmitSound("Weapon_Pistol.Empty")
		self:SetNextPrimaryFire(CurTime() + 0.2)
		return
	end

	if self:CanPrimaryAttack() then
		local Spread = self.Primary.Spread

		if not BannedClasses[self:GetClass()] then
			if self.Owner:GetVelocity():Length() > 100 then
				Spread = self.Primary.Spread * 6
			elseif self.Owner:KeyDown(IN_DUCK) then
				Spread = self.Primary.Spread / 2
			end
		end

		self:SetNextPrimaryFire(CurTime() + 1 / (self.Primary.RPM / 60))
		self:TakePrimaryAmmo(1)
		self:ShootBullet((1 * self.Primary.Damage) * math.Rand(.85,1.3),self.Primary.Recoil,self.Primary.NumShots,Spread)
		self.Owner:SetAnimation(PLAYER_ATTACK1)
		self:EmitSound(self.Primary.Sound)
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
		self:MuzzleFlash() -- IDK if this is really needed tbh
	end
end

function SWEP:ShootBullet(damage,_,num_bullets,aimcone)
	num_bullets = num_bullets or 1
	aimcone = aimcone or 0

	local bullet = {
		Num = num_bullets,
		Src = self.Owner:GetShootPos(),
		Dir = self.Owner:GetAimVector(),
		Spread = Vector(aimcone,aimcone,0),
		Tracer = 3,
		TracerName = "Tracer",
		Force = damage * 0.3,
		Damage = damage
	}

	local KickUp = self.Primary.KickUp
	local KickDown = self.Primary.KickDown
	local KickHorizontal = self.Primary.KickHorizontal

	if self.Owner:KeyDown(IN_DUCK) then
		KickUp = self.Primary.KickUp / 2
		KickDown = self.Primary.KickDown / 2
		KickHorizontal = self.Primary.KickHorizontal / 2
	end

	local SharedRandom = Angle(util.SharedRandom("m9k_gun_kick1",-KickDown,-KickUp),util.SharedRandom("m9k_gun_kick2",-KickHorizontal,KickHorizontal),0)
	self.Owner:ViewPunch(SharedRandom) -- This needs to be shared

	if SERVER and game.SinglePlayer() or SERVER and self.Owner:IsListenServerHost() then -- This is specifically for the host or when in singleplayer
		local eyes = self.Owner:EyeAngles()
		eyes:SetUnpacked(eyes.pitch + SharedRandom.pitch,eyes.yaw + SharedRandom.yaw,0)
		self.Owner:SetEyeAngles(eyes)
	elseif CLIENT and not game.SinglePlayer() then -- This is for other players in multiplayer (Or anyone on the server if dedicated)
		local eyes = self.Owner:EyeAngles()
		eyes:SetUnpacked(eyes.pitch + (SharedRandom.pitch/5),eyes.yaw + (SharedRandom.yaw/5),0)
		self.Owner:SetEyeAngles(eyes)
	end

	self:ShootEffects()
	self.Owner:FireBullets(bullet) -- The bullet always comes out last! (Stop messing with simple logic pls.)
end

function SWEP:SecondaryAttack()
	return false
end

function SWEP:Reload()
	if self.CanReload and self.Owner:GetAmmoCount(self.Primary.Ammo) >= 1 and self:Clip1() < self.Primary.ClipSize then
		if self.IronSightState then
			self.Owner:SetFOV(0,0.3)
			self.IronSightState = false
			self.DrawCrosshair = true
		end

		self.Owner:SetAnimation(PLAYER_RELOAD)
		self:DefaultReload(ACT_VM_RELOAD)
	end
end

function SWEP:Holster()
	if not SERVER and self.Owner ~= LocalPlayer() then return end

	if self.IronSightState then
		self.Owner:SetFOV(0,0.3)
		self.IronSightState = false
		self.DrawCrosshair = true
	end

	return true
end

function SWEP:IronSight()
	if self.Owner:GetViewEntity() ~= self.Owner or not self.CanIronSights then return end

	if self.Owner:KeyPressed(IN_ATTACK2) and not self.IronSightState then
		self.Owner:SetFOV(80,0.2)
		self.IronSightState = true
		self.DrawCrosshair = false
	elseif self.Owner:KeyReleased(IN_ATTACK2) then
		self.Owner:SetFOV(0,0.1)
		self.IronSightState = false
		self.DrawCrosshair = true
	end
end

function SWEP:Think()
	self:IronSight()
end

if CLIENT then
	function SWEP:GetViewModelPosition(pos,ang)
		if not self.IronSightsPos then return pos, ang end

		self.AimMul = self.IronSightState and (self.AimMul + math.abs(self.LastCurTick - RealTime())*5) or (self.AimMul - math.abs(self.LastCurTick - RealTime())*5)

		self.AimMul = math.Clamp(self.AimMul,0.2,1)
		self.LastCurTick = RealTime()

		if self.IronSightsAng then
			ang:RotateAroundAxis(ang:Right(),self.IronSightsAng.x * self.AimMul)
			ang:RotateAroundAxis(ang:Up(),self.IronSightsAng.y * self.AimMul)
			ang:RotateAroundAxis(ang:Forward(),self.IronSightsAng.z * self.AimMul)
		end

		pos = pos + self.IronSightsPos.x * ang:Right() * self.AimMul
		pos = pos + self.IronSightsPos.y * ang:Forward() * self.AimMul
		pos = pos + self.IronSightsPos.z * ang:Up() * self.AimMul

		return pos, ang
	end

	local effectData = EffectData() -- We don't have to re-create this
	effectData:SetAttachment(1)
	effectData:SetScale(1)
	effectData:SetFlags(0)

	function SWEP:FireAnimationEvent(_,_,event)
		if event == 5001 or event == 5011 or event == 5021 or event == 5031 then
			if self.Owner:GetViewEntity() ~= self.Owner then return end

			effectData:SetEntity(self.Owner:GetViewModel())
			util.Effect("CS_MuzzleFlash",effectData)

			return true
		end
	end
end