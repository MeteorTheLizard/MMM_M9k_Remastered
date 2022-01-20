SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9K Assault Rifles"
SWEP.PrintName = "KAC PDW"

SWEP.Slot = 3
SWEP.HoldType = "smg"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_kac_pdw1.mdl"
SWEP.WorldModel = "models/weapons/w_kac_pdw.mdl"

SWEP.Primary.Sound = "KAC_PDW.Single"
SWEP.Primary.RPM = 500
SWEP.Primary.ClipSize = 30

SWEP.Primary.KickUp = 2.1
SWEP.Primary.KickDown = 1.9
SWEP.Primary.KickHorizontal = 1.6
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "ar2"
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 18
SWEP.Primary.Spread = .0275

SWEP.IronSightsPos = Vector(3.355,0,0.9)
SWEP.IronSightsAng = Vector(1,0,0)

SWEP.ViewModelScale = Vector(1,1,1)
SWEP.ModelViewForwardMult = 0.275
SWEP.ModelViewRightMult = 9.5
SWEP.ModelViewUpMult = 7.25
SWEP.ModelViewAngForward = -185
SWEP.ModelViewAngRight = 0
SWEP.ModelViewAngUp = -90

if CLIENT then
	function SWEP:CreateViewModel() -- We need to create these like that since a player could join and these would be invalid!
		if IsValid(self.ViewEnt) then self.ViewEnt:Remove() end

		self.ViewEnt = ClientsideModel("models/wystan/attachments/eotech557sight.mdl",RENDERGROUP_VIEWMODEL_TRANSLUCENT)
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

		if CLIENT then
			self.WepSelectIcon = surface.GetTextureID("vgui/hud/m9k_kac_pdw")

			if self.Owner == LocalPlayer() then
				self:SendWeaponAnim(ACT_VM_IDLE)

				self:CreateViewModel()

				if self.Owner:GetActiveWeapon() == self then -- Compat/Bugfix
					self:Equip()
					self:Deploy()
				end
			end
		end
	end

	function SWEP:ViewModelDrawn(vm)
		if not IsValid(self.ViewEnt) then self:CreateViewModel() end

		self.CachedViewBone = self.CachedViewBone or vm:LookupBone("DrawCall_0") -- This is faster than looking it up every frame!
		local mMatrix = vm:GetBoneMatrix(self.CachedViewBone)
		if not mMatrix then return end -- Required to fix a one-time error
		local Pos, Ang = mMatrix:GetTranslation(), mMatrix:GetAngles()
		Ang:SetUnpacked(Ang.p + 180,Ang.y,Ang.r) -- This is needed to fix the really weird bone angles

		self.ViewEnt:SetPos(Pos + Ang:Forward() * self.ModelViewForwardMult + Ang:Right() * self.ModelViewRightMult + Ang:Up() * self.ModelViewUpMult)
		Ang:RotateAroundAxis(Ang:Forward(),self.ModelViewAngForward)
		Ang:RotateAroundAxis(Ang:Right(),self.ModelViewAngRight)
		Ang:RotateAroundAxis(Ang:Up(),self.ModelViewAngUp)

		self.ViewEnt:SetAngles(Ang)
		self.ViewEnt:EnableMatrix("RenderMultiply",self.ViewMatrix)
		self.ViewEnt:DrawModel()
	end

	function SWEP:Holster()
		if IsValid(self.ViewEnt) then
			self.ViewEnt:SetNoDraw(true)
		end

		return true
	end

	function SWEP:OnRemove()
		if IsValid(self.ViewEnt) then
			self.ViewEnt:Remove()
		end
	end
end