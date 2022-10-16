SWEP.Base = "bobs_shotty_base"
SWEP.Category = "M9kR: Shotguns"
SWEP.PrintName = "USAS"

SWEP.Slot = 4
SWEP.HoldType = "ar2"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_usas12_shot.mdl"
SWEP.WorldModel = "models/weapons/w_usas_12.mdl"

SWEP.ReloadSoundStart = "weapons/usas12/magout.mp3"
SWEP.ReloadSound = ""
SWEP.ReloadSoundFinish = "weapons/usas12/magin.mp3"

SWEP.ReloadInstantly = true

SWEP.DrawSound = "weapons/usas12/draw.mp3"

SWEP.Primary.Sound = "weapons/usas12/xm1014-1.wav"

SWEP.Primary.RPM = 175
SWEP.Primary.ClipSize = 20
SWEP.Primary.KickUp = 4
SWEP.Primary.KickDown = 2
SWEP.Primary.KickHorizontal = 2
SWEP.Primary.Automatic = true
SWEP.Primary.NumShots = 39
SWEP.Primary.Damage = 3
SWEP.Primary.Spread = .20
SWEP.Primary.Ammo = "buckshot"

SWEP.IronSightsPos = Vector(4.519,-2.159,1.039)
SWEP.IronSightsAng = Vector(0.072,0.975,0)

SWEP.LegacyBalance = {
	Primary = {
		RPM = 260,
		ClipSize = 20,
		KickUp = 1,
		KickDown = 0.4,
		KickHorizontal = 0.7,
		Automatic = true,
		NumShots = 10,
		Damage = 7,
		Spread = .048
	}
}


-- These are required for firstperson

sound.Add({
	name = "Weapon_usas.clipin",
	channel = CHAN_ITEM,
	volume = 1.0,
	sound = "weapons/usas12/magin.mp3"
})

sound.Add({
	name = "Weapon_usas.clipout",
	channel = CHAN_ITEM,
	volume = 1.0,
	sound = "weapons/usas12/magout.mp3"
})