SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9kR: Assault Rifles"
SWEP.PrintName = "AK-47"

SWEP.Slot = 3
SWEP.HoldType = "ar2"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_dot_ak47.mdl"
SWEP.WorldModel = "models/weapons/w_ak47_m9k.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/AYKAYFORTY/magout.mp3",
		iDelay = 0.40
	},
	{
		sSound = "weapons/AYKAYFORTY/magin.mp3",
		iDelay = 0.40 + 0.60
	},
	{
		sSound = "weapons/AYKAYFORTY/bolt.mp3",
		iDelay = 0.40 + 0.60 + 0.90
	}
}

SWEP.tDrawSoundSequence = {
	{
		sSound = "weapons/AYKAYFORTY/bolt.mp3",
		iDelay = 0.40
	}
}

SWEP.Primary.Sound = "weapons/AYKAYFORTY/ak47-1.wav"

SWEP.Primary.RPM = 450
SWEP.Primary.ClipSize = 30
SWEP.Primary.KickUp = 3
SWEP.Primary.KickDown = 1.7
SWEP.Primary.KickHorizontal = 1.8
SWEP.Primary.Automatic = true
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 41
SWEP.Primary.Spread = .037
SWEP.Primary.Ammo = "ar2"

SWEP.IronSightsPos = Vector(4.539,-4.238,1.799)
SWEP.IronSightsAng = Vector(0.958,-0.021,0)

SWEP.LegacyBalance = {
	Primary = {
		RPM = 600,
		ClipSize = 30,
		KickUp = 0.3,
		KickDown = 0.3,
		KickHorizontal = 0.3,
		Automatic = true,
		NumShots = 1,
		Damage = 30,
		Spread = .023
	}
}