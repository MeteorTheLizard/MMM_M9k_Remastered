SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9kR: Pistols"
SWEP.PrintName = "Remington 1858"

SWEP.Slot = 1
SWEP.HoldType = "revolver"
SWEP.Spawnable = true

SWEP.ViewModelFOV = 65
SWEP.ViewModel = "models/weapons/v_pist_re1858.mdl"
SWEP.WorldModel = "models/weapons/w_remington_1858.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/remington/cylinderhit.mp3",
		iDelay = 1.20
	},
	{
		sSound = "weapons/remington/cylinderswap.mp3",
		iDelay = 1.20 + 0.35
	},
	{
		sSound = "weapons/remington/bounce3.mp3",
		iDelay = 1.20 + 0.35 + 0.55
	},
	{
		sSound = "weapons/remington/bounce3.mp3",
		iDelay = 1.20 + 0.35 + 0.55 + 0.35
	},
	{
		sSound = "weapons/remington/bounce3.mp3",
		iDelay = 1.20 + 0.35 + 0.55 + 0.35 + 0.15
	}
}

SWEP.tDrawSoundSequence = {
	{
		sSound = "weapons/remington/hammer.mp3",
		iDelay = 0.35
	}
}

SWEP.Primary.Sound = "weapons/remington/remington-1.wav"

SWEP.Primary.RPM = 157
SWEP.Primary.ClipSize = 6
SWEP.Primary.KickUp = 5
SWEP.Primary.KickDown = 3
SWEP.Primary.KickHorizontal = 4
SWEP.Primary.Automatic = false
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 23
SWEP.Primary.Spread = .037
SWEP.Primary.Ammo = "357"

SWEP.IronSightsPos = Vector(5.44,0,1.72)
SWEP.bBlockIronSights = true

SWEP.LegacyBalance = {
	Primary = {
		RPM = 150,
		ClipSize = 6,
		KickUp = 0.9,
		KickDown = 0.5,
		KickHorizontal = 0.4,
		Automatic = false,
		NumShots = 1,
		Damage = 34,
		Spread = .025
	}
}