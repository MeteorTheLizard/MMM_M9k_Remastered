AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "High Explosive Anti-Tank RPG"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.DoNotDuplicate = true
ENT.DisableDuplicator = true

if SERVER then
	local VectorCache1 = Vector(0,0,-0.111)
	local effectdata = EffectData()
	effectdata:SetMagnitude(18)
	effectdata:SetScale(1.3)

	function ENT:Initialize()
		self.flightvector = self:GetForward() * ((115*52.5)/66)
		self.timeleft = CurTime() + 15
		self:SetModel("models/weapons/w_missile.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_NONE)
		local Glow = ents.Create("env_sprite")
		Glow:SetKeyValue("model","orangecore2.vmt")
		Glow:SetKeyValue("rendercolor","255 150 100")
		Glow:SetKeyValue("scale","0.3")
		Glow:SetPos(self:GetPos())
		Glow:SetParent(self)
		Glow:Spawn()
		Glow:Activate()
		self:SetNWBool("smoke", true)
	end

	function ENT:Think()
		if self.timeleft < CurTime() then
			self:Remove()
			return
		end

		local Tr = util.TraceLine({
			start = self:GetPos(),
			endpos = self:GetPos() + self.flightvector,
			filter = {self,self.Owner}
		})

		if Tr.Hit then
			effectdata:SetOrigin(Tr.HitPos)
			effectdata:SetNormal(Tr.HitNormal)
			effectdata:SetEntity(self)
			effectdata:SetRadius(Tr.MatType)
			util.BlastDamage(self,self.Owner,Tr.HitPos,600,150)
			util.Effect("m9k_gdcw_tpaboom",effectdata)
			util.ScreenShake(Tr.HitPos,10,5,1,3000)
			util.Decal("Scorch",Tr.HitPos + Tr.HitNormal,Tr.HitPos - Tr.HitNormal)
			self:SetNWBool("smoke",false)
			self:Remove()
		end

		self.flightvector = self.flightvector - (self.flightvector/500)  + Vector(math.Rand(-0.2,0.2), math.Rand(-0.2,0.2),math.Rand(-0.1,0.1)) + VectorCache1
		self:SetPos(self:GetPos() + self.flightvector)
		self:SetAngles(self.flightvector:Angle())

		self:NextThink(CurTime() + 0.03)
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

			for i = 0,10 do
				local particle = self.Emitter:Add("particle/smokesprites_000" .. math.random(1,9),pos + (self:GetForward() * -100 * i))

				if particle then
					particle:SetVelocity(self:GetForward() * -2000)
					particle:SetDieTime(math.Rand(1.5,3))
					particle:SetStartAlpha(math.Rand(5,8))
					particle:SetEndAlpha(0)
					particle:SetStartSize(math.Rand(40,50))
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