SWEP.Base = "meteors_melee_base_model"
SWEP.Category = "M9kR: Specialties"
SWEP.PrintName = "Harpoon"

SWEP.HoldType = "melee"
SWEP.Spawnable = true

SWEP.Primary.Damage = 67

SWEP.ViewModelFOV = 55
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/cstrike/c_knife_t.mdl" -- Does not require any game apart from Garry's Mod even though it is from CS:S
SWEP.WorldModel = "models/props_junk/harpoon002a.mdl" -- We make our own since the original is horrible

SWEP.ModelWorldForwardMult = 3.25
SWEP.ModelWorldRightMult = 2
SWEP.ModelWorldAngForward = 20
SWEP.ModelWorldAngRight = -20
SWEP.ModelWorldAngUp = -95

SWEP.ViewModelScale = Vector(0.6,0.6,0.6)
SWEP.ModelViewForwardMult = -3.6
SWEP.ModelViewRightMult = 2.65
SWEP.ModelViewUpMult = 7.5
SWEP.ModelViewAngForward = -60
SWEP.ModelViewAngRight = -25
SWEP.ModelViewAngUp = 50
SWEP.ModelViewBlacklistedBones = {
	["v_weapon.Knife_Handle"] = true,
	["v_weapon.Right_Arm"] = true
}

SWEP.IsBlade = false

SWEP.DrawSound = "weapons/knife/knife_draw_x.mp3"
SWEP.SwingSound = "weapons/blades/woosh.mp3"
SWEP.SwingDelay = 0.15

SWEP.DoViewPunch = false
SWEP.HitRange = 135

SWEP.AttackDelay = 1.10
SWEP.ThrowDelay = 0.25

SWEP.bCanThrow = true
SWEP.sProjectileClass = "m9k_thrown_harpoon"
SWEP.sProjectileModel = "models/props_junk/harpoon002a.mdl"

SWEP.vForceAngle = Vector(0,0,0)

SWEP.iPrimaryAnim = ACT_VM_SECONDARYATTACK