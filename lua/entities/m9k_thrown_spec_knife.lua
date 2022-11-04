AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Knife"
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

	ENT.GravGunPickupAllowed = fReturnFalse -- This is Serverside only


	local fGetStuck = function(self,tTrace)

		local obj_Phys = self:GetPhysicsObject()

		if IsValid(obj_Phys) then
			obj_Phys:EnableMotion(false)
		end


		self:SetCollisionGroup(COLLISION_GROUP_WEAPON)


		util.Decal("Impact.Concrete",tTrace.HitPos - tTrace.HitNormal,tTrace.HitPos + tTrace.HitNormal,self)

		self:EmitSound("weapons/blades/impact.mp3")


		-- This might seem weird but yeah, we do that here to save a lot of bytes.

		if self:GetClass() == "m9k_thrown_harpoon" then -- This makes Harpoons actually stick in the surface.
			self:SetPos(self:GetPos() + self:GetAngles():Forward() * 10)

			self:SetCollisionGroup(COLLISION_GROUP_NONE) -- Make them climbable
		end


		self:SetOwner(nil)

	end


	local fApplyDamage = function(self,tTrace,eEnt)

		local obj_EffectData = EffectData()
		obj_EffectData:SetScale(1)
		obj_EffectData:SetStart(tTrace.HitPos)
		obj_EffectData:SetOrigin(tTrace.HitPos)

		util.Effect("BloodImpact",obj_EffectData)

		util.Decal("Blood",tTrace.HitPos - tTrace.HitNormal,tTrace.HitPos + tTrace.HitNormal,self)


		self:EmitSound("physics/flesh/flesh_impact_bullet" .. math.random(5) .. ".wav")


		eEnt:TakeDamage(80,self.Owner,self)


		if (eEnt:Health() - 80) <= 0 then -- They died so we drop to the floor


			self:SetCollisionGroup(COLLISION_GROUP_WEAPON)


			self.Think = nil -- Stop thinking!
			self.PhysicsCollide = nil

			return

		end


		self:Remove() -- They didn't die so we remove ourselves

	end


	ENT.iNextSound = 0

	ENT.vStartForwardOffset = 6.5
	ENT.vStartUpOffset = 6.5

	ENT.vEndForwardOffset = 10
	ENT.vEndUpOffset = 10


	function ENT:Initialize()

		if not self.M9kr_CreatedByWeapon then -- Prevents exploiting it
			self:Remove()

			return
		end


		self:PhysicsInit(SOLID_VPHYSICS)

		self:SetUseType(SIMPLE_USE)


		self.tFilters = {self,self.Owner} -- Don't recreate this over and over again.

	end


	function ENT:Use(eActivator) -- We may pick the Knife back up
		if eActivator:IsPlayer() and eActivator:GetWeapon("m9k_knife") == NULL then
			eActivator:Give("m9k_knife")

			self:Remove()
		end
	end


	function ENT:Think()


		local vPos = self:GetPos()
		local aAng = self:GetAngles()

		local tTrace = util.TraceLine({
			start = vPos + aAng:Forward() * self.vStartForwardOffset + aAng:Up() * self.vStartUpOffset,
			endpos = vPos + aAng:Forward() * self.vEndForwardOffset + aAng:Up() * self.vEndUpOffset,
			filter = self.tFilters
		})


		if tTrace.Hit then


			if tTrace.HitWorld then -- Get stuck in world geometry

				fGetStuck(self,tTrace)


				self.Think = nil -- Stop thinking!
				self.PhysicsCollide = nil

				return

			end


			-- If we hit an entity, make it take damage.

			local eEnt = tTrace.Entity


			if IsValid(eEnt) then

				if eEnt:IsPlayer() or eEnt:IsNPC() then -- Blood splat

					fApplyDamage(self,tTrace,eEnt)

					return

				else -- Get stuck in Entities

					fGetStuck(self,tTrace)

					self:SetParent(eEnt)


					eEnt:TakeDamage(80,self.Owner,self) -- They got stuck so deal damage!


					if eEnt:GetClass() == "prop_ragdoll" then -- It's a ragdoll so do blood stuff
						fApplyDamage(self,tTrace,eEnt)
					end
				end
			end


			self.Think = nil -- Stop thinking!
			self.PhysicsCollide = nil

			return

		end


		self:NextThink(CurTime())
		return true
	end


	function ENT:PhysicsCollide(obj_Data)

		if self.iNextSound < CurTime() then
			self:EmitSound("physics/metal/metal_grenade_impact_hard" .. math.random(3) .. ".wav",65)

			self.iNextSound = CurTime() + 0.1
		end


		if IsValid(obj_Data.HitEntity) and (obj_Data.HitEntity:IsPlayer() or obj_Data.HitEntity:IsNPC()) then -- Hit a player / NPC
			fApplyDamage(self,obj_Data,obj_Data.HitEntity)
		end
	end
end


if CLIENT then

	function ENT:Draw()

		self:DrawModel()

		--[[ Visualize TraceLine (Requires vars to be set in ENT.Initialize on the CLIENT)
		local vPos = self:GetPos()
		local aAng = self:GetAngles()

		cam.Start3D()
			render.DrawLine(vPos + aAng:Forward() * self.vStartForwardOffset + aAng:Up() * self.vStartUpOffset,vPos + aAng:Forward() * self.vEndForwardOffset + aAng:Up() * self.vEndUpOffset)
		cam.End3D()
		]]

	end
end