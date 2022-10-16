SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9kR: Pistols"
SWEP.PrintName = "S&W Model 627"

SWEP.Slot = 1
SWEP.HoldType = "revolver"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_swmodel_627.mdl"
SWEP.WorldModel = "models/weapons/w_sw_model_627.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/627/wheel_out.mp3",
		iDelay = 0.35
	},
	{
		sSound = "weapons/627/bullets_in.mp3",
		iDelay = 0.35 + 0.55
	},
	{
		sSound = "weapons/627/bulletout_1.mp3",
		iDelay = 0.35 + 0.55 + 0.35
	},
	{
		sSound = "weapons/627/bulletout_2.mp3",
		iDelay = 0.35 + 0.55 + 0.35 + 0.25
	},
	{
		sSound = "weapons/627/bulletout_3.mp3",
		iDelay = 0.35 + 0.55 + 0.35 + 0.25 + 0.25
	},
	{
		sSound = "weapons/627/bullets_in.mp3",
		iDelay = 0.35 + 0.55 + 0.35 + 0.25 + 0.30
	},
	{
		sSound = "weapons/627/wheel_in.mp3",
		iDelay = 0.35 + 0.55 + 0.35 + 0.25 + 0.30 + 0.65
	}
}

SWEP.tDrawSoundSequence = {
	{
		sSound = "weapons/627/wheel_in.mp3",
		iDelay = 0.65
	}
}

SWEP.Primary.Sound = "weapons/627/deagle-1.wav"

SWEP.Primary.RPM = 96
SWEP.Primary.ClipSize = 6
SWEP.Primary.KickUp = 7.5
SWEP.Primary.KickDown = 3
SWEP.Primary.KickHorizontal = 6
SWEP.Primary.Automatic = true
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 67
SWEP.Primary.Spread = .019
SWEP.Primary.Ammo = "357"

SWEP.IronSightsPos = Vector(2.68,0.019,1.521)
SWEP.IronSightsAng = Vector(-0.141,-0.139,0)

SWEP.LegacyBalance = {
	Primary = {
		RPM = 120,
		ClipSize = 6,
		KickUp = 0.3,
		KickDown = 0.3,
		KickHorizontal = 0.3,
		Automatic = true,
		NumShots = 1,
		Damage = 20,
		Spread = .01
	}
}