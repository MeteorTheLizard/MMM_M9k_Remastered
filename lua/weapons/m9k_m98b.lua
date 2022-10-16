SWEP.Base = "bobs_scoped_base"
SWEP.Category = "M9kR: Sniper Rifles"
SWEP.PrintName = "Barret M98B"

SWEP.HoldType = "ar2"
SWEP.Spawnable = true

SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_m98bravo.mdl"
SWEP.WorldModel = "models/weapons/w_barrett_m98b.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/M98/foley.mp3",
		iDelay = 0.40
	},
	{
		sSound = "weapons/M98/clipout.mp3",
		iDelay = 0.40 + 0.45
	},
	{
		sSound = "weapons/M98/clipin.mp3",
		iDelay = 0.40 + 0.45 + 0.70
	},
	{
		sSound = "weapons/M98/boltback.mp3",
		iDelay = 0.40 + 0.45 + 0.70 + 0.80
	},
	{
		sSound = "weapons/M98/boltforward.mp3",
		iDelay = 0.40 + 0.45 + 0.70 + 0.80 + 0.40
	}
}

SWEP.iBoltTotalTime = 0.65 + 1.35
SWEP.tBoltDynamic = {
	{
		sSound = "weapons/M98/bolt.mp3",
		iDelay = 0.65
	}
}

SWEP.DrawSound = "weapons/M98/draw.mp3"

SWEP.Primary.Sound = "weapons/M98/shot-1.wav"

SWEP.Primary.RPM = 30
SWEP.Primary.ClipSize = 10
SWEP.Primary.KickUp = 3
SWEP.Primary.KickDown = 6
SWEP.Primary.KickHorizontal = 5
SWEP.Primary.Automatic = false
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 115
SWEP.Primary.Spread = .20
SWEP.Primary.Ammo = "SniperPenetratedRound"

SWEP.Primary.SpreadBefore = SWEP.Primary.Spread

SWEP.IsBoltAction = true
SWEP.ScopeStages = 3
SWEP.ScopeScale = 0.7
SWEP.ReticleScale = 0.6

SWEP.LegacyBalance = {
	Primary = {
		RPM = 50,
		ClipSize = 10,
		KickUp = 1,
		KickDown = 1,
		KickHorizontal = 1,
		Automatic = false,
		NumShots = 1,
		Damage = 90,
		Spread = .001
	}
}