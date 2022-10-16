SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9kR: Pistols"
SWEP.PrintName = "Desert Eagle"

SWEP.Slot = 1
SWEP.Spawnable = true

SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_tcom_deagle.mdl"
SWEP.WorldModel = "models/weapons/w_tcom_deagle.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/fokku_tc_deagle/de_clipout.mp3",
		iDelay = 0.40
	},
	{
		sSound = "weapons/fokku_tc_deagle/de_clipin.mp3",
		iDelay = 0.40 + 1.00
	},
	{
		sSound = "weapons/fokku_tc_deagle/de_slideback.mp3",
		iDelay = 0.40 + 1.00 + 0.20
	}
}

SWEP.tDrawSoundSequence = {
	{
		sSound = "weapons/fokku_tc_deagle/de_deploy.mp3",
		iDelay = 0.05
	}
}

SWEP.Primary.Sound = "weapons/fokku_tc_deagle/deagle-1.wav"
SWEP.Primary.SoundVolume = 85

SWEP.Primary.RPM = 165
SWEP.Primary.ClipSize = 7
SWEP.Primary.KickUp = 7
SWEP.Primary.KickDown = 2
SWEP.Primary.KickHorizontal = 6
SWEP.Primary.Automatic = false
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 60
SWEP.Primary.Spread = .055
SWEP.Primary.Ammo = "pistol"

SWEP.IronSightsPos = Vector(-1.7102,0,0.2585)

SWEP.LegacyBalance = {
	Primary = {
		RPM = 600,
		ClipSize = 7,
		KickUp = 1,
		KickDown = 0.5,
		KickHorizontal = 0.5,
		Automatic = false,
		NumShots = 1,
		Damage = 30,
		Spread = .025
	}
}