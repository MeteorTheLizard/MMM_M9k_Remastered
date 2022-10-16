SWEP.Base = "bobs_shotty_base"
SWEP.Category = "M9kR: Shotguns"
SWEP.PrintName = "Ithaca M37"

SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_ithaca_m37shot.mdl"
SWEP.WorldModel = "models/weapons/w_ithaca_m37.mdl"

SWEP.ReloadSound = "weapons/m37/m3_insertshell.mp3"

SWEP.DrawSound = "weapons/m37/m3_pump.mp3"
SWEP.DrawCantHear = true

SWEP.Primary.Sound = "weapons/m37/m3-1.wav"

SWEP.Primary.RPM = 60
SWEP.Primary.ClipSize = 6
SWEP.Primary.KickUp = 8
SWEP.Primary.KickDown = 5
SWEP.Primary.KickHorizontal = 8
SWEP.Primary.Automatic = false
SWEP.Primary.NumShots = 26
SWEP.Primary.Damage = 5
SWEP.Primary.Spread = .17
SWEP.Primary.Ammo = "buckshot"

SWEP.IronSightsPos = Vector(2.16,-1.429,0.6)
SWEP.IronSightsAng = Vector(3,0,0)
SWEP.bShotgunNoIron = true

SWEP.LegacyBalance = {
	Primary = {
		RPM = 60,
		ClipSize = 6,
		KickUp = .9,
		KickDown = 0.6,
		KickHorizontal = 0.6,
		Automatic = false,
		NumShots = 8,
		Damage = 12,
		Spread = .023
	}
}


-- These are required for firstperson

sound.Add({
	name = "IthacaM37.Insertshell",
	channel = CHAN_ITEM,
	volume = 1.0,
	sound = "weapons/m37/m3_insertshell.mp3"
})

sound.Add({
	name = "IthacaM37.Pump",
	channel = CHAN_ITEM,
	volume = 1.0,
	sound = "weapons/m37/m3_pump.mp3"
})