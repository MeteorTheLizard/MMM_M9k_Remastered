SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9K Shotguns"
SWEP.PrintName = "USAS"

SWEP.Slot = 4
SWEP.HoldType = "ar2"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_usas12_shot.mdl"
SWEP.WorldModel = "models/weapons/w_usas_12.mdl"

SWEP.Primary.Sound = "Weapon_usas.Single"
SWEP.Primary.RPM = 175
SWEP.Primary.ClipSize = 20

SWEP.Primary.KickUp = 4
SWEP.Primary.KickDown = 2
SWEP.Primary.KickHorizontal = 2
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "buckshot"
SWEP.Primary.NumShots = 39
SWEP.Primary.Damage = 3
SWEP.Primary.Spread = .20

SWEP.IronSightsPos = Vector(4.519,-2.159,1.039)
SWEP.IronSightsAng = Vector(0.072,0.975,0)

SWEP.ShouldDoMoveSpread = false
SWEP.IsUSASReloading = false

local ReloadSound = "Weapon_usas.draw"

function SWEP:CanPrimaryAttack()
	if not SERVER and self.Owner ~= LocalPlayer() or self.IsUSASReloading then return end

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
	if not self.CanReload or self.IsUSASReloading then return end

	if self.Owner:GetAmmoCount(self.Primary.Ammo) >= 1 and self:Clip1() < self.Primary.ClipSize then
		self.Owner:SetAnimation(PLAYER_RELOAD)
		self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_START)

		self.IsUSASReloading = true

		if self.IronSightState then
			self.Owner:SetFOV(0,0.3)
			self.IronSightState = false
			self.DrawCrosshair = true
		end

		local TimerName = "USAS_Reload_" .. self.OurIndex
		timer.Create(TimerName,0.65,1,function()
			if not IsValid(self) or not IsValid(self.Owner) or not IsValid(self.Owner:GetActiveWeapon()) or self.Owner:GetActiveWeapon():GetClass() ~= self.ClassName then return end

			self:EmitSound(ReloadSound)

			timer.Create(TimerName,0.3,1,function()
				if not IsValid(self) or not IsValid(self.Owner) or not IsValid(self.Owner:GetActiveWeapon()) or self.Owner:GetActiveWeapon():GetClass() ~= self.ClassName then return end

				self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)

				timer.Create(TimerName,0.7,1,function()
					if not IsValid(self) then return end
					self:SetClip1(self.Owner:GetAmmoCount(self.Primary.Ammo) >= 20 and 20 or self.Owner:GetAmmoCount(self.Primary.Ammo))
					self.IsUSASReloading = false

					self:SetNextPrimaryFire(CurTime() + 0.25)
				end)
			end)
		end)
	end
end

function SWEP:Holster() -- Make sure the reload animation is canceled when swapping
	if not SERVER and self.Owner ~= LocalPlayer() then return end

	if self.IronSightState then
		self.Owner:SetFOV(0,0.3)
		self.IronSightState = false
		self.DrawCrosshair = true
	end

	timer.Remove("USAS_Reload_" .. self.OurIndex)
	self.IsUSASReloading = false
	return true
end