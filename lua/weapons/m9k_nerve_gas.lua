SWEP.Base = "meteors_grenade_base_model"
SWEP.Category = "M9kR: Specialties"
SWEP.PrintName = "Nerve Gas"

SWEP.Spawnable = true

SWEP.ViewModelFOV = 55
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/cstrike/c_eq_fraggrenade.mdl"
SWEP.WorldModel = "models/healthvial.mdl"

SWEP.Primary.Ammo = "NerveGas"

SWEP.WorldModelStr = "models/healthvial.mdl"
SWEP.ViewModelStr = "models/healthvial.mdl"

SWEP.WorldTexture = "models/weapons/gv/nerve_vial.vmt"
SWEP.ViewTexture = "models/weapons/gv/nerve_vial.vmt"

SWEP.ModelWorldForwardMult = 4.25
SWEP.ModelWorldRightMult = 1.75
SWEP.ModelWorldUpMult = -5.5
SWEP.ModelWorldAngForward = 5
SWEP.ModelWorldAngRight = 15
SWEP.ModelWorldAngUp = -80

SWEP.ViewModelScale = Vector(0.6,0.6,0.6)
SWEP.ModelViewForwardMult = 4
SWEP.ModelViewRightMult = 2.5
SWEP.ModelViewUpMult = -4
SWEP.ModelViewAngForward = -5
SWEP.ModelViewAngRight = 10
SWEP.ModelViewAngUp = -100
SWEP.ModelViewBlacklistedBones = {
	["v_weapon.Flashbang_Parent"] = true,
	["v_weapon.strike_lever"] = true,
	["v_weapon.safety_pin"] = true,
	["v_weapon.pull_ring"] = true
}

SWEP.GrenadeClassEnt = "m9k_nervegasnade"
SWEP.GrenadeModelStr = "models/healthvial.mdl"
SWEP.GrenadeMaterialStr = "models/weapons/gv/nerve_vial.vmt"
SWEP.GrenadeThrowAng = Angle(0,0,-45)
SWEP.GrenadeTrailCol = Color(225,0,0)
SWEP.GrenadeNoPin = true