SWEP.Base = "bobs_scoped_base"
SWEP.Category = "M9kR: Sniper Rifles"
SWEP.PrintName = "M24"

SWEP.HoldType = "ar2"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_dmg_m24s.mdl"
SWEP.WorldModel = "models/weapons/w_snip_m24_6.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/dmg_m24/m24_magout.mp3",
		iDelay = 0.40
	},
	{
		sSound = "weapons/dmg_m24/m24_magin.mp3",
		iDelay = 0.40 + 0.85
	},
	{
		sSound = "weapons/dmg_m24/m24_boltback.mp3",
		iDelay = 0.40 + 0.85 + 0.70
	},
	{
		sSound = "weapons/dmg_m24/m24_boltforward.mp3",
		iDelay = 0.40 + 0.85 + 0.70 + 0.35
	}
}

SWEP.iBoltTotalTime = 0.45 + 0.35 + 0.45
SWEP.tBoltDynamic = {
	{
		sSound = "weapons/dmg_m24/m24_boltback.mp3",
		iDelay = 0.45
	},
	{
		sSound = "weapons/dmg_m24/m24_boltforward.mp3",
		iDelay = 0.45 + 0.35
	}
}

SWEP.Primary.Sound = "weapons/dmg_m24/awp1.wav"

SWEP.Primary.RPM = 40
SWEP.Primary.ClipSize = 5
SWEP.Primary.KickUp = 6
SWEP.Primary.KickDown = 2
SWEP.Primary.KickHorizontal = 5
SWEP.Primary.Automatic = false
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 120
SWEP.Primary.Spread = .15
SWEP.Primary.Ammo = "SniperPenetratedRound"

SWEP.Primary.SpreadBefore = SWEP.Primary.Spread

SWEP.IsBoltAction = true
SWEP.ScopeType = "gdcw_scopesight"
SWEP.ScopeStages = 3
SWEP.ScopeScale = 0.7
SWEP.ReticleScale = 0.6

SWEP.LegacyBalance = {
	Primary = {
		RPM = 40,
		ClipSize = 5,
		KickUp = .6,
		KickDown = .6,
		KickHorizontal = .6,
		Automatic = false,
		NumShots = 1,
		Damage = 97,
		Spread = .01
	}
}