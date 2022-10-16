SWEP.Base = "meteors_grenade_base_model"
SWEP.Category = "M9kR: Specialties"
SWEP.PrintName = "IED Detonator"

SWEP.Slot = 4
SWEP.HoldType = "slam"
SWEP.Spawnable = true
SWEP.UseHands = true

SWEP.ViewModelFOV = 60
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/c_slam.mdl"
SWEP.WorldModel = "models/props_junk/cardboard_box004a.mdl"

SWEP.Primary.Ammo = "IED_Detonators"

SWEP.ModelViewBlacklistedBones = {
	["Detonator"] = true,
	["Slam_base"] = true,
	["Slam_panel"] = true
}

SWEP.GrenadeClassEnt = "m9k_improvised_explosive"
SWEP.GrenadeModelStr = "models/props_junk/cardboard_box004a.mdl"
SWEP.GrenadeThrowAng = Angle(0,0,-45)
SWEP.GrenadeTrailCol = Color(0,0,0,0)
SWEP.GrenadeNoPin = true

SWEP.iThrowAnim = ACT_SLAM_THROW_THROW
SWEP.iThrowDelay = 0.45

SWEP.PinPullSound = "" -- No sound


local sTag = "MMM_M9kr_IDE"


if SERVER then

	SWEP.bDontStripWeapon = true


	function SWEP:ResetInternalVarsHooked()
		timer.Remove(sTag .. self:EntIndex())
	end


	function SWEP:DeployHooked()

		self:SendWeaponAnim(ACT_SLAM_DETONATOR_THROW_DRAW)


		local iCur = CurTime()

		self:SetNextPrimaryFire(iCur) -- We may throw immediately!
		self:SetNextSecondaryFire(iCur) -- Needed.

	end


	function SWEP:PrimaryAttackHooked()

		timer.Create(sTag .. self:EntIndex(),0.6,1,function()
			if not IsValid(self) then return end -- Get the next box ready.

			self:SendWeaponAnim(ACT_SLAM_THROW_DRAW)

		end)
	end


	function SWEP:ProjectileModifications(eProjectile)

		timer.Simple(0.25,function() -- Needs to be delayed.
			if not IsValid(eProjectile) then return end

			eProjectile:SetOwner(nil) -- Required
		end)


		eProjectile.IEDOwner = self.Owner

	end


	function SWEP:SecondaryAttack()
		if self:GetNextPrimaryFire() > CurTime() then return end

		self:SetNextPrimaryFire(CurTime() + 0.25)


		self.Owner:EmitSound("buttons/button14.wav")


		self:SendWeaponAnim(ACT_SLAM_THROW_DETONATE)

		timer.Create(sTag .. self:EntIndex(),0.1,1,function()
			if not IsValid(self) then return end -- Don't put down the Detonator.

			self:SendWeaponAnim(ACT_SLAM_THROW_IDLE)
		end)


		timer.Simple(0,function() -- Boom!
			if not IsValid(self) or not IsValid(self.Owner) then return end

			for _,v in ipairs(ents.FindByClass(self.GrenadeClassEnt)) do
				if IsValid(v.IEDOwner) and v.IEDOwner == self.Owner then
					v:Explosion()
				end
			end
		end)
	end
end


if CLIENT then

	SWEP.sBombModel = "models/props_junk/cardboard_box004a.mdl"
	SWEP.sDetonatorModel = "models/weapons/w_camphon2.mdl"


	local vViewScale = Vector(0.5,0.5,0.5)
	local vViewScaleDetonator = Vector(1,1,1)


	function SWEP:PinPullEvent() -- Do nothing

	end


	function SWEP:ThrowEvent()

		self.bShouldDrawModel = false

		timer.Create(sTag .. self:EntIndex(),0.4,1,function()
			if not IsValid(self) or not IsValid(self.Owner) then return end

			self.bShouldDrawModel = true
		end)
	end


	function SWEP:SecondaryAttack()
		if self:GetNextPrimaryFire() > CurTime() then return end

		self:SetNextPrimaryFire(CurTime() + 0.25)
	end


	function SWEP:ResetInternalVarsHooked2()

		timer.Remove(sTag .. self:EntIndex())

		if IsValid(self.ViewMatrixDetonator) then
			self.ViewMatrixDetonator:Remove()
		end

		if IsValid(self.WorldEntDetonator) then
			self.WorldEntDetonator:Remove()
		end
	end


	function SWEP:ViewModelDrawn(vm)

		if not IsValid(self.ViewEnt) then -- This is used fairly often

			self:CreateViewModel()
			self:HideBaseViewModel()

			return -- Prevent error in the same tick
		end


		-- Detonator

		self.CachedViewBoneDetonator = self.CachedViewBoneDetonator or vm:LookupBone("ValveBiped.Bip01_L_Hand") -- This is faster than looking it up every frame!
		if not self.CachedViewBoneDetonator then return end -- Thanks to wrefgtzweve on GitHub for finding this.

		local mMatrix = vm:GetBoneMatrix(self.CachedViewBoneDetonator)
		if not mMatrix then return end


		local vPos, aAng = mMatrix:GetTranslation(), mMatrix:GetAngles()

		self.ViewEntDetonator:SetPos(vPos + aAng:Forward() * 2.5 + aAng:Right() * 3 + aAng:Up() * 5)

		aAng:RotateAroundAxis(aAng:Forward(),-55)
		aAng:RotateAroundAxis(aAng:Right(),-35)
		aAng:RotateAroundAxis(aAng:Up(),55)

		self.ViewEntDetonator:SetAngles(aAng)
		self.ViewEntDetonator:EnableMatrix("RenderMultiply",self.ViewMatrixDetonator)
		self.ViewEntDetonator:DrawModel()


		if not self.bShouldDrawModel then return true end


		-- IDE

		self.CachedViewBone = self.CachedViewBone or vm:LookupBone("ValveBiped.Bip01_R_Hand") -- This is faster than looking it up every frame!
		if not self.CachedViewBone then return end -- Thanks to wrefgtzweve on GitHub for finding this.

		local mMatrix = vm:GetBoneMatrix(self.CachedViewBone)
		if not mMatrix then return end


		local vPos, aAng = mMatrix:GetTranslation(), mMatrix:GetAngles()

		self.ViewEnt:SetPos(vPos + aAng:Forward() * 6 + aAng:Right() * 3.25 + aAng:Up() * -0.2)

		aAng:RotateAroundAxis(aAng:Forward(),-35)
		aAng:RotateAroundAxis(aAng:Right(),-45)
		aAng:RotateAroundAxis(aAng:Up(),-45)

		self.ViewEnt:SetAngles(aAng)
		self.ViewEnt:EnableMatrix("RenderMultiply",self.ViewMatrix)
		self.ViewEnt:DrawModel()
	end


	function SWEP:CreateViewModel()

		if IsValid(self.ViewEnt) then self.ViewEnt:Remove() end
		if IsValid(self.ViewEntDetonator) then self.ViewEntDetonator:Remove() end


		-- IDE

		self.ViewEnt = ClientsideModel(self.sBombModel,RENDERGROUP_OPAQUE)
		self.ViewEnt:SetPos(self:GetPos())
		self.ViewEnt:SetAngles(self:GetAngles())
		self.ViewEnt:SetParent(self)
		self.ViewEnt:SetNoDraw(true)

		self.ViewMatrix = Matrix()
		self.ViewMatrix:Scale(vViewScale)


		-- Detonator

		self.ViewEntDetonator = ClientsideModel(self.sDetonatorModel,RENDERGROUP_OPAQUE)
		self.ViewEntDetonator:SetPos(self:GetPos())
		self.ViewEntDetonator:SetAngles(self:GetAngles())
		self.ViewEntDetonator:SetParent(self)
		self.ViewEntDetonator:SetNoDraw(true)

		self.ViewMatrixDetonator = Matrix()
		self.ViewMatrixDetonator:Scale(vViewScaleDetonator)
	end


	function SWEP:DrawWorldModel()

		if not IsValid(self.Owner) then -- Can be used to use the default worldmodel // Weapon is dropped
			self:DrawModel()

			return true
		end


		if not IsValid(self.WorldEnt) or not IsValid(self.WorldEntDetonator) then
			self:CreateWorldModel()

			return -- Prevent error in the same tick
		end


		-- Detonator

		self.CachedWorldBoneDetonator = self.CachedWorldBoneDetonator or self.Owner:LookupBone("ValveBiped.Bip01_L_Hand") -- This is faster than looking it up every frame!
		if not self.CachedWorldBoneDetonator then return end -- Thanks to wrefgtzweve on GitHub for finding this.


		local vPos, aAng = self.Owner:GetBonePosition(self.CachedWorldBoneDetonator)

		self.WorldEntDetonator:SetPos(vPos + aAng:Forward() * 4.5 + aAng:Right() * 4.25 + aAng:Up() * 1.25)

		aAng:RotateAroundAxis(aAng:Forward(),10)
		aAng:RotateAroundAxis(aAng:Up(),75)

		self.WorldEntDetonator:SetAngles(aAng)
		self.WorldEntDetonator:EnableMatrix("RenderMultiply",self.WorldMatrixDetonator)
		self.WorldEntDetonator:DrawModel()


		-- IDE

		self.CachedWorldBone = self.CachedWorldBone or self.Owner:LookupBone("ValveBiped.Bip01_R_Hand") -- This is faster than looking it up every frame!
		if not self.CachedWorldBone then return end -- Thanks to wrefgtzweve on GitHub for finding this.


		local vPos, aAng = self.Owner:GetBonePosition(self.CachedWorldBone)

		self.WorldEnt:SetPos(vPos + aAng:Forward() * 2.5 + aAng:Right() * 5 + aAng:Up() * -1.25)

		aAng:RotateAroundAxis(aAng:Forward(),25)
		aAng:RotateAroundAxis(aAng:Up(),90)

		self.WorldEnt:SetAngles(aAng)
		self.WorldEnt:EnableMatrix("RenderMultiply",self.WorldMatrix)
		self.WorldEnt:DrawModel()
	end


	function SWEP:CreateWorldModel()

		if IsValid(self.WorldEnt) then self.WorldEnt:Remove() end
		if IsValid(self.WorldEntDetonator) then self.WorldEntDetonator:Remove() end


		-- Detonator

		self.WorldEntDetonator = ClientsideModel(self.sDetonatorModel,RENDERGROUP_OPAQUE)
		self.WorldEntDetonator:SetPos(self:GetPos())
		self.WorldEntDetonator:SetAngles(self:GetAngles())
		self.WorldEntDetonator:SetParent(self)
		self.WorldEntDetonator:SetNoDraw(true)

		self.WorldMatrixDetonator = Matrix()
		self.WorldMatrixDetonator:Scale(vViewScaleDetonator)


		-- IDE

		self.WorldEnt = ClientsideModel(self.sBombModel,RENDERGROUP_OPAQUE)
		self.WorldEnt:SetPos(self:GetPos())
		self.WorldEnt:SetAngles(self:GetAngles())
		self.WorldEnt:SetParent(self)
		self.WorldEnt:SetNoDraw(true)

		self.WorldMatrix = Matrix()
		self.WorldMatrix:Scale(vViewScale)
	end
end