SWEP.Base = "bobs_shotty_base"
SWEP.Category = "M9K Specialties"
SWEP.PrintName = "EX41"

SWEP.Slot = 5
SWEP.HoldType = "shotgun"
SWEP.Spawnable = true

SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_ex41.mdl"
SWEP.WorldModel = "models/weapons/w_ex41.mdl"

SWEP.Primary.Sound = "40mmGrenade.Single"
SWEP.Primary.ClipSize = 3
SWEP.Primary.DefaultClip = 3
SWEP.Primary.KickUp = 1
SWEP.Primary.KickDown = 0.3
SWEP.Primary.KickHorizontal = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "40mmGrenade"

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
		self:SetNextPrimaryFire(CurTime() + 1.5)
		self:TakePrimaryAmmo(1)

		local aim = self.Owner:GetAimVector()
		local side = aim:Cross(VectorCache1)
		local pos = self.Owner:GetShootPos() + side * 6 + side:Cross(aim) * -5

		if SERVER then
			local rocket = ents.Create("m9k_launched_m79") -- We use the m79 entity here since its identical with the original EX41 one
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

		if self:Clip1() == 0 then -- Don't cock when empty! SMH
			self:SendWeaponAnim(ACT_VM_DRAW) -- This is an extremely ugly hack, but it works I guess
		end
	end
end