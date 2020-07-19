SWEP.Base = "bobs_shotty_base"
SWEP.Category = "M9K Specialties"
SWEP.PrintName = "Milkor Mk1"

SWEP.Slot = 5
SWEP.HoldType = "shotgun"
SWEP.Spawnable = true

SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/v_milkor_mgl1.mdl"
SWEP.WorldModel = "models/weapons/w_milkor_mgl1.mdl"

SWEP.Primary.Sound = "40mmGrenade.Single"
SWEP.Primary.RPM = 250
SWEP.Primary.ClipSize = 6

SWEP.Primary.KickUp = 0
SWEP.Primary.KickDown = 0
SWEP.Primary.KickHorizontal = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "40mmGrenade"
SWEP.Primary.NumShots = 0
SWEP.Primary.Damage = 0
SWEP.Primary.Spread = 0
SWEP.ShellTime = .5

local AngleCache1 = Angle(90,0,0)
local VectorCache1 = Vector(0,0,1)
local MetaE = FindMetaTable("Entity")
local CPPIExists = MetaE.CPPISetOwner and true or false

function SWEP:PrimaryAttack()
	if self.Owner:WaterLevel() == 3 then -- No weapons may fire underwater
		self:EmitSound("Weapon_Pistol.Empty")
		self:SetNextPrimaryFire(CurTime() + 0.2)
		return
	end

	if self.InsertingShell and not self.CanceledReloadSuccess then
		self:FinishReloading()
	elseif self:CanPrimaryAttack() and not self.InsertingShell then
		self:SetNextPrimaryFire(CurTime() + 1 / (self.Primary.RPM / 60))
		self:TakePrimaryAmmo(1)

		local aim = self.Owner:GetAimVector()
		local side = aim:Cross(VectorCache1)
		local pos = self.Owner:GetShootPos() + side * 6 + side:Cross(aim) * -5

		if SERVER then
			local rocket = ents.Create("m9k_launched_m79")
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
		end

		self.Owner:SetAnimation(PLAYER_ATTACK1)
		self:EmitSound(self.Primary.Sound)
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	end
end