SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9kR: Machine Guns"
SWEP.PrintName = "M60 Machine Gun"

SWEP.Slot = 4
SWEP.HoldType = "ar2"
SWEP.Spawnable = true

SWEP.ViewModelFOV = 65
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_m60machinegun.mdl"
SWEP.WorldModel = "models/weapons/w_m60_machine_gun.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/m60/m60_boxout.mp3",
		iDelay = 0.55
	},
	{
		sSound = "weapons/m60/m60_coverup.mp3",
		iDelay = 0.40 + 1.55
	},
	{
		sSound = "weapons/m60/m60_boxin.mp3",
		iDelay = 0.40 + 1.55 + 1.35
	},
	{
		sSound = "weapons/m60/m60_chain.mp3",
		iDelay = 0.40 + 1.55 + 1.35 + 0.75
	},
	{
		sSound = "weapons/m60/m60_coverdown.mp3",
		iDelay = 0.40 + 1.55 + 1.35 + 0.75 + 0.80
	}
}

SWEP.tDrawSoundSequence = {
	{
		sSound = "weapons/m60/m60_coverdown.mp3",  -- What a dumb deploy sound.
		iDelay = 0.35
	}
}

SWEP.Primary.Sound = "weapons/m60/m60-1.wav"

SWEP.Primary.RPM = 465
SWEP.Primary.ClipSize = 200
SWEP.Primary.KickUp = 1.2
SWEP.Primary.KickDown = 0.7
SWEP.Primary.KickHorizontal = 1.3
SWEP.Primary.Automatic = true
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 21
SWEP.Primary.Spread = .045
SWEP.Primary.Ammo = "ar2"

SWEP.IronSightsPos = Vector(-5.851,-2.763,3.141)

SWEP.LegacyBalance = {
	Primary = {
		RPM = 575,
		ClipSize = 200,
		KickUp = 0.6,
		KickDown = 0.4,
		KickHorizontal = 0.5,
		Automatic = true,
		NumShots = 1,
		Damage = 33,
		Spread = .035
	}
}