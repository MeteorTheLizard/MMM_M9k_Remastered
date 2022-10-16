SWEP.Base = "bobs_scoped_base"
SWEP.Category = "M9kR: Sniper Rifles"
SWEP.PrintName = "Intervention"

SWEP.DynamicLightScale = 4 -- This thing is a monster!

SWEP.HoldType = "ar2"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_snip_int.mdl"
SWEP.WorldModel = "models/weapons/w_snip_int.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/fokku_tc_intrv/int_bolt.mp3",
		iDelay = 0.50
	},
	{
		sSound = "weapons/fokku_tc_intrv/int_clipout.mp3",
		iDelay = 0.50 + 1.30
	},
	{
		sSound = "weapons/fokku_tc_intrv/int_clipin.mp3",
		iDelay = 0.50 + 1.30 + 0.65
	},
	{
		sSound = "weapons/fokku_tc_intrv/int_bolt.mp3",
		iDelay = 0.50 + 1.30 + 0.65 + 0.30
	}
}

SWEP.iBoltTotalTime = 0.70 + 0.30 + 0.85
SWEP.tBoltDynamic = {
	{
		sSound = "weapons/fokku_tc_intrv/int_bolt.mp3",
		iDelay = 0.70
	},
	{
		sSound = "weapons/fokku_tc_intrv/int_bolt.mp3",
		iDelay = 0.70 + 0.30
	}
}

SWEP.DrawSound = "weapons/fokku_tc_intrv/int_deploy.mp3"

SWEP.Primary.Sound = "weapons/fokku_tc_intrv/int1.wav"
SWEP.Primary.SoundVolume = 110 -- Monster!

SWEP.Primary.RPM = 35
SWEP.Primary.ClipSize = 5
SWEP.Primary.KickUp = 7
SWEP.Primary.KickDown = 2
SWEP.Primary.KickHorizontal = 9
SWEP.Primary.Automatic = false
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 155
SWEP.Primary.Spread = .30
SWEP.Primary.Ammo = "SniperPenetratedRound"

SWEP.Primary.SpreadBefore = SWEP.Primary.Spread

SWEP.IsBoltAction = true
SWEP.ScopeType = "gdcw_scopesight"
SWEP.ScopeStages = 3
SWEP.ScopeScale = 0.7
SWEP.ReticleScale = 0.5

SWEP.LegacyBalance = {
	Primary = {
		RPM = 35,
		ClipSize = 5,
		KickUp = 1,
		KickDown = .6,
		KickHorizontal = .4,
		Automatic = false,
		NumShots = 1,
		Damage = 95,
		Spread = .01
	}
}