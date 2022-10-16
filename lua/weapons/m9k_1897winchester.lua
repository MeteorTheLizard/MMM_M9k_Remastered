SWEP.Base = "bobs_shotty_base"
SWEP.Category = "M9kR: Shotguns"
SWEP.PrintName = "Winchester 1897"

SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_1897trenchshot.mdl"
SWEP.WorldModel = "models/weapons/w_winchester_1897_trench.mdl"

SWEP.ReloadSound = "weapons/1897trench/m3_insertshell.mp3"
SWEP.ReloadSoundFinish = "weapons/1897trench/m3_pump.mp3"

SWEP.DrawSound = "weapons/1897trench/1897_deploy.mp3"

SWEP.Primary.Sound = "weapons/1897trench/m3-1.wav"

SWEP.Primary.RPM = 55
SWEP.Primary.ClipSize = 4
SWEP.Primary.KickUp = 2
SWEP.Primary.KickDown = 1
SWEP.Primary.KickHorizontal = 2
SWEP.Primary.Automatic = false
SWEP.Primary.NumShots = 30
SWEP.Primary.Damage = 4
SWEP.Primary.Spread = 0.27
SWEP.Primary.Ammo = "buckshot"

SWEP.IronSightsPos = Vector(2.85,0,2)
SWEP.bShotgunNoIron = true

SWEP.LegacyBalance = {
	Primary = {
		RPM = 70,
		ClipSize = 4,
		KickUp = 0.9,
		KickDown = 0.6,
		KickHorizontal = 0.4,
		Automatic = false,
		NumShots = 11,
		Damage = 10,
		Spread = .04
	}
}


-- These are required for firstperson

sound.Add({
	name = "Trench_97.Insertshell",
	channel = CHAN_ITEM,
	volume = 1.0,
	sound = "weapons/1897trench/m3_insertshell.mp3"
})

sound.Add({
	name = "Trench_97.Pump",
	channel = CHAN_ITEM,
	volume = 1.0,
	sound = "weapons/1897trench/m3_pump.mp3"
})