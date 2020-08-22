SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9K Machine Guns"
SWEP.PrintName = "Minigun"

SWEP.Slot = 4
SWEP.HoldType = "crossbow"
SWEP.Spawnable = true

SWEP.ViewModelFOV = 65
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_minigunvulcan.mdl"
SWEP.WorldModel = "models/weapons/w_m134_minigun.mdl"

SWEP.Primary.Sound = "BlackVulcan.Single"
SWEP.Primary.RPM = 600
SWEP.Primary.ClipSize = 150

SWEP.Primary.KickUp = 1.6
SWEP.Primary.KickDown = 0.8
SWEP.Primary.KickHorizontal = 1.4
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "ar2"
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 33
SWEP.Primary.Spread = .1

function SWEP:IronSight() -- This weapon should not have ironsights!
end