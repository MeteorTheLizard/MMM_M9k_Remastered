AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Davy Crockett"
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
	local IsValid = IsValid
	local Vector = Vector

	local cColor1 = Color(82,102,39,254)
	local aCached1 = Angle(90,0,0)
	local vCached1 = Vector(0,0,-0.111)


	ENT.GravGunPickupAllowed = fReturnFalse -- This is Serverside only


	local fCreateExplosion = function(self)

		if not IsValid(self) or not IsValid(self.Owner) then

			if IsValid(self) then
				self:Remove()
			end

			return
		end


		local eExplosion = ents.Create("m9k_davy_crockett_explo")
		eExplosion:SetPos(self:GetPos())
		eExplosion:SetOwner(self.Owner)


		eExplosion.bWasFiredWithWeapon = true -- Required.


		eExplosion:Spawn()


		eExplosion.Owner = self.Owner


		self:Remove()

	end


	function ENT:Initialize()

		if not self.bWasFiredWithWeapon then
			self:Remove() -- This ensures that nukes can only be created with the SWEP. Damn exploiters!

			return
		end


		self.vFlight = self:GetUp() * ((115 * 52.5) / 66)
		self.iLifetime = CurTime() + 5


		self:SetModel("models/failure/mk6/m62.mdl")
		self:SetColor(cColor1)

		self:PhysicsInit(SOLID_VPHYSICS)


		local eGlow = ents.Create("env_sprite")

		eGlow:SetKeyValue("model","orangecore2.vmt")
		eGlow:SetKeyValue("rendercolor","255 150 100")
		eGlow:SetKeyValue("scale","1")

		eGlow:SetPos(self:GetPos() + self:GetUp() * -35)
		eGlow:SetParent(self)
		eGlow:Spawn()


		self.tFilter = {self,self.Owner} -- Don't re-create this over and over

	end


	function ENT:Think()

		local iCur = CurTime()


		if self.iLifetime < iCur then

			pcall(fCreateExplosion,self) -- If something goes wrong.. Don't spam explosions

			if IsValid(self) then
				self:Remove()
			end

			return
		end


		local vPos = self:GetPos()

		local tr = utilTraceLine({
			start = vPos,
			endpos = vPos + self.vFlight,
			filter = self.tFilter
		})


		if tr.Hit or tr.HitSky then

			pcall(fCreateExplosion,self) -- If something goes wrong.. Don't spam explosions

			if IsValid(self) then
				self:Remove()
			end

			return
		end


		self:SetPos(vPos + self.vFlight)

		self.vFlight = self.vFlight - self.vFlight / ((147 * 39.37) / 66) + self:GetUp() * 2 + Vector(mathRand(-0.3,0.3),mathRand(-0.3,0.3),mathRand(-0.1,0.1)) + vCached1

		self:SetAngles(self.vFlight:Angle() + aCached1)


		self:NextThink(iCur)
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

		local vUp = self:GetUp()


		for i = 1,3 do

			local obj_Particle = self.eParticleEmitter:Add("particle/smokesprites_000" .. mathrandom(9),self:GetPos() + (vUp * -100 * i))

			if obj_Particle then
				obj_Particle:SetVelocity(vUp * -2000)
				obj_Particle:SetDieTime(mathRand(2,5))
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