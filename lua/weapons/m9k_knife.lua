SWEP.Base = "meteors_melee_base_model"
SWEP.Category = "M9kR: Specialties"
SWEP.PrintName = "Knife"

SWEP.HoldType = "knife"
SWEP.Spawnable = true

SWEP.Primary.Damage = 30

SWEP.ViewModelFOV = 55
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/cstrike/c_knife_t.mdl" -- Does not require any game apart from Garry's Mod even though it is from CS:S
SWEP.WorldModel = "models/weapons/w_extreme_ratio.mdl" -- We make our own since the original is horrible, ^ same goes for viewmodel

SWEP.ModelWorldForwardMult = -1
SWEP.ModelWorldRightMult = 0.5
SWEP.ModelWorldUpMult = -1
SWEP.ModelWorldAngForward = -10
SWEP.ModelWorldAngRight = -190
SWEP.ModelWorldAngUp = -170

SWEP.ViewModelScale = Vector(0.75,0.75,0.75)
SWEP.ModelViewRightMult = 0.45
SWEP.ModelViewUpMult = -1.5
SWEP.ModelViewAngForward = 15
SWEP.ModelViewAngRight = -190
SWEP.ModelViewAngUp = 190
SWEP.ModelViewBlacklistedBones = {
	["v_weapon.Knife_Handle"] = true,
	["v_weapon.Right_Arm"] = true
}

SWEP.DrawSound = "weapons/blades/deploy.mp3"
SWEP.SwingSound = "weapons/blades/woosh.mp3"
SWEP.SwingDelay = 0.05

SWEP.DoViewPunch = false
SWEP.HitRange = 65

SWEP.AttackDelay = 0.55
SWEP.ThrowDelay = 0.25

SWEP.bCanThrow = true
SWEP.sProjectileClass = "m9k_thrown_spec_knife"
SWEP.sProjectileModel = "models/weapons/w_extreme_ratio.mdl"


function SWEP:SecondaryAttack() -- Right click hits twice as hard.
	if not self:CanPrimaryAttack() then return end

	local iCur = CurTime()


	self.SwingDelayOld = self.SwingDelay
	self.SwingDelay = 0.20


	self:PrimaryAttack()
	self:SetNextPrimaryFire(iCur)
	self:PrimaryAttack()

	self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
	self:AttackAnimation()


	self.SwingDelay = self.SwingDelayOld
	self.SwingDelayOld = nil


	self:SetNextPrimaryFire(iCur + 1.5)

end