SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9kR: Submachine Guns"
SWEP.PrintName = "UZI"

SWEP.Slot = 2
SWEP.HoldType = "pistol"
SWEP.Spawnable = true

SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_imi_uzi01.mdl"
SWEP.WorldModel = "models/weapons/w_uzi_imi.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/uzi/mac10_clipout.mp3",
		iDelay = 0.55
	},
	{
		sSound = "weapons/uzi/mac10_clipin.mp3",
		iDelay = 0.55 + 0.20
	},
	{
		sSound = "weapons/uzi/mac10_boltpull.mp3",
		iDelay = 0.55 + 0.20 + 1.85
	}
}

SWEP.tDrawSoundSequence = {
	{
		sSound = "weapons/uzi/mac10_clipout.mp3",
		iDelay = 0.45
	}
}

SWEP.Primary.Sound = "weapons/uzi/mac10-1.wav"

SWEP.Primary.RPM = 725
SWEP.Primary.ClipSize = 32
SWEP.Primary.KickUp = 1
SWEP.Primary.KickDown = 0.7
SWEP.Primary.KickHorizontal = 0.9
SWEP.Primary.Automatic = true
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 12
SWEP.Primary.Spread = .03
SWEP.Primary.Ammo = "smg1"

SWEP.IronSightsPos = Vector(-2.951,-2.629,1.633)
SWEP.IronSightsAng = Vector(0.109,-0.772,1.725)

SWEP.LegacyBalance = {
	Primary = {
		RPM = 600,
		ClipSize = 32,
		KickUp = 0.3,
		KickDown = 0.3,
		KickHorizontal = 0.3,
		Automatic = true,
		NumShots = 1,
		Damage = 20,
		Spread = .028
	}
}