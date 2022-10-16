SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9kR: Assault Rifles"
SWEP.PrintName = "AS VAL"

SWEP.Slot = 3
SWEP.HoldType = "ar2"
SWEP.Spawnable = true

SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_dmg_vally.mdl"
SWEP.WorldModel = "models/weapons/w_dmg_vally.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/dmg_val/galil_clipout.mp3",
		iDelay = 0.90
	},
	{
		sSound = "weapons/dmg_val/galil_clipin.mp3",
		iDelay = 0.90 + 0.50
	},
	{
		sSound = "weapons/dmg_val/galil_Boltpull.mp3",
		iDelay = 0.90 + 0.50 + 0.75
	}
}

SWEP.DrawSound = "weapons/dmg_val/draw.mp3"

SWEP.Primary.Sound = "weapons/dmg_val/galil-1.wav"
SWEP.Primary.SoundVolume = 65 -- Silenced!

SWEP.Primary.RPM = 445
SWEP.Primary.ClipSize = 20
SWEP.Primary.KickUp = 1.7
SWEP.Primary.KickDown = 0.56
SWEP.Primary.KickHorizontal = 1.3
SWEP.Primary.Automatic = true
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 24
SWEP.Primary.Spread = .02
SWEP.Primary.Ammo = "ar2"

SWEP.IronSightsPos = Vector(-2.2442,-1.8353,1.0599)
SWEP.IronSightsAng = Vector(1.0513,0.0322,0)

SWEP.LegacyBalance = {
	Primary = {
		RPM = 900,
		ClipSize = 20,
		KickUp = 0.3,
		KickDown = 0.3,
		KickHorizontal = 0.5,
		Automatic = true,
		NumShots = 1,
		Damage = 27,
		Spread = .019
	}
}