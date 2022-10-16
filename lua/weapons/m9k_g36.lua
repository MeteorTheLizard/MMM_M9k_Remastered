SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9kR: Assault Rifles"
SWEP.PrintName = "G36"

SWEP.Slot = 3
SWEP.HoldType = "ar2"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_rif_g362.mdl"
SWEP.WorldModel = "models/weapons/w_hk_g36c.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/G36/Cloth.mp3",
		iDelay = 0.05
	},
	{
		sSound = "weapons/G36/MagOut.mp3",
		iDelay = 0.05 + 0.35
	},
	{
		sSound = "weapons/G36/MagFiddle.mp3",
		iDelay = 0.05 + 0.35 + 0.90
	},
	{
		sSound = "weapons/G36/MagSlap.mp3",
		iDelay = 0.05 + 0.35 + 0.90 + 0.45
	},
	{
		sSound = "weapons/G36/BoltPull.mp3",
		iDelay = 0.05 + 0.35 + 0.90 + 0.45 + 0.60
	},
	{
		sSound = "weapons/G36/Boltback.mp3",
		iDelay = 0.05 + 0.35 + 0.90 + 0.45 + 0.60 + 0.25
	}
}

SWEP.tDrawSoundSequence = {
	{
		sSound = "weapons/G36/PocketRussle.mp3",
		iDelay = 0.00
	},
	{
		sSound = "weapons/G36/Safety.mp3",
		iDelay = 0.00 + 0.40
	},
	{
		sSound = "weapons/G36/Cloth.mp3",
		iDelay = 0.00 + 0.40 + 0.35
	}
}

SWEP.Primary.Sound = "weapons/G36/m4a1_unsil-1.wav"

SWEP.Primary.RPM = 465
SWEP.Primary.ClipSize = 30
SWEP.Primary.KickUp = 1.6
SWEP.Primary.KickDown = 1.7
SWEP.Primary.KickHorizontal = 1.4
SWEP.Primary.Automatic = true
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 21
SWEP.Primary.Spread = .02
SWEP.Primary.Ammo = "ar2"

SWEP.IronSightsPos = Vector(2.865,-0.857,1.06)

SWEP.LegacyBalance = {
	Primary = {
		RPM = 750,
		ClipSize = 30,
		KickUp = 0.3,
		KickDown = 0.3,
		KickHorizontal = 0.3,
		Automatic = true,
		NumShots = 1,
		Damage = 28,
		Spread = .02
	}
}

--[[ We might need these in the future!
sound.Add({
	name = "G36.PlaceSilencer",
	channel = CHAN_ITEM,
	volume = 1.0,
	sound = "weapons/G36/PlaceSilencer.mp3"
})

sound.Add({
	name = "G36.TightenSilencer",
	channel = CHAN_ITEM,
	volume = 1.0,
	sound = "weapons/G36/TightenSilencer.mp3"
})

sound.Add({
	name = "G36.SpinSilencer",
	channel = CHAN_ITEM,
	volume = 1.0,
	sound = "weapons/G36/SpinSilencer.mp3"
})
]]