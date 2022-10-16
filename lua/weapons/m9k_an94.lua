SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9kR: Assault Rifles"
SWEP.PrintName = "AN-94"

SWEP.Slot = 3
SWEP.HoldType = "ar2"
SWEP.Spawnable = true

SWEP.ViewModelFOV = 55
SWEP.ViewModel = "models/weapons/v_rif_an_94.mdl"
SWEP.WorldModel = "models/weapons/w_rif_an_94.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/an94/clipout.mp3",
		iDelay = 0.45
	},
	{
		sSound = "weapons/an94/clipin.mp3",
		iDelay = 0.45 + 1.00
	},
	{
		sSound = "weapons/an94/boltpull.mp3",
		iDelay = 0.45 + 1.00 + 0.95
	}
}

SWEP.DrawSound = "weapons/an94/draw.mp3"

SWEP.Primary.Sound = "weapons/an94/galil-1.wav"
SWEP.Primary.SoundVolume = 85

SWEP.Primary.RPM = 250
SWEP.Primary.ClipSize = 30
SWEP.Primary.KickUp = 3
SWEP.Primary.KickDown = 0.5
SWEP.Primary.KickHorizontal = 1.7
SWEP.Primary.Automatic = true
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 37
SWEP.Primary.Spread = .025
SWEP.Primary.Ammo = "ar2"

SWEP.IronSightsPos = Vector(4.552,0,3.062)
SWEP.IronSightsAng = Vector(0.93,-0.5,0)

SWEP.LegacyBalance = {
	Primary = {
		RPM = 600,
		ClipSize = 30,
		KickUp = 0.3,
		KickDown = 0.1,
		KickHorizontal = 0.3,
		Automatic = true,
		Ammo = "ar2",
		NumShots = 1,
		Damage = 31,
		Spread = .015
	}
}

-- This Weapon suffers from misaligned ironsights.
-- The Idle, Deploy, and Reload animations are broken because they change the angle of the Weapon that makes it become misaligned.
-- The ironsights are aligned after firing a shot.
-- There is no fix for this.