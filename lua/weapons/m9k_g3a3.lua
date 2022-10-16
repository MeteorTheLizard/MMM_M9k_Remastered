SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9kR: Assault Rifles"
SWEP.PrintName = "HK G3A3"

SWEP.Slot = 3
SWEP.HoldType = "ar2"
SWEP.Spawnable = true

SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_hk_g3_rif.mdl"
SWEP.WorldModel = "models/weapons/w_hk_g3.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/hk_g3/galil_clipout.mp3",
		iDelay = 0.45
	},
	{
		sSound = "weapons/hk_g3/galil_clipin.mp3",
		iDelay = 0.45 + 0.45
	},
	{
		sSound = "weapons/hk_g3/boltpull.mp3",
		iDelay = 0.45 + 0.45 + 0.60
	},
	{
		sSound = "weapons/hk_g3/boltforward.mp3",
		iDelay = 0.45 + 0.45 + 0.60 + 0.40
	}
}

SWEP.tDrawSoundSequence = {
	{
		sSound = "weapons/hk_g3/draw.mp3",
		iDelay = 0.25
	}
}

SWEP.Primary.Sound = "weapons/hk_g3/galil-1.wav"

SWEP.Primary.RPM = 300
SWEP.Primary.ClipSize = 20
SWEP.Primary.KickUp = 2
SWEP.Primary.KickDown = 1.4
SWEP.Primary.KickHorizontal = 1.9
SWEP.Primary.Automatic = true
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 37
SWEP.Primary.Spread = .026
SWEP.Primary.Ammo = "ar2"

SWEP.IronSightsPos = Vector(-2.419,-2.069,1.498)
SWEP.IronSightsAng = Vector(-0.109,-0.281,0)

SWEP.LegacyBalance = {
	Primary = {
		RPM = 550,
		ClipSize = 20,
		KickUp = 0.4,
		KickDown = 0.3,
		KickHorizontal = 0.5,
		Automatic = true,
		NumShots = 1,
		Damage = 33,
		Spread = .026
	}
}