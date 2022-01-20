SWEP.Base = "bobs_scoped_base"
SWEP.Category = "M9K Assault Rifles"
SWEP.PrintName = "AAC Honey Badger"

SWEP.Slot = 3
SWEP.HoldType = "ar2"
SWEP.Spawnable = true

SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_aacbadger.mdl"
SWEP.WorldModel = "models/weapons/w_aac_honeybadger.mdl"

SWEP.Primary.Sound = "Weapon_HoneyB.single"
SWEP.Primary.RPM = 335
SWEP.Primary.ClipSize = 30

SWEP.Primary.KickUp = 1.5
SWEP.Primary.KickDown = .7
SWEP.Primary.KickHorizontal = 0.9
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "ar2"
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 31
SWEP.Primary.Spread = .022
SWEP.Primary.SpreadZoomed = .0125
SWEP.Primary.SpreadBefore = SWEP.Primary.Spread

SWEP.ScopeScale = 0.5
SWEP.ReticleScale = 0.5
SWEP.HasZoomStages = false -- This weapon does not have variable zooms (No zoom stages)

SWEP.ViewModelScale = Vector(1,1,1)
SWEP.ModelViewForwardMult = 0.25
SWEP.ModelViewRightMult = 5
SWEP.ModelViewUpMult = -4.5
SWEP.ModelViewAngForward = 0
SWEP.ModelViewAngRight = 0
SWEP.ModelViewAngUp = 180

SWEP.ViewModelScaleLens = Vector(0.024,0.024,0.024)
SWEP.ModelViewForwardMultLens = 0
SWEP.ModelViewRightMultLens = 0
SWEP.ModelViewUpMultLens = 2.25
SWEP.ModelViewAngForwardLens = 90
SWEP.ModelViewAngRightLens = 90
SWEP.ModelViewAngUpLens = 0

if CLIENT then
	local CachedTextureID1 = surface.GetTextureID("scope/aimpoint")
	local CachedTextureID2 = surface.GetTextureID("scope/gdcw_closedsight")

	function SWEP:DrawHUD()
		if self.Owner:GetViewEntity() ~= self.Owner then return end

		if self:GetNWInt("ScopeState") > 0 then
			if self.DrawCrosshair then -- Only set the vars once (this is faster)
				self.Owner:DrawViewModel(false)
				self.DrawCrosshair = false
			end

			surface.SetDrawColor(0,0,0,255)
			surface.SetTexture(CachedTextureID1)
			surface.DrawTexturedRect(self.ReticleTable.x,self.ReticleTable.y,self.ReticleTable.w,self.ReticleTable.h)

			surface.SetTexture(CachedTextureID2)
			surface.DrawTexturedRect(self.LensTable.x,self.LensTable.y,self.LensTable.w,self.LensTable.h)
		elseif not self.DrawCrosshair then -- Only set the vars once (this is faster)
			self.Owner:DrawViewModel(true)
			self.DrawCrosshair = true
		end
	end

	function SWEP:CreateViewModel() -- We need to create these like that since a player could join and these would be invalid!
		if IsValid(self.ViewEnt) then self.ViewEnt:Remove() end

		self.ViewEnt = ClientsideModel("models/wystan/attachments/aimpoint.mdl",RENDERGROUP_VIEWMODEL_TRANSLUCENT)
		self.ViewEnt:SetPos(self:GetPos())
		self.ViewEnt:SetAngles(self:GetAngles())
		self.ViewEnt:SetParent(self)
		self.ViewEnt:SetNoDraw(true)

		self.ViewMatrix = Matrix()
		self.ViewMatrix:Scale(self.ViewModelScale)

		self.ViewEntLens = ClientsideModel("models/XQM/panel360.mdl",RENDERGROUP_VIEWMODEL_TRANSLUCENT) -- Lens
		self.ViewEntLens:SetPos(self:GetPos())
		self.ViewEntLens:SetAngles(self:GetAngles())
		self.ViewEntLens:SetParent(self)
		self.ViewEntLens:SetNoDraw(true)
		self.ViewEntLens:SetMaterial("models/wystan/attachments/aimpoint/lense")

		self.ViewMatrixLens = Matrix()
		self.ViewMatrixLens:Scale(self.ViewModelScaleLens)
	end

	function SWEP:Initialize()
		self:SetHoldType(self.HoldType)
		self.OurIndex = self:EntIndex()
		self:SetNWInt("ScopeState",0)

		if CLIENT then
			self.WepSelectIcon = surface.GetTextureID("vgui/hud/m9k_honeybadger")

			if self.Owner == LocalPlayer() then
				self:SendWeaponAnim(ACT_VM_IDLE)

				self:CreateViewModel()

				if self.Owner:GetActiveWeapon() == self then -- Compat/Bugfix
					self:Equip()
					self:Deploy()
				end
			end

			local iScreenWidth = ScrW()
			local iScreenHeight = ScrH()

			self.ScopeTable = {}
			self.ScopeTable.l = iScreenHeight * self.ScopeScale
			self.ScopeTable.x1 = 0.5 * (iScreenWidth + self.ScopeTable.l)
			self.ScopeTable.y1 = 0.5 * (iScreenHeight - self.ScopeTable.l)
			self.ScopeTable.x2 = self.ScopeTable.x1
			self.ScopeTable.y2 = 0.5 * (iScreenHeight + self.ScopeTable.l)
			self.ScopeTable.x3 = 0.5 * (iScreenWidth - self.ScopeTable.l)
			self.ScopeTable.y3 = self.ScopeTable.y2
			self.ScopeTable.x4 = self.ScopeTable.x3
			self.ScopeTable.y4 = self.ScopeTable.y1
			self.ScopeTable.l = (iScreenHeight + 1) * self.ScopeScale
			self.QuadTable = {}
			self.QuadTable.x1 = 0
			self.QuadTable.y1 = 0
			self.QuadTable.w1 = iScreenWidth
			self.QuadTable.h1 = 0.5 * iScreenHeight - self.ScopeTable.l
			self.QuadTable.x2 = 0
			self.QuadTable.y2 = 0.5 * iScreenHeight + self.ScopeTable.l
			self.QuadTable.w2 = self.QuadTable.w1
			self.QuadTable.h2 = self.QuadTable.h1
			self.QuadTable.x3 = 0
			self.QuadTable.y3 = 0
			self.QuadTable.w3 = 0.5 * iScreenWidth - self.ScopeTable.l
			self.QuadTable.h3 = iScreenHeight
			self.QuadTable.x4 = 0.5 * iScreenWidth + self.ScopeTable.l
			self.QuadTable.y4 = 0
			self.QuadTable.w4 = self.QuadTable.w3
			self.QuadTable.h4 = self.QuadTable.h3
			self.LensTable = {}
			self.LensTable.x = self.QuadTable.w3
			self.LensTable.y = self.QuadTable.h1
			self.LensTable.w = 2 * self.ScopeTable.l
			self.LensTable.h = 2 * self.ScopeTable.l
			self.ReticleTable = {}
			self.ReticleTable.wdivider = 3.125
			self.ReticleTable.hdivider = 1.7579 / self.ReticleScale
			self.ReticleTable.x = (iScreenWidth / 2) - ((iScreenHeight / self.ReticleTable.hdivider) / 2)
			self.ReticleTable.y = (iScreenHeight / 2) - ((iScreenHeight / self.ReticleTable.hdivider) / 2)
			self.ReticleTable.w = iScreenHeight / self.ReticleTable.hdivider
			self.ReticleTable.h = iScreenHeight / self.ReticleTable.hdivider
		end
	end

	function SWEP:ViewModelDrawn(vm)
		if not IsValid(self.ViewEnt) then self:CreateViewModel() end

		self.CachedViewBone = self.CachedViewBone or vm:LookupBone("Gun") -- This is faster than looking it up every frame!
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

		self.ViewEntLens:SetPos(Pos + Ang:Forward() * self.ModelViewForwardMultLens + Ang:Right() * self.ModelViewRightMultLens + Ang:Up() * self.ModelViewUpMultLens)
		Ang:RotateAroundAxis(Ang:Forward(),self.ModelViewAngForwardLens)
		Ang:RotateAroundAxis(Ang:Right(),self.ModelViewAngRightLens)
		Ang:RotateAroundAxis(Ang:Up(),self.ModelViewAngUpLens)

		self.ViewEntLens:SetAngles(Ang)
		self.ViewEntLens:EnableMatrix("RenderMultiply",self.ViewMatrixLens)

		render.SetBlend(0.25) -- Make it so that you can see through it!
		render.SuppressEngineLighting(true)
		self.ViewEntLens:DrawModel()
		render.SuppressEngineLighting(false)
		render.SetBlend(1)
	end

	function SWEP:Holster()
		if IsValid(self.ViewEnt) then
			self.ViewEnt:SetNoDraw(true)
		end

		if IsValid(self.ViewEntLens) then
			self.ViewEntLens:SetNoDraw(true)
		end

		return true
	end

	function SWEP:OnRemove()
		if IsValid(self.ViewEnt) then
			self.ViewEnt:Remove()
		end

		if IsValid(self.ViewEntLens) then
			self.ViewEntLens:Remove()
		end
	end
end