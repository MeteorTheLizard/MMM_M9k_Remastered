SWEP.Base = "bobs_scoped_base"
SWEP.Category = "M9kR: Sniper Rifles"
SWEP.PrintName = "Remington 7615P"

SWEP.HoldType = "ar2"
SWEP.Spawnable = true

SWEP.ViewModelFOV = 60
SWEP.ViewModel = "models/weapons/v_remington_7615p.mdl"
SWEP.WorldModel = "models/weapons/w_remington_7615p.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/7615p/sg550_clipout.mp3",
		iDelay = 0.35
	},
	{
		sSound = "weapons/7615p/sg550_clipin.mp3",
		iDelay = 0.35 + 1.10
	},
	{
		sSound = "weapons/7615p/m3_pump.mp3",
		iDelay = 0.35 + 1.10 + 0.60
	}
}

SWEP.iBoltTotalTime = 0.65 + 0.80
SWEP.tBoltDynamic = {
	{
		sSound = "weapons/7615p/m3_pump.mp3",
		iDelay = 0.65
	}
}

SWEP.Primary.Sound = "weapons/7615p/scout_fire-1.wav"

SWEP.Primary.RPM = 40
SWEP.Primary.ClipSize = 10
SWEP.Primary.KickUp = 4
SWEP.Primary.KickDown = 2
SWEP.Primary.KickHorizontal = 3
SWEP.Primary.Automatic = false
SWEP.Primary.NumShots = 3
SWEP.Primary.Damage = 30
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
		RPM = 50,
		ClipSize = 10,
		KickUp = 1,
		KickDown = 1,
		KickHorizontal = 1,
		Automatic = false,
		NumShots = 1,
		Damage = 35,
		Spread = .01
	}
}