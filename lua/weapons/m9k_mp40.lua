SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9kR: Submachine Guns"
SWEP.PrintName = "MP40"

SWEP.Slot = 2
SWEP.HoldType = "smg"
SWEP.Spawnable = true

SWEP.ViewModelFOV = 55
SWEP.ViewModel = "models/weapons/v_mp40smg.mdl"
SWEP.WorldModel = "models/weapons/w_mp40smg.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/hk45/magout.mp3",
		iDelay = 0.25
	},
	{
		sSound = "weapons/mp40/magin.mp3",
		iDelay = 0.25 + 1.50
	},
	{
		sSound = "weapons/mp40/boltback.mp3",
		iDelay = 0.25 + 1.50 + 0.55
	}
}

SWEP.Primary.Sound = "weapons/mp40/mp5-1.wav"

SWEP.Primary.RPM = 500
SWEP.Primary.ClipSize = 32
SWEP.Primary.KickUp = 1.2
SWEP.Primary.KickDown = 0.8
SWEP.Primary.KickHorizontal = 0.75
SWEP.Primary.Automatic = true
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 12
SWEP.Primary.Spread = .034
SWEP.Primary.Ammo = "smg1"

SWEP.IronSightsPos = Vector(3.881,0.187,1.626)

SWEP.LegacyBalance = {
	Primary = {
		RPM = 500,
		ClipSize = 32,
		KickUp = 0.3,
		KickDown = 0.2,
		KickHorizontal = 0.4,
		Automatic = true,
		NumShots = 1,
		Damage = 25,
		Spread = .022
	}
}