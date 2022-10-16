SWEP.Base = "bobs_scoped_base"
SWEP.Category = "M9kR: Sniper Rifles"
SWEP.PrintName = "Barret M82"

SWEP.HoldType = "ar2"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_50calm82.mdl"
SWEP.WorldModel = "models/weapons/w_barret_m82.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/M82/clipout.mp3",
		iDelay = 0.55
	},
	{
		sSound = "weapons/M82/clipin.mp3",
		iDelay = 0.55 + 1.05
	},
	{
		sSound = "weapons/M82/boltup.mp3",
		iDelay = 0.55 + 1.05 + 0.75
	},
	{
		sSound = "weapons/M82/boltdown.mp3",
		iDelay = 0.55 + 1.05 + 0.75 + 0.35
	}
}

SWEP.Primary.Sound = "weapons/M82/barret50-1.wav"

SWEP.Primary.RPM = 60
SWEP.Primary.ClipSize = 10
SWEP.Primary.KickUp = 3
SWEP.Primary.KickDown = 5
SWEP.Primary.KickHorizontal = 6
SWEP.Primary.Automatic = false
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 130
SWEP.Primary.Spread = .18
SWEP.Primary.Ammo = "SniperPenetratedRound"

SWEP.Primary.SpreadBefore = SWEP.Primary.Spread

SWEP.ScopeStages = 3
SWEP.ScopeScale = 0.7
SWEP.ReticleScale = 0.6

SWEP.LegacyBalance = {
	Primary = {
		RPM = 200,
		ClipSize = 10,
		KickUp = 1,
		KickDown = 1,
		KickHorizontal = 1,
		Automatic = false,
		NumShots = 1,
		Damage = 110,
		Spread = .01
	}
}