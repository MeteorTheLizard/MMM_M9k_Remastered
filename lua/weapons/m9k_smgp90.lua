SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9kR: Submachine Guns"
SWEP.PrintName = "FN P90"

SWEP.Slot = 2
SWEP.HoldType = "pistol"
SWEP.Spawnable = true

SWEP.ViewModelFOV = 65
SWEP.ViewModel = "models/weapons/v_p90_smg.mdl"
SWEP.WorldModel = "models/weapons/w_fn_p90.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/p90_smg/p90_unlock.mp3",
		iDelay = 0.25
	},
	{
		sSound = "weapons/p90_smg/p90_magout.mp3",
		iDelay = 0.25 + 0.45
	},
	{
		sSound = "weapons/p90_smg/p90_magin.mp3",
		iDelay = 0.25 + 0.45 + 0.75
	},
	{
		sSound = "weapons/p90_smg/p90_cock.mp3",
		iDelay = 0.25 + 0.45 + 0.75 + 0.85
	}
}

SWEP.Primary.Sound = "weapons/p90_smg/p90-1.wav"

SWEP.Primary.RPM = 800
SWEP.Primary.ClipSize = 50
SWEP.Primary.KickUp = 0.8
SWEP.Primary.KickDown = 0.6
SWEP.Primary.KickHorizontal = 0.7
SWEP.Primary.Automatic = true
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 13
SWEP.Primary.Spread = .032
SWEP.Primary.Ammo = "smg1"

SWEP.IronSightsPos = Vector(2.685,-2.46,1.7)

SWEP.LegacyBalance = {
	Primary = {
		RPM = 900,
		ClipSize = 50,
		KickUp = 0.6,
		KickDown = 0.4,
		KickHorizontal = 0.5,
		Automatic = true,
		NumShots = 1,
		Damage = 18,
		Spread = .032
	}
}

SWEP._UsesCustomModels = true


if CLIENT then

	-- The FN P90 has a scope slapped onto it. So we gotta draw it in the viewmodel and worldmodel!


	local vector_one = Vector(1,1,1)


	function SWEP:CreateViewModel() -- We need to create these like that since a player could join and these would be invalid!
		if IsValid(self.ViewEnt) then self.ViewEnt:Remove() end


		self.ViewEnt = ClientsideModel("models/wystan/attachments/doctorrds.mdl",RENDERGROUP_VIEWMODEL_TRANSLUCENT)
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


		self.CachedViewBone = self.CachedViewBone or vm:LookupBone("p90_body") -- This is faster than looking it up every frame!
		-- This bone is always valid.

		local mMatrix = vm:GetBoneMatrix(self.CachedViewBone)
		if not mMatrix then return end -- Required to fix a one-time error


		local vPos, aAng = mMatrix:GetTranslation(), mMatrix:GetAngles()

			aAng:SetUnpacked(aAng.p + 180,aAng.y,aAng.r) -- This is needed to fix the really weird bone angles


		self.ViewEnt:SetPos(vPos + aAng:Forward() * -5 + aAng:Right() * 3.125 + aAng:Up() * -0.075)

		aAng:RotateAroundAxis(aAng:Forward(),90)
		aAng:RotateAroundAxis(aAng:Up(),90)

		self.ViewEnt:SetAngles(aAng)
		self.ViewEnt:EnableMatrix("RenderMultiply",self.ViewMatrix)
		self.ViewEnt:DrawModel()
	end


	function SWEP:CreateWorldModel() -- We need to create these like that since a player could join and these would be invalid!
		if IsValid(self.WorldEnt) then self.WorldEnt:Remove() end


		self.WorldEnt = ClientsideModel("models/wystan/attachments/doctorrds.mdl",RENDERGROUP_VIEWMODEL_TRANSLUCENT)
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

			self.WorldEnt:SetPos(vPos + aAng:Forward() * 5.6 + aAng:Right() * -1 + aAng:Up() * 6.3)

			aAng:RotateAroundAxis(aAng:Right(),5)
			aAng:RotateAroundAxis(aAng:Up(),-90)

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

		self.WorldEnt:SetPos(vPos + aAng:Forward() * 5.4 + aAng:Right() + aAng:Up() * -6.3)

		aAng:RotateAroundAxis(aAng:Forward(),180)
		aAng:RotateAroundAxis(aAng:Right(),7.5)
		aAng:RotateAroundAxis(aAng:Up(),-90)

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