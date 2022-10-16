SWEP.Base = "bobs_shotty_base"
SWEP.Category = "M9kR: Shotguns"
SWEP.PrintName = "Benelli M3"

SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_benelli_m3_s90.mdl"
SWEP.WorldModel = "models/weapons/w_benelli_m3.mdl"

SWEP.ReloadSound = "weapons/BenelliM3/m3_insertshell.mp3"
SWEP.ReloadSoundFinish = "weapons/BenelliM3/m3_pump.mp3"

SWEP.DrawSound = "weapons/BenelliM3/m3_pump.mp3"
SWEP.DrawCantHear = true

SWEP.Primary.Sound = "weapons/BenelliM3/m3-1.wav"

SWEP.Primary.RPM = 70
SWEP.Primary.ClipSize = 8
SWEP.Primary.KickUp = 6
SWEP.Primary.KickDown = 3
SWEP.Primary.KickHorizontal = 7
SWEP.Primary.Automatic = false
SWEP.Primary.NumShots = 35
SWEP.Primary.Damage = 4
SWEP.Primary.Spread = .16
SWEP.Primary.Ammo = "buckshot"

SWEP.IronSightsPos = Vector(2.279,-1.007,1.302)
SWEP.IronSightsAng = Vector(0.47,-0.024,0)
SWEP.bShotgunNoIron = true

SWEP.LegacyBalance = {
	Primary = {
		RPM = 70,
		ClipSize = 8,
		KickUp = 0.8,
		KickDown = 0.5,
		KickHorizontal = 0.3,
		Automatic = false,
		NumShots = 9,
		Damage = 10,
		Spread = .0326
	}
}


-- These are required for firstperson

sound.Add({
	name = "BenelliM3.insertshell",
	channel = CHAN_ITEM,
	volume = 1.0,
	sound = "weapons/BenelliM3/m3_insertshell.mp3"
})

sound.Add({
	name = "BenelliM3.Pump",
	channel = CHAN_ITEM,
	volume = 1.0,
	sound = "weapons/BenelliM3/m3_pump.mp3"
})