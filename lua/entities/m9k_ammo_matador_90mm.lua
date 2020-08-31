AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "90mm High Explosive"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.DoNotDuplicate = true
ENT.DisableDuplicator = true

if SERVER then
	local VectorCache1 = Vector(0,0,-0.111)
	local AngleCache1 = Angle(90,0,0)
	local ColorCache1 = Color(45,55,40,255)
	local effectData = EffectData()

	function ENT:Initialize()
		self.flightvector = self:GetUp() * ((250 * 52.5) / 66)
		self.timeleft = CurTime() + 10
		self:SetModel("models/props_junk/garbage_glassbottle001a.mdl")
		self:SetColor(ColorCache1)
		local Glow = ents.Create("env_sprite")
		Glow:SetKeyValue("model","orangecore2.vmt")
		Glow:SetKeyValue("rendercolor","255 150 100")
		Glow:SetKeyValue("scale","0.3")
		Glow:SetPos(self:GetPos())
		Glow:SetParent(self)
		Glow:Spawn()
		Glow:Activate()
		self:SetNWBool("smoke",true)
	end

	function ENT:Think()
		if self.timeleft < CurTime() then
			self:Remove()
		end

		local Tr = util.TraceLine({
			start = self:GetPos(),
			endpos = self:GetPos() + self.flightvector,
			filter = {self,self.Owner}
		})

		if Tr.Hit then
			if not IsValid(self.Owner) then
				self:Remove()
				return
			end

			util.BlastDamage(self,self.Owner,Tr.HitPos,450,150)

			effectData:SetScale(1.8)
			effectData:SetMagnitude(18)
			effectData:SetOrigin(Tr.HitPos)
			effectData:SetNormal(Tr.HitNormal)
			effectData:SetRadius(Tr.MatType)
			util.Effect("m9k_gdcw_cinematicboom",effectData)

			util.ScreenShake(Tr.HitPos,10,5,1,3000)
			util.Decal("Scorch",Tr.HitPos + Tr.HitNormal,Tr.HitPos - Tr.HitNormal)
			self:SetNWBool("smoke",false)
			self:Remove()
		end

		self.flightvector = self.flightvector - (self.flightvector / 200) + Vector(math.Rand(-0.1,0.1),math.Rand(-0.1,0.1),math.Rand(-0.05,0.05)) + VectorCache1
		self:SetPos(self:GetPos() + self.flightvector)
		self:SetAngles(self.flightvector:Angle() + AngleCache1)

		self:NextThink(CurTime())
		return true
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

			for i = 0,5 do
				local particle = self.Emitter:Add("particle/smokesprites_000" .. math.random(1,9),pos + (self:GetUp() * -100 * i))

				if particle then
					particle:SetVelocity((self:GetUp() * -2000) + (VectorRand() * 100))
					particle:SetDieTime(math.Rand(2,5))
					particle:SetStartAlpha(math.Rand(5,7))
					particle:SetEndAlpha(0)
					particle:SetStartSize(math.Rand(30,40))
					particle:SetEndSize(math.Rand(130,150))
					particle:SetRoll(math.Rand(0,360))
					particle:SetRollDelta(math.Rand(-1,1))
					particle:SetColor(200,200,200)
					particle:SetAirResistance(200)
					particle:SetGravity(VectorCache1)
				end
			end
		end
	end
end