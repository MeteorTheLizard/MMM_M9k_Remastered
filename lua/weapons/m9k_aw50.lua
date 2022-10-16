SWEP.Base = "bobs_scoped_base"
SWEP.Category = "M9kR: Sniper Rifles"
SWEP.PrintName = "AI AW50"

SWEP.HoldType = "ar2"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_aw50_awp.mdl"
SWEP.WorldModel = "models/weapons/w_acc_int_aw50.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/aw50/awp_magout.mp3",
		iDelay = 0.45
	},
	{
		sSound = "weapons/aw50/awp_magin.mp3",
		iDelay = 0.45 + 0.55
	},
	{
		sSound = "weapons/aw50/m24_boltback.mp3",
		iDelay = 0.45 + 0.55 + 0.55
	},
	{
		sSound = "weapons/aw50/m24_boltforward.mp3",
		iDelay = 0.45 + 0.55 + 0.55 + 0.50
	}
}

SWEP.iBoltTotalTime = 0.50 + 0.45 + 1
SWEP.tBoltDynamic = {
	{
		sSound = "weapons/aw50/m24_boltback.mp3",
		iDelay = 0.50
	},
	{
		sSound = "weapons/aw50/m24_boltforward.mp3",
		iDelay = 0.50 + 0.45
	}
}

SWEP.DrawSound = "weapons/shrike/ready.mp3"

SWEP.Primary.Sound = "weapons/aw50/awp_fire.wav"

SWEP.Primary.RPM = 30
SWEP.Primary.ClipSize = 10
SWEP.Primary.KickUp = 4
SWEP.Primary.KickDown = 7
SWEP.Primary.KickHorizontal = 10
SWEP.Primary.Automatic = false
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 140
SWEP.Primary.Spread = .17
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
		Damage = 95,
		Spread = .01
	}
}