SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9kR: Assault Rifles"
SWEP.PrintName = "KAC PDW"

SWEP.Slot = 3
SWEP.HoldType = "smg"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_kac_pdw1.mdl"
SWEP.WorldModel = "models/weapons/w_kac_pdw.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/kac_pdw/m4a1_clipout.mp3",
		iDelay = 0.40
	},
	{
		sSound = "weapons/kac_pdw/m4a1_clipin.mp3",
		iDelay = 0.40 + 0.90
	},
	{
		sSound = "weapons/kac_pdw/m4a1_boltpull.mp3",
		iDelay = 0.40 + 0.90 + 0.70
	}
}

SWEP.tDrawSoundSequence = {
	{
		sSound = "weapons/kac_pdw/m4a1_boltpull.mp3",
		iDelay = 0.30
	}
}

SWEP.Primary.Sound = "weapons/kac_pdw/m4a1_unsil-1.wav"

SWEP.Primary.RPM = 500
SWEP.Primary.ClipSize = 30
SWEP.Primary.KickUp = 2.1
SWEP.Primary.KickDown = 1.9
SWEP.Primary.KickHorizontal = 1.6
SWEP.Primary.Automatic = true
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 18
SWEP.Primary.Spread = .0275
SWEP.Primary.Ammo = "ar2"

SWEP.IronSightsPos = Vector(3.355,0,0.9)
SWEP.IronSightsAng = Vector(1,0,0)

SWEP.LegacyBalance = {
	Primary = {
		RPM = 600,
		ClipSize = 30,
		KickUp = 0.1,
		KickDown = 0.1,
		KickHorizontal = 0.2,
		Automatic = true,
		NumShots = 1,
		Damage = 15,
		Spread = .025
	}
}

SWEP._UsesCustomModels = true


--[[ We might need these in the future!
sound.Add({
	name = "KAC_PDW.SilentSingle",
	channel = CHAN_USER_BASE + 10,
	volume = 1.0,
	sound = "weapons/kac_pdw/m4a1-1.wav"
})

sound.Add({
	name = "kac_pdw_001.Silencer_On",
	channel = CHAN_ITEM,
	volume = 1.0,
	sound = "weapons/kac_pdw/m4a1_silencer_on.mp3"
})

sound.Add({
	name = "kac_pdw_001.Silencer_Off",
	channel = CHAN_ITEM,
	volume = 1.0,
	sound = "weapons/kac_pdw/m4a1_silencer_off.mp3"
})
]]

if CLIENT then

	-- The KAC_PDW has a scope slapped onto it. So we gotta draw it in the viewmodel and worldmodel!


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


		self.CachedViewBone = self.CachedViewBone or vm:LookupBone("DrawCall_0") -- This is faster than looking it up every frame!
		-- This bone is always valid.

		local mMatrix = vm:GetBoneMatrix(self.CachedViewBone)
		if not mMatrix then return end -- Required to fix a one-time error


		local vPos, aAng = mMatrix:GetTranslation(), mMatrix:GetAngles()

			aAng:SetUnpacked(aAng.p + 180,aAng.y,aAng.r) -- This is needed to fix the really weird bone angles


		self.ViewEnt:SetPos(vPos + aAng:Forward() * 0.275 + aAng:Right() * 9.55 + aAng:Up() * 7.25)

		aAng:RotateAroundAxis(aAng:Forward(),-185)
		aAng:RotateAroundAxis(aAng:Up(),-90)

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

			self.WorldEnt:SetPos(vPos + aAng:Forward() * -5.2 + aAng:Right() * -1.325 + aAng:Up() * -5.125)

			aAng:RotateAroundAxis(aAng:Right(),5)

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

		self.WorldEnt:SetPos(vPos + aAng:Forward() * -6.175 + aAng:Right() * 1.35 + aAng:Up() * 4.30)

		aAng:RotateAroundAxis(aAng:Forward(),180)

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