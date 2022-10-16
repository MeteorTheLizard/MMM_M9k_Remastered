SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9kR: Pistols"
SWEP.PrintName = "Raging Bull"

SWEP.Slot = 1
SWEP.HoldType = "revolver"
SWEP.Spawnable = true

SWEP.ViewModelFOV = 65
SWEP.ViewModel = "models/weapons/v_raging_bull.mdl"
SWEP.WorldModel = "models/weapons/w_taurus_raging_bull.mdl"

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
SWEP.Primary.SoundVolume = 85

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

SWEP.IronSightsPos = Vector(2.773,0,0.846)
SWEP.IronSightsAng = Vector(-0.157,0,0)

SWEP.LegacyBalance = {
	Primary = {
		RPM = 115,
		ClipSize = 6,
		KickUp = 1,
		KickDown = 0.5,
		KickHorizontal = 0.5,
		Automatic = false,
		NumShots = 1,
		Damage = 31,
		Spread = .02
	}
}