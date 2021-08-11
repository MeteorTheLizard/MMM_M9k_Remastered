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
		burnFX:SetKeyValue("duration",10)
		burnFX:Spawn()

		SafeRemoveEntityDelayed(burnFX,10)

		self.sSound = CreateSound(burnFX,"weapons/flaregun/burn.wav")
			self.sSound:Play()

		timer.Simple(0,function() -- For some dumb reason this has to happen in the next tick
			if not IsValid(self) then return end

			ParticleEffectAttach("Rocket_Smoke_Trail",PATTACH_ABSORIGIN_FOLLOW,self,0)
		end)
	end

	function ENT:OnRemove()
		if self.sSound then
			self.sSound:Stop()
		end
	end

	local BurnEntity = function(Ent,Target)
		local burnFX = ents.Create("env_flare")
		burnFX:SetPos(Ent:GetPos())
		burnFX:SetParent(Target)
		burnFX:SetKeyValue("scale",3)
		burnFX:SetKeyValue("duration",10)
		burnFX:Spawn()

		SafeRemoveEntityDelayed(burnFX,10)

		Target:Ignite(10)

		local sSound = CreateSound(burnFX,"weapons/flaregun/burn.wav")
			sSound:Play()

		timer.Simple(10,function()
			if sSound then
				sSound:Stop()
			end
		end)

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

	function ENT:Think()
		local iCurTime = CurTime()

		local PhysLight = DynamicLight(self:EntIndex())

		if PhysLight then
			PhysLight.Pos = self:GetPos()
			PhysLight.r = 255
			PhysLight.G = 55
			PhysLight.B = 55
			PhysLight.Brightness = 3
			PhysLight.Size = 20000
			PhysLight.Decay = 2500
			PhysLight.DieTime = iCurTime + 0.1
		end

		self:SetNextClientThink(iCurTime)
		return true
	end
end