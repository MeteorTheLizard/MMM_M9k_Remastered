SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9kR: Machine Guns"
SWEP.PrintName = "Minigun"

SWEP.Slot = 4
SWEP.HoldType = "crossbow"
SWEP.Spawnable = true

SWEP.ViewModelFOV = 65
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_minigunvulcan.mdl"
SWEP.WorldModel = "models/weapons/w_m134_minigun.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/minigun/mini_boxout.mp3",
		iDelay = 1.25
	},
	{
		sSound = "weapons/minigun/mini_boxin.mp3",
		iDelay = 1.25 + 1.75
	},
	{
		sSound = "weapons/minigun/mini_chain.mp3",
		iDelay = 1.25 + 1.75 + 0.95
	}
}

SWEP.Primary.Sound = "weapons/minigun/mini-1.wav"

SWEP.Primary.RPM = 600
SWEP.Primary.ClipSize = 150
SWEP.Primary.KickUp = 1.6
SWEP.Primary.KickDown = 0.8
SWEP.Primary.KickHorizontal = 1.4
SWEP.Primary.Automatic = true
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 33
SWEP.Primary.Spread = .1
SWEP.Primary.Ammo = "ar2"

SWEP.LegacyBalance = {
	Primary = {
		RPM = 3500,
		ClipSize = 100,
		KickUp = 0.5,
		KickDown = 0.6,
		KickHorizontal = 0.6,
		Automatic = true,
		NumShots = 1,
		Damage = 25,
		Spread = .035
	}
}


function SWEP:IronSight() -- This weapon should not have ironsights!

end


if SERVER then
	function SWEP:PostReloadCall() -- After reloading the guy does not want to grip the handle properly, is it sticky? wtf. Just grab it omg.
		self:SendWeaponAnim(ACT_VM_IDLE) -- Reset the animation state to fix it.
	end
end