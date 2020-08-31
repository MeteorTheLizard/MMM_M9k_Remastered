AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "M54 High Explosive Anti-Tank"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.DoNotDuplicate = true
ENT.DisableDuplicator = true

if SERVER then
	local VectorCache1 = Vector(0,0,-0.111)
	local VectorCache2 = Vector(0,0,1)
	local AngleCache1 = Angle(90,0,0)
	local effectData = EffectData()

	function ENT:Initialize()
		self.flightvector = self:GetUp() * ((75 * 52.5) / 66)
		self.timeleft = CurTime() + 15
		self:SetModel("models/weapons/w_40mm_grenade_launched.mdl")
		self.InFlight = true
		self:SetNWBool("smoke",true)
	end

	function ENT:Think()
		local Tr = util.TraceLine({
			start = self:GetPos(),
			endpos = self:GetPos() + self.flightvector,
			filter = {self,self.Owner}
		})

		if Tr.Hit and self.InFlight then
			if not IsValid(self.Owner) then
				self:Remove()
				return
			end

			if Tr.MatType ~= 70 and Tr.MatType ~= 50 then
				util.BlastDamage(self,self.Owner,Tr.HitPos,350,150)

				effectData:SetScale(1.3)
				effectData:SetMagnitude(14)
				effectData:SetOrigin(Tr.HitPos)
				effectData:SetNormal(Tr.HitNormal)
				effectData:SetRadius(Tr.MatType)
				util.Effect("m9k_gdcw_cinematicboom",effectData)

				util.ScreenShake(Tr.HitPos,10,5,1,3000)
				util.Decal("Scorch",Tr.HitPos + Tr.HitNormal,Tr.HitPos - Tr.HitNormal)
				self:Remove()
			else
				if Tr.Entity:IsPlayer() or Tr.Entity:IsNPC() then
					Tr.Entity:TakeDamage(150,self.Owner,self)
				end

				effectData:SetScale(1)
				effectData:SetOrigin(Tr.HitPos)
				effectData:SetNormal(Tr.HitNormal)
				util.Effect("m9k_cinematic_blood_cloud",effectData)

				Tr.Entity:EmitSound("physics/flesh/flesh_squishy_impact_hard" .. math.random(1,4) .. ".wav",500,100)
				self:SetMoveType(MOVETYPE_VPHYSICS)
				self:SetPos(Tr.HitPos)
				self:PhysWake()
				self.InFlight = false
				self:SetNWBool("smoke",false)
				self.timeleft = CurTime() + 2
			end
		end

		if self.InFlight then
			self.flightvector = self.flightvector - (self.flightvector / 350) + Vector(math.Rand(-0.2,0.2),math.Rand(-0.2,0.2),math.Rand(-0.1,0.1)) + VectorCache1
			self:SetPos(self:GetPos() + self.flightvector)
			self:SetAngles(self.flightvector:Angle() + AngleCache1)
		end

		if CurTime() > self.timeleft then
			self:Explosion()
		end

		self:NextThink(CurTime())
		return true
	end

	function ENT:Explosion()
		if not IsValid(self.Owner) then
			self:Remove()
			return
		end

		util.BlastDamage(self,self.Owner,self:GetPos(),350,150)

		effectData:SetNormal(VectorCache2)
		effectData:SetScale(1.3)
		effectData:SetRadius(67)
		effectData:SetMagnitude(14)
		effectData:SetOrigin(self:GetPos())
		util.Effect("m9k_gdcw_cinematicboom",effectData)

		util.ScreenShake(self:GetPos(),10,5,1,3000)
		self:Remove()
	end

	function ENT:PhysgunPickup()
		return false
	end

	function ENT:CanTool()
		return false
	end
end

if CLIENT then
	local VectorCache1 = Vector(100,0,0)

	function ENT:Draw()
		self:DrawModel()
	end

	function ENT:Initialize()
		self.Emitter = ParticleEmitter(self:GetPos())
	end

	function ENT:Think()
		if self:GetNWBool("smoke") then
			local pos = self:GetPos()

			for i = 0,4 do
				local particle = self.Emitter:Add("particle/smokesprites_000" .. math.random(1,9),pos + (self:GetUp() * -120 * i))

				if particle then
					particle:SetVelocity((self:GetUp() * -2000) + (VectorRand() * 100))
					particle:SetDieTime(math.Rand(2,3))
					particle:SetStartAlpha(math.Rand(3,5))
					particle:SetEndAlpha(0)
					particle:SetStartSize(math.Rand(30,40))
					particle:SetEndSize(math.Rand(80,90))
					particle:SetRoll(math.Rand(0,360))
					particle:SetRollDelta(math.Rand(-1,1))
					particle:SetColor(150,150,150)
					particle:SetAirResistance(200)
					particle:SetGravity(VectorCache1)
				end
			end
		end
	end
end