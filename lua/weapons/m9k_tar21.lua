SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9kR: Assault Rifles"
SWEP.PrintName = "TAR-21"

SWEP.Slot = 3
SWEP.HoldType = "ar2"
SWEP.Spawnable = true

SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_imi_tavor.mdl"
SWEP.WorldModel = "models/weapons/w_imi_tar21.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/tavor/famas_clipout.mp3",
		iDelay = 0.50
	},
	{
		sSound = "weapons/tavor/famas_clipout1.mp3",
		iDelay = 0.50 + 0.15
	},
	{
		sSound = "weapons/tavor/famas_tap.mp3",
		iDelay = 0.50 + 0.15 + 0.35
	},
	{
		sSound = "weapons/tavor/famas_clipin.mp3",
		iDelay = 0.50 + 0.15 + 0.35 + 0.80
	},
	{
		sSound = "weapons/tavor/famas_boltpull.mp3",
		iDelay = 0.50 + 0.15 + 0.35 + 0.80 + 0.70
	},
	{
		sSound = "weapons/tavor/famas_boltrelease.mp3",
		iDelay = 0.50 + 0.15 + 0.35 + 0.80 + 0.70 + 0.15
	}
}

SWEP.tDrawSoundSequence = {
	{
		sSound = "weapons/tavor/famas_boltpull.mp3",
		iDelay = 0.25
	},
	{
		sSound = "weapons/tavor/famas_boltrelease.mp3",
		iDelay = 0.25 + 0.15
	}
}

SWEP.Primary.Sound = "weapons/tavor/famas-1.wav"

SWEP.Primary.RPM = 390
SWEP.Primary.ClipSize = 30
SWEP.Primary.KickUp = 1.85
SWEP.Primary.KickDown = 1.3
SWEP.Primary.KickHorizontal = 1.9
SWEP.Primary.Automatic = true
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 24
SWEP.Primary.Spread = .024
SWEP.Primary.Ammo = "ar2"

SWEP.IronSightsPos = Vector(-1.825,0.685,0.155)
SWEP.IronSightsAng = Vector(0.768,0,0)

SWEP.LegacyBalance = {
	Primary = {
		RPM = 900,
		ClipSize = 30,
		KickUp = 0.3,
		KickDown = 0.3,
		KickHorizontal = 0.3,
		Automatic = true,
		NumShots = 1,
		Damage = 30,
		Spread = .027
	}
}