SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9kR: Submachine Guns"
SWEP.PrintName = "Tommy Gun"

SWEP.Slot = 2
SWEP.HoldType = "smg"
SWEP.Spawnable = true

SWEP.ViewModelFOV = 65
SWEP.ViewModel = "models/weapons/v_tommy_g.mdl"
SWEP.WorldModel = "models/weapons/w_tommy_gun.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/tmg/tmg_magout.mp3",
		iDelay = 0.45
	},
	{
		sSound = "weapons/tmg/tmg_magin.mp3",
		iDelay = 0.45 + 1.20
	},
	{
		sSound = "weapons/tmg/tmg_cock.mp3",
		iDelay = 0.45 + 1.20 + 0.85
	}
}

SWEP.Primary.Sound = "weapons/tmg/tmg_1.wav"

SWEP.Primary.RPM = 700
SWEP.Primary.ClipSize = 85
SWEP.Primary.KickUp = 0.8
SWEP.Primary.KickDown = 0.5
SWEP.Primary.KickHorizontal = 0.6
SWEP.Primary.Automatic = true
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 11
SWEP.Primary.Spread = .05
SWEP.Primary.Ammo = "smg1"

SWEP.IronSightsPos = Vector(3.359,0,1.84)
SWEP.IronSightsAng = Vector(-2.166,-4.039,0)

SWEP.LegacyBalance = {
	Primary = {
		RPM = 575,
		ClipSize = 75,
		KickUp = 0.7,
		KickDown = 0.6,
		KickHorizontal = 0.65,
		Automatic = true,
		NumShots = 1,
		Damage = 22,
		Spread = .03
	}
}