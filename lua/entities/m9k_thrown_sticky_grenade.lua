AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Sticky Grenade"
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

	local utilEffect = util.Effect -- Optimization

	local cCached1 = Vector(0,0,1)
	local cCached2 = Vector(0,0,-25)


	function ENT:Initialize()

		if not self.M9kr_CreatedByWeapon then -- Prevents exploiting it
			self:Remove()

			return
		end


		self:PhysicsInit(SOLID_VPHYSICS)

		self:SetTrigger(true) -- Required for StartTouch


		self.iLifeTime = CurTime() + 3
		self.iNextSound = 0
		self.bSticking = false


		SafeRemoveEntityDelayed(self,3.1) -- Just in case

	end


	function ENT:Think()

		if self.iLifeTime < CurTime() then

			local vPos = self:GetPos()


			local obj_EffectData = EffectData()

			obj_EffectData:SetNormal(cCached1)
			obj_EffectData:SetEntity(self)
			obj_EffectData:SetOrigin(vPos)
			obj_EffectData:SetStart(vPos)

			utilEffect("cball_explode",obj_EffectData)
			utilEffect("Explosion",obj_EffectData)

			obj_EffectData:SetOrigin(vPos)
			obj_EffectData:SetScale(500)
			obj_EffectData:SetMagnitude(500)

			utilEffect("ThumperDust",obj_EffectData)

			obj_EffectData:SetMagnitude(3)
			obj_EffectData:SetRadius(8)
			obj_EffectData:SetScale(5)

			utilEffect("Sparks",obj_EffectData)


			util.ScreenShake(vPos,500,500,1.25,500)

			util.Decal("Scorch",vPos,vPos + cCached2,self)

			util.BlastDamage(self,self.Owner,vPos,350,100)


			self:EmitSound("ambient/explosions/explode_" .. math.random(4) .. ".wav",100)


			self:Remove()

		end
	end


	function ENT:StartTouch(eEnt) -- Stick to object (Better than using PhysicsCollide)
		if eEnt == self.Owner then return end

		self.StartTouch = nil -- We be sticking.


		if eEnt:IsPlayer() or eEnt:IsNPC() then
			self:SetParent(eEnt)
			self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)

			return
		end


		constraint.Weld(eEnt,self,0,0,0,true) -- Weld if Havok.

	end


	function ENT:PhysicsCollide(obj_Data)

		if self.iNextSound < CurTime() and obj_Data.Speed > 100 and obj_Data.DeltaTime > 0.1 then

			self:EmitSound("weapons/hegrenade/he_bounce-1.wav")

			self.iNextSound = CurTime() + 0.1

		end
	end


	function ENT:OnTakeDamage(obj_DamageInfo) -- Make it explode on taking damage
		self.iLifeTime = 0 -- Automatically prevents all of them exploding in the same tick (Optimizations!)
	end
end


if CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end
end