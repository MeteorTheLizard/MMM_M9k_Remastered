SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9kR: Pistols"
SWEP.PrintName = "M29 Satan"

SWEP.Slot = 1
SWEP.HoldType = "revolver"
SWEP.Spawnable = true

SWEP.ViewModelFOV = 60
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_pist_satan2.mdl"
SWEP.WorldModel = "models/weapons/w_m29_satan.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/satan1/blick.mp3",
		iDelay = 0.25
	},
	{
		sSound = "weapons/satan1/bulletsout.mp3",
		iDelay = 0.25 + 0.35
	},
	{
		sSound = "weapons/satan1/bulletsin.mp3",
		iDelay = 0.25 + 0.35 + 0.85
	},
	{
		sSound = "weapons/satan1/blick.mp3",
		iDelay = 0.25 + 0.35 + 0.85 + 0.25
	}
}

SWEP.tDrawSoundSequence = {
	{
		sSound = "weapons/satan1/unfold.mp3",
		iDelay = 0.15
	}
}

SWEP.Primary.Sound = "weapons/satan1/satan-1.wav"

SWEP.Primary.RPM = 85
SWEP.Primary.ClipSize = 6
SWEP.Primary.KickUp = 7
SWEP.Primary.KickDown = 1
SWEP.Primary.KickHorizontal = 9
SWEP.Primary.Automatic = false
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 70
SWEP.Primary.Spread = .014
SWEP.Primary.Ammo = "357"

SWEP.IronSightsPos = Vector(-2.82,-1.247,0.456)
SWEP.IronSightsAng = Vector(0.505,2.407,0)

SWEP.LegacyBalance = {
	Primary = {
		RPM = 115,
		ClipSize = 6,
		KickUp = 1,
		KickDown = 0.5,
		KickHorizontal = 0.5,
		Automatic = false,
		NumShots = 1,
		Damage = 32,
		Spread = .015
	}
}

--[[ This weapon has TWO deploy animations that play randomly. We have no way to know which one will play so we just ignore the one with the cylinder open. Maybe this sound will be used again in the future.
sound.Add({
	name = "Weapon_satan1.blick",
	channel = CHAN_ITEM,
	volume = 1.0,
	sound = "weapons/satan1/blick.mp3"
})
]]