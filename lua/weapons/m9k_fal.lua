SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9kR: Assault Rifles"
SWEP.PrintName = "FN FAL"

SWEP.Slot = 3
SWEP.HoldType = "ar2"
SWEP.Spawnable = true

SWEP.ViewModelFOV = 55
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_fnfalnato.mdl"
SWEP.WorldModel = "models/weapons/w_fn_fal.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/fn_fal/galil_clipout.mp3",
		iDelay = 0.75
	},
	{
		sSound = "weapons/fn_fal/galil_clipin.mp3",
		iDelay = 0.75 + 0.50
	},
	{
		sSound = "weapons/fn_fal/galil_boltpull.mp3",
		iDelay = 0.75 + 0.50 + 0.80
	}
}

SWEP.tDrawSoundSequence = {
	{
		sSound = "weapons/fn_fal/galil_boltpull.mp3",
		iDelay = 0.25
	}
}

SWEP.Primary.Sound = "weapons/fn_fal/galil-1.wav"

SWEP.Primary.RPM = 250
SWEP.Primary.ClipSize = 20
SWEP.Primary.KickUp = 7
SWEP.Primary.KickDown = 3
SWEP.Primary.KickHorizontal = 5
SWEP.Primary.Automatic = false
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 46
SWEP.Primary.Spread = .037
SWEP.Primary.Ammo = "ar2"

SWEP.IronSightsPos = Vector(-3.175,-1.068,1.27)
SWEP.IronSightsAng = Vector(0.425,0.05,0)

SWEP.LegacyBalance = {
	Primary = {
		RPM = 750,
		ClipSize = 20,
		KickUp = 0.5,
		KickDown = 0.3,
		KickHorizontal = 0.5,
		Automatic = false,
		NumShots = 1,
		Damage = 30,
		Spread = .02
	}
}

-- This Weapon suffers from misaligned ironsights.
-- The Idle, Deploy, and Reload animations are broken because they change the angle of the Weapon that makes it become misaligned.
-- The ironsights are aligned after firing a shot.
-- There is no fix for this.