SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9kR: Pistols"
SWEP.PrintName = "Colt Python"

SWEP.Slot = 1
SWEP.HoldType = "revolver"
SWEP.Spawnable = true

SWEP.ViewModelFOV = 65
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_pist_python.mdl"
SWEP.WorldModel = "models/weapons/w_colt_python.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/coltpython/clipdraw.mp3",
		iDelay = 0.05
	},
	{
		sSound = "weapons/coltpython/blick.mp3",
		iDelay = 0.05 + 0.50
	},
	{
		sSound = "weapons/coltpython/bulletsout.mp3",
		iDelay = 0.05 + 0.50 + 0.50
	},
	{
		sSound = "weapons/coltpython/bulletsout.mp3",
		iDelay = 0.05 + 0.50 + 0.50 + 0.35
	},
	{
		sSound = "weapons/coltpython/bulletsin.mp3",
		iDelay = 0.05 + 0.50 + 0.50 + 0.35 + 0.85
	},
	{
		sSound = "weapons/coltpython/blick.mp3",
		iDelay = 0.05 + 0.50 + 0.50 + 0.35 + 0.85 + 0.55
	}
}

SWEP.tDrawSoundSequence = {
	{
		sSound = "weapons/coltpython/clipdraw.mp3",
		iDelay = 0.05
	}
}

SWEP.Primary.Sound = "weapons/coltpython/python-1.wav"

SWEP.Primary.RPM = 105
SWEP.Primary.ClipSize = 6
SWEP.Primary.KickUp = 8
SWEP.Primary.KickDown = 3
SWEP.Primary.KickHorizontal = 4
SWEP.Primary.Automatic = false
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 65
SWEP.Primary.Spread = .016
SWEP.Primary.Ammo = "357"

SWEP.IronSightsPos = Vector(-2.743,-1.676,1.796)
SWEP.IronSightsAng = Vector(0.611,0.185,0)

SWEP.LegacyBalance = {
	Primary = {
		RPM = 115,
		ClipSize = 6,
		KickUp = 1,
		KickDown = 0.5,
		KickHorizontal = 0.5,
		Automatic = false,
		NumShots = 1,
		Damage = 29,
		Spread = .02
	}
}