AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "M9kR - Rocket"
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

	local utilTraceLine = util.TraceLine -- Optimizations
	local mathRand = math.Rand
	local CurTime = CurTime
	local IsValid = IsValid
	local Vector = Vector

	local vCached1 = Vector(0,0,-0.111)


	ENT.GravGunPickupAllowed = fReturnFalse -- This is Serverside only


	function ENT:Initialize()

		if not self.M9kr_CreatedByWeapon then -- Prevents exploiting it
			self:Remove()

			return
		end


		self:SetModel("models/weapons/w_missile.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_NONE)


		self.eGlow = ents.Create("env_sprite")

		if IsValid(self.eGlow) then

			self.eGlow:SetKeyValue("model","orangecore2.vmt")
			self.eGlow:SetKeyValue("rendercolor","255 150 100")
			self.eGlow:SetKeyValue("scale","0.3")

			self.eGlow:SetPos(self:GetPos())
			self.eGlow:SetParent(self)
			self.eGlow:Spawn()

		end


		self.vFlight = self:GetForward() * ((115 * 52.5) / 66)
		self.iLifeTime = CurTime() + 15
		self.tFilters = {self,self.Owner} -- Don't recreate this over and over again.

	end


	function ENT:Think()

		if self.iLifeTime < CurTime() then
			self:Remove()

			return
		end


		local vPos = self:GetPos()

		local tTrace = utilTraceLine({
			start = vPos,
			endpos = vPos + self.vFlight,
			filter = self.tFilters
		})


		if tTrace.Hit then

			local obj_EffectData = EffectData()

			obj_EffectData:SetMagnitude(18)
			obj_EffectData:SetScale(1.3)
			obj_EffectData:SetOrigin(tTrace.HitPos)
			obj_EffectData:SetNormal(tTrace.HitNormal)
			obj_EffectData:SetRadius(tTrace.MatType)

			util.Effect("m9k_gdcw_tpaboom",obj_EffectData)


			util.ScreenShake(tTrace.HitPos,10,5,1,3000)

			util.Decal("Scorch",tTrace.HitPos + tTrace.HitNormal,tTrace.HitPos - tTrace.HitNormal)

			util.BlastDamage(self,self.Owner,tTrace.HitPos,600,150)


			self:Remove()


			return

		end


		self.vFlight = self.vFlight - (self.vFlight / 500)  + Vector(mathRand(-0.2,0.2),mathRand(-0.2,0.2),mathRand(-0.1,0.1)) + vCached1

		self:SetPos(vPos + self.vFlight)
		self:SetAngles(self.vFlight:Angle())


		self:NextThink(CurTime() + 0.03)
		return true
	end
end


if CLIENT then

	local ParticleEmitter = ParticleEmitter -- Optimization
	local mathrandom = math.random
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

		for i = 0,2 do

			local obj_Particle = self.eParticleEmitter:Add("particle/smokesprites_000" .. mathrandom(9),self:GetPos() + (self:GetForward() * -100 * i))

			if obj_Particle then
				obj_Particle:SetVelocity(self:GetForward() * -2000)
				obj_Particle:SetDieTime(mathRand(1.5,3))
				obj_Particle:SetStartAlpha(mathRand(5,8))
				obj_Particle:SetEndAlpha(0)
				obj_Particle:SetStartSize(mathRand(40,50))
				obj_Particle:SetEndSize(mathRand(130,150))
				obj_Particle:SetRoll(mathRand(0,360))
				obj_Particle:SetRollDelta(mathRand(-1,1))
				obj_Particle:SetColor(200,200,200)
				obj_Particle:SetAirResistance(200)
				obj_Particle:SetGravity(vCached1)
			end
		end
	end
end