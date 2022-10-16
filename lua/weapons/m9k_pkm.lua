SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9kR: Machine Guns"
SWEP.PrintName = "PKM"

SWEP.Slot = 4
SWEP.HoldType = "ar2"
SWEP.Spawnable = true

SWEP.ViewModelFOV = 55
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_mach_russ_pkm.mdl"
SWEP.WorldModel = "models/weapons/w_mach_russ_pkm.mdl"

SWEP.tReloadDynamic = { -- Insanity
	{
		sSound = "weapons/pkm/pkm_cloth.mp3",
		iDelay = 0.65
	},
	{
		sSound = "weapons/pkm/pkm_coverup.mp3",
		iDelay = 0.65 + 0.45
	},
	{
		sSound = "weapons/pkm/pkm_bullet.mp3",
		iDelay = 0.65 + 0.45 + 0.15
	},
	{
		sSound = "weapons/pkm/pkm_boxout.mp3",
		iDelay = 0.65 + 0.45 + 0.15 + 1.15
	},
	{
		sSound = "weapons/pkm/pkm_boxin.mp3",
		iDelay = 0.65 + 0.45 + 0.15 + 1.15 + 1.15
	},
	{
		sSound = "weapons/pkm/pkm_chain.mp3",
		iDelay = 0.65 + 0.45 + 0.15 + 1.15 + 1.15 + 0.25
	},
	{
		sSound = "weapons/pkm/pkm_coverdown.mp3",
		iDelay = 0.65 + 0.45 + 0.15 + 1.15 + 1.15 + 0.25 + 0.80
	},
	{
		sSound = "weapons/pkm/pkm_coversmack.mp3",
		iDelay = 0.65 + 0.45 + 0.15 + 1.15 + 1.15 + 0.25 + 0.80 + 0.35
	},
	{
		sSound = "weapons/pkm/pkm_bolt.mp3",
		iDelay = 0.65 + 0.45 + 0.15 + 1.15 + 1.15 + 0.25 + 0.80 + 0.35 + 0.65
	}
}

SWEP.DrawSound = "weapons/pkm/pkm_draw.mp3"

SWEP.Primary.Sound = "weapons/pkm/pkm-2.wav"

SWEP.Primary.RPM = 675
SWEP.Primary.ClipSize = 100
SWEP.Primary.KickUp = 1.2
SWEP.Primary.KickDown = 0.8
SWEP.Primary.KickHorizontal = 0.9
SWEP.Primary.Automatic = true
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 17
SWEP.Primary.Spread = .038
SWEP.Primary.Ammo = "ar2"

SWEP.IronSightsPos = Vector(-2.22,-2.116,0.36)
SWEP.IronSightsAng = Vector(-0.13,0.054,0)

SWEP.LegacyBalance = {
	Primary = {
		RPM = 750,
		ClipSize = 100,
		KickUp = 0.6,
		KickDown = 0.3,
		KickHorizontal = 0.5,
		Automatic = true,
		NumShots = 1,
		Damage = 33,
		Spread = .035
	}
}