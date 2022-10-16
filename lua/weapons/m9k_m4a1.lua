SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9kR: Assault Rifles"
SWEP.PrintName = "M4A1 Iron"

SWEP.Slot = 3
SWEP.HoldType = "ar2"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_m4a1_iron.mdl"
SWEP.WorldModel = "models/weapons/w_m4a1_iron.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/dmg_m16a4/magout.mp3",
		iDelay = 0.25
	},
	{
		sSound = "weapons/dmg_m16a4/magin.mp3",
		iDelay = 0.25 + 0.85
	},
	{
		sSound = "weapons/dmg_m16a4/boltrelease.mp3",
		iDelay = 0.25 + 0.85 + 1.35
	}
}

SWEP.tDrawSoundSequence = {
	{
		sSound = "weapons/dmg_m16a4/boltpull.mp3",
		iDelay = 0.15
	},
	{
		sSound = "weapons/dmg_m16a4/boltrelease.mp3",
		iDelay = 0.15 + 0.25
	}
}

SWEP.Primary.Sound = "weapons/dmg_m4a1/m4a1_unsil-1.wav"

SWEP.Primary.RPM = 345
SWEP.Primary.ClipSize = 30
SWEP.Primary.KickUp = 3
SWEP.Primary.KickDown = 1.8
SWEP.Primary.KickHorizontal = 2.2
SWEP.Primary.Automatic = true
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 24
SWEP.Primary.Spread = .02
SWEP.Primary.Ammo = "ar2"

SWEP.IronSightsPos = Vector(2.4537,1.0923,0.2696)
SWEP.IronSightsAng = Vector(-0.0105,-0.0061,0)

SWEP.LegacyBalance = {
	Primary = {
		RPM = 800,
		ClipSize = 30,
		KickUp = 0.4,
		KickDown = 0.4,
		KickHorizontal = 0.5,
		Automatic = true,
		NumShots = 1,
		Damage = 30,
		Spread = .02
	}
}

-- This Weapon suffers from misaligned ironsights.
-- The Idle, Deploy, and Reload animations are broken because they change the angle of the Weapon that makes it become misaligned.
-- The ironsights are aligned after firing a shot.
-- There is no fix for this.