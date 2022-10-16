SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9kR: Submachine Guns"
SWEP.PrintName = "HK USC"

SWEP.Slot = 2
SWEP.HoldType = "smg"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_hkoch_usc.mdl"
SWEP.WorldModel = "models/weapons/w_hk_usc.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/usc/ump45_clipout.mp3",
		iDelay = 0.70
	},
	{
		sSound = "weapons/usc/ump45_clipin.mp3",
		iDelay = 0.70 + 1.30
	},
	{
		sSound = "weapons/usc/ump45_boltslap.mp3",
		iDelay = 0.70 + 1.30 + 0.60
	}
}

SWEP.Primary.Sound = "weapons/usc/ump45-1.wav"

SWEP.Primary.RPM = 500
SWEP.Primary.ClipSize = 25
SWEP.Primary.KickUp = 1.4
SWEP.Primary.KickDown = 0.7
SWEP.Primary.KickHorizontal = 2
SWEP.Primary.Automatic = false
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 37
SWEP.Primary.Spread = .05
SWEP.Primary.Ammo = "smg1"

SWEP.IronSightsPos = Vector(4.698,-2.566,2.038)

SWEP.LegacyBalance = {
	Primary = {
		RPM = 600,
		ClipSize = 25,
		KickUp = 0.2,
		KickDown = 0.4,
		KickHorizontal = 0.45,
		Automatic = false,
		NumShots = 1,
		Damage = 23,
		Spread = .02
	}
}