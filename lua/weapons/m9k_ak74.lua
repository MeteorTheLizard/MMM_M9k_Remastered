SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9kR: Assault Rifles"
SWEP.PrintName = "AK-74"

SWEP.Slot = 3
SWEP.HoldType = "ar2"
SWEP.Spawnable = true

SWEP.ViewModelFOV = 65
SWEP.ViewModel = "models/weapons/v_tct_ak47.mdl"
SWEP.WorldModel = "models/weapons/w_tct_ak47.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/fokku_tc_ak47/ak47_clipout.mp3",
		iDelay = 0.75
	},
	{
		sSound = "weapons/fokku_tc_ak47/ak47_clipin.mp3",
		iDelay = 0.75 + 1.15
	}
}

SWEP.DrawSound = "weapons/fokku_tc_ak47/ak47_boltpull.mp3"

SWEP.Primary.Sound = "weapons/fokku_tc_ak47/ak47-1.wav"
SWEP.Primary.SoundVolume = 85

SWEP.Primary.RPM = 415
SWEP.Primary.ClipSize = 30
SWEP.Primary.KickUp = 2.7
SWEP.Primary.KickDown = 1.7
SWEP.Primary.KickHorizontal = 1.8
SWEP.Primary.Automatic = true
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 43
SWEP.Primary.Spread = .037
SWEP.Primary.Ammo = "ar2"

SWEP.IronSightsPos = Vector(2.0378,-3.8941,0.8809)

SWEP.LegacyBalance = {
	Primary = {
		RPM = 600,
		ClipSize = 30,
		KickUp = 0.4,
		KickDown = 0.4,
		KickHorizontal = 0.4,
		Automatic = true,
		NumShots = 1,
		Damage = 31,
		Spread = .02
	}
}