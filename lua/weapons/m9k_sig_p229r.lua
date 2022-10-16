SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9kR: Pistols"
SWEP.PrintName = "SIG Sauer P229R"

SWEP.Slot = 1
SWEP.Spawnable = true

SWEP.ViewModelFOV = 65
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_sick_p228.mdl"
SWEP.WorldModel = "models/weapons/w_sig_229r.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/sig_p228/shift.mp3",
		iDelay = 0.05
	},
	{
		sSound = "weapons/sig_p228/magout.mp3",
		iDelay = 0.05 + 0.40
	},
	{
		sSound = "weapons/sig_p228/magin.mp3",
		iDelay = 0.05 + 0.40 + 0.80
	},
	{
		sSound = "weapons/sig_p228/magshove.mp3",
		iDelay = 0.05 + 0.40 + 0.80 + 0.45
	},
	{
		sSound = "weapons/sig_p228/sliderelease.mp3",
		iDelay = 0.05 + 0.40 + 0.80 + 0.45 + 0.45
	}
}

SWEP.DrawSound = "weapons/sig_p228/cloth.mp3"

SWEP.Primary.Sound = "weapons/sig_p228/p228-1.wav"

SWEP.Primary.RPM = 285
SWEP.Primary.ClipSize = 12
SWEP.Primary.KickUp = 1.8
SWEP.Primary.KickDown = 0.9
SWEP.Primary.KickHorizontal = 1.4
SWEP.Primary.Automatic = false
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 21
SWEP.Primary.Spread = .022
SWEP.Primary.Ammo = "pistol"

SWEP.IronSightsPos = Vector(-2.653,-.686,1.06)
SWEP.IronSightsAng = Vector(0.3,0,0)

SWEP.LegacyBalance = {
	Primary = {
		RPM = 500,
		ClipSize = 12,
		KickUp = 0.4,
		KickDown = 0.3,
		KickHorizontal = 0.3,
		Automatic = false,
		NumShots = 1,
		Damage = 17,
		Spread = .025
	}
}