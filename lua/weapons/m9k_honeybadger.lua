SWEP.Base = "bobs_scoped_base"
SWEP.Category = "M9kR: Assault Rifles"
SWEP.PrintName = "AAC Honey Badger"

SWEP.DynamicLightScale = 1 -- Set to Default

SWEP.Slot = 3
SWEP.HoldType = "ar2"
SWEP.Spawnable = true

SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_aacbadger.mdl"
SWEP.WorldModel = "models/weapons/w_aac_honeybadger.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/hb/magout.mp3",
		iDelay = 0.40
	},
	{
		sSound = "weapons/hb/magin.mp3",
		iDelay = 0.40 + 0.95
	},
	{
		sSound = "weapons/hb/boltcatch.mp3",
		iDelay = 0.40 + 0.95 + 0.60
	}
}

SWEP.tDrawSoundSequence = {
	{
		sSound = "weapons/hb/boltback.mp3",
		iDelay = 0.25
	},
	{
		sSound = "weapons/hb/boltforward.mp3",
		iDelay = 0.25 + 0.20
	}
}

SWEP.Primary.Sound = "weapons/hb/hb_fire.wav"
SWEP.Primary.SoundVolume = 65 -- Silenced!

SWEP.Primary.RPM = 335
SWEP.Primary.ClipSize = 30
SWEP.Primary.KickUp = 1.5
SWEP.Primary.KickDown = .7
SWEP.Primary.KickHorizontal = 0.9
SWEP.Primary.Automatic = true
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 31
SWEP.Primary.Spread = .022
SWEP.Primary.Ammo = "ar2"

SWEP.Primary.SpreadBefore = SWEP.Primary.Spread

SWEP.ScopeType = "gdcw_aimpoint"
SWEP.ScopeStages = 1
SWEP.ScopeScale = 0.5
SWEP.ReticleScale = 0.5

SWEP.LegacyBalance = {
	Primary = {
		RPM = 791,
		ClipSize = 30,
		KickUp = .5,
		KickDown = .3,
		KickHorizontal = .5,
		Automatic = true,
		NumShots = 1,
		Damage = 24,
		Spread = .023
	}
}

SWEP._UsesCustomModels = true


if CLIENT then

	-- The Honeybadger has a scope slapped onto it. So we gotta draw it in the viewmodel and worldmodel!


	local vector_one = Vector(1,1,1)
	local vector_aut = Vector(0.024,0.024,0.024)


	function SWEP:CreateViewModel() -- We need to create these like that since a player could join and these would be invalid!
		if IsValid(self.ViewEnt) then self.ViewEnt:Remove() end


		self.ViewEnt = ClientsideModel("models/wystan/attachments/aimpoint.mdl",RENDERGROUP_VIEWMODEL_TRANSLUCENT)
		if not IsValid(self.ViewEnt) then return end

		self.ViewEnt:SetPos(self:GetPos())
		self.ViewEnt:SetAngles(self:GetAngles())
		self.ViewEnt:SetParent(self)
		self.ViewEnt:SetNoDraw(true)

		self.ViewMatrix = Matrix()
		self.ViewMatrix:Scale(vector_one)


		self.ViewEntLens = ClientsideModel("models/XQM/panel360.mdl",RENDERGROUP_VIEWMODEL_TRANSLUCENT) -- Lens
		if not IsValid(self.ViewEntLens) then return end

		self.ViewEntLens:SetPos(self:GetPos())
		self.ViewEntLens:SetAngles(self:GetAngles())
		self.ViewEntLens:SetParent(self)
		self.ViewEntLens:SetNoDraw(true)

		self.ViewEntLens:SetMaterial("models/wystan/attachments/aimpoint/lense")

		self.ViewMatrixLens = Matrix()
		self.ViewMatrixLens:Scale(vector_aut)
	end


	function SWEP:ViewModelDrawn(vm)

		if not IsValid(self.ViewEnt) then
			self:CreateViewModel()

			return -- We gotta wait a tick!
		end


		self.CachedViewBone = self.CachedViewBone or vm:LookupBone("Gun") -- This is faster than looking it up every frame!
		-- This bone is always valid.

		local mMatrix = vm:GetBoneMatrix(self.CachedViewBone)
		if not mMatrix then return end -- Required to fix a one-time error


		local vPos, aAng = mMatrix:GetTranslation(), mMatrix:GetAngles()


		self.ViewEnt:SetPos(vPos + aAng:Forward() * 0.25 + aAng:Right() * 5 + aAng:Up() * -4.5)

		aAng:RotateAroundAxis(aAng:Up(),180)

		self.ViewEnt:SetAngles(aAng)
		self.ViewEnt:EnableMatrix("RenderMultiply",self.ViewMatrix)
		self.ViewEnt:DrawModel()


		self.ViewEntLens:SetPos(vPos + aAng:Up() * 2.25)

		aAng:RotateAroundAxis(aAng:Forward(),90)
		aAng:RotateAroundAxis(aAng:Right(),90)

		self.ViewEntLens:SetAngles(aAng)
		self.ViewEntLens:EnableMatrix("RenderMultiply",self.ViewMatrixLens)


		render.SetBlend(0.25) -- Make it so that you can see through it!
		render.SuppressEngineLighting(true)

		self.ViewEntLens:DrawModel()

		render.SuppressEngineLighting(false)
		render.SetBlend(1)
	end


	function SWEP:CreateWorldModel() -- We need to create these like that since a player could join and these would be invalid!
		if IsValid(self.WorldEnt) then self.WorldEnt:Remove() end


		self.WorldEnt = ClientsideModel("models/wystan/attachments/aimpoint.mdl",RENDERGROUP_VIEWMODEL_TRANSLUCENT)
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

			self.WorldEnt:SetPos(vPos + aAng:Forward() * 1.4 + aAng:Right() * -0.6 + aAng:Up() * 0.65)

			aAng:RotateAroundAxis(aAng:Up(),90)

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

		self.WorldEnt:SetPos(vPos + aAng:Forward() * 1.35 + aAng:Right() * 0.55 + aAng:Up() * -0.75)

		aAng:RotateAroundAxis(aAng:Forward(),180)
		aAng:RotateAroundAxis(aAng:Up(),90)

		self.WorldEnt:SetAngles(aAng)
		self.WorldEnt:EnableMatrix("RenderMultiply",self.ViewMatrix)
		self.WorldEnt:DrawModel()

		self:DrawModel()
	end


	function SWEP:ResetInternalVarsHooked2() -- Remove the entities if the Weapon is reset!
		if IsValid(self.ViewEnt) then
			self.ViewEnt:Remove()
		end

		if IsValid(self.ViewEntLens) then
			self.ViewEntLens:Remove()
		end

		if IsValid(self.WorldEnt) then
			self.WorldEnt:Remove()
		end
	end
end