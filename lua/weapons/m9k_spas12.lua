SWEP.Base = "bobs_shotty_base"
SWEP.Category = "M9kR: Shotguns"
SWEP.PrintName = "SPAS 12"

SWEP.Spawnable = true

SWEP.ViewModelFOV = 60
SWEP.ViewModel = "models/weapons/v_spas12_shot.mdl"
SWEP.WorldModel = "models/weapons/w_spas_12.mdl"

SWEP.ReloadSound = "weapons/spas_12/xm_insert.mp3"
SWEP.ReloadSoundFinish = "weapons/spas_12/xm_cock.mp3"

SWEP.Primary.Sound = "weapons/spas_12/xm1014-1.wav"

SWEP.Primary.RPM = 165
SWEP.Primary.ClipSize = 8
SWEP.Primary.KickUp = 5
SWEP.Primary.KickDown = 2
SWEP.Primary.KickHorizontal = 3
SWEP.Primary.Automatic = false
SWEP.Primary.NumShots = 27
SWEP.Primary.Damage = 4
SWEP.Primary.Spread = .19
SWEP.Primary.Ammo = "buckshot"

SWEP.IronSightsPos = Vector(2.657,.394,1.659)

SWEP.LegacyBalance = {
	Primary = {
		RPM = 350,
		ClipSize = 8,
		KickUp = 1.5,
		KickDown = 0.3,
		KickHorizontal = 0.7,
		Automatic = false,
		NumShots = 10,
		Damage = 10,
		Spread = .03
	}
}


-- These are required for firstperson

sound.Add({
	name = "spas_12_shoty.insert",
	channel = CHAN_ITEM,
	volume = 1.0,
	sound = "weapons/spas_12/xm_insert.mp3"
})

sound.Add({
	name = "spas_12_shoty.cock",
	channel = CHAN_ITEM,
	volume = 1.0,
	sound = "weapons/spas_12/xm_cock.mp3"
})