SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9kR: Machine Guns"
SWEP.PrintName = "M1918 BAR"

SWEP.Slot = 4
SWEP.HoldType = "ar2"
SWEP.Spawnable = true

SWEP.ViewModelFOV = 65
SWEP.ViewModel = "models/weapons/v_m1918bar.mdl"
SWEP.WorldModel = "models/weapons/w_m1918_bar.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/jen.ak/mag.out.mp3",
		iDelay = 0.35
	},
	{
		sSound = "weapons/jen.ak/mag.in.mp3",
		iDelay = 0.35 + 0.50
	},
	{
		sSound = "weapons/jen.ak/bolt.pull.mp3",
		iDelay = 0.35 + 0.50 + 0.85
	},
	{
		sSound = "weapons/jen.ak/bolt.rel.mp3",
		iDelay = 0.35 + 0.50 + 0.85 + 0.25
	}
}

SWEP.tDrawSoundSequence = {
	{
		sSound = "weapons/jen.ak/bolt.pull.mp3",
		iDelay = 0.35
	},
	{
		sSound = "weapons/jen.ak/bolt.rel.mp3",
		iDelay = 0.35 + 0.25
	}
}

SWEP.Primary.Sound = "weapons/jen.ak/fire.wav"

SWEP.Primary.RPM = 450
SWEP.Primary.ClipSize = 20
SWEP.Primary.KickUp = 2.3
SWEP.Primary.KickDown = 1.5
SWEP.Primary.KickHorizontal = 1.7
SWEP.Primary.Automatic = true
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 28
SWEP.Primary.Spread = .027
SWEP.Primary.Ammo = "ar2"

SWEP.IronSightsPos = Vector(3.305,0,1.399)

SWEP.LegacyBalance = {
	Primary = {
		RPM = 450,
		ClipSize = 20,
		KickUp = 0.6,
		KickDown = 0.4,
		KickHorizontal = 0.5,
		Automatic = true,
		NumShots = 1,
		Damage = 40,
		Spread = .025
	}
}