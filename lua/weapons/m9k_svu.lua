SWEP.Base = "bobs_scoped_base"
SWEP.Category = "M9kR: Sniper Rifles"
SWEP.PrintName = "Dragunov SVU"

SWEP.DynamicLightScale = 1.5 -- Its silenced so the flash is smaller, yes??

SWEP.HoldType = "ar2"
SWEP.Spawnable = true

SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_sniper_svu.mdl"
SWEP.WorldModel = "models/weapons/w_dragunov_svu.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/svu/g3sg1_clipout.mp3",
		iDelay = 0.65
	},
	{
		sSound = "weapons/svu/g3sg1_clipin.mp3",
		iDelay = 0.65 + 1.25
	},
	{
		sSound = "weapons/svu/g3sg1_slide.mp3",
		iDelay = 0.65 + 1.25 + 1.05
	}
}

SWEP.tDrawSoundSequence = {
	{
		sSound = "weapons/svu/g3sg1_slide.mp3",
		iDelay = 0.15
	}
}

SWEP.Primary.Sound = "weapons/svu/g3sg1-1.wav"
SWEP.Primary.SoundVolume = 75 -- Its silenced bro!

SWEP.Primary.RPM = 85
SWEP.Primary.ClipSize = 10
SWEP.Primary.KickUp = 3
SWEP.Primary.KickDown = 2
SWEP.Primary.KickHorizontal = 2
SWEP.Primary.Automatic = false
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 75
SWEP.Primary.Spread = .25
SWEP.Primary.Ammo = "SniperPenetratedRound"

SWEP.Primary.SpreadBefore = SWEP.Primary.Spread

SWEP.ScopeType = "gdcw_svdsight"
SWEP.ScopeStages = 3
SWEP.ScopeScale = 0.7
SWEP.ReticleScale = 0.6

SWEP.LegacyBalance = {
	Primary = {
		RPM = 400,
		ClipSize = 10,
		KickUp = 1,
		KickDown = 1,
		KickHorizontal = 1,
		Automatic = false,
		NumShots = 1,
		Damage = 93,
		Spread = .01
	}
}