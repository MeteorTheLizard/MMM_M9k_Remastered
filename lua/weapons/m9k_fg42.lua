SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9kR: Machine Guns"
SWEP.PrintName = "FG 42"

SWEP.Slot = 4
SWEP.HoldType = "ar2"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_rif_fg42.mdl"
SWEP.WorldModel = "models/weapons/w_fg42.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/fg42/ak47_clipout.mp3",
		iDelay = 0.35
	},
	{
		sSound = "weapons/fg42/ak47_clipin.mp3",
		iDelay = 0.35 + 1.00
	},
	{
		sSound = "weapons/fg42/ak47_boltpull.mp3",
		iDelay = 0.35 + 1.00 + 0.55
	}
}

SWEP.Primary.Sound = "weapons/fg42/ak47-1.wav"

SWEP.Primary.RPM = 250
SWEP.Primary.ClipSize = 20
SWEP.Primary.KickUp = 2.3
SWEP.Primary.KickDown = 1.5
SWEP.Primary.KickHorizontal = 1.7
SWEP.Primary.Automatic = true
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 42
SWEP.Primary.Spread = .05
SWEP.Primary.Ammo = "ar2"

SWEP.IronSightsPos = Vector(3.47,-6.078,1.96)
SWEP.IronSightsAng = Vector(0.216,-0.082,0)

SWEP.LegacyBalance = {
	Primary = {
		RPM = 900,
		ClipSize = 20,
		KickUp = 0.3,
		KickDown = 0.3,
		KickHorizontal = 0.3,
		Automatic = true,
		NumShots = 1,
		Damage = 38,
		Spread = .02
	}
}