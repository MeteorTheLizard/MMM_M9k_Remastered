SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9kR: Assault Rifles"
SWEP.PrintName = "SCAR"

SWEP.Slot = 3
SWEP.HoldType = "ar2"
SWEP.Spawnable = true

SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_fnscarh.mdl"
SWEP.WorldModel = "models/weapons/w_fn_scar_h.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/fnscarh/aug_clipout.mp3",
		iDelay = 0.45
	},
	{
		sSound = "weapons/fnscarh/aug_boltslap.mp3",
		iDelay = 0.45 + 0.85
	},
	{
		sSound = "weapons/fnscarh/aug_clipin.mp3",
		iDelay = 0.45 + 0.85 + 0.35
	},
	{
		sSound = "weapons/fnscarh/aug_boltpull.mp3",
		iDelay = 0.45 + 0.85 + 0.35 + 0.45
	}
}

SWEP.tDrawSoundSequence = {
	{
		sSound = "weapons/fnscarh/aug_boltpull.mp3",
		iDelay = 0.30
	}
}

SWEP.Primary.Sound = "weapons/fnscarh/aug-1.wav"

SWEP.Primary.RPM = 390
SWEP.Primary.ClipSize = 30
SWEP.Primary.KickUp = 2.2
SWEP.Primary.KickDown = 1.35
SWEP.Primary.KickHorizontal = 1.9
SWEP.Primary.Automatic = true
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 32
SWEP.Primary.Spread = .03
SWEP.Primary.Ammo = "ar2"

SWEP.IronSightsPos = Vector(-2.652,0.187,-0.003)
SWEP.IronSightsAng = Vector(2.565,0.034,0)

SWEP.LegacyBalance = {
	Primary = {
		RPM = 625,
		ClipSize = 30,
		KickUp = 0.4,
		KickDown = 0.3,
		KickHorizontal = 0.3,
		Automatic = true,
		NumShots = 1,
		Damage = 30,
		Spread = .02
	}
}