SWEP.Base = "bobs_shotty_base"
SWEP.Category = "M9kR: Shotguns"
SWEP.PrintName = "Mossberg 590"

SWEP.Spawnable = true

SWEP.ViewModelFOV = 60
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_shot_mberg_590.mdl"
SWEP.WorldModel = "models/weapons/w_mossberg_590.mdl"

SWEP.ReloadSound = "weapons/590/m3_insertshell.mp3"
SWEP.ReloadSoundFinish = "weapons/590/m3_pump.mp3"

SWEP.DrawSound = "weapons/590/m3_draw.mp3"

SWEP.Primary.Sound = "weapons/590/m3-1.wav"
SWEP.Primary.SoundPump = "weapons/590/m3_pump.mp3"
SWEP.Primary.SoundPumpDelay = 0.5

SWEP.Primary.RPM = 45
SWEP.Primary.ClipSize = 8
SWEP.Primary.KickUp = 5
SWEP.Primary.KickDown = 2
SWEP.Primary.KickHorizontal = 8
SWEP.Primary.Automatic = false
SWEP.Primary.NumShots = 38
SWEP.Primary.Damage = 3.3
SWEP.Primary.Spread = .18
SWEP.Primary.Ammo = "buckshot"

SWEP.IronSightsPos = Vector(-2.72,-3.143,1.28)
SWEP.IronSightsAng = Vector(0,-0.75,3)
SWEP.bShotgunNoIron = true

SWEP.LegacyBalance = {
	Primary = {
		RPM = 75,
		ClipSize = 8,
		KickUp = 1,
		KickDown = 0.8,
		KickHorizontal = 0.8,
		Automatic = false,
		NumShots = 10,
		Damage = 9,
		Spread = .03
	}
}


-- These are required for firstperson

sound.Add({
	name = "Mberg_590.Insertshell",
	channel = CHAN_ITEM,
	volume = 1.0,
	sound = "weapons/590/m3_insertshell.mp3"
})

sound.Add({
	name = "Mberg_590.Pump",
	channel = CHAN_ITEM,
	volume = 1.0,
	sound = "weapons/590/m3_pump.mp3"
})