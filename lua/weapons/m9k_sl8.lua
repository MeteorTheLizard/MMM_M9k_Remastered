SWEP.Base = "bobs_scoped_base"
SWEP.Category = "M9kR: Assault Rifles"
SWEP.PrintName = "HK SL8"

SWEP.DynamicLightScale = 1 -- Set to Default

SWEP.HoldType = "ar2"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_hk_sl8.mdl"
SWEP.WorldModel = "models/weapons/w_hk_sl8.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/hksl8/magout.mp3",
		iDelay = 0.60
	},
	{
		sSound = "weapons/hksl8/magfiddle.mp3",
		iDelay = 0.60 + 0.90
	},
	{
		sSound = "weapons/hksl8/magin.mp3",
		iDelay = 0.60 + 0.90 + 0.55
	},
	{
		sSound = "weapons/hksl8/boltback.mp3",
		iDelay = 0.60 + 0.90 + 0.55 + 0.70
	},
	{
		sSound = "weapons/hksl8/boltforward.mp3",
		iDelay = 0.60 + 0.90 + 0.55 + 0.70 + 0.25
	}
}

SWEP.tDrawSoundSequence = {
	{
		sSound = "weapons/hksl8/draw.mp3",
		iDelay = 0.00
	},
	{
		sSound = "weapons/hksl8/safety.mp3",
		iDelay = 0.00 + 0.55
	}
}

SWEP.Primary.Sound = "weapons/hksl8/SG552-1.wav"
SWEP.Primary.SoundVolume = 75

SWEP.Primary.RPM = 410
SWEP.Primary.ClipSize = 30
SWEP.Primary.KickUp = 1.4
SWEP.Primary.KickDown = 0.9
SWEP.Primary.KickHorizontal = 1.5
SWEP.Primary.Automatic = true
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 27
SWEP.Primary.Spread = .025
SWEP.Primary.Ammo = "ar2"

SWEP.Primary.SpreadBefore = SWEP.Primary.Spread

SWEP.ScopeType = "gdcw_acog"
SWEP.ScopeStages = 1
SWEP.ScopeScale = 0.5
SWEP.ReticleScale = 0.6

SWEP.LegacyBalance = {
	Primary = {
		RPM = 300,
		ClipSize = 30,
		KickUp = .6,
		KickDown = .6,
		KickHorizontal = .6,
		Automatic = true,
		NumShots = 1,
		Damage = 60,
		Spread = .015
	}
}