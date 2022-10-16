SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9kR: Pistols"
SWEP.PrintName = "TEC-9"

SWEP.Slot = 1
SWEP.HoldType = "smg"
SWEP.Spawnable = true

SWEP.ViewModelFOV = 60
SWEP.ViewModel = "models/weapons/v_tec_9_smg.mdl"
SWEP.WorldModel = "models/weapons/w_intratec_tec9.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/tec9/tec9_magout.mp3",
		iDelay = 0.35
	},
	{
		sSound = "weapons/tec9/tec9_newmag.mp3",
		iDelay = 0.35 + 0.35
	},
	{
		sSound = "weapons/tec9/tec9_magin.mp3",
		iDelay = 0.35 + 0.40 + 0.75
	},
	{
		sSound = "weapons/tec9/tec9_charge.mp3",
		iDelay = 0.35 + 0.40 + 0.75 + 1.45
	}
}

SWEP.tDrawSoundSequence = {
	{
		sSound = "weapons/tec9/tec9_charge.mp3",
		iDelay = 0.25
	}
}

SWEP.Primary.Sound = "weapons/tec9/ump45-1.wav"

SWEP.Primary.RPM = 400
SWEP.Primary.ClipSize = 32
SWEP.Primary.KickUp = 2.5
SWEP.Primary.KickDown = 1.3
SWEP.Primary.KickHorizontal = 1.5
SWEP.Primary.Automatic = true
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 16
SWEP.Primary.Spread = .029
SWEP.Primary.Ammo = "pistol"

SWEP.IronSightsPos = Vector(4.314,-1.216,2.135)

SWEP.LegacyBalance = {
	Primary = {
		RPM = 825,
		ClipSize = 32,
		KickUp = 0.2,
		KickDown = 0.3,
		KickHorizontal = 0.1,
		Automatic = true,
		NumShots = 1,
		Damage = 17,
		Spread = .029
	}
}