SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9K Submachine Guns"
SWEP.PrintName = "FN P90"

SWEP.Slot = 2
SWEP.HoldType = "pistol"
SWEP.Spawnable = true

SWEP.ViewModelFOV = 65
SWEP.ViewModel = "models/weapons/v_p90_smg.mdl"
SWEP.WorldModel = "models/weapons/w_fn_p90.mdl"

SWEP.Primary.Sound = "P90_weapon.single"
SWEP.Primary.RPM = 800
SWEP.Primary.ClipSize = 50

SWEP.Primary.KickUp = 0.8
SWEP.Primary.KickDown = 0.6
SWEP.Primary.KickHorizontal = 0.7
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 13
SWEP.Primary.Spread = .032

SWEP.IronSightsPos = Vector(2.685,-2.46,1.7)

SWEP.ViewModelScale = Vector(1,1,1)
SWEP.ModelViewForwardMult = -5
SWEP.ModelViewRightMult = 3.125
SWEP.ModelViewUpMult = -0.075
SWEP.ModelViewAngForward = 90
SWEP.ModelViewAngRight = 0
SWEP.ModelViewAngUp = 90

if CLIENT then
	function SWEP:CreateViewModel() -- We need to create these like that since a player could join and these would be invalid!
		if IsValid(self.ViewEnt) then self.ViewEnt:Remove() end

		self.ViewEnt = ClientsideModel("models/wystan/attachments/doctorrds.mdl",RENDERGROUP_VIEWMODEL_TRANSLUCENT)
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
			self.WepSelectIcon = surface.GetTextureID("vgui/hud/m9k_smgp90")

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

		self.CachedViewBone = self.CachedViewBone or vm:LookupBone("p90_body") -- This is faster than looking it up every frame!
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