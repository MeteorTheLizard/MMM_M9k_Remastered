AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Frag Grenade"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.DoNotDuplicate = true
ENT.DisableDuplicator = true

function ENT:CanTool() return false end

if SERVER then
	local CachedVector1 = Vector(0,0,1)
	local CachedVector2 = Vector(0,0,-25)

	function ENT:Initialize()
		self:PhysicsInit(SOLID_VPHYSICS)
		self.Phys = self:GetPhysicsObject()

		self.TimeLeft = CurTime() + 3
		self.NextSound = CurTime()
	end

	function ENT:Think()
		if self.TimeLeft < CurTime() then
			local Pos = self:GetPos()
			local effectData = EffectData()

			effectData:SetNormal(CachedVector1)
			effectData:SetEntity(self)
			effectData:SetOrigin(Pos)
			effectData:SetStart(Pos)
			util.Effect("cball_explode",effectData)
			util.Effect("Explosion",effectData)

			effectData:SetOrigin(Pos)
			effectData:SetScale(500)
			effectData:SetMagnitude(500)
			util.Effect("ThumperDust",effectData)

			effectData:SetMagnitude(3)
			effectData:SetRadius(8)
			effectData:SetScale(5)
			util.Effect("Sparks",effectData)

			util.BlastDamage(self,self.Owner,Pos,350,100)
			util.ScreenShake(Pos,500,500,1.25,500)
			util.Decal("Scorch",Pos,Pos + CachedVector2,self)

			self:Remove()
		end
	end

	function ENT:PhysicsCollide(Data) -- Impact sounds
		if Data.Speed > 100 and Data.DeltaTime > 0.1 and self.NextSound < CurTime() then
			self:EmitSound("weapons/hegrenade/he_bounce-1.wav")
			self.NextSound = CurTime() + 0.2
		end
	end
end

if CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end
end