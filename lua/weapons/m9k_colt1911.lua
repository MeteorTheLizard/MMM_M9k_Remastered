SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9kR: Pistols"
SWEP.PrintName = "Colt 1911"

SWEP.Slot = 1
SWEP.Spawnable = true

SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/f_dmgf_co1911.mdl"
SWEP.WorldModel = "models/weapons/s_dmgf_co1911.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/dmg_colt1911/draw.mp3",
		iDelay = 0.20
	},
	{
		sSound = "weapons/dmg_colt1911/de_clipin.mp3",
		iDelay = 0.20 + 0.65
	},
	{
		sSound = "weapons/dmg_colt1911/de_slideback.mp3",
		iDelay = 0.20 + 0.65 + 0.55
	}
}

SWEP.tDrawSoundSequence = {
	{
		sSound = "weapons/dmg_colt1911/draw.mp3",
		iDelay = 0.25
	}
}

SWEP.Primary.Sound = "weapons/dmg_colt1911/deagle-1.wav"

SWEP.Primary.RPM = 350
SWEP.Primary.ClipSize = 7
SWEP.Primary.KickUp = 1.8
SWEP.Primary.KickDown = 0.9
SWEP.Primary.KickHorizontal = 1.6
SWEP.Primary.Automatic = false
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 22
SWEP.Primary.Spread = .015
SWEP.Primary.Ammo = "pistol"

SWEP.IronSightsPos = Vector(-2.6004,-1.3877,1.1892)
SWEP.IronSightsAng = Vector(0.3756,-0.0032,0.103)

SWEP.LegacyBalance = {
	Primary = {
		RPM = 700,
		ClipSize = 7,
		KickUp = 0.4,
		KickDown = 0.3,
		KickHorizontal = 0.3,
		Automatic = false,
		NumShots = 1,
		Damage = 17,
		Spread = .025
	}
}