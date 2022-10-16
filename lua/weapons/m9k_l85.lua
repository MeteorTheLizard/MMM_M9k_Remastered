SWEP.Base = "bobs_scoped_base"
SWEP.Category = "M9kR: Assault Rifles"
SWEP.PrintName = "L85"

SWEP.DynamicLightScale = 1 -- Set to Default

SWEP.Slot = 3
SWEP.HoldType = "ar2"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_rif_l85.mdl"
SWEP.WorldModel = "models/weapons/w_l85a2.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/L85A2/magout.mp3",
		iDelay = 0.40
	},
	{
		sSound = "weapons/L85A2/magin.mp3",
		iDelay = 0.40 + 0.70
	},
	{
		sSound = "weapons/L85A2/tap.mp3",
		iDelay = 0.40 + 0.70 + 0.25
	},
	{
		sSound = "weapons/L85A2/boltpull.mp3",
		iDelay = 0.40 + 0.70 + 0.25 + 0.70
	}
}

SWEP.tDrawSoundSequence = {
	{
		sSound = "weapons/L85A2/cloth.mp3",
		iDelay = 0.00
	},
	{
		sSound = "weapons/L85A2/boltslap.mp3",
		iDelay = 0.00 + 0.30
	}
}

SWEP.Primary.Sound = "weapons/L85A2/aug-1.wav"

SWEP.Primary.RPM = 325
SWEP.Primary.ClipSize = 30
SWEP.Primary.KickUp = 2.5
SWEP.Primary.KickDown = 1.3
SWEP.Primary.KickHorizontal = 2
SWEP.Primary.Automatic = true
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 38
SWEP.Primary.Spread = .02
SWEP.Primary.Ammo = "ar2"

SWEP.Primary.SpreadBefore = SWEP.Primary.Spread

SWEP.ScopeType = "gdcw_acog"
SWEP.ScopeStages = 1
SWEP.ScopeScale = 0.5
SWEP.ReticleScale = 0.6

SWEP.LegacyBalance = {
	Primary = {
		RPM = 675,
		ClipSize = 30,
		KickUp = .4,
		KickDown = .4,
		KickHorizontal = .5,
		Automatic = true,
		NumShots = 1,
		Damage = 29,
		Spread = .023
	}
}