SWEP.Base = "bobs_scoped_base"
SWEP.Category = "M9kR: Pistols"
SWEP.PrintName = "Raging Bull - Scoped"

SWEP.DynamicLightScale = 1 -- Set to Default

SWEP.Slot = 1
SWEP.HoldType = "revolver"
SWEP.Spawnable = true

SWEP.ViewModelFOV = 65
SWEP.ViewModel = "models/weapons/v_raging_bull_scoped.mdl"
SWEP.WorldModel = "models/weapons/w_raging_bull_scoped.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/r_bull/bullreload.mp3",
		iDelay = 0.05
	}
}

SWEP.tDrawSoundSequence = {
	{
		sSound = "weapons/r_bull/draw_gun.mp3",
		iDelay = 0.05
	}
}

SWEP.Primary.Sound = "weapons/r_bull/r-bull-1.wav"

SWEP.Primary.RPM = 115
SWEP.Primary.ClipSize = 6
SWEP.Primary.KickUp = 9
SWEP.Primary.KickDown = 4
SWEP.Primary.KickHorizontal = 6.5
SWEP.Primary.Automatic = false
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 75
SWEP.Primary.Spread = .018
SWEP.Primary.Ammo = "357"

SWEP.Primary.SpreadBefore = SWEP.Primary.Spread

SWEP.ScopeType = "gdcw_scopesight"
SWEP.ScopeStages = 3
SWEP.ScopeScale = 0.7
SWEP.ReticleScale = 0.6

SWEP.LegacyBalance = {
	Primary = {
		RPM = 115,
		ClipSize = 6,
		KickUp = 10,
		KickDown = .5,
		KickHorizontal = 1,
		Automatic = false,
		NumShots = 1,
		Damage = 31,
		Spread = .02
	}
}