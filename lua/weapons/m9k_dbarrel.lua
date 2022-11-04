SWEP.Base = "bobs_shotty_base"
SWEP.Category = "M9kR: Shotguns"
SWEP.PrintName = "Double Barrel Shotgun"

SWEP.Spawnable = true

SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_doublebarrl.mdl"
SWEP.WorldModel = "models/weapons/w_double_barrel_shotgun.mdl"

SWEP.ReloadSoundStart = "weapons/dbarrel/barrelup.mp3"
SWEP.ReloadSound = "weapons/dbarrel/xm1014_insertshell.mp3"
SWEP.ReloadSoundFinish = "weapons/dbarrel/barreldown.mp3"

SWEP.Primary.Sound = "weapons/dbarrel/xm1014-1.wav"

SWEP.Primary.RPM = 180
SWEP.Primary.ClipSize = 2
SWEP.Primary.KickUp = 7
SWEP.Primary.KickDown = 5
SWEP.Primary.KickHorizontal = 10
SWEP.Primary.Automatic = false
SWEP.Primary.NumShots = 27
SWEP.Primary.Damage = 4
SWEP.Primary.Spread = .15
SWEP.Primary.Ammo = "buckshot"

SWEP.iShellTime = 0.5

SWEP.bShotgunNoIron = true

SWEP.LegacyBalance = {
	Primary = {
		RPM = 180,
		ClipSize = 2,
		KickUp = 10,
		KickDown = 5,
		KickHorizontal = 5,
		Automatic = false,
		NumShots = 18,
		Damage = 10,
		Spread = .03
	}
}


-- These are required for firstperson

sound.Add({
	name = "Double_Barrel.InsertShell",
	channel = CHAN_ITEM,
	volume = 1.0,
	sound = "weapons/dbarrel/xm1014_insertshell.mp3"
})

sound.Add({
	name = "Double_Barrel.barreldown",
	channel = CHAN_ITEM,
	volume = 1.0,
	sound = "weapons/dbarrel/barreldown.mp3"
})

sound.Add({
	name = "Double_Barrel.barrelup",
	channel = CHAN_ITEM,
	volume = 1.0,
	sound = "weapons/dbarrel/barrelup.mp3"
})


function SWEP:SecondaryAttack() -- Secondary should make you fire both barrels. (Needs to be shared)

	if not self:CanPrimaryAttack() then return end


	self:PrimaryAttack()

	if self:Clip1() >= 1 then -- Fire both barrels!
		self:SetNextPrimaryFire(CurTime())
		self:PrimaryAttack()

		self:EmitSound("weapons/dbarrel/dblast.wav",85)
	end
end