SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9kR: Submachine Guns"
SWEP.PrintName = "KRISS Vector"

SWEP.Slot = 2
SWEP.HoldType = "smg"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_kriss_svs.mdl"
SWEP.WorldModel = "models/weapons/w_kriss_vector.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/Kriss/magrel.mp3",
		iDelay = 0.25
	},
	{
		sSound = "weapons/Kriss/clipout.mp3",
		iDelay = 0.25 + 0.10
	},
	{
		sSound = "weapons/Kriss/clipin.mp3",
		iDelay = 0.25 + 0.10 + 0.85
	},
	{
		sSound = "weapons/Kriss/boltpull.mp3",
		iDelay = 0.25 + 0.10 + 0.85 + 1.15
	}
}

SWEP.tDrawSoundSequence = {
	{
		sSound = "weapons/Kriss/unfold.mp3",
		iDelay = 0.30
	}
}

SWEP.Primary.Sound = "weapons/Kriss/ump45-1.wav"

SWEP.Primary.RPM = 800
SWEP.Primary.ClipSize = 54
SWEP.Primary.KickUp = 0.77
SWEP.Primary.KickDown = 0.4
SWEP.Primary.KickHorizontal = 1
SWEP.Primary.Automatic = true
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 11
SWEP.Primary.Spread = .026
SWEP.Primary.Ammo = "smg1"

SWEP.IronSightsPos = Vector(3.943,-0.129,1.677)
SWEP.IronSightsAng = Vector(-1.922,0.481,0)

SWEP.LegacyBalance = {
	Primary = {
		RPM = 1000,
		ClipSize = 30,
		KickUp = 0.2,
		KickDown = 0.1,
		KickHorizontal = 0.3,
		Automatic = true,
		NumShots = 1,
		Damage = 18,
		Spread = .026
	}
}