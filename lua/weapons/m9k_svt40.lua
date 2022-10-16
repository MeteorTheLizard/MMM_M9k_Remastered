SWEP.Base = "bobs_scoped_base"
SWEP.Category = "M9kR: Sniper Rifles"
SWEP.PrintName = "SVT 40"

SWEP.DynamicLightScale = 1 -- Set to Default

SWEP.HoldType = "ar2"
SWEP.Spawnable = true

SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_snip_svt40.mdl"
SWEP.WorldModel = "models/weapons/w_svt_40.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/svt40/g3sg1_cloth1.mp3",
		iDelay = 0.10
	},
	{
		sSound = "weapons/svt40/g3sg1_clipout.mp3",
		iDelay = 0.10 + 0.75
	},
	{
		sSound = "weapons/svt40/g3sg1_clipin.mp3",
		iDelay = 0.10 + 0.75 + 1.25
	},
	{
		sSound = "weapons/svt40/g3sg1_cliptap.mp3",
		iDelay = 0.10 + 0.75 + 1.25 + 1.10
	},
	{
		sSound = "weapons/svt40/g3sg1_slide_b.mp3",
		iDelay = 0.10 + 0.75 + 1.25 + 1.10 + 0.85
	},
	{
		sSound = "weapons/svt40/g3sg1_slide_f.mp3",
		iDelay = 0.10 + 0.75 + 1.25 + 1.10 + 0.85 + 0.25
	}
}

SWEP.tDrawSoundSequence = {
	{
		sSound = "weapons/svt40/g3sg1_cloth1.mp3",
		iDelay = 0.10
	},
	{
		sSound = "weapons/svt40/g3sg1_slide_b.mp3",
		iDelay = 0.10 + 0.75
	},
	{
		sSound = "weapons/svt40/g3sg1_slide_f.mp3",
		iDelay = 0.10 + 0.75 + 0.30
	},
	{
		sSound = "weapons/svt40/g3sg1_cloth2.mp3",
		iDelay = 0.10 + 0.75 + 0.30 + 0.35
	}
}

SWEP.Primary.Sound = "weapons/svt40/g3sg1-1.wav"

SWEP.Primary.RPM = 300
SWEP.Primary.ClipSize = 10
SWEP.Primary.KickUp = 3
SWEP.Primary.KickDown = 1
SWEP.Primary.KickHorizontal = 4
SWEP.Primary.Automatic = false
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 47
SWEP.Primary.Spread = .15
SWEP.Primary.Ammo = "SniperPenetratedRound"

SWEP.Primary.SpreadBefore = SWEP.Primary.Spread

SWEP.ScopeType = "gdcw_scopesight"
SWEP.ScopeStages = 3
SWEP.ScopeScale = 0.7
SWEP.ReticleScale = 0.6

SWEP.LegacyBalance = {
	Primary = {
		RPM = 350,
		ClipSize = 10,
		KickUp = 1,
		KickDown = 1,
		KickHorizontal = 1,
		Automatic = false,
		NumShots = 1,
		Damage = 80,
		Spread = .01
	}
}