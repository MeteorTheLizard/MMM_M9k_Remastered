SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9K Machine Guns"
SWEP.PrintName = "Minigun"

SWEP.Slot = 5
SWEP.HoldType = "crossbow"
SWEP.Spawnable = true

SWEP.ViewModelFOV = 65
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_minigunvulcan.mdl"
SWEP.WorldModel = "models/weapons/w_m134_minigun.mdl"

SWEP.Primary.Sound = "BlackVulcan.Single"
SWEP.Primary.RPM = 600
SWEP.Primary.ClipSize = 150
SWEP.Primary.KickUp = 0.5
SWEP.Primary.KickDown = 0.4
SWEP.Primary.KickHorizontal = 0.7
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "ar2"
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 27
SWEP.Primary.Spread = .08

function SWEP:IronSight() -- This weapon should not have ironsights!
end