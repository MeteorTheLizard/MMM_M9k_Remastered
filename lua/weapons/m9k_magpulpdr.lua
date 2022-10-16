SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9kR: Submachine Guns"
SWEP.PrintName = "Magpul PDR"

SWEP.Slot = 2
SWEP.HoldType = "pistol"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_pdr_smg.mdl"
SWEP.WorldModel = "models/weapons/w_magpul_pdr.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/pdr/pdr_clipout.mp3",
		iDelay = 0.40
	},
	{
		sSound = "weapons/pdr/pdr_clipin.mp3",
		iDelay = 0.40 + 1.05
	},
	{
		sSound = "weapons/pdr/pdr_clipin2.mp3",
		iDelay = 0.40 + 1.05 + 0.40
	},
	{
		sSound = "weapons/pdr/pdr_boltpull.mp3",
		iDelay = 0.40 + 1.05 + 0.40 + 0.50
	},
	{
		sSound = "weapons/pdr/pdr_boltrelease.mp3",
		iDelay = 0.40 + 1.05 + 0.40 + 0.50 + 0.35
	}
}

SWEP.tDrawSoundSequence = {
	{
		sSound = "weapons/pdr/pdr_boltpull.mp3",
		iDelay = 0.35
	},
	{
		sSound = "weapons/pdr/pdr_boltrelease.mp3",
		iDelay = 0.35 + 0.20
	}
}

SWEP.Primary.Sound = "weapons/pdr/pdr-1.wav"

SWEP.Primary.RPM = 625
SWEP.Primary.ClipSize = 30
SWEP.Primary.KickUp = 0.9
SWEP.Primary.KickDown = 0.5
SWEP.Primary.KickHorizontal = 0.7
SWEP.Primary.Automatic = true
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 16
SWEP.Primary.Spread = .045
SWEP.Primary.Ammo = "smg1"

SWEP.IronSightsPos = Vector(4.8,0,2.079)
SWEP.bBlockIronSights = true

SWEP.LegacyBalance = {
	Primary = {
		RPM = 575,
		ClipSize = 30,
		KickUp = 0.3,
		KickDown = 0.3,
		KickHorizontal = 0.3,
		Automatic = true,
		NumShots = 1,
		Damage = 30,
		Spread = .03
	}
}