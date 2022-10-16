SWEP.Base = "meteors_grenade_base_model"
SWEP.Category = "M9kR: Specialties"
SWEP.PrintName = "M61 Grenade"

SWEP.Spawnable = true

SWEP.ViewModelFOV = 55
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/cstrike/c_eq_fraggrenade.mdl"
SWEP.WorldModel = "models/weapons/w_m61_fraggynade.mdl"

SWEP.Primary.Ammo = "Grenade"

SWEP.ModelWorldForwardMult = 3
SWEP.ModelWorldRightMult = 2
SWEP.ModelWorldUpMult = -1.5
SWEP.ModelWorldAngRight = 190
SWEP.ModelWorldAngUp = 110

SWEP.ViewModelScale = Vector(0.9,0.9,0.9)
SWEP.ModelViewForwardMult = 3.5
SWEP.ModelViewRightMult = 2
SWEP.ModelViewUpMult = -1.5
SWEP.ModelViewAngForward = -15
SWEP.ModelViewAngRight = 180
SWEP.ModelViewAngUp = 110
SWEP.ModelViewBlacklistedBones = {
	["v_weapon.Flashbang_Parent"] = true,
	["v_weapon.strike_lever"] = true,
	["v_weapon.safety_pin"] = true,
	["v_weapon.pull_ring"] = true
}

SWEP.GrenadeClassEnt = "m9k_thrown_m61"
SWEP.GrenadeModelStr = "models/weapons/w_m61_fraggynade_thrown.mdl"
SWEP.GrenadeThrowAng = Angle(0,0,-45)
SWEP.GrenadeTrailCol = Color(225,0,0)