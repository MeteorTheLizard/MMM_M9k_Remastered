SWEP.Base = "bobs_shotty_base"
SWEP.Category = "M9kR: Specialties"
SWEP.PrintName = "Milkor Mk1"

SWEP.HoldType = "smg"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_milkor_mgl1.mdl"
SWEP.WorldModel = "models/weapons/w_milkor_mgl1.mdl"

SWEP.ReloadSound = "weapons/striker12/m3_insertshell.mp3"

SWEP.Primary.Sound = "weapons/M79/40mmthump.wav"

SWEP.Primary.RPM = 125
SWEP.Primary.ClipSize = 6
SWEP.Primary.KickUp = 4
SWEP.Primary.KickDown = 3
SWEP.Primary.KickHorizontal = 2
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "40mmGrenade"

SWEP.IronSightsPos = Vector(2.635,-0.03,2.04)
SWEP.IronSightsAng = Vector(-2,2.7,0)

SWEP.LegacyBalance = {
	Primary = {
		RPM = 250,
		ClipSize = 6,
		KickUp = 0,
		KickDown = 0,
		KickHorizontal = 0,
		Automatic = false,
		NumShots = 0,
		Damage = 0,
		Spread = 0
	}
}

SWEP.bBlockShellEject = true
SWEP.bBlockMuzzleFlash = true
SWEP.bFiresEntity = true

SWEP._UsesCustomModels = true


if SERVER then

	local aCached1 = Angle(90,0,0)
	local vCached1 = Vector(0,0,1)


	function SWEP:PrimaryAttackHooked2()

		self.Owner:LagCompensation(true)

		local aAim = self.Owner:GetAimVector()
		local vSide = aAim:Cross(vCached1)


		local eProjectile = ents.Create("m9k_launched_m79") -- We use the m79 entity here since its identical with the original MilkorGL one

		if IsValid(eProjectile) then

			SafeRemoveEntityDelayed(eProjectile,30)


			eProjectile:SetAngles(aAim:Angle() + aCached1)
			eProjectile:SetPos(self.Owner:GetShootPos() + vSide * 6 + vSide:Cross(aAim) * -5)

			eProjectile:SetOwner(self.Owner)

			if MMM_M9k_CPPIExists then
				eProjectile:CPPISetOwner(self.Owner)
			end

			eProjectile.M9kr_CreatedByWeapon = true -- Required
			eProjectile:SetNWBool("M9kR_Created",true) -- Mark it for Clients.

			eProjectile:Spawn()
			eProjectile:Activate()
		end

		self.Owner:LagCompensation(false)

	end
end


if CLIENT then

	function SWEP:FireAnimationEvent(_,_,iEvent) -- No shell ejection
		if iEvent == 20 then return true end
	end


	-- The MilkorGL has a scope slapped onto it. So we gotta draw it in the viewmodel and worldmodel!


	local vector_one = Vector(1,1,1)


	function SWEP:CreateViewModel() -- We need to create these like that since a player could join and these would be invalid!
		if IsValid(self.ViewEnt) then self.ViewEnt:Remove() end


		self.ViewEnt = ClientsideModel("models/wystan/attachments/eotech557sight.mdl",RENDERGROUP_VIEWMODEL_TRANSLUCENT)
		if not IsValid(self.ViewEnt) then return end

		self.ViewEnt:SetPos(self:GetPos())
		self.ViewEnt:SetAngles(self:GetAngles())
		self.ViewEnt:SetParent(self)
		self.ViewEnt:SetNoDraw(true)

		self.ViewMatrix = Matrix()
		self.ViewMatrix:Scale(vector_one)
	end


	function SWEP:ViewModelDrawn(vm)

		if not IsValid(self.ViewEnt) then
			self:CreateViewModel()

			return -- We gotta wait a tick!
		end


		self.CachedViewBone = self.CachedViewBone or vm:LookupBone("body") -- This is faster than looking it up every frame!
		-- This bone is always valid.

		local mMatrix = vm:GetBoneMatrix(self.CachedViewBone)
		if not mMatrix then return end -- Required to fix a one-time error


		local vPos, aAng = mMatrix:GetTranslation(), mMatrix:GetAngles()

			aAng:SetUnpacked(aAng.p + 180,aAng.y,aAng.r) -- This is needed to fix the really weird bone angles


		self.ViewEnt:SetPos(vPos + aAng:Forward() * -12 + aAng:Right() * -9.35 + aAng:Up() * 0.75)

		aAng:RotateAroundAxis(aAng:Forward(),90)
		aAng:RotateAroundAxis(aAng:Right(),5)

		self.ViewEnt:SetAngles(aAng)
		self.ViewEnt:EnableMatrix("RenderMultiply",self.ViewMatrix)
		self.ViewEnt:DrawModel()
	end


	function SWEP:CreateWorldModel() -- We need to create these like that since a player could join and these would be invalid!
		if IsValid(self.WorldEnt) then self.WorldEnt:Remove() end


		self.WorldEnt = ClientsideModel("models/wystan/attachments/eotech557sight.mdl",RENDERGROUP_VIEWMODEL_TRANSLUCENT)
		if not IsValid(self.WorldEnt) then return end

		self.WorldEnt:SetPos(self:GetPos())
		self.WorldEnt:SetAngles(self:GetAngles())
		self.WorldEnt:SetParent(self)
		self.WorldEnt:SetNoDraw(true)

		self.ViewMatrix = Matrix()
		self.ViewMatrix:Scale(vector_one)
	end


	function SWEP:DrawWorldModel()

		if not IsValid(self.WorldEnt) then
			self:CreateWorldModel()

			return -- We gotta wait a tick!
		end


		if not IsValid(self.Owner) then -- Draw the scope on the dropped Weapon

			local vPos, aAng = self:GetPos(), self:GetAngles()

			self.WorldEnt:SetPos(vPos + aAng:Forward() * 18.35 + aAng:Right() * 0.5 + aAng:Up() * -5.5)

			aAng:RotateAroundAxis(aAng:Up(),180)
			aAng:RotateAroundAxis(aAng:Right(),-2)


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

		self.WorldEnt:SetPos(vPos + aAng:Forward() * -1 + aAng:Right() * 0.75 + aAng:Up() * 5.9)

		aAng:RotateAroundAxis(aAng:Forward(),180)
		aAng:RotateAroundAxis(aAng:Right(),10)

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