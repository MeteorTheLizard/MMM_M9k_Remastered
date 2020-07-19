SWEP.Base = "bobs_shotty_base"
SWEP.Category = "M9K Shotguns"
SWEP.PrintName = "Double Barrel Shotgun"

SWEP.HoldType = "shotgun"
SWEP.Spawnable = true

SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_doublebarrl.mdl"
SWEP.WorldModel = "models/weapons/w_double_barrel_shotgun.mdl"

SWEP.Primary.Sound = "Double_Barrel.Single"
SWEP.Primary.RPM = 180
SWEP.Primary.ClipSize = 2

SWEP.Primary.KickUp = 7
SWEP.Primary.KickDown = 5
SWEP.Primary.KickHorizontal = 10
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "buckshot"
SWEP.Primary.NumShots = 81
SWEP.Primary.Damage = 1
SWEP.Primary.Spread = .30
SWEP.ShellTime = .5

SWEP.Secondary.Sound = "dbarrel_dblast"

function SWEP:SecondaryAttack()
	if timer.Exists("ShotgunReload_" .. self:EntIndex()) then return end

	if self.Owner:WaterLevel() == 3 then -- No weapons may fire underwater
		self:EmitSound("Weapon_Pistol.Empty")
		self:SetNextPrimaryFire(CurTime() + 0.2)
		return
	end

	if self.InsertingShell and not self.CanceledReloadSuccess then
		self:FinishReloading()
	elseif self:CanPrimaryAttack() and not self.InsertingShell then
		if self:Clip1() >= 2 then
			self:ShootBullet(1 * self.Primary.Damage * math.Rand(.85,1.3),self.Primary.Recoil,self.Primary.NumShots * 4,self.Primary.Spread * 2)
			self:TakePrimaryAmmo(2)
			self:EmitSound(self.Secondary.Sound)
			self.Owner:SetAnimation(PLAYER_ATTACK1)
			self.Owner:MuzzleFlash()
			self:SetNextSecondaryFire(CurTime() + 1 / ((self.Primary.RPM / 2) / 60))
		elseif self:Clip1() == 1 then
			self:PrimaryAttack()
		elseif self:Clip1() == 0 then
			self:Reload()
		end
	end
end