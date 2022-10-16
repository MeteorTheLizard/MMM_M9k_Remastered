SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9kR: Assault Rifles"
SWEP.PrintName = "AMD 65"

SWEP.Slot = 3
SWEP.HoldType = "ar2"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_amd_65.mdl"
SWEP.WorldModel = "models/weapons/w_amd_65.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/amd65/clipout.mp3",
		iDelay = 0.50
	},
	{
		sSound = "weapons/amd65/magin2.mp3",
		iDelay = 0.50 + 0.65
	},
	{
		sSound = "weapons/amd65/boltpull.mp3",
		iDelay = 0.50 + 0.65 + 0.55
	},
	{
		sSound = "weapons/amd65/boltrelease.mp3",
		iDelay = 0.50 + 0.65 + 0.55 + 0.25
	}
}

SWEP.Primary.Sound = "weapons/amd65/amd-1.wav"

SWEP.Primary.RPM = 395
SWEP.Primary.ClipSize = 20
SWEP.Primary.KickUp = 1.9
SWEP.Primary.KickDown = 1.1
SWEP.Primary.KickHorizontal = 1.15
SWEP.Primary.Automatic = true
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 34
SWEP.Primary.Spread = .029
SWEP.Primary.Ammo = "ar2"

SWEP.IronSightsPos = Vector(3.5,-2.21,2.115)
SWEP.IronSightsAng = Vector(-3.701,0,0)

SWEP.LegacyBalance = {
	Primary = {
		RPM = 750,
		ClipSize = 20,
		KickUp = .7,
		KickDown = 0.2,
		KickHorizontal = 0.4,
		Automatic = true,
		NumShots = 1,
		Damage = 31,
		Spread = .021
	}
}