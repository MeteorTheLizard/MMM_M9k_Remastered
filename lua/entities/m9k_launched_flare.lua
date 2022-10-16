AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Flare"
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

	local cCached1 = Color(255,255,255,0)


	ENT.GravGunPickupAllowed = fReturnFalse -- This is Serverside only


	local fCreateFlare = function(self,eTarget)

		if self.eBurnFX then -- Attach to new target
			if not eTarget then return end -- No target??

			self.eBurnFX:SetParent(eTarget)

			self:Remove()

			return
		end


		local eBurnFX = ents.Create("env_flare")
			self.eBurnFX = eBurnFX

			SafeRemoveEntityDelayed(eBurnFX,10)


		if IsValid(eBurnFX) then

			eBurnFX:SetPos(self:GetPos())
			eBurnFX:SetParent(self)
			eBurnFX:SetKeyValue("scale",3)
			eBurnFX:SetKeyValue("duration",10)
			eBurnFX:Spawn()


			eBurnFX:CallOnRemove("M9kr_StopSound",function()
				eBurnFX:StopSound("weapons/flaregun/burn.wav") -- STOP!!
			end)


			eBurnFX:EmitSound("weapons/flaregun/burn.wav",75)

		end
	end


	function ENT:Initialize()

		if not self.M9kr_CreatedByWeapon then -- Prevents exploiting it
			self:Remove()

			return
		end


		SafeRemoveEntityDelayed(self,10)


		self:SetModel("models/hunter/plates/plate.mdl")
		self:SetRenderMode(RENDERMODE_TRANSALPHA)
		self:SetColor(cCached1)

		self:Use(self,self,USE_SET,1)
		self:SetTrigger(true)

		self:PhysicsInit(SOLID_VPHYSICS)


		fCreateFlare(self)


		timer.Simple(0,function() -- For some dumb reason this has to happen in the next tick
			if not IsValid(self) then return end

			ParticleEffectAttach("Rocket_Smoke_Trail",PATTACH_ABSORIGIN_FOLLOW,self,0)

		end)
	end


	local fBurnObject = function(self,eTarget)

		fCreateFlare(self,eTarget)

		eTarget:Ignite(10)

		self:Remove()

	end


	function ENT:StartTouch(eTouched)
		if not eTouched:IsNPC() then return end

		fBurnObject(self,eTouched)
	end
end


if CLIENT then

	function ENT:Initialize()

		self.obj_Light = DynamicLight(self:EntIndex()) -- Create the light.. once.

		if self.obj_Light then
			self.obj_Light.Pos = self:GetPos()
			self.obj_Light.r = 255
			self.obj_Light.G = 55
			self.obj_Light.B = 55
			self.obj_Light.Brightness = 3
			self.obj_Light.Size = 10000
			self.obj_Light.Decay = 1
			self.obj_Light.DieTime = CurTime() + 10
		end
	end


	function ENT:Draw()
		self:DrawModel()
	end


	function ENT:OnRemove() -- Remove the light instantly
		if self.obj_Light then
			self.obj_Light.DieTime = 0
		end
	end


	function ENT:Think()
		if self.obj_Light then
			self.obj_Light.Pos = self:GetPos()
		end
	end
end