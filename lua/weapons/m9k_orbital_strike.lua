SWEP.Base = "bobs_scoped_base"
SWEP.Category = "M9kR: Specialties"
SWEP.PrintName = "Orbital Strike Marker"

SWEP.DynamicLightScale = 0 -- None!

SWEP.Slot = 4
SWEP.HoldType = "camera"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/c_bugbait.mdl"
SWEP.WorldModel = "models/weapons/binos.mdl"
SWEP.UseHands = true

SWEP.Primary.Sound = "weapons/satellite/targaquired.mp3"

SWEP.Primary.RPM = 50
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.KickUp = 0
SWEP.Primary.KickDown = 0
SWEP.Primary.KickHorizontal = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Primary.SpreadBefore = SWEP.Primary.Spread

SWEP.ScopeType = "gdcw_scopesight"
SWEP.ScopeStages = 3
SWEP.ScopeScale = 1.5
SWEP.ReticleScale = 0.5

SWEP.CanFireUnderwater = true

SWEP.bBlockShellEject = true
SWEP.bBlockMuzzleFlash = true
SWEP.bFiresEntity = true

SWEP._UsesCustomModels = true


if SERVER then

	local vCached1 = Vector(0,0,65000)
	local vCached2 = Vector(0,0,10)


	function SWEP:PrimaryAttack()

		if not IsValid(self.Owner) then return end -- If somehow an NPC got it on their hands or similar.. this will cause huge problems!

		if MMM_M9k_IsSinglePlayer then
			self:CallOnClient("PrimaryAttack")-- Make sure that it runs on the CLIENT! (Singleplayer!)
		end


		if self:GetNextPrimaryFire() < CurTime() and (not self.Owner:KeyDown(IN_SPEED) and not self.Owner:KeyDown(IN_RELOAD)) then


			self.Owner:LagCompensation(true)

			local tTrace = self.Owner:GetEyeTrace()

			self.Owner:LagCompensation(false)


			if tTrace.HitSky then
				self.Owner:EmitSound("player/suit_denydevice.wav")
				self:SetNextPrimaryFire(CurTime() + 0.5)

				return
			end


			local tTraceSky = {
				start = tTrace.HitPos,
				endpos = tTrace.HitPos + vCached1
			}

			local tSkyCheck = util.TraceLine(tTraceSky)


			if not tSkyCheck.HitSky then
				self.Owner:EmitSound("player/suit_denydevice.wav")
				self:SetNextPrimaryFire(CurTime() + 0.5)

				return
			end


			if tSkyCheck.HitSky then


				local vPos = tSkyCheck.HitPos - vCached2


				local eStrike = ents.Create("m9k_oribital_cannon")

				if IsValid(eStrike) then

					eStrike.Ground = tTrace.HitPos
					eStrike.Sky = vPos
					eStrike.Owner = self.Owner

					eStrike:SetPos(vPos)
					eStrike:Spawn()

				end


			elseif IsValid(tTrace.Entity) and (tTrace.Entity:IsPlayer() or tTrace.Entity:IsNPC()) then -- We aimed at something


				local tTraceSky2 = {
					start = tTrace.Entity:GetPos(),
					endpos = tTrace.Entity:GetPos() + vCached1,
					filter = tTrace.Entity
				}

				local tSkyCheck2 = util.TraceLine(tTraceSky2)


				if not tSkyCheck2.HitSky then
					self.Owner:EmitSound("player/suit_denydevice.wav")
					self:SetNextPrimaryFire(CurTime() + 0.5)

					return
				end


				local vPos = tSkyCheck2.HitPos - vCached2


				local eStrike = ents.Create("m9k_oribital_cannon")

				if IsValid(eStrike) then

					eStrike.Target = tTrace.Entity
					eStrike.Sky = vPos
					eStrike.Owner = self.Owner

					eStrike:SetPos(vPos)
					eStrike:Spawn()

				end

			end


			self.Owner:EmitSound(self.Primary.Sound)

			self:SetNextPrimaryFire(CurTime() + 15)

		end
	end


	function SWEP:Reload()

	end
end


if CLIENT then

	local vector_one = Vector(1,1,1)

	function SWEP:CreateViewModel() -- We need to create these like that since a player could join and these would be invalid!
		if IsValid(self.ViewEnt) then self.ViewEnt:Remove() end


		self.ViewEnt = ClientsideModel("models/weapons/binos.mdl",RENDERGROUP_VIEWMODEL_TRANSLUCENT)
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


		self.CachedViewBone = self.CachedViewBone or vm:LookupBone("ValveBiped.cube") -- This is faster than looking it up every frame!
		-- This bone is always valid.

		local mMatrix = vm:GetBoneMatrix(self.CachedViewBone)
		if not mMatrix then return end -- Required to fix a one-time error


		local vPos, aAng = mMatrix:GetTranslation(), mMatrix:GetAngles()


		self.ViewEnt:SetPos(vPos + aAng:Right() * 2 + aAng:Up() * 1)

		aAng:RotateAroundAxis(aAng:Forward(),-100)
		aAng:RotateAroundAxis(aAng:Right(),-40)
		aAng:RotateAroundAxis(aAng:Up(),-25)

		self.ViewEnt:SetAngles(aAng)
		self.ViewEnt:EnableMatrix("RenderMultiply",self.ViewMatrix)
		self.ViewEnt:DrawModel()
	end


	function SWEP:CreateWorldModel() -- We need to create these like that since a player could join and these would be invalid!
		if IsValid(self.WorldEnt) then self.WorldEnt:Remove() end


		self.WorldEnt = ClientsideModel("models/weapons/binos.mdl",RENDERGROUP_VIEWMODEL_TRANSLUCENT)
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


		if not IsValid(self.Owner) then
			self:DrawModel()

			return
		end


		self.CachedWorldBone = self.CachedWorldBone or self.Owner:LookupBone("ValveBiped.Bip01_R_Hand") -- This is faster than looking it up every frame!
		if not self.CachedWorldBone then return end -- Thanks to wrefgtzweve on GitHub for finding this.


		local vPos, aAng = self.Owner:GetBonePosition(self.CachedWorldBone)

		self.WorldEnt:SetPos(vPos + aAng:Forward() * 7 + aAng:Right() * 6.25 + aAng:Up() * -2)

		aAng:RotateAroundAxis(aAng:Forward(),190)
		aAng:RotateAroundAxis(aAng:Right(),-25)
		aAng:RotateAroundAxis(aAng:Up(),95)

		self.WorldEnt:SetAngles(aAng)
		self.WorldEnt:EnableMatrix("RenderMultiply",self.ViewMatrix)
		self.WorldEnt:DrawModel()
	end


	function SWEP:ResetInternalVarsHooked2() -- Remove the entities if the Weapon is reset!
		if IsValid(self.ViewEnt) then
			self.ViewEnt:Remove()
		end

		if IsValid(self.WorldEnt) then
			self.WorldEnt:Remove()
		end
	end
end