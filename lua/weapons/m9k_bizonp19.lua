SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9kR: Submachine Guns"
SWEP.PrintName = "Bizon PP19"

SWEP.Slot = 2
SWEP.HoldType = "ar2"
SWEP.Spawnable = true

SWEP.ViewModelFOV = 65
SWEP.ViewModel = "models/weapons/v_bizon19.mdl"
SWEP.WorldModel = "models/weapons/w_pp19_bizon.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/p19/p90_cliprelease.mp3",
		iDelay = 0.45
	},
	{
		sSound = "weapons/p19/p90_clipout.mp3",
		iDelay = 0.45 + 0.25
	},
	{
		sSound = "weapons/p19/p90_clipin.mp3",
		iDelay = 0.45 + 0.25 + 0.95
	},
	{
		sSound = "weapons/p19/p90_boltpull.mp3",
		iDelay = 0.45 + 0.25 + 0.95 + 1.05
	}
}

SWEP.Primary.Sound = "weapons/p19/p90-1.wav"

SWEP.Primary.RPM = 700
SWEP.Primary.ClipSize = 64
SWEP.Primary.KickUp = 1
SWEP.Primary.KickDown = 1
SWEP.Primary.KickHorizontal = 1
SWEP.Primary.Automatic = true
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 12
SWEP.Primary.Spread = .025
SWEP.Primary.Ammo = "smg1"

SWEP.IronSightsPos = Vector(3.359,0,0.839)
SWEP.IronSightsAng = Vector(0.744,-0.588,0)

SWEP.LegacyBalance = {
	Primary = {
		RPM = 675,
		ClipSize = 64,
		KickUp = 0.6,
		KickDown = 0.4,
		KickHorizontal = 0.5,
		Automatic = true,
		NumShots = 1,
		Damage = 19,
		Spread = .02
	}
}