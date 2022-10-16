SWEP.Base = "bobs_scoped_base"
SWEP.Category = "M9kR: Submachine Guns"
SWEP.PrintName = "HK MP7"

SWEP.DynamicLightScale = 1 -- Set to Default

SWEP.Slot = 2
SWEP.HoldType = "smg"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_mp7_silenced.mdl"
SWEP.WorldModel = "models/weapons/w_mp7_silenced.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/mp7/mp7_magout.mp3",
		iDelay = 0.15
	},
	{
		sSound = "weapons/mp7/mp7_magin.mp3",
		iDelay = 0.15 + 1.15
	},
	{
		sSound = "weapons/mp7/mp7_charger.mp3",
		iDelay = 0.15 + 1.15 + 0.45
	}
}

SWEP.Primary.Sound = "weapons/mp7/usp1.wav"
SWEP.Primary.SoundVolume = 65 -- Silenced!

SWEP.Primary.RPM = 600
SWEP.Primary.ClipSize = 30
SWEP.Primary.KickUp = 1.2
SWEP.Primary.KickDown = .6
SWEP.Primary.KickHorizontal = .7
SWEP.Primary.Automatic = true
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 11
SWEP.Primary.Spread = .023
SWEP.Primary.Ammo = "smg1"

SWEP.Primary.SpreadBefore = SWEP.Primary.Spread

SWEP.ScopeType = "gdcw_aimpoint"
SWEP.ScopeStages = 1
SWEP.ScopeScale = 0.5
SWEP.ReticleScale = 0.5

SWEP.LegacyBalance = {
	Primary = {
		RPM = 950,
		ClipSize = 30,
		KickUp = .5,
		KickDown = .4,
		KickHorizontal = .4,
		Automatic = true,
		NumShots = 1,
		Damage = 24,
		Spread = .023
	}
}