SWEP.Base = "bobs_shotty_base"
SWEP.Category = "M9kR: Shotguns"
SWEP.PrintName = "Browning Auto 5"

SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_brown_auto5.mdl"
SWEP.WorldModel = "models/weapons/w_browning_auto.mdl"

SWEP.ReloadSoundStart = "weapons/browninga5/xm1014_check.mp3"
SWEP.ReloadSound = "weapons/xm1014/xm1014_insertshell.wav"

SWEP.DrawSound = "weapons/browninga5/xm1014_deploy.mp3"

SWEP.Primary.Sound = "weapons/browninga5/xm1014-1.wav"

SWEP.Primary.RPM = 225
SWEP.Primary.ClipSize = 6
SWEP.Primary.KickUp = 3
SWEP.Primary.KickDown = 5
SWEP.Primary.KickHorizontal = 0.6
SWEP.Primary.Automatic = false
SWEP.Primary.NumShots = 36
SWEP.Primary.Damage = 3
SWEP.Primary.Spread = .15
SWEP.Primary.Ammo = "buckshot"

SWEP.IronSightsPos = Vector(1.953,0,1.388)

SWEP.LegacyBalance = {
	Primary = {
		RPM = 250,
		ClipSize = 6,
		KickUp = 1,
		KickDown = 0.8,
		KickHorizontal = 0.6,
		Automatic = false,
		NumShots = 9,
		Damage = 10,
		Spread = .03
	}
}


-- This is required for firstperson

sound.Add({
	name = "Weapon_a5.back",
	channel = CHAN_ITEM,
	volume = 1.0,
	sound = "weapons/browninga5/xm1014_check.mp3"
})