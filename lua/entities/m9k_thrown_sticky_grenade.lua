AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Sticky Grenade"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.DoNotDuplicate = true
ENT.DisableDuplicator = true

function ENT:CanTool() return false end

if SERVER then
	local MetaE = FindMetaTable("Entity")
	local CPPIExists = MetaE.CPPIGetOwner and true or false
	local CachedVector1 = Vector(0,0,1)
	local CachedVector2 = Vector(0,0,-25)

	function ENT:Initialize()
		self:PhysicsInit(SOLID_VPHYSICS)
		self.Phys = self:GetPhysicsObject()

		self:SetTrigger(true)

		self.TimeLeft = CurTime() + 3
		self.NextSound = CurTime()
		self.IsSticking = false
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

			util.BlastDamage(self,self.Owner,Pos,220,220)
			util.ScreenShake(Pos,500,500,1.25,500)

			self:EmitSound("ambient/explosions/explode_" .. math.random(1,4) .. ".wav",Pos,100)
			self:Remove()
		end
	end

	-- This function is heavily influenced by MMM and its PVP mode as well as CPPI functions.
	-- This is fully compatible with non-MMM environment servers as well as with servers that do not have prop protection addon(s)

	function ENT:StartTouch(Ent) -- Stick to object (Better than using PhysicsCollide)
		if Ent == self.Owner then return end
		local EntOwner = CPPIExists and Ent:CPPIGetOwner() or IsValid(Ent.Owner) and Ent.Owner or IsValid(Ent:GetOwner()) and Ent:GetOwner() or NULL

		if Ent:IsPlayer() and (MMM and self.Owner:IsPVP() and Ent:IsPVP() or not MMM) or (Ent:IsNPC() and (CPPIExists and Ent:CPPIGetOwner() == self:GetOwner() or not CPPIExists)) then
			self:SetParent(Ent)
			self:SetCollisionGroup(COLLISION_GROUP_DEBRIS) -- NPCs and Players should not get stuck inside a sticky nade!
		elseif not self.IsSticking and (CPPIExists and Ent:CPPIGetOwner() == self:GetOwner() or (MMM and self.Owner:IsPVP() and (IsValid(EntOwner) and EntOwner:IsPVP()) or not MMM)) or not CPPIExists then
			constraint.Weld(Ent,self,0,0,0,true)
			self.IsSticking = true
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