SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9kR: Machine Guns"
SWEP.PrintName = "Ares Shrike"

SWEP.Slot = 4
SWEP.HoldType = "ar2"
SWEP.Spawnable = true

SWEP.ViewModelFOV = 65
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_ares_shrike01.mdl"
SWEP.WorldModel = "models/weapons/w_ares_shrike.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/shrike/boxout.mp3",
		iDelay = 0.40
	},
	{
		sSound = "weapons/shrike/coverup.mp3",
		iDelay = 0.40 + 1.050
	},
	{
		sSound = "weapons/shrike/bullet.mp3",
		iDelay = 0.40 + 1.05 + 0.70
	},
	{
		sSound = "weapons/shrike/boxin.mp3",
		iDelay = 0.40 + 1.05 + 0.70 + 0.90
	},
	{
		sSound = "weapons/shrike/bullet.mp3",
		iDelay = 0.40 + 1.05 + 0.70 + 0.90 + 0.35
	},
	{
		sSound = "weapons/shrike/coverdown.mp3",
		iDelay = 0.40 + 1.05 + 0.70 + 0.90 + 0.35 + 0.95
	}
}

SWEP.DrawSound = "weapons/shrike/ready.mp3"

SWEP.Primary.Sound = "weapons/shrike/shrike-1.wav"
SWEP.Primary.SoundVolume = 85

SWEP.Primary.RPM = 650
SWEP.Primary.ClipSize = 200
SWEP.Primary.KickUp = 1.2
SWEP.Primary.KickDown = 0.9
SWEP.Primary.KickHorizontal = 1.1
SWEP.Primary.Automatic = true
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 21
SWEP.Primary.Spread = .056
SWEP.Primary.Ammo = "ar2"

SWEP.IronSightsPos = Vector(-3.804,0,0.495)
SWEP.IronSightsAng = Vector(0.119,-0.019,0)

SWEP.LegacyBalance = {
	Primary = {
		RPM = 650,
		ClipSize = 200,
		KickUp = 0.6,
		KickDown = 0.4,
		KickHorizontal = 0.5,
		Automatic = true,
		Ammo = "ar2",
		NumShots = 1,
		Damage = 30,
		Spread = .03
	}
}