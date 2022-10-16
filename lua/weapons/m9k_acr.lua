SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9kR: Assault Rifles"
SWEP.PrintName = "ACR"

SWEP.Slot = 3
SWEP.HoldType = "ar2"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_rif_msda.mdl"
SWEP.WorldModel = "models/weapons/w_masada_acr.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/masadamagpul/foley.mp3",
		iDelay = 0.05
	},
	{
		sSound = "weapons/masadamagpul/magout.mp3",
		iDelay = 0.05 + 0.35
	},
	{
		sSound = "weapons/masadamagpul/magin1.mp3",
		iDelay = 0.05 + 0.35 + 0.95
	},
	{
		sSound = "weapons/masadamagpul/magin2.mp3",
		iDelay = 0.05 + 0.35 + 0.95 + 0.35
	},
	{
		sSound = "weapons/masadamagpul/chargerback.mp3",
		iDelay = 0.05 + 0.35 + 0.75 + 0.55 + 0.95
	},
	{
		sSound = "weapons/masadamagpul/boltrelease.mp3",
		iDelay = 0.05 + 0.35 + 0.75 + 0.55 + 0.95 + 0.25
	}
}

SWEP.tDrawSoundSequence = {
	{
		sSound = "weapons/masadamagpul/cloth2.mp3",
		iDelay = 0.05
	},
	{
		sSound = "weapons/masadamagpul/safety.mp3",
		iDelay = 0.05 + 0.50
	},
	{
		sSound = "weapons/masadamagpul/cloth1.mp3",
		iDelay = 0.05 + 0.50 + 0.35
	}
}

SWEP.Primary.Sound = "weapons/masadamagpul/masada_unsil.wav"
SWEP.Primary.SoundVolume = 80

SWEP.Primary.RPM = 425
SWEP.Primary.ClipSize = 30
SWEP.Primary.KickUp = 1.3
SWEP.Primary.KickDown = 0.9
SWEP.Primary.KickHorizontal = 1.1
SWEP.Primary.Automatic = true
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 34
SWEP.Primary.Spread = .021
SWEP.Primary.Ammo = "ar2"

SWEP.IronSightsPos = Vector(2.668,0,0.675)

SWEP.LegacyBalance = {
	Primary = {
		RPM = 825,
		ClipSize = 30,
		KickUp = 0.3,
		KickDown = 0.3,
		KickHorizontal = 0.3,
		Automatic = true,
		NumShots = 1,
		Damage = 30,
		Spread = .025
	}
}

--[[ We might need these in the future!
sound.Add({
	name = "Masada.Placesilencer",
	channel = CHAN_ITEM,
	volume = 1.0,
	sound = "weapons/masadamagpul/placesilencer.mp3"
})

sound.Add({
	name = "Masada.Removesilencer",
	channel = CHAN_ITEM,
	volume = 1.0,
	sound = "weapons/masadamagpul/removesilencer.mp3"
})
]]