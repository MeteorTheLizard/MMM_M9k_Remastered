SWEP.Base = "bobs_shotty_base"
SWEP.Category = "M9kR: Assault Rifles"
SWEP.PrintName = "73 Winchester Carbine"

SWEP.HoldType = "ar2"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_winchester1873.mdl"
SWEP.WorldModel = "models/weapons/w_winchester_1873.mdl"

SWEP.ReloadSound = "weapons/winchester73/w73insertshell.mp3"
SWEP.ReloadSoundFinish = "weapons/winchester73/w73pump.mp3"

SWEP.DrawSound = "weapons/winchester73/w73pump.mp3"
SWEP.DrawCantHear = true

SWEP.Primary.Sound = "weapons/winchester73/w73-1.wav"
SWEP.Primary.SoundPump = "weapons/winchester73/w73pump.mp3"
SWEP.Primary.SoundPumpDelay = 0.5

SWEP.Primary.RPM = 55
SWEP.Primary.ClipSize = 12
SWEP.Primary.KickUp = 6
SWEP.Primary.KickDown = 2
SWEP.Primary.KickHorizontal = 6
SWEP.Primary.Automatic = false
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 76
SWEP.Primary.Spread = .01
SWEP.Primary.Ammo = "AirboatGun"

SWEP.IronSightsPos = Vector(4.356,0,2.591)
SWEP.bShotgunNoIron = true

SWEP.LegacyBalance = {
	Primary = {
		RPM = 66,
		ClipSize = 8,
		KickUp = .2,
		KickDown = 0,
		KickHorizontal = 0.1,
		Automatic = false,
		NumShots = 1,
		Damage = 85,
		Spread = .01
	}
}


-- These are required for firstperson

sound.Add({
	name = "Weapon_73.Pump",
	channel = CHAN_ITEM,
	volume = 1.0,
	sound = "weapons/winchester73/w73pump.mp3"
})

sound.Add({
	name = "Weapon_73.Insertshell",
	channel = CHAN_ITEM,
	volume = 1.0,
	sound = "weapons/winchester73/w73insertshell.mp3"
})