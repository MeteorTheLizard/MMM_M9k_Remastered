SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9K Submachine Guns"
SWEP.PrintName = "MP9"

SWEP.Slot = 2
SWEP.HoldType = "pistol"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_b_t_mp9.mdl"
SWEP.WorldModel = "models/weapons/w_brugger_thomet_mp9.mdl"

SWEP.Primary.Sound = "Weapon_mp9.Single"
SWEP.Primary.RPM = 800
SWEP.Primary.ClipSize = 30

SWEP.Primary.KickUp = 1
SWEP.Primary.KickDown = 0.7
SWEP.Primary.KickHorizontal = 0.7
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "ar2"
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 13
SWEP.Primary.Spread = .035

SWEP.IronSightsPos = Vector(4.073,-3.438,1.259)

function SWEP:FireAnimationEvent(_,_,event)
	if event == 5001 or event == 5011 or event == 5021 or event == 5031 then

		return true
	end
end