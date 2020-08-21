AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "MMM Launched Flare Object"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.DoNotDuplicate = true
ENT.DisableDuplicator = true

if SERVER then
	local MetaE = FindMetaTable("Entity")
	local CPPIExists = MetaE.CPPIGetOwner and true or false
	local ColorCache1 = Color(255,255,255,0)

	function ENT:Initialize()
		self:SetModel("models/hunter/plates/plate.mdl")
		self:SetRenderMode(RENDERMODE_TRANSALPHA)
		self:SetColor(ColorCache1)

		self:Use(self,self,USE_SET,1)
		self:SetTrigger(true)

		self:PhysicsInit(SOLID_VPHYSICS)

		local burnFX = ents.Create("env_flare")
		burnFX:SetPos(self:GetPos())
		burnFX:SetParent(self)
		burnFX:SetKeyValue("scale",3)
		burnFX:SetKeyValue("duration",30)
		burnFX:Spawn()

		SafeRemoveEntityDelayed(burnFX,30)
	end

	local BurnEntity = function(Ent,Target)
		local burnFX = ents.Create("env_flare")
		burnFX:SetPos(Ent:GetPos())
		burnFX:SetParent(Target)
		burnFX:SetKeyValue("scale",3)
		burnFX:SetKeyValue("duration",30)
		burnFX:Spawn()

		SafeRemoveEntityDelayed(burnFX,30)

		Target:Ignite(30)

		Ent:Remove()
	end

	function ENT:StartTouch(v)
		if v:IsNPC() and (CPPIExists and v:CPPIGetOwner() == self.Owner or not CPPIExists) or v:IsPlayer() and (MMM and v:IsPVP() and self.Owner:IsPVP() or not MMM) then
			BurnEntity(self,v)
		elseif MMM and v:GetClass() == "prop_ragdoll" and ((CPPIExists and v:CPPIGetOwner() == self.Owner or not CPPIExists) or (v:GetOwner():IsPVP() and self.Owner:IsPVP())) then -- MMM Compat
			BurnEntity(self,v)
		end
	end
end

if CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end
end