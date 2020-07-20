SWEP.Base = "bobs_scoped_base"
SWEP.Category = "M9K Sniper Rifles"
SWEP.PrintName = "Thompson Contender G2"

SWEP.HoldType = "revolver"
SWEP.Spawnable = true

SWEP.ViewModelFOV = 65
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_contender2.mdl"
SWEP.WorldModel = "models/weapons/w_g2_contender.mdl"

SWEP.Primary.Sound = "contender_g2.Single"
SWEP.Primary.RPM = 45
SWEP.Primary.ClipSize = 1
SWEP.Primary.KickUp = 4
SWEP.Primary.KickDown = 3
SWEP.Primary.KickHorizontal = 5
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "SniperPenetratedRound"
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 74
SWEP.Primary.Spread = .15
SWEP.Primary.SpreadZoomed = .001
SWEP.Primary.SpreadBefore = SWEP.Primary.Spread

local OurClass = "m9k_contender"

-- The thompson Contender is a special little something that requires its own PrimaryAttack function as the original creators thought it was a good idea to have the reload animation EMBEDDED into the primary fire animation (SMH)

function SWEP:PrimaryAttack()
	if self.Owner:WaterLevel() == 3 then -- No weapons may fire underwater
		self:EmitSound("Weapon_Pistol.Empty")
		self:SetNextPrimaryFire(CurTime() + 0.2)
		return
	end

	if self:CanPrimaryAttack() then
		local Spread = self.Primary.Spread

		if self.Owner:GetVelocity():Length() > 100 then
			Spread = self.Primary.Spread * 6
		elseif self.Owner:KeyDown(IN_DUCK) then
			Spread = self.Primary.Spread / 2
		end

		self:SetNextPrimaryFire(CurTime() + 1 / (self.Primary.RPM / 60))
		self:TakePrimaryAmmo(1)
		self:ShootBullet((1 * self.Primary.Damage) * math.Rand(.85,1.3),self.Primary.Recoil,self.Primary.NumShots,Spread)
		self.Owner:SetAnimation(PLAYER_ATTACK1)
		self:EmitSound(self.Primary.Sound)
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
		self:MuzzleFlash() -- IDK if this is really needed tbh

		-- The following part is needed for the viewmodel to not glitch out but also follow logic
		if self:Clip1() == 0 and self.Owner:GetAmmoCount(self.Primary.Ammo) >= 1 then
			local TimerName = "Contender_Reload_" .. self:EntIndex()
			self.ScopeCD = CurTime() + 1.5
			self.ScopeState = 0
			self.Owner:SetFOV(0,0.1)

			timer.Create(TimerName,1.25,1,function() -- Seems to be a tiny bit faster than the viewmodel animation which is what we want
				if not IsValid(self) or not IsValid(self.Owner) or not IsValid(self.Owner:GetActiveWeapon()) or self.Owner:GetActiveWeapon():GetClass() ~= OurClass then return end

				self:SetClip1(1)
				self.Owner:RemoveAmmo(1,self.Primary.Ammo)
			end)
		else
			self:SendWeaponAnim(ACT_VM_IDLE)
		end
	end
end

function SWEP:Holster() -- Make sure the special reload animation gets canceled
	self.ScopeState = 0
	timer.Remove("Contender_Reload_" .. self:EntIndex())
	return true -- We have to return true
end