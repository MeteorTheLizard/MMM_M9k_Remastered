SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9kR: Submachine Guns"
SWEP.PrintName = "STEN"

SWEP.Slot = 2
SWEP.HoldType = "ar2"
SWEP.Spawnable = true

SWEP.ViewModelFOV = 65
SWEP.ViewModel = "models/weapons/v_smgsten.mdl"
SWEP.WorldModel = "models/weapons/w_sten.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/sten/mp5_boltpull.mp3",
		iDelay = 0.25
	},
	{
		sSound = "weapons/sten/mp5_clipout.mp3",
		iDelay = 0.25 + 0.65
	},
	{
		sSound = "weapons/sten/mp5_clipin.mp3",
		iDelay = 0.25 + 0.65 + 1.25
	},
	{
		sSound = "weapons/sten/mp5_boltslap.mp3",
		iDelay = 0.25 + 0.65 + 1.25 + 0.55
	}
}

SWEP.tDrawSoundSequence = {
	{
		sSound = "weapons/sten/mp5_slideback.mp3",
		iDelay = 0.25
	}
}

SWEP.Primary.Sound = "weapons/sten/mp5-1.wav"

SWEP.Primary.RPM = 300
SWEP.Primary.ClipSize = 32
SWEP.Primary.KickUp = 1.53
SWEP.Primary.KickDown = 0.78
SWEP.Primary.KickHorizontal = 1.2
SWEP.Primary.Automatic = true
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 24
SWEP.Primary.Spread = .035
SWEP.Primary.Ammo = "smg1"

SWEP.IronSightsPos = Vector(4.367,-1.476,3.119)
SWEP.IronSightsAng = Vector(-0.213,-0.426,0)

SWEP.LegacyBalance = {
	Primary = {
		RPM = 500,
		ClipSize = 32,
		KickUp = 0.6,
		KickDown = 0.4,
		KickHorizontal = 0.5,
		Automatic = true,
		NumShots = 1,
		Damage = 20,
		Spread = .03
	}
}