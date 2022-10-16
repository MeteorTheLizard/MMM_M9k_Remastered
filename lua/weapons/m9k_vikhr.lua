SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9kR: Assault Rifles"
SWEP.PrintName = "SR-3M Vikhr"

SWEP.Slot = 3
SWEP.HoldType = "ar2"
SWEP.Spawnable = true

SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_dmg_vikhr.mdl"
SWEP.WorldModel = "models/weapons/w_dmg_vikhr.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/dmg_vikhr/galil_clipout.mp3",
		iDelay = 0.85
	},
	{
		sSound = "weapons/dmg_vikhr/galil_clipin.mp3",
		iDelay = 0.85 + 0.45
	},
	{
		sSound = "weapons/dmg_vikhr/galil_Boltpull.mp3",
		iDelay = 0.85 + 0.45 + 0.75
	}
}

SWEP.DrawSound = "weapons/dmg_vikhr/draw.mp3"

SWEP.Primary.Sound = "weapons/dmg_vikhr/galil-1.wav"

SWEP.Primary.RPM = 565
SWEP.Primary.ClipSize = 30
SWEP.Primary.KickUp = 2.3
SWEP.Primary.KickDown = 1.65
SWEP.Primary.KickHorizontal = 2.3
SWEP.Primary.Automatic = true
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 21
SWEP.Primary.Spread = .023
SWEP.Primary.Ammo = "ar2"

SWEP.IronSightsPos = Vector(-2.2363,-1.0859,0.5292)
SWEP.IronSightsAng = Vector(1.4076,0.0907,0)

SWEP.LegacyBalance = {
	Primary = {
		RPM = 900,
		ClipSize = 30,
		KickUp = 0.3,
		KickDown = 0.3,
		KickHorizontal = 0.5,
		Automatic = true,
		NumShots = 1,
		Damage = 29,
		Spread = .02
	}
}

--[[ We might need these in the future!
sound.Add({
	name = "Dmgfok_vikhr.Silenced",
	channel = CHAN_ITEM,
	volume = 1.0,
	sound = "weapons/dmg_vikhr/galil-sil.mp3"
})
]]