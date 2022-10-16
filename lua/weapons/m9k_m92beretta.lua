SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9kR: Pistols"
SWEP.PrintName = "M92 Beretta"

SWEP.Slot = 1
SWEP.Spawnable = true

SWEP.ViewModelFOV = 65
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_pistberettam92.mdl"
SWEP.WorldModel = "models/weapons/w_beretta_m92.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/beretta92/berettam92_clipout.mp3",
		iDelay = 0.35
	},
	{
		sSound = "weapons/beretta92/berettam92_clipin.mp3",
		iDelay = 0.35 + 0.85
	},
	{
		sSound = "weapons/beretta92/berettam92_sliderelease.mp3",
		iDelay = 0.35 + 0.85 + 0.85
	}
}

SWEP.tDrawSoundSequence = {
	{
		sSound = "weapons/beretta92/berettam92_slideback.mp3",
		iDelay = 0.05
	}
}

SWEP.Primary.Sound = "weapons/beretta92/berettam92-1.wav"

SWEP.Primary.RPM = 350
SWEP.Primary.ClipSize = 15
SWEP.Primary.KickUp = 1.9
SWEP.Primary.KickDown = 1.7
SWEP.Primary.KickHorizontal = 1.5
SWEP.Primary.Automatic = false
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 17
SWEP.Primary.Spread = .028
SWEP.Primary.Ammo = "pistol"

SWEP.IronSightsPos = Vector(-2.379,0,1.205)

SWEP.LegacyBalance = {
	Primary = {
		RPM = 500,
		ClipSize = 15,
		KickUp = 1,
		KickDown = 0.5,
		KickHorizontal = 0.5,
		Automatic = false,
		NumShots = 1,
		Damage = 14,
		Spread = .027
	}
}