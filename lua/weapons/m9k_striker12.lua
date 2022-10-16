SWEP.Base = "bobs_shotty_base"
SWEP.Category = "M9kR: Shotguns"
SWEP.PrintName = "Striker 12"

SWEP.HoldType = "smg"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_striker_12g.mdl"
SWEP.WorldModel = "models/weapons/w_striker_12g.mdl"

SWEP.ReloadSound = "weapons/striker12/m3_insertshell.mp3"

SWEP.DrawSound = "weapons/striker12/deploy.mp3"

SWEP.Primary.Sound = "weapons/striker12/xm1014-1.wav"

SWEP.Primary.RPM = 225
SWEP.Primary.ClipSize = 12
SWEP.Primary.KickUp = 4
SWEP.Primary.KickDown = 2
SWEP.Primary.KickHorizontal = 2
SWEP.Primary.Automatic = true
SWEP.Primary.NumShots = 32
SWEP.Primary.Damage = 4
SWEP.Primary.Spread = .25
SWEP.Primary.Ammo = "buckshot"

SWEP.IronSightsPos = Vector(3.805,-1.045,1.805)
SWEP.IronSightsAng = Vector(2.502,3.431,0)

SWEP.LegacyBalance = {
	Primary = {
		RPM = 365,
		ClipSize = 12,
		KickUp = 4,
		KickDown = 0.5,
		KickHorizontal = .6,
		Automatic = true,
		NumShots = 6,
		Damage = 8,
		Spread = .04
	}
}


-- This is required for firstperson

sound.Add({
	name = "ShotStriker12.InsertShell",
	channel = CHAN_ITEM,
	volume = 1.0,
	sound = "weapons/striker12/m3_insertshell.mp3"
})