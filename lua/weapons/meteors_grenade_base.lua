--Made by MrRangerLP.

SWEP.SlotPos = 1

SWEP.Spawnable = false
SWEP.AdminSpawnable = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.DrawAmmo = true
SWEP.DrawCrosshair = true
SWEP.DrawWeaponInfoBox = false
SWEP.BounceWeaponIcon = false

SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = true

SWEP.HoldType = "grenade"

SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1

SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Ammo = "none"

SWEP.CanPullPin = true
SWEP.PinPulled = false

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	self.OurIndex = self:EntIndex()

	if SERVER and game.SinglePlayer() then -- In singleplayer we need to force the weapon to be equipped after spawning
		timer.Simple(0,function()
			if not IsValid(self) then return end -- We need to abort when the owner already had the weapon!
			self.Owner:SelectWeapon(self:GetClass())
		end)
	end

	if CLIENT then
		self.WepSelectIcon = surface.GetTextureID(string.gsub("vgui/hud/name","name",self:GetClass()))

		if self.Owner == LocalPlayer() then
			self:SendWeaponAnim(ACT_VM_IDLE)

			if self.Owner:GetActiveWeapon() == self then -- Compat/Bugfix
				self:Equip()
				self:Deploy()
			end
		end
	end
end

function SWEP:Equip()
	self.LastOwner = self.Owner

	if SERVER and not self.Owner:IsPlayer() then
		self:Remove()
		return
	end
end

function SWEP:Deploy()
	if SERVER and (self:Clip1() <= 0 and self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0) then -- Make sure we can not equip a Grenade when we do not even have one!
		self.Owner:StripWeapon(self:GetClass())
	end

	self:SetHoldType(self.HoldType)

	local vm = self.Owner:GetViewModel()
	if IsValid(vm) then -- This is required since the code should only run on the server or on the player holding the gun (Causes errors otherwise)
		self:SendWeaponAnim(ACT_VM_DRAW)

		local Dur = vm:SequenceDuration() + 0.2
		self:SetNextPrimaryFire(CurTime() + Dur)
		self:SetNextSecondaryFire(CurTime() + Dur)

		timer.Remove("MMM_M9k_Deploy_" .. self.OurIndex)
		timer.Create("MMM_M9k_Deploy_" .. self.OurIndex,Dur,1,function()
			if not IsValid(self) or not IsValid(self.Owner) or not IsValid(self.Owner:GetActiveWeapon()) or self.Owner:GetActiveWeapon():GetClass() ~= self:GetClass() then return end
			self.CanPullPin = true
		end)
	end

	return true
end

function SWEP:AttackAnimation()
	if not IsValid(self.Owner) then return end
	self.Owner:SetAnimation(PLAYER_ATTACK1)
end

function SWEP:PrimaryAttack()
	if self:CanPrimaryAttack() and self.CanPullPin and self:GetNextPrimaryFire() < CurTime() then
		self:SetNextPrimaryFire(CurTime() + 2)
		self.CanPullPin = false

		self:SendWeaponAnim(ACT_VM_PULLPIN)

		local vm = self.Owner:GetViewModel()
		if SERVER or IsValid(vm) then -- SERVER or the CLIENT throwing the grenade
			if not IsFirstTimePredicted() then return end -- Fixes weird prediction bugs
			local Dur = vm:SequenceDuration() + 0.2

			timer.Create("M9k_MMM_Grenade_Pullpin" .. self.OurIndex,Dur,1,function()
				if not IsValid(self) or not IsValid(self.Owner) or not IsValid(self.Owner:GetActiveWeapon()) or self.Owner:GetActiveWeapon():GetClass() ~= self:GetClass() then return end
				self.PinPulled = true
			end)
		end
	end
end

function SWEP:Think()
	if self.PinPulled and not self.Owner:KeyDown(IN_ATTACK) then
		self:SendWeaponAnim(self.PrimaryAttackSequence or ACT_VM_THROW)
		self:AttackAnimation()

		local vm = self.Owner:GetViewModel()
		if SERVER or IsValid(vm) then -- SERVER or the CLIENT throwing the grenade
			local Dur = vm:SequenceDuration() - (self.PrimaryAttackSequenceDelay or (game.SinglePlayer() and 0.3 or 0.5))

			timer.Create("M9k_MMM_Grenade_Grenadethrow" .. self.OurIndex,Dur,1,function()
				if not IsValid(self) or not IsValid(self.Owner) or not IsValid(self.Owner:GetActiveWeapon()) or self.Owner:GetActiveWeapon():GetClass() ~= self:GetClass() then return end

				if SERVER then
					self:TakePrimaryAmmo(1)
					if self.AttacksoundPrimary then -- Could be useful for modders
						self:EmitSound(self.AttacksoundPrimary)
					end

					local Ang = self.Owner:EyeAngles() -- Taken from TTT base grenade since it is quite good in my opinion
					local Src = self.Owner:GetPos() + (self.Owner:Crouching() and self.Owner:GetViewOffsetDucked() or self.Owner:GetViewOffset()) + (Ang:Forward() * 8) + (Ang:Right() * 10)
					local Target = self.Owner:GetEyeTraceNoCursor().HitPos
					local TAng = (Target - Src):Angle()

					if TAng.p < 90 then
						TAng.p = -10 + TAng.p * ((90 + 10) / 90)
					else
						TAng.p = 360 - TAng.p
						TAng.p = -10 + TAng.p * -((90 + 10) / 90)
					end

					TAng.p = math.Clamp(TAng.p,-90,90)
					local Vel = math.min(800,(90 - TAng.p) * 6)
					local Thr = TAng:Forward() * Vel + self.Owner:GetVelocity()

					local Projectile = self:CreateGrenadeProjectile(Src)

					if IsValid(Projectile) then
						local Phys = Projectile:GetPhysicsObject()

						if IsValid(Phys) then
							Phys:SetVelocity(Thr)
							Phys:AddAngleVelocity(Vector(600,math.random(-1200,1200),0))
						end
					end
				end

				timer.Create("M9k_MMM_Grenade_Grenadethrow" .. self.OurIndex,0.3,1,function()
					if not IsValid(self) or not IsValid(self.Owner) or not IsValid(self.Owner:GetActiveWeapon()) or self.Owner:GetActiveWeapon():GetClass() ~= self:GetClass() then return end

					if (self:Clip1() <= 0 and self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0) then
						if SERVER then
							self.CanPullPin = true -- Needs to be set so the last grenade throw does not call the OnDrop 'death' function
							self.Owner:StripWeapon(self:GetClass())
						end
					else
						self:Deploy()
						self.Owner:RemoveAmmo(1,self.Primary.Ammo)
						self:SetClip1(1)
					end
				end)
			end)
		end

		self.PinPulled = false
	end
end

function SWEP:Holster()
	if not SERVER and self.Owner ~= LocalPlayer() then return end

	timer.Remove("M9k_MMM_Grenade_Pullpin" .. self.OurIndex)
	timer.Remove("M9k_MMM_Grenade_Grenadethrow" .. self.OurIndex)

	self.CanPullPin = true
	self.PinPulled = false

	if SERVER and IsValid(self.Owner) then
		if (self:Clip1() <= 0 and self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0) then -- Remove the grenade when its 'empty'
			self.Owner:StripWeapon(self:GetClass())
		elseif self:Clip1() <= 0 then -- Unless we still have some left in which case we refill the 'magazine'
			self:SetClip1(1)
			self.Owner:RemoveAmmo(1,self.Primary.Ammo)
		end
	end

	return true
end

--[[ This doesn't work. Why? Check the SWEP:OnDrop() function.
if CLIENT then -- This is done to fix the viewmodel after dropping
	function SWEP:OwnerChanged()
		self:Holster()
	end
end
]]

if SERVER then
	function SWEP:OnDrop()
		if self.PinPulled or not self.CanPullPin then -- The owner died and the pin was pulled, so we do whatever the throwable does!
			self.Owner = self.LastOwner
			self:CreateGrenadeProjectile(self:GetPos())
			self:Remove()
		else
			self:Holster()

			-- HACK!! At the time of coding this, WEAPON:OwnerChanged does not work for the first spawn and drop! (Which causes issues!!)
			-- https://github.com/Facepunch/garrysmod-issues/issues/4639
			if IsValid(self.LastOwner) then -- This is done to fix the viewmodel after dropping
				self.LastOwner:SendLua("local Ent = Entity(" .. self.OurIndex .. "); if IsValid(Ent) then Ent:Holster() end")
			end
		end
	end
end

function SWEP:OnRemove()
	if SERVER and IsValid(self.Owner) then
		self.Owner:StripWeapon(self:GetClass())
	end
end

function SWEP:CanPrimaryAttack()
	if self:Clip1() <= 0 then
		self:SetNextPrimaryFire(CurTime() + 0.2)

		return false
	end

	return true
end

function SWEP:SecondaryAttack()
	return false
end

function SWEP:Reload()
	return false
end