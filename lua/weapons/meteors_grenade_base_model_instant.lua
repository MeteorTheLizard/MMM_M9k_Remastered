--Made by MrRangerLP.
-- This is for grenades that use custom viewmodels and worldmodels that do not require a pin to be pulled in order to be thrown

SWEP.Base = "meteors_grenade_base_model"

if CLIENT then
	local VectorCache1 = Vector(1,1,1)
	local angle_zero = Angle(0,0,0)
	local vector_zero = Vector(0,0,0)

	function SWEP:Holster()
		local vm = IsValid(self.Owner) and self.Owner:GetViewModel() or IsValid(self.LastOwner) and self.LastOwner:GetViewModel()
		if not IsValid(vm) or not vm:GetBoneCount() then return end

		for k = 0,vm:GetBoneCount() do -- Make sure to reset the bones! (very important!!)
			vm:ManipulateBoneScale(k,VectorCache1)
			vm:ManipulateBoneAngles(k,angle_zero)
			vm:ManipulateBonePosition(k,vector_zero)
		end

		timer.Remove("M9k_MMM_Grenade_Grenadethrow" .. self.OurIndex)

		self.ShouldDraw = true

		self.ViewEnt:SetNoDraw(true)
		return true
	end
end

function SWEP:Think()
	if CLIENT then -- Hide base viewmodel when cameras changed
		local View = self.Owner:GetViewEntity()

		if View ~= self.LastViewEntity then
			self:HideBaseViewModel()
		end

		self.LastViewEntity = View
	end
end

function SWEP:PrimaryAttack()
	if self:CanPrimaryAttack() and self:GetNextPrimaryFire() < CurTime() then
		self:SetNextPrimaryFire(CurTime() + 2)

		timer.Remove("M9k_MMM_Grenade_Grenadethrow" .. self.OurIndex) -- Prevent the animation from being overwritten by the idle thing

		self:SendWeaponAnim(self.PrimaryAttackSequence or ACT_VM_THROW)
		self:AttackAnimation()

		local vm = self.Owner:GetViewModel()
		if SERVER or IsValid(vm) then -- SERVER or the CLIENT throwing the grenade
			if not IsFirstTimePredicted() or game.SinglePlayer() then return end -- Fixes weird prediction bugs
			local Dur = vm:SequenceDuration() - (self.PrimaryAttackSequenceDelay or 0.5)

			if CLIENT then
				timer.Simple(0.1,function() -- This only runs on the thrower
					self.ShouldDraw = false
				end)
			end

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

					if IsValid(Projectile) and IsValid(Projectile.Phys) then
						Projectile.Phys:SetVelocity(Thr)
						Projectile.Phys:AddAngleVelocity(Vector(600,math.random(-1200,1200),0))
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

					if CLIENT then
						self.ShouldDraw = true
					end
				end)
			end)
		end
	end
end