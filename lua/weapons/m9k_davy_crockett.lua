SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9kR: Specialties"
SWEP.PrintName = "Davy Crockett"

SWEP.Slot = 4
SWEP.HoldType = "rpg"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_rl7.mdl"
SWEP.WorldModel = "models/weapons/w_rl7.mdl"

SWEP.Primary.Sound = "GDC/Rockets/RPGF.wav"

SWEP.Primary.RPM = 20
SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.KickUp = 3
SWEP.Primary.KickDown = 5
SWEP.Primary.KickHorizontal = 10
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "M9k_Nuclear_Warhead"

SWEP.CanFireUnderwater = true

SWEP.IronSightsPos = Vector(-3.7384,-5.7481,-0.2713)
SWEP.IronSightsAng = Vector(1.1426,0.0675,0)
SWEP.bBlockIronSights = true

SWEP.bBlockIdleSight = true
SWEP.bBlockShellEject = true
SWEP.bBlockMuzzleFlash = true
SWEP.bFiresEntity = true

SWEP._UsesCustomModels = true


if SERVER then

	local vCached1 = Vector(0,0,1)
	local aCached1 = Angle(90,0,0)


	function SWEP:PrimaryAttackHooked()

		self.Owner:LagCompensation(true)

		local aAim = self.Owner:GetAimVector()
		local vSide = aAim:Cross(vCached1)


		local eProjectile = ents.Create("m9k_launched_davycrockett")

		if IsValid(eProjectile) then

			eProjectile:SetAngles(aAim:Angle() + aCached1)
			eProjectile:SetPos(self.Owner:GetShootPos() + vSide * 6 + vSide:Cross(aAim) * -5)

			eProjectile:SetOwner(self.Owner)

			if MMM_M9k_CPPIExists then
				eProjectile:CPPISetOwner(self.Owner)
			end


			eProjectile.bWasFiredWithWeapon = true -- Required


			eProjectile:Spawn()
			eProjectile:Activate()
		end

		self.Owner:LagCompensation(false)


		--[[ -- Maybe no automatic reload here..
		if self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 then
			self:Reload()
		end
		]]

	end
end


if CLIENT then

	-- The Davy Crockett has a huge rocket attached to it. So we gotta draw it in the viewmodel and worldmodel!


	local vector_Scale = Vector(0.449, 0.449, 0.449)


	function SWEP:CreateViewModel() -- We need to create these like that since a player could join and these would be invalid!
		if IsValid(self.ViewEnt) then self.ViewEnt:Remove() end


		self.ViewEnt = ClientsideModel("models/failure/mk6/m62.mdl",RENDERGROUP_VIEWMODEL_TRANSLUCENT)
		if not IsValid(self.ViewEnt) then return end

		self.ViewEnt:SetPos(self:GetPos())
		self.ViewEnt:SetAngles(self:GetAngles())
		self.ViewEnt:SetParent(self)
		self.ViewEnt:SetNoDraw(true)

		self.ViewMatrix = Matrix()
		self.ViewMatrix:Scale(vector_Scale)
	end


	function SWEP:ViewModelDrawn(vm)

		if not IsValid(self.ViewEnt) then
			self:CreateViewModel()

			return -- We gotta wait a tick!
		end


		self.CachedViewBone = self.CachedViewBone or vm:LookupBone("Rocket") -- This is faster than looking it up every frame!
		-- This bone is always valid.

		local mMatrix = vm:GetBoneMatrix(self.CachedViewBone)
		if not mMatrix then return end -- Required to fix a one-time error


		local vPos, aAng = mMatrix:GetTranslation(), mMatrix:GetAngles()


		self.ViewEnt:SetPos(vPos + aAng:Right() * 7)

		aAng:RotateAroundAxis(aAng:Forward(),90)

		self.ViewEnt:SetAngles(aAng)
		self.ViewEnt:EnableMatrix("RenderMultiply",self.ViewMatrix)
		self.ViewEnt:DrawModel()
	end


	function SWEP:CreateWorldModel() -- We need to create these like that since a player could join and these would be invalid!
		if IsValid(self.WorldEnt) then self.WorldEnt:Remove() end


		self.WorldEnt = ClientsideModel("models/failure/mk6/m62.mdl",RENDERGROUP_VIEWMODEL_TRANSLUCENT)
		if not IsValid(self.WorldEnt) then return end

		self.WorldEnt:SetPos(self:GetPos())
		self.WorldEnt:SetAngles(self:GetAngles())
		self.WorldEnt:SetParent(self)
		self.WorldEnt:SetNoDraw(true)

		self.ViewMatrix = Matrix()
		self.ViewMatrix:Scale(vector_Scale)
	end


	function SWEP:DrawWorldModel()

		if not IsValid(self.WorldEnt) then
			self:CreateWorldModel()

			return -- We gotta wait a tick!
		end


		if not IsValid(self.Owner) then -- Draw the scope on the dropped Weapon

			local vPos, aAng = self:GetPos(), self:GetAngles()

			self.WorldEnt:SetPos(vPos + aAng:Forward() * -10.5 + aAng:Right() * 0.4 + aAng:Up() * -0.5)

			aAng:RotateAroundAxis(aAng:Right(),101)

			self.WorldEnt:SetAngles(aAng)
			self.WorldEnt:EnableMatrix("RenderMultiply",self.ViewMatrix)
			self.WorldEnt:DrawModel()

			self:DrawModel()

			return
		end


		-- The Weapon is not dropped!

		self.CachedWorldBone = self.CachedWorldBone or self.Owner:LookupBone("ValveBiped.Bip01_R_Hand") -- This is faster than looking it up every frame!
		if not self.CachedWorldBone then return end -- Thanks to wrefgtzweve on GitHub for finding this.


		local vPos, aAng = self.Owner:GetBonePosition(self.CachedWorldBone)

		self.WorldEnt:SetPos(vPos + aAng:Right() + aAng:Forward() * 26 + aAng:Up() * -5)

		aAng:RotateAroundAxis(aAng:Right(),-90)

		self.WorldEnt:SetAngles(aAng)
		self.WorldEnt:EnableMatrix("RenderMultiply",self.ViewMatrix)
		self.WorldEnt:DrawModel()

		self:DrawModel()
	end


	function SWEP:ResetInternalVarsHooked() -- Remove the entities if the Weapon is reset!
		if IsValid(self.ViewEnt) then
			self.ViewEnt:Remove()
		end

		if IsValid(self.WorldEnt) then
			self.WorldEnt:Remove()
		end
	end
end