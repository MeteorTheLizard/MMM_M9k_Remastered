SWEP.Base = "bobs_scoped_base"
SWEP.Category = "M9kR: Assault Rifles"
SWEP.PrintName = "Steyr AUG A3"

SWEP.DynamicLightScale = 1 -- Set to Default

SWEP.Slot = 3
SWEP.HoldType = "smg"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_auga3sa.mdl"
SWEP.WorldModel = "models/weapons/w_auga3.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/auga3/clipout.mp3",
		iDelay = 0.60
	},
	{
		sSound = "weapons/auga3/clipin.mp3",
		iDelay = 0.60 + 1.30
	},
	{
		sSound = "weapons/auga3/boltpull.mp3",
		iDelay = 0.60 + 1.30 + 0.50
	}
}

SWEP.tDrawSoundSequence = {
	{
		sSound = "weapons/auga3/boltslap.mp3",
		iDelay = 0.65
	}
}

SWEP.Primary.Sound = "weapons/auga3/aug-1.wav"

SWEP.Primary.RPM = 345
SWEP.Primary.ClipSize = 30
SWEP.Primary.KickUp = 2.5
SWEP.Primary.KickDown = 1.9
SWEP.Primary.KickHorizontal = 1.75
SWEP.Primary.Automatic = true
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 35
SWEP.Primary.Spread = .03
SWEP.Primary.Ammo = "ar2"

SWEP.Primary.SpreadBefore = SWEP.Primary.Spread

SWEP.ScopeType = "gdcw_aimpoint"
SWEP.ScopeStages = 1
SWEP.ScopeScale = 0.5
SWEP.ReticleScale = 0.6

SWEP.LegacyBalance = {
	Primary = {
		RPM = 700,
		ClipSize = 30,
		KickUp = .4,
		KickDown = .4,
		KickHorizontal = .5,
		Automatic = true,
		NumShots = 1,
		Damage = 22,
		Spread = .025
	}
}