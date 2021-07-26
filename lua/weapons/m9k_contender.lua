SWEP.Base = "bobs_scoped_base"
SWEP.Category = "M9K Sniper Rifles"
SWEP.PrintName = "Thompson Contender G2"

SWEP.HoldType = "revolver"
SWEP.Spawnable = true

SWEP.ViewModelFOV = 65
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_contender2.mdl"
SWEP.WorldModel = "models/weapons/w_g2_contender.mdl"

SWEP.Primary.Sound = "contender_g2.Single"
SWEP.Primary.RPM = 45
SWEP.Primary.ClipSize = 1
SWEP.Primary.KickUp = 4
SWEP.Primary.KickDown = 3
SWEP.Primary.KickHorizontal = 5
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "SniperPenetratedRound"
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 75
SWEP.Primary.Spread = .30
SWEP.Primary.SpreadBefore = SWEP.Primary.Spread

SWEP.ScopeScale = 0.7
SWEP.ReticleScale = 0.6

function SWEP:Holster() -- Make sure the special reload animation gets canceled
	if not SERVER and self.Owner ~= LocalPlayer() then return end

	if self.IronSightState then
		self.Owner:SetFOV(0,0.3)
		self.IronSightState = false
		self.DrawCrosshair = true
	end

	self:SetNWInt("ScopeState",0)
	timer.Remove("Contender_Reload_" .. self.OurIndex)
	return true -- We have to return true
end

function SWEP:PrimaryAttack()
	if self.Owner:WaterLevel() == 3 then -- No weapons may fire underwater
		self:EmitSound("Weapon_Pistol.Empty")
		self:SetNextPrimaryFire(CurTime() + 0.2)
		return
	end

	if self:CanPrimaryAttack() and self:GetNextPrimaryFire() < CurTime() then
		local Spread = self.Primary.Spread

		if self.Owner:GetVelocity():Length() > 100 then
			Spread = self.Primary.Spread * 6
		elseif self.Owner:KeyDown(IN_DUCK) then
			Spread = self.Primary.Spread / 2
		end

		self:SetNextPrimaryFire(CurTime() + 1 / (self.Primary.RPM / 60))
		self:TakePrimaryAmmo(1)
		self:ShootBullet((1 * self.Primary.Damage) * math.Rand(.85,1.3),self.Primary.Recoil,self.Primary.NumShots,Spread)
		self:AttackAnimation()
		self:EmitSound(self.Primary.Sound)
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
		self:MuzzleFlash() -- IDK if this is really needed tbh

		-- The following part is needed for the viewmodel to not glitch out but also follow logic
		if self:Clip1() == 0 and self.Owner:GetAmmoCount(self.Primary.Ammo) >= 1 then
			self.CanReload = false
			self.ScopeCD = CurTime() + 1.5
			self:SetNWInt("ScopeState",0)
			self.Owner:SetFOV(0,0.1)
			self.Owner:SetAnimation(PLAYER_RELOAD)

			local TimerName = "Contender_Reload_" .. self.OurIndex
			timer.Create(TimerName,1.6,1,function() -- Seems to be a tiny bit faster than the viewmodel animation which is what we want
				if not IsValid(self) or not IsValid(self.Owner) or not IsValid(self.Owner:GetActiveWeapon()) or self.Owner:GetActiveWeapon():GetClass() ~= self.ClassName then return end

				self:SetClip1(1)
				self.Owner:RemoveAmmo(1,self.Primary.Ammo)
				self.CanReload = true
			end)
		else
			self:SendWeaponAnim(ACT_VM_IDLE)
		end
	end
end

function SWEP:Reload()
	if self:GetNWInt("ScopeState") > 0 then
		self.Owner:SetFOV(0,0.1)
		self:SetNWInt("ScopeState",0)
		self.ScopeCD = CurTime() + 0.2
		self.Owner:EmitSound("weapons/zoom.wav")
		self.NextReloadTime = CurTime() + 0.5
	end

	if self.CanReload and self.NextReloadTime < CurTime() and self.Owner:GetAmmoCount(self.Primary.Ammo) >= 1 and self:Clip1() < self:GetMaxClip1() then
		self:DefaultReload(ACT_VM_RELOAD)
		self.Owner:SetAnimation(PLAYER_RELOAD)
	end
end

if CLIENT then
	local CachedTextureID1 = surface.GetTextureID("scope/gdcw_scopesight")

	function SWEP:DrawHUD()
		if self.Owner:GetViewEntity() ~= self.Owner then return end

		if self:GetNWInt("ScopeState") > 0 then
			if self.DrawCrosshair then -- Only set the vars once (this is faster)
				self.Owner:DrawViewModel(false)
				self.DrawCrosshair = false
			end

			surface.SetDrawColor(0,0,0,255)
			surface.SetTexture(CachedTextureID1)
			surface.DrawTexturedRect(self.LensTable.x,self.LensTable.y,self.LensTable.w,self.LensTable.h)
		elseif not self.DrawCrosshair then -- Only set the vars once (this is faster)
			self.Owner:DrawViewModel(true)
			self.DrawCrosshair = true
		end
	end
end