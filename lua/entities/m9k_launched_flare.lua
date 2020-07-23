AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "MMM Launched Flare Object"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.DoNotDuplicate = true
ENT.DisableDuplicator = true

if SERVER then
	local ColorCache1 = Color(255,255,255,0)

	function ENT:Initialize()
		self:SetModel("models/hunter/plates/plate.mdl")
		self:SetRenderMode(RENDERMODE_TRANSALPHA)
		self:SetColor(ColorCache1)

		self:Use(self,self,USE_SET,1)
		self:SetTrigger(true)

		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_WEAPON)

		local burnFX = ents.Create("env_flare")
		burnFX:SetPos(self:GetPos())
		burnFX:SetParent(self)
		burnFX:SetKeyValue("scale",3)
		burnFX:SetKeyValue("duration",30)
		burnFX:Spawn()
	end

	local BurnEntity = function(Ent,Target)
		local burnFX = ents.Create("env_flare")
		burnFX:SetPos(Ent:GetPos())
		burnFX:SetParent(Target)
		burnFX:SetKeyValue("scale",3)
		burnFX:SetKeyValue("duration",30)
		burnFX:Spawn()

		Target:Ignite(30)

		SafeRemoveEntityDelayed(Target,30)

		Ent:Remove()
	end

	function ENT:StartTouch(v)
		if v:IsNPC() then
			BurnEntity(self,v)
		elseif MMM and v:GetClass() == "prop_ragdoll" then -- MMM Compat
			BurnEntity(self,v)
		end
	end
end

if CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end
end