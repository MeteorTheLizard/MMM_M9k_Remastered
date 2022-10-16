SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9kR: Submachine Guns"
SWEP.PrintName = "MP9"

SWEP.Slot = 2
SWEP.HoldType = "pistol"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_b_t_mp9.mdl"
SWEP.WorldModel = "models/weapons/w_brugger_thomet_mp9.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/mp9/tmp_clipout.mp3",
		iDelay = 0.70
	},
	{
		sSound = "weapons/mp9/tmp_clipin.mp3",
		iDelay = 0.70 + 1.00
	}
}

SWEP.Primary.Sound = "weapons/mp9/tmp-1.wav"
SWEP.Primary.SoundVolume = 65 -- Silenced!

SWEP.Primary.RPM = 800
SWEP.Primary.ClipSize = 30
SWEP.Primary.KickUp = 1
SWEP.Primary.KickDown = 0.7
SWEP.Primary.KickHorizontal = 0.7
SWEP.Primary.Automatic = true
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 13
SWEP.Primary.Spread = .035
SWEP.Primary.Ammo = "ar2"

SWEP.IronSightsPos = Vector(4.073,-3.438,1.259)

SWEP.bBlockMuzzleFlash = true

SWEP.LegacyBalance = {
	Primary = {
		RPM = 900,
		ClipSize = 30,
		KickUp = 0.2,
		KickDown = 0.1,
		KickHorizontal = 0.2,
		Automatic = true,
		NumShots = 1,
		Damage = 20,
		Spread = .023
	}
}

function SWEP:FireAnimationEvent(_,_,event)
	if event == 5001 or event == 5011 or event == 5021 or event == 5031 then

		return true
	end
end