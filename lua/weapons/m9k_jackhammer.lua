SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9kR: Shotguns"
SWEP.PrintName = "Pancor Jackhammer"

SWEP.Slot = 4
SWEP.HoldType = "ar2"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_jackhammer2.mdl"
SWEP.WorldModel = "models/weapons/w_pancor_jackhammer.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/jackhammer/clipout.mp3",
		iDelay = 1.05
	},
	{
		sSound = "weapons/jackhammer/magtap.mp3",
		iDelay = 1.05 + 0.80
	},
	{
		sSound = "weapons/jackhammer/boltcatch.mp3",
		iDelay = 1.05 + 0.80 + 0.45
	}
}

SWEP.DrawSound = "weapons/jackhammer/cloth.mp3"

SWEP.Primary.Sound = "weapons/jackhammer/xm1014-1.wav"

SWEP.Primary.RPM = 190
SWEP.Primary.ClipSize = 10
SWEP.Primary.KickUp = 2
SWEP.Primary.KickDown = 1
SWEP.Primary.KickHorizontal = 2
SWEP.Primary.Automatic = true
SWEP.Primary.NumShots = 30
SWEP.Primary.Damage = 3
SWEP.Primary.Spread = .19
SWEP.Primary.Ammo = "buckshot"

SWEP.IronSightsPos = Vector(4.026,-2.296,0.917)

SWEP.LegacyBalance = {
	Primary = {
		RPM = 240,
		ClipSize = 10,
		KickUp = 1,
		KickDown = 0.5,
		KickHorizontal = 0.4,
		Automatic = true,
		NumShots = 6,
		Damage = 10,
		Spread = .045
	}
}