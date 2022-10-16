SWEP.Base = "bobs_shotty_base"
SWEP.Category = "M9kR: Shotguns"
SWEP.PrintName = "Remington 870"

SWEP.Spawnable = true

SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_rem870tactical.mdl"
SWEP.WorldModel = "models/weapons/w_remington_870_tact.mdl"

SWEP.ReloadSound = "weapons/tact870/m3_insertshell.mp3"
SWEP.ReloadSoundFinish = "weapons/tact870/m3_pump.mp3"

SWEP.DrawSound = "weapons/tact870/m3_pump.mp3"
SWEP.DrawCantHear = true

SWEP.Primary.Sound = "weapons/tact870/m3-1.wav"
SWEP.Primary.SoundPump = "weapons/tact870/m3_pump.mp3"
SWEP.Primary.SoundPumpDelay = 0.5

SWEP.Primary.RPM = 60
SWEP.Primary.ClipSize = 8
SWEP.Primary.KickUp = 4
SWEP.Primary.KickDown = 2
SWEP.Primary.KickHorizontal = 10
SWEP.Primary.Automatic = false
SWEP.Primary.NumShots = 40
SWEP.Primary.Damage = 3
SWEP.Primary.Spread = .17
SWEP.Primary.Ammo = "buckshot"

SWEP.IronSightsPos = Vector(-2.014,0.1,1.2)
SWEP.IronSightsAng = Vector(0.551,0.028,0)
SWEP.bShotgunNoIron = true

SWEP.LegacyBalance = {
	Primary = {
		RPM = 70,
		ClipSize = 8,
		KickUp = 1.25,
		KickDown = 0.8,
		KickHorizontal = 0.4,
		Automatic = false,
		NumShots = 9,
		Damage = 10,
		Spread = .035
	}
}


-- These are required for firstperson

sound.Add({
	name = "WepRem870.pump",
	channel = CHAN_ITEM,
	volume = 1.0,
	sound = "weapons/tact870/m3_pump.mp3"
})

sound.Add({
	name = "WepRem870.Insertshell",
	channel = CHAN_ITEM,
	volume = 1.0,
	sound = "weapons/tact870/m3_insertshell.mp3"
})