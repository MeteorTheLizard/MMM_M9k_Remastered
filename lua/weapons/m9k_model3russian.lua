SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9kR: Pistols"
SWEP.PrintName = "S&W Model 3 Russian"

SWEP.Slot = 1
SWEP.HoldType = "revolver"
SWEP.Spawnable = true

SWEP.ViewModelFOV = 60
SWEP.ViewModel = "models/weapons/v_pist_model3.mdl"
SWEP.WorldModel = "models/weapons/w_model_3_rus.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/model3/Hammer.mp3",
		iDelay = 0.45
	},
	{
		sSound = "weapons/model3/Break_eject.mp3",
		iDelay = 0.45 + 0.25
	},
	{
		sSound = "weapons/model3/bulletout_1.mp3",
		iDelay = 0.45 + 0.25 + 0.35
	},
	{
		sSound = "weapons/model3/bulletout_2.mp3",
		iDelay = 0.45 + 0.25 + 0.35 + 0.10
	},
	{
		sSound = "weapons/model3/bulletout_3.mp3",
		iDelay = 0.45 + 0.25 + 0.35 + 0.10 + 0.10
	},
	{
		sSound = "weapons/model3/bullets_in.mp3",
		iDelay = 0.45 + 0.25 + 0.35 + 0.10 + 0.10 + 0.30
	},
	{
		sSound = "weapons/model3/Break_Close.mp3",
		iDelay = 0.45 + 0.25 + 0.35 + 0.10 + 0.10 + 0.30 + 0.35
	}
}

SWEP.Primary.Sound = "weapons/model3/model3-1.wav"

SWEP.Primary.RPM = 110
SWEP.Primary.ClipSize = 6
SWEP.Primary.KickUp = 7
SWEP.Primary.KickDown = 5
SWEP.Primary.KickHorizontal = 10
SWEP.Primary.Automatic = false
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 70
SWEP.Primary.Spread = .020
SWEP.Primary.Ammo = "357"

SWEP.IronSightsPos = Vector(4.06,0,0.876)
SWEP.IronSightsAng = Vector(-0.207,0,0)

SWEP.LegacyBalance = {
	Primary = {
		RPM = 115,
		ClipSize = 6,
		KickUp = 1,
		KickDown = 0.5,
		KickHorizontal = 0.5,
		Automatic = false,
		NumShots = 1,
		Damage = 30,
		Spread = .02
	}
}