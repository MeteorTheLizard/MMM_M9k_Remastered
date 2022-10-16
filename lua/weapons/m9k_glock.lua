SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9kR: Pistols"
SWEP.PrintName = "Glock 18"

SWEP.Slot = 1
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_dmg_glock.mdl"
SWEP.WorldModel = "models/weapons/w_dmg_glock.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/dmg_glock/magout.mp3",
		iDelay = 0.25
	},
	{
		sSound = "weapons/dmg_glock/magin.mp3",
		iDelay = 0.25 + 1.45
	},
	{
		sSound = "weapons/dmg_glock/boltpull.mp3",
		iDelay = 0.25 + 1.45 + 0.65
	}
}

SWEP.tDrawSoundSequence = {
	{
		sSound = "weapons/dmg_glock/boltpull.mp3",
		iDelay = 0.35
	}
}

SWEP.Primary.Sound = "weapons/dmg_glock/mac10-1.wav"

SWEP.Primary.RPM = 650
SWEP.Primary.ClipSize = 32
SWEP.Primary.KickUp = 1.9
SWEP.Primary.KickDown = 1.3
SWEP.Primary.KickHorizontal = 1.1
SWEP.Primary.Automatic = true
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 11
SWEP.Primary.Spread = .036
SWEP.Primary.Ammo = "pistol"

SWEP.IronSightsPos = Vector(2.2042,0,1.7661)

SWEP.LegacyBalance = {
	Primary = {
		RPM = 1200,
		ClipSize = 32,
		KickUp = 0.4,
		KickDown = 0.3,
		KickHorizontal = 0.3,
		Automatic = true,
		NumShots = 1,
		Damage = 12,
		Spread = .03
	}
}