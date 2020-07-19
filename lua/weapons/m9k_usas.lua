SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9K Shotguns"
SWEP.PrintName = "USAS"

SWEP.Slot = 4
SWEP.HoldType = "shotgun"
SWEP.Spawnable = true

SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/v_usas12_shot.mdl"
SWEP.WorldModel = "models/weapons/w_usas_12.mdl"

SWEP.Primary.Sound = "Weapon_usas.Single"
SWEP.Primary.RPM = 175
SWEP.Primary.ClipSize = 20

SWEP.Primary.KickUp = 2
SWEP.Primary.KickDown = 0.5
SWEP.Primary.KickHorizontal = 1.2
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "buckshot"
SWEP.Primary.NumShots = 45
SWEP.Primary.Damage = 2
SWEP.Primary.Spread = .37

SWEP.IsUSASReloading = false

local OurClass = "m9k_usas"
local ReloadSound = "Weapon_usas.draw"

function SWEP:CanPrimaryAttack()
	if self.IsUSASReloading then
		return false
	end

	if self:Clip1() <= 0 then
		self:EmitSound("Weapon_Pistol.Empty")
		self:SetNextPrimaryFire(CurTime() + 0.2)
		self:Reload()
		return false
	end

	return true
end

-- And once again we have a special snowflake as this weapon requires 2 animations to be played in order to reload properly.
function SWEP:Reload() -- This function has some serious and crappy workarounds, if only they would have made a NORMAL reload animation instead of using shotgun reload start etc..
	if self.IsUSASReloading then return false end

	if self.Owner:GetAmmoCount(self.Primary.Ammo) >= 1 and self:Clip1() < self.Primary.ClipSize then
		self.IsUSASReloading = true

		self.Owner:SetAnimation(PLAYER_RELOAD)
		self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_START)

		local TimerName = "USAS_Reload_" .. self:EntIndex()
		timer.Create(TimerName,0.65,1,function()
			if not IsValid(self) or not IsValid(self.Owner) or not IsValid(self.Owner:GetActiveWeapon()) or self.Owner:GetActiveWeapon():GetClass() ~= OurClass then return end

			self:EmitSound(ReloadSound)

			timer.Create(TimerName,0.3,1,function()
				if not IsValid(self) or not IsValid(self.Owner) or not IsValid(self.Owner:GetActiveWeapon()) or self.Owner:GetActiveWeapon():GetClass() ~= OurClass then return end

				self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)

				timer.Create(TimerName,0.7,1,function()
					self:SetClip1(self.Owner:GetAmmoCount(self.Primary.Ammo) >= 20 and 20 or self.Owner:GetAmmoCount(self.Primary.Ammo))
					self.IsUSASReloading = false

					self:SetNextPrimaryFire(CurTime() + 0.25)
				end)
			end)
		end)
	end
end

function SWEP:Holster() -- Make sure the reload animation is canceled when swapping
	timer.Remove("USAS_Reload_" .. self:EntIndex())
	self.IsUSASReloading = false
	return true
end