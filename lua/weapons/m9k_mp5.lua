SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9kR: Submachine Guns"
SWEP.PrintName = "HK MP5"

SWEP.Slot = 2
SWEP.HoldType = "ar2"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_navymp5.mdl"
SWEP.WorldModel = "models/weapons/w_hk_mp5.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/brightmp5/boltback.mp3",
		iDelay = 0.50
	},
	{
		sSound = "weapons/brightmp5/magout.mp3",
		iDelay = 0.50 + 0.75
	},
	{
		sSound = "weapons/brightmp5/magin1.mp3",
		iDelay = 0.50 + 0.75 + 1.00
	},
	{
		sSound = "weapons/brightmp5/magin2.mp3",
		iDelay = 0.50 + 0.75 + 1.00 + 0.20
	},
	{
		sSound = "weapons/brightmp5/boltslap.mp3",
		iDelay = 0.50 + 0.75 + 1.00 + 0.20 + 0.60
	}
}

SWEP.tDrawSoundSequence = {
	{
		sSound = "weapons/brightmp5/cloth.mp3",
		iDelay = 0.15
	},
	{
		sSound = "weapons/brightmp5/safety.mp3",
		iDelay = 0.15 + 0.35
	}
}

SWEP.Primary.Sound = "weapons/brightmp5/mp5-1.wav"

SWEP.Primary.RPM = 675
SWEP.Primary.ClipSize = 30
SWEP.Primary.KickUp = 0.8
SWEP.Primary.KickDown = 0.5
SWEP.Primary.KickHorizontal = 0.6
SWEP.Primary.Automatic = true
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 15
SWEP.Primary.Spread = .027
SWEP.Primary.Ammo = "smg1"

SWEP.IronSightsPos = Vector(2.549,-0.927,1.09)
SWEP.IronSightsAng = Vector(0.125,-0.071,0)

SWEP.LegacyBalance = {
	Primary = {
		RPM = 800,
		ClipSize = 30,
		KickUp = 0.1,
		KickDown = 0.1,
		KickHorizontal = 0.2,
		Automatic = true,
		NumShots = 1,
		Damage = 22,
		Spread = .023
	}
}