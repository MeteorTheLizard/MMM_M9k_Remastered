SWEP.Base = "bobs_gun_base"
SWEP.Slot = 4
SWEP.SlotPos = 1

SWEP.ShellTime = 0.35
SWEP.InsertingShell = false
SWEP.CanceledReloadSuccess = false

function SWEP:Deploy()
	self:SetHoldType(self.HoldType)

	local TimerName = "ShotgunReload_" .. self:EntIndex()
	timer.Remove(TimerName)

	self:SendWeaponAnim(ACT_VM_DRAW)
	self:SetNextPrimaryFire(CurTime() + 1)
	self:SetNextSecondaryFire(CurTime() + 1)
	self.InsertingShell = false

	return true
end

function SWEP:PrimaryAttack()
	if self.InsertingShell and not self.CanceledReloadSuccess then
		self:FinishReloading()
	elseif self:CanPrimaryAttack() and not self.InsertingShell then
		local Spread = self.Primary.Spread
		local Class = self:GetClass()

		if not (Class == "m9k_m3" or Class == "m9k_browningauto5" or Class == "m9k_dbarrel" or Class == "m9k_ithacam37" or Class == "m9k_mossberg590" or Class == "m9k_jackhammer" or Class == "m9k_remington870" or Class == "m9k_spas12" or Class == "m9k_striker12" or Class == "m9k_1897winchester" or Class == "m9k_1887winchester") then
			if self.Owner:GetVelocity():Length() > 100 then
				Spread = self.Primary.Spread * 6
			elseif self.Owner:KeyDown(IN_DUCK) then
				Spread = self.Primary.Spread / 2
			end
		end

		self:SetNextPrimaryFire(CurTime() + 1 / (self.Primary.RPM / 60))
		self:TakePrimaryAmmo(1)
		self:ShootBullet((1 * self.Primary.Damage) * math.Rand(.85,1.3),self.Primary.Recoil,self.Primary.NumShots,Spread)
		self.Owner:SetAnimation(PLAYER_ATTACK1)
		self:EmitSound(self.Primary.Sound)
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	end
end

function SWEP:Reload()
	if self.Owner:GetAmmoCount(self.Primary.Ammo) >= 1 and not self.InsertingShell and self:Clip1() < self.Primary.ClipSize then
		self.InsertingShell = true
		self.CanceledReloadSuccess = false

		local TimerName = "ShotgunReload_" .. self:EntIndex()
		timer.Remove(TimerName)

		self.Owner:SetAnimation(PLAYER_RELOAD)
		self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_START)

		timer.Create(TimerName,self.ShellTime + 0.05,self.Primary.ClipSize - self:Clip1(),function()
			if not IsValid(self) or not IsValid(self.Owner) or self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0 then
				self:FinishReloading()
				timer.Remove(TimerName)
				return
			end

			local vm = self.Owner:GetViewModel()
			vm:ResetSequence(vm:LookupSequence("after_reload"))
			vm:SetPlaybackRate(.01)

			timer.Simple(0.1,function()
				if not IsValid(self) or not IsValid(self.Owner) then return end

				self:SendWeaponAnim(ACT_VM_RELOAD)

				timer.Simple(0.2,function()
					if not IsValid(self) or not IsValid(self.Owner) then return end

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
		local TimerName = "ShotgunReload_" .. self:EntIndex()
		timer.Remove(TimerName)

		timer.Simple(0.35,function()
			if not IsValid(self) or not IsValid(self.Owner) then return end

			self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)
			self.CanceledReloadSuccess = true
		end)

		self.InsertingShell = false
		self:SetNextPrimaryFire(CurTime() + 1.25)
	end
end