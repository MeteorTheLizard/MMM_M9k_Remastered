SWEP.Base = "bobs_scoped_base"
SWEP.Category = "M9kR: Sniper Rifles"
SWEP.PrintName = "SVD Dragunov"

SWEP.HoldType = "ar2"
SWEP.Spawnable = true

SWEP.ViewModelFOV = 65
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_dragunov02.mdl"
SWEP.WorldModel = "models/weapons/w_svd_dragunov.mdl"

SWEP.tReloadDynamic = { -- What a monster
	{
		sSound = "weapons/SVD/handle.mp3",
		iDelay = 0.35
	},
	{
		sSound = "weapons/SVD/Clipout.mp3",
		iDelay = 0.35 + 0.60
	},
	{
		sSound = "weapons/SVD/ClipIn.mp3",
		iDelay = 0.35 + 0.60 + 1.00
	},
	{
		sSound = "weapons/SVD/Cliptap.mp3",
		iDelay = 0.35 + 0.60 + 1.00 + 0.30
	},
	{
		sSound = "weapons/SVD/SlideBack.mp3",
		iDelay = 0.35 + 0.60 + 1.00 + 0.30 + 0.50
	},
	{
		sSound = "weapons/SVD/SlideForward.mp3",
		iDelay = 0.35 + 0.60 + 1.00 + 0.30 + 0.50 + 0.20
	},
	{
		sSound = "weapons/SVD/foley.mp3",
		iDelay = 0.35 + 0.60 + 1.00 + 0.30 + 0.50 + 0.20 + 0.35
	}
}

SWEP.DrawSound = "weapons/SVD/Draw.mp3"

SWEP.Primary.Sound = "weapons/SVD/g3sg1-1.wav"

SWEP.Primary.RPM = 125
SWEP.Primary.ClipSize = 10
SWEP.Primary.KickUp = 5
SWEP.Primary.KickDown = 3
SWEP.Primary.KickHorizontal = 5
SWEP.Primary.Automatic = false
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 76
SWEP.Primary.Spread = .15
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
		KickDown = .6,
		KickHorizontal = .5,
		Automatic = false,
		NumShots = 1,
		Damage = 90,
		Spread = .01
	}
}