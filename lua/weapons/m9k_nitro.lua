SWEP.Base = "meteors_grenade_base_model_instant"
SWEP.Category = "M9kR: Specialties"
SWEP.PrintName = "Nitro Glycerine"

SWEP.Spawnable = true

SWEP.ViewModelFOV = 55
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/cstrike/c_eq_fraggrenade.mdl"
SWEP.WorldModel = "models/weapons/w_nitro.mdl"

SWEP.Primary.Ammo = "nitroG"

SWEP.ModelWorldForwardMult = 2
SWEP.ModelWorldRightMult = 24
SWEP.ModelWorldUpMult = 8
SWEP.ModelWorldAngRight = 190
SWEP.ModelWorldAngUp = 185

SWEP.ViewModelScale = Vector(0.75,0.75,0.75)
SWEP.ModelViewForwardMult = -11.5
SWEP.ModelViewRightMult = 9
SWEP.ModelViewUpMult = 4
SWEP.ModelViewAngForward = -5
SWEP.ModelViewAngRight = 190
SWEP.ModelViewAngUp = -110
SWEP.ModelViewBlacklistedBones = {
	["v_weapon.Flashbang_Parent"] = true,
	["v_weapon.strike_lever"] = true,
	["v_weapon.safety_pin"] = true,
	["v_weapon.pull_ring"] = true
}

SWEP.GrenadeClassEnt = "m9k_thrown_nitrox"
SWEP.GrenadeModelStr = "models/weapons/w_nitro.mdl"
SWEP.GrenadeThrowAng = Angle(0,0,-45)
SWEP.GrenadeTrailCol = Color(225,255,0)
SWEP.GrenadeNoPin = true