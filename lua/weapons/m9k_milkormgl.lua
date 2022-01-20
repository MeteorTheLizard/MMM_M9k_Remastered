SWEP.Base = "bobs_shotty_base"
SWEP.Category = "M9K Specialties"
SWEP.PrintName = "Milkor Mk1"

SWEP.Slot = 5
SWEP.HoldType = "smg"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_milkor_mgl1.mdl"
SWEP.WorldModel = "models/weapons/w_milkor_mgl1.mdl"

SWEP.Primary.Sound = "40mmGrenade.Single"
SWEP.Primary.RPM = 125
SWEP.Primary.ClipSize = 6

SWEP.Primary.KickUp = 4
SWEP.Primary.KickDown = 3
SWEP.Primary.KickHorizontal = 2
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "40mmGrenade"
SWEP.ShellTime = .45

SWEP.IronSightsPos = Vector(2.635,-0.03,2.04)
SWEP.IronSightsAng = Vector(-2,2.7,0)

SWEP.ViewModelScale = Vector(1,1,1)
SWEP.ModelViewForwardMult = -12
SWEP.ModelViewRightMult = -9.35
SWEP.ModelViewUpMult = 0.75
SWEP.ModelViewAngForward = 90
SWEP.ModelViewAngRight = 5
SWEP.ModelViewAngUp = 0

local AngleCache1 = Angle(90,0,0)
local VectorCache1 = Vector(0,0,1)
local MetaE = FindMetaTable("Entity")
local CPPIExists = MetaE.CPPIGetOwner and true or false

function SWEP:PrimaryAttack()
	if self.Owner:WaterLevel() == 3 then -- No weapons may fire underwater
		self:EmitSound("Weapon_Pistol.Empty")
		self:SetNextPrimaryFire(CurTime() + 0.2)
		return
	end

	if self.InsertingShell and not self.CanceledReloadSuccess then
		self:FinishReloading()
	elseif self:CanPrimaryAttack() and self:GetNextPrimaryFire() < CurTime() and not self.InsertingShell then
		self:SetNextPrimaryFire(CurTime() + 1 / (self.Primary.RPM / 60))

		if SERVER then
			self:TakePrimaryAmmo(1)

			local aim = self.Owner:GetAimVector()
			local side = aim:Cross(VectorCache1)
			local pos = self.Owner:GetShootPos() + side * 6 + side:Cross(aim) * -5

			local rocket = ents.Create("m9k_launched_m79")
			rocket:SetAngles(aim:Angle() + AngleCache1)
			rocket:SetPos(pos)

			rocket:SetOwner(self.Owner)

			if CPPIExists then
				rocket:CPPISetOwner(self.Owner)
			else
				rocket:SetNWEntity("my_owner",self.Owner) -- TinyCPPI Compatibility
			end

			rocket:Spawn()
			rocket:Activate()
		end

		local KickUp = self.Primary.KickUp
		local KickDown = self.Primary.KickDown
		local KickHorizontal = self.Primary.KickHorizontal

		if self.Owner:KeyDown(IN_DUCK) then
			KickUp = self.Primary.KickUp / 2
			KickDown = self.Primary.KickDown / 2
			KickHorizontal = self.Primary.KickHorizontal / 2
		end

		local SharedRandom = Angle(util.SharedRandom("m9k_gun_kick1",-KickDown,-KickUp),util.SharedRandom("m9k_gun_kick2",-KickHorizontal,KickHorizontal),0)
		self.Owner:ViewPunch(SharedRandom) -- This needs to be shared

		if SERVER and game.SinglePlayer() or SERVER and self.Owner:IsListenServerHost() then -- This is specifically for the host or when in singleplayer
			local eyes = self.Owner:EyeAngles()
			eyes:SetUnpacked(eyes.pitch + SharedRandom.pitch,eyes.yaw + SharedRandom.yaw,0)
			self.Owner:SetEyeAngles(eyes)
		elseif CLIENT and not game.SinglePlayer() then -- This is for other players in multiplayer (Or anyone on the server if dedicated)
			local eyes = self.Owner:EyeAngles()
			eyes:SetUnpacked(eyes.pitch + (SharedRandom.pitch/5),eyes.yaw + (SharedRandom.yaw/5),0)
			self.Owner:SetEyeAngles(eyes)
		end

		self:AttackAnimation()
		self:EmitSound(self.Primary.Sound)
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	end
end

if CLIENT then
	function SWEP:FireAnimationEvent(_,_,event) -- No shell ejection
		if event == 20 then return true end
	end

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
			self.WepSelectIcon = surface.GetTextureID("vgui/hud/m9k_milkormgl")

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

		self.CachedViewBone = self.CachedViewBone or vm:LookupBone("body") -- This is faster than looking it up every frame!
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