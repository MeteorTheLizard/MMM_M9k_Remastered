SWEP.Base = "meteors_melee_base_model"
SWEP.Category = "M9kR: Specialties"
SWEP.PrintName = "Machete"

SWEP.HoldType = "knife"
SWEP.Spawnable = true

SWEP.Primary.Damage = 60

SWEP.ViewModelFOV = 55
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/cstrike/c_knife_t.mdl" -- Does not require any game apart from Garry's Mod even though it is from CS:S
SWEP.WorldModel = "models/weapons/w_fc2_machete.mdl" -- We make our own since the original is horrible, ^ same goes for viewmodel

SWEP.ModelWorldForwardMult = -0.5
SWEP.ModelWorldRightMult = 0.5
SWEP.ModelWorldUpMult = -0.25
SWEP.ModelWorldAngForward = -10
SWEP.ModelWorldAngRight = -200
SWEP.ModelWorldAngUp = -170

SWEP.ViewModelScale = Vector(0.75,0.75,0.75)
SWEP.ModelViewRightMult = 0.65
SWEP.ModelViewUpMult = -1
SWEP.ModelViewAngForward = 15
SWEP.ModelViewAngRight = -190
SWEP.ModelViewAngUp = 190
SWEP.ModelViewBlacklistedBones = {
	["v_weapon.Knife_Handle"] = true,
	["v_weapon.Right_Arm"] = true
}

SWEP.DrawSound = "weapons/knife/knife_draw_x.mp3"
SWEP.SwingSound = "weapons/blades/woosh.mp3"
SWEP.SwingDelay = 0.05

SWEP.DoViewPunch = false
SWEP.HitRange = 75

SWEP.AttackDelay = 0.55
SWEP.ThrowDelay = 0.25

SWEP.bCanThrow = true
SWEP.sProjectileClass = "m9k_thrown_knife"
SWEP.sProjectileModel = "models/weapons/w_fc2_machete.mdl"

SWEP.vForceAngle = Vector(35,0,0)