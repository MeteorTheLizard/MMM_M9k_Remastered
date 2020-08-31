SWEP.Base = "bobs_gun_base"
SWEP.Slot = 4

SWEP.HoldType = "shotgun"

SWEP.ShellTime = 0.35
SWEP.InsertingShell = false
SWEP.CanceledReloadSuccess = false

function SWEP:Deploy()
	if SERVER and game.SinglePlayer() then self:CallOnClient("Deploy") end -- Make sure that it runs on the CLIENT!
	self:SetHoldType(self.HoldType)

	timer.Remove("ShotgunReload_" .. self.OurIndex)

	local vm = self.Owner:GetViewModel()
	if IsValid(vm) then -- This is required since the code should only run on the server or on the player holding the gun (Causes errors otherwise)
		self.CanReload = false
		self:SetNWBool("CanIronSights",false)
		self:SendWeaponAnim(ACT_VM_DRAW)

		local Dur = vm:SequenceDuration() + 0.1
		self:SetNextPrimaryFire(CurTime() + Dur)
		self:SetNextSecondaryFire(CurTime() + Dur)

		timer.Remove("MMM_M9k_Deploy_" .. self.OurIndex)
		timer.Create("MMM_M9k_Deploy_" .. self.OurIndex,Dur,1,function()
			if not IsValid(self) or not IsValid(self.Owner) or not IsValid(self.Owner:GetActiveWeapon()) or self.Owner:GetActiveWeapon():GetClass() ~= self:GetClass() then return end
			self:SetNWBool("CanIronSights",true)
			self.CanReload = true
		end)
	end

	self.InsertingShell = false
	return true
end

function SWEP:Holster()
	if SERVER and game.SinglePlayer() then self:CallOnClient("Holster") end -- Make sure that it runs on the CLIENT!
	if not SERVER and self.Owner ~= LocalPlayer() then return end

	if self.IronSightState then
		self.Owner:SetFOV(0,0.3)
		self.IronSightState = false
		self.DrawCrosshair = true
	end

	if self.InsertingShell then
		timer.Remove("ShotgunReload_" .. self.OurIndex)
		self.InsertingShell = false
		self:SetNextPrimaryFire(CurTime() + 1.25)
	end

	return true
end

function SWEP:PrimaryAttack()
	if SERVER and game.SinglePlayer() then self:CallOnClient("PrimaryAttack") end -- Make sure that it runs on the CLIENT!

	if self.Owner:WaterLevel() == 3 then -- No weapons may fire underwater
		self:EmitSound("Weapon_Pistol.Empty")
		self:SetNextPrimaryFire(CurTime() + 0.2)
		return
	end

	if self.InsertingShell and not self.CanceledReloadSuccess then
		self:FinishReloading()
	elseif self:CanPrimaryAttack() and self:GetNextPrimaryFire() < CurTime() and not self.InsertingShell then
		local Spread = self.Primary.Spread

		if self.ShouldDoMoveSpread then
			if self.Owner:GetVelocity():Length() > 100 then
				Spread = self.Primary.Spread * 6
			elseif self.Owner:KeyDown(IN_DUCK) then
				Spread = self.Primary.Spread / 2
			end
		end

		self:SetNextPrimaryFire(CurTime() + 1 / (self.Primary.RPM / 60))

		if CLIENT and game.SinglePlayer() then return end

		self:TakePrimaryAmmo(1)
		self:ShootBullet((1 * self.Primary.Damage) * math.Rand(.85,1.3),self.Primary.Recoil,self.Primary.NumShots,Spread)
		self:AttackAnimation()
		self:EmitSound(self.Primary.Sound)
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
		self:MuzzleFlash()
	end
end

function SWEP:Reload()
	if self.CanReload and self.Owner:GetAmmoCount(self.Primary.Ammo) >= 1 and not self.InsertingShell and self:Clip1() < self.Primary.ClipSize then
		if self.IronSightState then
			self.Owner:SetFOV(0,0.3)
			self.IronSightState = false
			self.DrawCrosshair = true
		end

		self:SetNWBool("CanIronSights",false)
		self.InsertingShell = true
		self.CanceledReloadSuccess = false

		self.Owner:SetAnimation(PLAYER_RELOAD)
		self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_START)

		timer.Remove("ShotgunReload_" .. self.OurIndex)
		timer.Create("ShotgunReload_" .. self.OurIndex,self.ShellTime + 0.05,self.Primary.ClipSize - self:Clip1(),function()
			if not IsValid(self) or not IsValid(self.Owner) or not IsValid(self.Owner:GetActiveWeapon()) or self.Owner:GetActiveWeapon():GetClass() ~= self:GetClass() then
				timer.Remove("ShotgunReload_" .. self.OurIndex)
				return
			end

			if self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0 then
				self:FinishReloading()
				timer.Remove("ShotgunReload_" .. self.OurIndex)
				return
			end

			local vm = self.Owner:GetViewModel()
			if IsValid(vm) then
				vm:ResetSequence("after_reload")
				vm:SetPlaybackRate(.01)
			end

			timer.Simple(0.1,function()
				if not IsValid(self) or not IsValid(self.Owner) or not IsValid(self.Owner:GetActiveWeapon()) or self.Owner:GetActiveWeapon():GetClass() ~= self:GetClass() then return end

				self:SendWeaponAnim(ACT_VM_RELOAD)

				timer.Simple(0.2,function()
					if not IsValid(self) or not IsValid(self.Owner) or not IsValid(self.Owner:GetActiveWeapon()) or self.Owner:GetActiveWeapon():GetClass() ~= self:GetClass() then return end

					self.Owner:RemoveAmmo(1,self.Primary.Ammo,false)
					self:SetClip1(self:Clip1() + 1)

					if self:Clip1() >= self.Primary.ClipSize then
						self:FinishReloading()
					end
				end)
			end)
		end)
	end
end

function SWEP:FinishReloading()
	if self.InsertingShell then
		timer.Remove("ShotgunReload_" .. self.OurIndex)

		timer.Simple(0.35,function()
			if not IsValid(self) or not IsValid(self.Owner) then return end

			self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)
			self.CanceledReloadSuccess = true
			self:SetNWBool("CanIronSights",true)
		end)

		self.InsertingShell = false
		self:SetNextPrimaryFire(CurTime() + 1.25)
		self:SetNextSecondaryFire(CurTime() + 1.25)
	end
end