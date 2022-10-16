SWEP.Base = "bobs_shotty_base"
SWEP.Category = "M9kR: Shotguns"
SWEP.PrintName = "Winchester 87"

SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_1887winchester.mdl"
SWEP.WorldModel = "models/weapons/w_winchester_1887.mdl"

SWEP.ReloadSoundStart = "weapons/1887winchester/1887pump2.mp3"
SWEP.ReloadSound = "weapons/1887winchester/1887_insertshell.mp3"
SWEP.ReloadSoundFinish = "weapons/1887winchester/1887pump1.mp3"

SWEP.Primary.Sound = "weapons/1887winchester/1887-1.wav"

SWEP.Primary.RPM = 55
SWEP.Primary.ClipSize = 4
SWEP.Primary.KickUp = 6
SWEP.Primary.KickDown = 4
SWEP.Primary.KickHorizontal = 4
SWEP.Primary.Automatic = false
SWEP.Primary.NumShots = 17
SWEP.Primary.Damage = 7
SWEP.Primary.Spread = .26
SWEP.Primary.Ammo = "buckshot"

SWEP.IronSightsPos = Vector(4.84,0,1.8)
SWEP.IronSightsAng = Vector(0,0,2.295)
SWEP.bShotgunNoIron = true

SWEP.LegacyBalance = {
	Primary = {
		RPM = 70,
		ClipSize = 4,
		KickUp = 1,
		KickDown = 0.8,
		KickHorizontal = 0.6,
		Automatic = false,
		NumShots = 10,
		Damage = 10,
		Spread = .042
	}
}


-- These are required for firstperson

sound.Add({
	name = "1887winch.Insertshell",
	channel = CHAN_ITEM,
	volume = 1.0,
	sound = "weapons/1887winchester/1887_insertshell.mp3"
})

sound.Add({
	name = "1887winch.Pump",
	channel = CHAN_ITEM,
	volume = 1.0,
	sound = "weapons/1887winchester/1887pump1.mp3"
})

sound.Add({
	name = "1887pump2.Pump",
	channel = CHAN_ITEM,
	volume = 1.0,
	sound = "weapons/1887winchester/1887pump2.mp3"
})