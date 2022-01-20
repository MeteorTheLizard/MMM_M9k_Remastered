--Made by MrRangerLP.
-- This is for grenades that use custom viewmodels and worldmodels

SWEP.Base = "meteors_grenade_base"

if CLIENT then
	local VectorCache1 = Vector(1,1,1)
	local angle_zero = Angle(0,0,0)
	local vector_zero = Vector(0,0,0)

	function SWEP:CreateWorldModel() -- We need to create these like that since a player could join and these would be invalid!
		if self.DoNotUseWorldModel then return end
		if IsValid(self.WorldEnt) then self.WorldModel:Remove() end

		self.WorldEnt = ClientsideModel(self.WorldModel,RENDERGROUP_OPAQUE)
		self.WorldEnt:SetPos(self:GetPos())
		self.WorldEnt:SetAngles(self:GetAngles())
		self.WorldEnt:SetParent(self)
		self.WorldEnt:SetNoDraw(true)

		self.WorldMatrix = Matrix()
		self.WorldMatrix:Scale(self.WorldModelScale)
	end

	function SWEP:CreateViewModel() -- We need to create these like that since a player could join and these would be invalid!
		if self.DoNotUseViewModel then return end
		if IsValid(self.ViewEnt) then self.ViewEnt:Remove() end

		self.ViewEnt = ClientsideModel(self.WorldModel,RENDERGROUP_OPAQUE)
		self.ViewEnt:SetPos(self:GetPos())
		self.ViewEnt:SetAngles(self:GetAngles())
		self.ViewEnt:SetParent(self)
		self.ViewEnt:SetNoDraw(true)

		self.ViewMatrix = Matrix()
		self.ViewMatrix:Scale(self.ViewModelScale)
	end

	function SWEP:Initialize()
		self:SetHoldType(self.HoldType)
		self.OurIndex = self:EntIndex()

		self.WepSelectIcon = surface.GetTextureID(string.gsub("vgui/hud/name","name",self:GetClass()))
		self:SetNWBool("ShouldDraw",true)
		self.LastViewEntity = NULL

		self:CreateWorldModel()

		if self.Owner == LocalPlayer() then
			self:SendWeaponAnim(ACT_VM_IDLE)

			self:CreateViewModel()

			if self.Owner:GetActiveWeapon() == self then -- Compat/Bugfix
				self:Equip()
				self:Deploy()
			end
		end
	end

	function SWEP:DrawWorldModel()
		if self.DoNotUseWorldModel then -- Can be used to use the default worldmodel
			self:DrawModel()
			return true
		end

		if not IsValid(self.WorldEnt) then self:CreateWorldModel() end

		if IsValid(self.Owner) then
			self.CachedWorldBone = self.CachedWorldBone or self.Owner:LookupBone("ValveBiped.Bip01_R_Hand") -- This is faster than looking it up every frame!
			local Pos, Ang = self.Owner:GetBonePosition(self.CachedWorldBone)

			self.WorldEnt:SetPos(Pos + Ang:Forward() * self.ModelWorldForwardMult + Ang:Right() * self.ModelWorldRightMult + Ang:Up() * self.ModelWorldUpMult)
			Ang:RotateAroundAxis(Ang:Forward(),self.ModelWorldAngForward)
			Ang:RotateAroundAxis(Ang:Right(),self.ModelWorldAngRight)
			Ang:RotateAroundAxis(Ang:Up(),self.ModelWorldAngUp)
			self.WorldEnt:SetAngles(Ang)
			self.WorldEnt:EnableMatrix("RenderMultiply",self.WorldMatrix)
			self.WorldEnt:DrawModel()
		else
			self:DrawModel()
		end
	end

	function SWEP:ViewModelDrawn(vm)
		if self.DoNotUseViewModel then return true end -- Can be used to use the default viewmodel
		if not IsValid(self.ViewEnt) then self:CreateViewModel() end

		if not self:GetNWBool("ShouldDraw") then return end -- At some points it should not be drawn, mainly during the throw animation

		self.CachedViewBone = self.CachedViewBone or vm:LookupBone("ValveBiped.Bip01_R_Hand") -- This is faster than looking it up every frame!
		local mMatrix = vm:GetBoneMatrix(self.CachedViewBone)
		if not mMatrix then return end -- Required to fix a one-time error
		local Pos, Ang = mMatrix:GetTranslation(), mMatrix:GetAngles()

		self.ViewEnt:SetPos(Pos + Ang:Forward() * self.ModelViewForwardMult + Ang:Right() * self.ModelViewRightMult + Ang:Up() * self.ModelViewUpMult)
		Ang:RotateAroundAxis(Ang:Forward(),self.ModelViewAngForward)
		Ang:RotateAroundAxis(Ang:Right(),self.ModelViewAngRight)
		Ang:RotateAroundAxis(Ang:Up(),self.ModelViewAngUp)
		self.ViewEnt:SetAngles(Ang)
		self.ViewEnt:EnableMatrix("RenderMultiply",self.ViewMatrix)
		self.ViewEnt:DrawModel()
	end

	-- Required when the user switches cameras it will undo bone changes (Or when the user draws the weapon while looking through a camera and going back to firstperson)
	-- This is also used to hide the base initially
	function SWEP:HideBaseViewModel()
		if self.DoNotUseViewModel then return end

		if self.Owner == LocalPlayer() then
			hook.Add("Tick","m9k_mmm_hidebasemodel",function() -- We make a hook since we have to wait for the viewmodel to become valid!
				if not IsValid(self) or not IsValid(self.Owner) then -- This can rarely happen when an unavailable weapon is given
					hook.Remove("Tick","m9k_mmm_hidebasemodel")
					return
				end

				local vm = self.Owner:GetViewModel()
				if IsValid(vm) then
					hook.Remove("Tick","m9k_mmm_hidebasemodel")

					local IDS = { }
					for k = 1,vm:GetBoneCount(),1 do -- Some 'bones' from the used viewmodel 'base' should be hidden
						if self.ModelViewBlacklistedBones[vm:GetBoneName(k)] then
							table.insert(IDS,k)
						end
					end

					for _,v in ipairs(IDS) do
						vm:ManipulateBoneScale(v,vector_zero)
					end
				end
			end)
		end
	end

	function SWEP:Holster()
		local vm = IsValid(self.Owner) and self.Owner:GetViewModel() or IsValid(self.LastOwner) and self.LastOwner:GetViewModel()
		if not IsValid(vm) or not vm:GetBoneCount() then return end

		for k = 0,vm:GetBoneCount() do -- Make sure to reset the bones! (very important!!)
			vm:ManipulateBoneScale(k,VectorCache1)
			vm:ManipulateBoneAngles(k,angle_zero)
			vm:ManipulateBonePosition(k,vector_zero)
		end

		timer.Remove("M9k_MMM_Grenade_Pullpin" .. self.OurIndex)
		timer.Remove("M9k_MMM_Grenade_Grenadethrow" .. self.OurIndex)

		self:SetNWBool("ShouldDraw",true)
		self.CanPullPin = true
		self.PinPulled = false

		if IsValid(self.ViewEnt) then
			self.ViewEnt:SetNoDraw(true)
		end

		return true
	end

	function SWEP:OnRemove()
		if IsValid(self.WorldEnt) then
			self.WorldEnt:Remove()
		end

		if IsValid(self.ViewEnt) then
			self.ViewEnt:Remove()
		end

		local vm = IsValid(self.Owner) and self.Owner:GetViewModel() or IsValid(self.LastOwner) and self.LastOwner:GetViewModel()
		if not IsValid(vm) or not vm:GetBoneCount() then return end

		for k = 0,vm:GetBoneCount() do -- Make sure to reset the bones! (very important!!)
			vm:ManipulateBoneScale(k,VectorCache1)
			vm:ManipulateBoneAngles(k,angle_zero)
			vm:ManipulateBonePosition(k,vector_zero)
		end
	end
end

function SWEP:Deploy()
	if SERVER and (self:Clip1() <= 0 and self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0) then -- Make sure we can not equip a Grenade when we do not even have one!
		self.Owner:StripWeapon(self:GetClass())
	end

	self:SetHoldType(self.HoldType)
	self:SetNWBool("ShouldDraw",true)

	local vm = self.Owner:GetViewModel()
	if IsValid(vm) then -- This is required since the code should only run on the server or on the player holding the gun (Causes errors otherwise)
		self:SendWeaponAnim(ACT_VM_DRAW)

		if SERVER then -- We have to do it like this since there are cases in which Deploy is not called since SelectWeapon messes with prediction!
			self:CallOnClient("HideBaseViewModel")

			if self.DeploySound then -- Might be useful for modders (also used in Knife)
				self.Owner:EmitSound(self.DeploySound)
			end
		end

		local Dur = vm:SequenceDuration() + 0.2
		self:SetNextPrimaryFire(CurTime() + Dur)
		self:SetNextSecondaryFire(CurTime() + Dur)

		timer.Remove("MMM_M9k_Deploy_" .. self.OurIndex)
		timer.Create("MMM_M9k_Deploy_" .. self.OurIndex,Dur,1,function()
			if not IsValid(self) or not IsValid(self.Owner) or not IsValid(self.Owner:GetActiveWeapon()) or self.Owner:GetActiveWeapon():GetClass() ~= self:GetClass() then return end
			self.CanPullPin = true

			if not self.Owner:KeyDown(IN_ATTACK) and not self.Owner:KeyDown(IN_ATTACK2) and not self.Owner:KeyDown(IN_RELOAD) then -- We make sure that we are not attacking since the idle animation can overwrite the attack animation
				self:SendWeaponAnim(ACT_VM_IDLE) -- Some bases need this
			end
		end)
	end

	return true
end

function SWEP:Think()
	if CLIENT then -- Hide base viewmodel when cameras changed
		local View = self.Owner:GetViewEntity()

		if View ~= self.LastViewEntity then
			self:HideBaseViewModel()
		end

		self.LastViewEntity = View
	end

	if self.PinPulled and not self.Owner:KeyDown(IN_ATTACK) then
		self:SendWeaponAnim(self.PrimaryAttackSequence or ACT_VM_THROW)
		self:AttackAnimation()

		local vm = self.Owner:GetViewModel()
		if SERVER or IsValid(vm) then -- SERVER or the CLIENT throwing the grenade
			if not IsFirstTimePredicted() then return end -- Fixes weird prediction bugs
			timer.Remove("M9k_MMM_Grenade_Grenadethrow" .. self.OurIndex) -- Prevent the animation from being overwritten by the idle thing
			local Dur = vm:SequenceDuration() - (self.PrimaryAttackSequenceDelay or (game.SinglePlayer() and 0.4 or 0.5))

			self:SetNWBool("ShouldDraw",false)

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

					self:SetNWBool("ShouldDraw",true)
				end)
			end)
		end

		self.PinPulled = false
	end
end