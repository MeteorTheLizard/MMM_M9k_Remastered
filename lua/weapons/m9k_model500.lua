SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9kR: Pistols"
SWEP.PrintName = "S&W Model 500"

SWEP.Slot = 1
SWEP.HoldType = "revolver"
SWEP.Spawnable = true

SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_swmodel_500.mdl"
SWEP.WorldModel = "models/weapons/w_sw_model_500.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/model500/de_clipout.mp3",
		iDelay = 0.25
	},
	{
		sSound = "weapons/model500/de_clipin.mp3",
		iDelay = 0.25 + 0.65
	},
	{
		sSound = "weapons/model500/de_slideback.mp3",
		iDelay = 0.25 + 0.65 + 0.35
	}
}

SWEP.tDrawSoundSequence = {
	{
		sSound = "weapons/model500/de_deploy.mp3",
		iDelay = 0.05
	}
}

SWEP.Primary.Sound = "weapons/model500/deagle-1.wav"

SWEP.Primary.RPM = 100
SWEP.Primary.ClipSize = 5
SWEP.Primary.KickUp = 15
SWEP.Primary.KickDown = 5
SWEP.Primary.KickHorizontal = 10
SWEP.Primary.Automatic = false
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 85
SWEP.Primary.Spread = .024
SWEP.Primary.Ammo = "357"

SWEP.IronSightsPos = Vector(-1.923,-1.675,0.374)
SWEP.IronSightsAng = Vector(0.052,0,0)

SWEP.LegacyBalance = {
	Primary = {
		RPM = 100,
		ClipSize = 5,
		KickUp = 1,
		KickDown = 0.3,
		KickHorizontal = 1,
		Automatic = false,
		NumShots = 1,
		Damage = 40,
		Spread = .02
	}
}