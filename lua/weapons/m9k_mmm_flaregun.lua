SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9K Additions (MMM)"
SWEP.PrintName = "Flaregun"

SWEP.Slot = 1
SWEP.HoldType = "revolver"
SWEP.Spawnable = true

SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_flaregun.mdl"
SWEP.WorldModel = "models/weapons/w_357.mdl"

SWEP.Primary.Sound = "weapons/mmm/flaregun-fire.mp3"
SWEP.Primary.RPM = 20
SWEP.Primary.ClipSize = 1

SWEP.Primary.KickUp = 12
SWEP.Primary.KickDown = 5
SWEP.Primary.KickHorizontal = 6
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "rzmflaregun"
SWEP.Primary.NumShots = 0
SWEP.Primary.Damage = 0
SWEP.Primary.Spread = 0

SWEP.IronSightsPos = Vector(-5.7,0,2)
SWEP.IronSightsAng = Vector(2,0,0)

local CachedColor1 = Color(255,93,0,255)
local AngleCache1 = Angle(90,0,0)
local VectorCache1 = Vector(0,0,1)
local MetaE = FindMetaTable("Entity")
local CPPIExists = MetaE.CPPIGetOwner and true or false

function SWEP:Initialize()
	self.OurIndex = self:EntIndex()
	self:SetColor(CachedColor1)
	self:SetMaterial("models/debug/debugwhite")

	if SERVER and game.SinglePlayer() then -- In singleplayer we need to force the weapon to be equipped after spawning
		timer.Simple(0,function()
			if not IsValid(self) or not IsValid(self.Owner) then return end -- We need to abort when the owner already had the weapon!
			self.Owner:SelectWeapon(self:GetClass())
		end)
	end

	if CLIENT then
		self.WepSelectIcon = surface.GetTextureID("vgui/hud/m9k_mmm_flaregun")

		if self.Owner == LocalPlayer() then
			self:SendWeaponAnim(ACT_VM_IDLE)

			if self.Owner:GetActiveWeapon() == self then -- Compat/Bugfix
				self:Equip()
				self:Deploy()
			end
		end
	end

	self.ReloadingTime = 0
end

function SWEP:IronSight()
	if self.ReloadingTime ~= 0 or self.Owner:GetViewEntity() ~= self.Owner or not self:GetNWBool("CanIronSights") then return end

	if self.Owner:KeyPressed(IN_ATTACK2) and not self.IronSightState then
		self.Owner:SetFOV(80,0.2)
		self.IronSightState = true
		self.DrawCrosshair = false
		self.LastCurTick = RealTime()
	elseif self.Owner:KeyReleased(IN_ATTACK2) then
		self.Owner:SetFOV(0,0.1)
		self.IronSightState = false
		self.DrawCrosshair = true
	end
end

function SWEP:PrimaryAttack()
	if self.Owner:WaterLevel() == 3 then -- No weapons may fire underwater
		self:EmitSound("Weapon_Pistol.Empty")
		self:SetNextPrimaryFire(CurTime() + 0.2)
		return
	end

	if self:CanPrimaryAttack() and self:GetNextPrimaryFire() < CurTime() then
		self:SetNextPrimaryFire(CurTime() + 0.5)

		if SERVER then
			self:TakePrimaryAmmo(1)

			local aim = self.Owner:GetAimVector()
			local side = aim:Cross(VectorCache1)
			local pos = self.Owner:GetShootPos() + side * 6 + side:Cross(aim) * -5

			local rocket = ents.Create("m9k_launched_flare")
			rocket:SetAngles(aim:Angle() + AngleCache1)
			rocket:SetPos(pos)

			rocket:SetOwner(self.Owner)

			if CPPIExists then
				rocket:CPPISetOwner(self.Owner)
			else
				rocket:SetNWEntity("my_owner",self.Owner) -- TinyCPPI Compatibility
			end

			rocket:Spawn()
			rocket:Activate()

			SafeRemoveEntityDelayed(rocket,10)

			local Phys = rocket:GetPhysicsObject()
			if IsValid(Phys) then
				Phys:SetVelocity(self.Owner:GetAimVector() * 2500)
				Phys:SetDragCoefficient(10)
			end
		end

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

		self:AttackAnimation()
		self:EmitSound(self.Primary.Sound,100) -- This is very loud yes
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	end
end

function SWEP:Holster()
	if not SERVER and self.Owner ~= LocalPlayer() then return end

	if self.IronSightState then
		self.Owner:SetFOV(0,0.3)
		self.IronSightState = false
		self.DrawCrosshair = true
	end

	timer.Remove("MMM_Flaregun_Reload_" .. self.OurIndex)
	self.Owner:StopSound("weapons/mmm/flaregun-reload1.mp3")
	return true
end

function SWEP:Reload()
	if self.CanReload and self.ReloadingTime == 0 and self:Clip1() < self.Primary.ClipSize and self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 then
		self.Owner:SetAnimation(PLAYER_RELOAD)
		self:DefaultReload(ACT_VM_HOLSTER)

		if self.IronSightState then
			self.Owner:SetFOV(0,0.1)
			self.IronSightState = false
			self.DrawCrosshair = true
		end

		self.ReloadingTime = CurTime() + 3.7
		self:SetNextPrimaryFire(self.ReloadingTime)

		if SERVER then -- Only play it once and for everyone!
			self.Owner:EmitSound("weapons/mmm/flaregun-reload1.mp3",65)
		end

		timer.Remove("MMM_Flaregun_Reload_" .. self.OurIndex)
		timer.Create("MMM_Flaregun_Reload_" .. self.OurIndex,2.6,1,function()
			if not IsValid(self) or not IsValid(self.Owner) or not IsValid(self.Owner:GetActiveWeapon()) or self.Owner:GetActiveWeapon():GetClass() ~= self.ClassName then return end
			self:SendWeaponAnim(ACT_VM_DRAW)
			self.ReloadingTime = 0
		end)
	end
end

if CLIENT then
	function SWEP:FireAnimationEvent(_,_,event) -- No muzzleflash
		if event == 22 or event == 6001 then return true end
	end
end