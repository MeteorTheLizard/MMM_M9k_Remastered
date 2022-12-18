AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Launched Grenade"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.DoNotDuplicate = true
ENT.DisableDuplicator = true


local fReturnFalse = function() -- Save some ram
	return false
end

ENT.CanTool = fReturnFalse -- Restrict certain things
ENT.CanProperty = fReturnFalse
ENT.PhysgunPickup = fReturnFalse


if SERVER then

	local utilTraceLine = util.TraceLine -- Optimization
	local mathRand = math.Rand
	local CurTime = CurTime
	local IsValid = IsValid
	local Vector = Vector


	local vCached1 = Vector(0,0,-0.111)
	local vCached2 = Vector(0,0,1)
	local aCached1 = Angle(90,0,0)

	local tFleshMats = {
		[45] = true, -- Combine visor
		[50] = true, -- Unknown
		[MAT_FLESH] = true
	}


	ENT.GravGunPickupAllowed = fReturnFalse -- This is Serverside only


	local fExplode = function(self)

		local vPos = self:GetPos()


		local obj_EffectData = EffectData()

		obj_EffectData:SetNormal(vCached2)
		obj_EffectData:SetScale(1.3)
		obj_EffectData:SetRadius(67)
		obj_EffectData:SetMagnitude(14)
		obj_EffectData:SetOrigin(vPos)

		util.Effect("m9k_gdcw_cinematicboom",obj_EffectData)


		util.ScreenShake(vPos,10,5,1,3000)

		util.BlastDamage(self,self.Owner,vPos,350,150)


		self:Remove()

	end


	ENT.bInFlight = true


	function ENT:Initialize()

		if not self.M9kr_CreatedByWeapon then -- Prevents exploiting it
			self:Remove()

			return
		end


		self:SetModel("models/weapons/w_40mm_grenade_launched.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_NONE)


		self.vFlight = self:GetUp() * ((75 * 52.5) / 66)
		self.iLifeTime = CurTime() + 15
		self.tFilters = {self,self.Owner} -- Don't recreate this over and over again.

	end


	function ENT:Think()

		if not IsValid(self.Owner) then
			self:Remove()

			return
		end


		local iCur = CurTime()


		if self.iLifeTime < iCur then
			fExplode(self)

			return
		end


		if self.bInFlight then

			local vPos = self:GetPos()

			local tTrace = utilTraceLine({
				start = vPos,
				endpos = vPos + self.vFlight,
				filter = self.tFilters
			})


			if tTrace.Hit then

				local obj_EffectData = EffectData()


				if not tFleshMats[tTrace.MatType] then

					obj_EffectData:SetScale(1.3)
					obj_EffectData:SetMagnitude(14)
					obj_EffectData:SetOrigin(tTrace.HitPos)
					obj_EffectData:SetNormal(tTrace.HitNormal)
					obj_EffectData:SetRadius(tTrace.MatType)

					util.Effect("m9k_gdcw_cinematicboom",obj_EffectData)

					util.Decal("Scorch",tTrace.HitPos + tTrace.HitNormal,tTrace.HitPos - tTrace.HitNormal)

					util.ScreenShake(tTrace.HitPos,10,5,1,3000)

					util.BlastDamage(self,self.Owner,tTrace.HitPos,350,150)


					self:Remove()


					return

				end


				-- We hit something alive

				local eEnt = tTrace.Entity -- Optimization

				if eEnt:IsPlayer() or eEnt:IsNPC() then
					eEnt:TakeDamage(150,self.Owner,self)
				end


				obj_EffectData:SetScale(1)
				obj_EffectData:SetOrigin(tTrace.HitPos)
				obj_EffectData:SetNormal(tTrace.HitNormal)

				util.Effect("m9k_cinematic_blood_cloud",obj_EffectData)


				eEnt:EmitSound("physics/flesh/flesh_squishy_impact_hard" .. math.random(4) .. ".wav",500,100)


				self:SetPos(tTrace.HitPos)
				self:SetParent(eEnt)
				self:SetNoDraw(true)


				self.bInFlight = false
				self.iLifeTime = CurTime() + 2

				self:SetNWBool("M9kr_NoSmoke",true)


				return -- No position update

			end


			self.vFlight = self.vFlight - (self.vFlight / 350) + Vector(mathRand(-0.2,0.2),mathRand(-0.2,0.2),mathRand(-0.1,0.1)) + vCached1

			self:SetPos(vPos + self.vFlight)
			self:SetAngles(self.vFlight:Angle() + aCached1)

		end


		self:NextThink(iCur)
		return true
	end
end


if CLIENT then

	local ParticleEmitter = ParticleEmitter -- Optimization
	local mathrandom = math.random
	local VectorRand = VectorRand
	local mathRand = math.Rand

	local vCached1 = Vector(100,0,0)


	function ENT:Initialize()
		self.eParticleEmitter = ParticleEmitter(self:GetPos())
	end


	function ENT:Draw()
		self:DrawModel()
	end


	function ENT:OnRemove()
		if not IsValid(self.eParticleEmitter) then return end

		self.eParticleEmitter:Finish()
	end


	function ENT:Think()

		if self:GetNWBool("M9kr_NoSmoke") then return end


		for i = 1,3 do

			local obj_Particle = self.eParticleEmitter:Add("particle/smokesprites_000" .. mathrandom(9),self:GetPos() + (self:GetUp() * -120 * i))

			if obj_Particle then
				obj_Particle:SetVelocity((self:GetUp() * -2000) + (VectorRand() * 100))
				obj_Particle:SetDieTime(mathRand(2,3))
				obj_Particle:SetStartAlpha(mathRand(3,5))
				obj_Particle:SetEndAlpha(0)
				obj_Particle:SetStartSize(mathRand(30,40))
				obj_Particle:SetEndSize(mathRand(80,90))
				obj_Particle:SetRoll(mathRand(0,360))
				obj_Particle:SetRollDelta(mathRand(-1,1))
				obj_Particle:SetColor(150,150,150)
				obj_Particle:SetAirResistance(200)
				obj_Particle:SetGravity(vCached1)
			end
		end
	end
end