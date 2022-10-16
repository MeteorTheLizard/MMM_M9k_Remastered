SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9kR: Pistols"
SWEP.PrintName = "P08 Luger"

SWEP.Slot = 1
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_p08_luger.mdl"
SWEP.WorldModel = "models/weapons/w_luger_p08.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/luger/luger_sliderelease.mp3",
		iDelay = 0.00
	},
	{
		sSound = "weapons/luger/luger_clipout.mp3",
		iDelay = 0.00 + 0.85
	},
	{
		sSound = "weapons/luger/luger_clipin.mp3",
		iDelay = 0.00 + 0.85 + 0.65
	},
	{
		sSound = "weapons/luger/luger_sliderelease.mp3",
		iDelay = 0.00 + 0.85 + 0.65 + 0.35
	}
}

SWEP.Primary.Sound = "weapons/luger/luger-1.wav"

SWEP.Primary.RPM = 825
SWEP.Primary.ClipSize = 8
SWEP.Primary.KickUp = 1.4
SWEP.Primary.KickDown = 0.7
SWEP.Primary.KickHorizontal = 1.3
SWEP.Primary.Automatic = false
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 26
SWEP.Primary.Spread = .025
SWEP.Primary.Ammo = "pistol"

SWEP.IronSightsPos = Vector(2.71,-2.122,2.27)
SWEP.IronSightsAng = Vector(0.563,-0.013,0)

SWEP.LegacyBalance = {
	Primary = {
		RPM = 825,
		ClipSize = 8,
		KickUp = 0.35,
		KickDown = 0.3,
		KickHorizontal = 0.2,
		Automatic = false,
		NumShots = 1,
		Damage = 23,
		Spread = .021
	}
}