SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9kR: Submachine Guns"
SWEP.PrintName = "HK UMP45"

SWEP.Slot = 2
SWEP.HoldType = "smg"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_hk_ump_45.mdl"
SWEP.WorldModel = "models/weapons/w_hk_ump45.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/hk_ump45/ump45_clipout1.mp3",
		iDelay = 0.25
	},
	{
		sSound = "weapons/hk_ump45/ump45_clipout2.mp3",
		iDelay = 0.25 + 0.55
	},
	{
		sSound = "weapons/hk_ump45/ump45_clipin1.mp3",
		iDelay = 0.25 + 0.55 + 0.85
	},
	{
		sSound = "weapons/hk_ump45/ump45_clipin2.mp3",
		iDelay = 0.25 + 0.55 + 0.85 + 0.20
	},
	{
		sSound = "weapons/hk_ump45/ump45_boltslap.mp3",
		iDelay = 0.25 + 0.55 + 0.85 + 0.20 + 0.35
	}
}

SWEP.tDrawSoundSequence = {
	{
		sSound = "weapons/hk_ump45/ump45_cloth.mp3",
		iDelay = 0.05
	}
}

SWEP.Primary.Sound = "weapons/hk_ump45/ump45-1.wav"

SWEP.Primary.RPM = 500
SWEP.Primary.ClipSize = 25
SWEP.Primary.KickUp = 1.2
SWEP.Primary.KickDown = 0.7
SWEP.Primary.KickHorizontal = 1.2
SWEP.Primary.Automatic = true
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 18
SWEP.Primary.Spread = .03
SWEP.Primary.Ammo = "smg1"

SWEP.IronSightsPos = Vector(2.826,-1.601,1.259)
SWEP.IronSightsAng = Vector(-0.055,0,0)

SWEP.LegacyBalance = {
	Primary = {
		RPM = 600,
		ClipSize = 25,
		KickUp = 0.2,
		KickDown = 0.4,
		KickHorizontal = 0.45,
		Automatic = true,
		NumShots = 1,
		Damage = 20,
		Spread = .028
	}
}