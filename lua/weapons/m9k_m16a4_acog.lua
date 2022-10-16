SWEP.Base = "bobs_scoped_base"
SWEP.Category = "M9kR: Assault Rifles"
SWEP.PrintName = "M16A4 ACOG"

SWEP.DynamicLightScale = 1 -- Set to Default

SWEP.Slot = 3
SWEP.HoldType = "ar2"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_m16_acog.mdl"
SWEP.WorldModel = "models/weapons/w_dmg_m16ag.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/dmg_m16a4/magout.mp3",
		iDelay = 0.25
	},
	{
		sSound = "weapons/dmg_m16a4/magin.mp3",
		iDelay = 0.25 + 0.85
	},
	{
		sSound = "weapons/dmg_m16a4/boltrelease.mp3",
		iDelay = 0.25 + 0.85 + 1.35
	}
}

SWEP.tDrawSoundSequence = {
	{
		sSound = "weapons/dmg_m16a4/boltpull.mp3",
		iDelay = 0.15
	},
	{
		sSound = "weapons/dmg_m16a4/boltrelease.mp3",
		iDelay = 0.15 + 0.25
	}
}

SWEP.Primary.Sound = "weapons/dmg_m16a4/shoot.wav"

SWEP.Primary.RPM = 360
SWEP.Primary.ClipSize = 30
SWEP.Primary.KickUp = 2.3
SWEP.Primary.KickDown = 1.3
SWEP.Primary.KickHorizontal = 1.8
SWEP.Primary.Automatic = true
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 31
SWEP.Primary.Spread = .02
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
		KickHorizontal = .6,
		Automatic = false,
		NumShots = 1,
		Damage = 30,
		Spread = .015
	}
}