SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9kR: Pistols"
SWEP.PrintName = "HK45C"

SWEP.Slot = 1
SWEP.Spawnable = true

SWEP.ViewModelFOV = 60
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_pist_hk45.mdl"
SWEP.WorldModel = "models/weapons/w_hk45c.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/hk45/magout.mp3",
		iDelay = 0.35
	},
	{
		sSound = "weapons/hk45/magin.mp3",
		iDelay = 0.35 + 1.35
	},
	{
		sSound = "weapons/hk45/sliderelease.mp3",
		iDelay = 0.35 + 1.35 + 1.25
	}
}

SWEP.tDrawSoundSequence = {
	{
		sSound = "weapons/hk45/slidepull.mp3",
		iDelay = 0.35
	},
	{
		sSound = "weapons/hk45/sliderelease.mp3",
		iDelay = 0.35 + 0.15
	}
}

SWEP.Primary.Sound = "weapons/hk45/hk45-1.wav"

SWEP.Primary.RPM = 310
SWEP.Primary.ClipSize = 13
SWEP.Primary.KickUp = 1.3
SWEP.Primary.KickDown = 0.7
SWEP.Primary.KickHorizontal = 0.8
SWEP.Primary.Automatic = false
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 21
SWEP.Primary.Spread = .029
SWEP.Primary.Ammo = "pistol"

SWEP.IronSightsPos = Vector(-2.32,0,0.86)

SWEP.LegacyBalance = {
	Primary = {
		RPM = 750,
		ClipSize = 8,
		KickUp = 0.4,
		KickDown = 0.3,
		KickHorizontal = 0.3,
		Automatic = false,
		NumShots = 1,
		Damage = 25,
		Spread = .025
	}
}