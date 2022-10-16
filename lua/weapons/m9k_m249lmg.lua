SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9kR: Machine Guns"
SWEP.PrintName = "M249 LMG"

SWEP.Slot = 4
SWEP.HoldType = "ar2"
SWEP.Spawnable = true

SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_machinegun249.mdl"
SWEP.WorldModel = "models/weapons/w_m249_machine_gun.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/schmung.M249/m249_boxout.mp3",
		iDelay = 0.70
	},
	{
		sSound = "weapons/schmung.M249/m249_coverup.mp3",
		iDelay = 0.70 + 1.85
	},
	{
		sSound = "weapons/schmung.M249/m249_chain.mp3",
		iDelay = 0.70 + 1.85 + 0.85
	},
	{
		sSound = "weapons/schmung.M249/m249_coverdown.mp3",
		iDelay = 0.70 + 1.85 + 0.85 + 1.10
	}
}

SWEP.tDrawSoundSequence = {
	{
		sSound = "weapons/schmung.M249/boltpull.mp3",
		iDelay = 0.20
	},
	{
		sSound = "weapons/schmung.M249/boltrel.mp3",
		iDelay = 0.20 + 0.25
	}
}

SWEP.Primary.Sound = "weapons/schmung.M249/m249-1.wav"

SWEP.Primary.RPM = 755
SWEP.Primary.ClipSize = 150
SWEP.Primary.KickUp = 1.3
SWEP.Primary.KickDown = 0.7
SWEP.Primary.KickHorizontal = 1.2
SWEP.Primary.Automatic = true
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 23
SWEP.Primary.Spread = .041
SWEP.Primary.Ammo = "ar2"

SWEP.IronSightsPos = Vector(-4.015,0,1.765)
SWEP.IronSightsAng = Vector(0,-0.014,0)

SWEP.LegacyBalance = {
	Primary = {
		RPM = 855,
		ClipSize = 150,
		KickUp = 0.6,
		KickDown = 0.4,
		KickHorizontal = 0.5,
		Automatic = true,
		NumShots = 1,
		Damage = 27,
		Spread = .035
	}
}