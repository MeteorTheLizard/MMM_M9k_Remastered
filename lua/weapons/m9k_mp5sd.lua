SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9kR: Submachine Guns"
SWEP.PrintName = "MP5SD"

SWEP.Slot = 2
SWEP.HoldType = "ar2"
SWEP.Spawnable = true

SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_hkmp5sd.mdl"
SWEP.WorldModel = "models/weapons/w_hk_mp5sd.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/hkmp5sd/magout.mp3",
		iDelay = 0.65
	},
	{
		sSound = "weapons/hkmp5sd/magfiddle.mp3",
		iDelay = 0.65 + 0.65
	},
	{
		sSound = "weapons/hkmp5sd/magin.mp3",
		iDelay = 0.65 + 0.65 + 0.20
	},
	{
		sSound = "weapons/hkmp5sd/boltpull.mp3",
		iDelay = 0.65 + 0.65 + 0.20 + 0.55
	},
	{
		sSound = "weapons/hkmp5sd/boltrelease.mp3",
		iDelay = 0.65 + 0.65 + 0.20 + 0.55 + 0.20
	}
}

SWEP.tDrawSoundSequence = {
	{
		sSound = "weapons/hkmp5sd/cloth.mp3",
		iDelay = 0.00
	},
	{
		sSound = "weapons/hkmp5sd/safety.mp3",
		iDelay = 0.00 + 0.30
	}
}

SWEP.Primary.Sound = "weapons/hkmp5sd/mp5-1.wav"
SWEP.Primary.SoundVolume = 75 -- Silenced, but not much.

SWEP.Primary.RPM = 675
SWEP.Primary.ClipSize = 30
SWEP.Primary.KickUp = 0.7
SWEP.Primary.KickDown = 0.5
SWEP.Primary.KickHorizontal = 0.5
SWEP.Primary.Automatic = true
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 11
SWEP.Primary.Spread = .027
SWEP.Primary.Ammo = "smg1"

SWEP.IronSightsPos = Vector(-2.29,-1.446,0.884)
SWEP.IronSightsAng = Vector(2.368,0,0)

SWEP.LegacyBalance = {
	Primary = {
		RPM = 700,
		ClipSize = 30,
		KickUp = 0.2,
		KickDown = 0.3,
		KickHorizontal = 0.2,
		Automatic = true,
		NumShots = 1,
		Damage = 30,
		Spread = .025
	}
}