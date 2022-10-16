SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9kR: Assault Rifles"
SWEP.PrintName = "M14"

SWEP.Slot = 3
SWEP.HoldType = "ar2"
SWEP.Spawnable = true

SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_snip_m14sp.mdl"
SWEP.WorldModel = "models/weapons/w_snip_m14sp.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/fokku_tc_m14/sg550_clipout.mp3",
		iDelay = 0.40
	},
	{
		sSound = "weapons/fokku_tc_m14/sg550_clipin.mp3",
		iDelay = 0.40 + 1.25
	},
	{
		sSound = "weapons/fokku_tc_m14/sg550_boltpull.mp3",
		iDelay = 0.40 + 1.25 + 1.05
	}
}

SWEP.DrawSound = "weapons/fokku_tc_m14/sg550_deploy.mp3"

SWEP.Primary.Sound = "weapons/fokku_tc_m14/sg550-1.wav"

SWEP.Primary.RPM = 200
SWEP.Primary.ClipSize = 10
SWEP.Primary.KickUp = 13
SWEP.Primary.KickDown = 6
SWEP.Primary.KickHorizontal = 9
SWEP.Primary.Automatic = false
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 52
SWEP.Primary.Spread = .028
SWEP.Primary.Ammo = "ar2"

SWEP.IronSightsPos = Vector(-2.7031,-1.0539,1.6562)

SWEP.LegacyBalance = {
	Primary = {
		RPM = 750,
		ClipSize = 20,
		KickUp = 0.6,
		KickDown = 0.6,
		KickHorizontal = 0.6,
		Automatic = false,
		NumShots = 1,
		Damage = 32,
		Spread = .01
	}
}