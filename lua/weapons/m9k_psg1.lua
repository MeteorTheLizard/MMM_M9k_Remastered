SWEP.Base = "bobs_scoped_base"
SWEP.Category = "M9kR: Sniper Rifles"
SWEP.PrintName = "PSG-1"

SWEP.HoldType = "ar2"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_psg1_snipe.mdl"
SWEP.WorldModel = "models/weapons/w_hk_psg1.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/psg1/psg_boltpull.mp3",
		iDelay = 0.65
	},
	{
		sSound = "weapons/psg1/psg_clipout.mp3",
		iDelay = 0.65 + 0.80
	},
	{
		sSound = "weapons/psg1/psg_clipin.mp3",
		iDelay = 0.65 + 0.80 + 1.50
	},
	{
		sSound = "weapons/psg1/psg_boltrelease.mp3",
		iDelay = 0.65 + 0.80 + 1.50 + 0.75
	}
}

SWEP.tDrawSoundSequence = {
	{
		sSound = "weapons/psg1/deploy1.mp3",
		iDelay = 0.10
	},
	{
		sSound = "weapons/psg1/psg_boltrelease.mp3",
		iDelay = 0.10 + 0.45
	}
}

SWEP.Primary.Sound = "weapons/psg1/g3sg1-1.wav"

SWEP.Primary.RPM = 150
SWEP.Primary.ClipSize = 10
SWEP.Primary.KickUp = 4
SWEP.Primary.KickDown = 2
SWEP.Primary.KickHorizontal = 3
SWEP.Primary.Automatic = true
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 65
SWEP.Primary.Spread = .15
SWEP.Primary.Ammo = "SniperPenetratedRound"

SWEP.Primary.SpreadBefore = SWEP.Primary.Spread

SWEP.ScopeType = "gdcw_scopesight"
SWEP.ScopeStages = 3
SWEP.ScopeScale = 0.7
SWEP.ReticleScale = 0.6

SWEP.LegacyBalance = {
	Primary = {
		RPM = 500,
		ClipSize = 10,
		KickUp = 1,
		KickDown = 1,
		KickHorizontal = 1,
		Automatic = false,
		NumShots = 1,
		Damage = 90,
		Spread = .01
	}
}