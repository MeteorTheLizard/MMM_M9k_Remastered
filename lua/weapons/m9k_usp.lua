SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9kR: Pistols"
SWEP.PrintName = "HK USP"

SWEP.Slot = 1
SWEP.Spawnable = true

SWEP.ViewModelFOV = 65
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_pist_fokkususp.mdl"
SWEP.WorldModel = "models/weapons/w_pist_fokkususp.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/fokku_tc_usp/fiveseven_clipout.mp3",
		iDelay = 0.20
	},
	{
		sSound = "weapons/fokku_tc_usp/fiveseven_clipin.mp3",
		iDelay = 0.20 + 0.60
	},
	{
		sSound = "weapons/fokku_tc_usp/fiveseven_slideback.mp3",
		iDelay = 0.20 + 0.60 + 0.45
	},
	{
		sSound = "weapons/fokku_tc_usp/fiveseven_slidepull.mp3",
		iDelay = 0.20 + 0.60 + 0.45 + 0.20
	}
}

SWEP.tDrawSoundSequence = {
	{
		sSound = "weapons/fokku_tc_usp/fiveseven_slideback.mp3",
		iDelay = 0.25
	},
	{
		sSound = "weapons/fokku_tc_usp/fiveseven_slidepull.mp3",
		iDelay = 0.25 + 0.20
	}
}

SWEP.Primary.Sound = "weapons/fokku_tc_usp/fiveseven-1.wav"

SWEP.Primary.RPM = 335
SWEP.Primary.ClipSize = 15
SWEP.Primary.KickUp = 1.6
SWEP.Primary.KickDown = 1.1
SWEP.Primary.KickHorizontal = 1.1
SWEP.Primary.Automatic = false
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 19
SWEP.Primary.Spread = .019
SWEP.Primary.Ammo = "pistol"

SWEP.IronSightsPos = Vector(-2.5944,0,1.1433)

SWEP.LegacyBalance = {
	Primary = {
		RPM = 750,
		ClipSize = 15,
		KickUp = 0.3,
		KickDown = 0.3,
		KickHorizontal = 0.3,
		Automatic = false,
		NumShots = 1,
		Damage = 16,
		Spread = .02
	}
}