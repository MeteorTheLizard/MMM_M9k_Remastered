SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9kR: Assault Rifles"
SWEP.PrintName = "FAMAS"

SWEP.Slot = 3
SWEP.HoldType = "ar2"
SWEP.Spawnable = true

SWEP.ViewModelFOV = 65
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_tct_famas.mdl"
SWEP.WorldModel = "models/weapons/w_tct_famas.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/fokku_tc_famas/famas_clipout.mp3",
		iDelay = 0.75
	},
	{
		sSound = "weapons/fokku_tc_famas/famas_clipin.mp3",
		iDelay = 0.75 + 1.45
	}
}

SWEP.DrawSound = "weapons/fokku_tc_famas/famas_forearm.mp3"

SWEP.Primary.Sound = "weapons/fokku_tc_famas/shot-1.wav"

SWEP.Primary.RPM = 485
SWEP.Primary.ClipSize = 30
SWEP.Primary.KickUp = 1.5
SWEP.Primary.KickDown = 1.1
SWEP.Primary.KickHorizontal = 1.3
SWEP.Primary.Automatic = true
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 26
SWEP.Primary.Spread = .02
SWEP.Primary.Ammo = "ar2"

SWEP.IronSightsPos = Vector(-3.342,0,0.247)
SWEP.IronSightsAng = Vector(0,-0.438,0)

SWEP.LegacyBalance = {
	Primary = {
		RPM = 950,
		ClipSize = 30,
		KickUp = 0.4,
		KickDown = 0.4,
		KickHorizontal = 0.4,
		Automatic = true,
		NumShots = 1,
		Damage = 29,
		Spread = .025
	}
}