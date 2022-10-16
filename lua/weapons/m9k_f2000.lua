SWEP.Base = "bobs_scoped_base"
SWEP.Category = "M9kR: Assault Rifles"
SWEP.PrintName = "F2000"

SWEP.DynamicLightScale = 1 -- Set to Default

SWEP.Slot = 3
SWEP.HoldType = "ar2"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_tct_f2000.mdl"
SWEP.WorldModel = "models/weapons/w_fn_f2000.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/fokku_tc_f2000/chargeback.mp3",
		iDelay = 0.35
	},
	{
		sSound = "weapons/fokku_tc_f2000/clipout.mp3",
		iDelay = 0.35 + 0.65
	},
	{
		sSound = "weapons/fokku_tc_f2000/clipin.mp3",
		iDelay = 0.35 + 0.65 + 0.95
	},
	{
		sSound = "weapons/fokku_tc_f2000/chargeback.mp3",
		iDelay = 0.35 + 0.65 + 0.95 + 0.70
	},
	{
		sSound = "weapons/fokku_tc_f2000/chargefor1.mp3",
		iDelay = 0.35 + 0.65 + 0.95 + 0.70 + 0.20
	}
}

SWEP.DrawSound = "weapons/fokku_tc_f2000/cloth2.mp3"

SWEP.Primary.Sound = "weapons/fokku_tc_f2000/shot-1.wav"
SWEP.Primary.SoundVolume = 80

SWEP.Primary.RPM = 355
SWEP.Primary.ClipSize = 30
SWEP.Primary.KickUp = 2
SWEP.Primary.KickDown = 1.3
SWEP.Primary.KickHorizontal = 1.5
SWEP.Primary.Automatic = true
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 28
SWEP.Primary.Spread = .025
SWEP.Primary.Ammo = "ar2"

SWEP.Primary.SpreadBefore = SWEP.Primary.Spread

SWEP.ScopeType = "gdcw_acog"
SWEP.ScopeStages = 1
SWEP.ScopeScale = 0.5
SWEP.ReticleScale = 0.6

SWEP.LegacyBalance = {
	Primary = {
		RPM = 850,
		ClipSize = 30,
		KickUp = .4,
		KickDown = .4,
		KickHorizontal = .4,
		Automatic = true,
		NumShots = 1,
		Damage = 23,
		Spread = .025
	}
}