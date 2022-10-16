SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9kR: Assault Rifles"
SWEP.PrintName = "HK 416"

SWEP.Slot = 3
SWEP.HoldType = "ar2"
SWEP.Spawnable = true

SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_hk416rif.mdl"
SWEP.WorldModel = "models/weapons/w_hk_416.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/twinkie_hk416/m4a1_clipout.mp3",
		iDelay = 0.40
	},
	{
		sSound = "weapons/twinkie_hk416/m4a1_tap.mp3",
		iDelay = 0.40 + 0.65
	},
	{
		sSound = "weapons/twinkie_hk416/m4a1_clipin.mp3",
		iDelay = 0.40 + 0.65 + 0.20
	},
	{
		sSound = "weapons/twinkie_hk416/m4a1_boltpull.mp3",
		iDelay = 0.40 + 0.65 + 0.20 + 0.90
	},
	{
		sSound = "weapons/twinkie_hk416/m4a1_boltrelease.mp3",
		iDelay = 0.40 + 0.65 + 0.20 + 0.90 + 0.20
	}
}

SWEP.tDrawSoundSequence = {
	{
		sSound = "weapons/twinkie_hk416/m4a1_boltpull.mp3",
		iDelay = 0.30
	},
	{
		sSound = "weapons/twinkie_hk416/m4a1_boltrelease.mp3",
		iDelay = 0.30 + 0.18
	}
}

SWEP.Primary.Sound = "weapons/twinkie_hk416/m4a1_unsil-1.wav"

SWEP.Primary.RPM = 395
SWEP.Primary.ClipSize = 30
SWEP.Primary.KickUp = 1.3
SWEP.Primary.KickDown = 0.8
SWEP.Primary.KickHorizontal = 1.3
SWEP.Primary.Automatic = true
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 32
SWEP.Primary.Spread = .025
SWEP.Primary.Ammo = "ar2"

SWEP.IronSightsPos = Vector(-2.892,-2.132,0.5)
SWEP.IronSightsAng = Vector(-0.033,0.07,0)

SWEP.LegacyBalance = {
	Primary = {
		RPM = 800,
		ClipSize = 30,
		KickUp = 0.4,
		KickDown = 0.4,
		KickHorizontal = 0.6,
		Automatic = true,
		NumShots = 1,
		Damage = 30,
		Spread = .025
	}
}

--[[ We might need these in the future!
sound.Add({
	name = "hk416weapon.SilencedSingle",
	channel = CHAN_USER_BASE + 10,
	volume = 1.0,
	sound = "weapons/twinkie_hk416/m4a1-1.wav"
})

sound.Add({
	name = "hk416weapon.Silencer_On",
	channel = CHAN_ITEM,
	volume = 1.0,
	sound = "weapons/twinkie_hk416/m4a1_silencer_on.mp3"
})

sound.Add({
	name = "hk416weapon.Silencer_Off",
	channel = CHAN_ITEM,
	volume = 1.0,
	sound = "weapons/twinkie_hk416/m4a1_silencer_off.mp3"
})
]]