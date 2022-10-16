AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Nerve Gas"
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


	function ENT:Initialize()

		if not self.M9kr_CreatedByWeapon then -- Prevents exploiting it
			self:Remove()

			return
		end


		self:PhysicsInit(SOLID_VPHYSICS)

	end


	function ENT:PhysicsCollide(obj_Data)

		if obj_Data.Speed > 50 and obj_Data.DeltaTime > 0.1 then

			self.PhysicsCollide = nil -- Hyper-sensitive, one touch = woop it broke!

			SafeRemoveEntityDelayed(self,18)


			self:EmitSound("physics/glass/glass_bottle_break" .. math.random(2) .. ".wav")


			self:SetNoDraw(true) -- Stop networking to client (makes it invisible)

			local obj_Phys = self:GetPhysicsObject()

			if IsValid(obj_Phys) then
				obj_Phys:EnableMotion(false)
			end


			local vPos = self:GetPos()

			self.vPos = vPos
			self.bBroke = true -- It broke! RUN COWARDS!


			local obj_EffectData = EffectData()
			obj_EffectData:SetOrigin(vPos)

			util.Effect("m9k_released_nerve_gas",obj_EffectData)


			for _,v in ipairs(ents.FindInSphere(vPos,200)) do -- When thrown into fire from Molotov/Incendiaries from the Throwables extension, explode!

				if v:GetClass() == "m9k_mmm_flame" then

					timer.Simple(0,function() -- This needs to be delayed by one tick to prevent the 'Changing collision rules within a callback is likely to cause crashes!' error!

						if not IsValid(self) then return end


						for I = 1,10 do

							local eEffect = ents.Create("prop_physics")

								SafeRemoveEntityDelayed(eEffect,2)

							if IsValid(eEffect) then

								eEffect:SetModel("models/hunter/plates/plate.mdl")
								eEffect:SetPos(vPos)
								eEffect:Spawn()

								eEffect:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
								eEffect:SetRenderMode(RENDERMODE_TRANSALPHA)
								eEffect:SetColor(cCached1)

								eEffect:DrawShadow(false)

								local obj_Phys = eEffect:GetPhysicsObject()

								if IsValid(obj_Phys) then
									obj_Phys:SetMass(100)
									obj_Phys:SetVelocity(Vector(math.random(-250,250),math.random(-250,250),350))
								end

								ParticleEffectAttach("fire_large_01",PATTACH_ABSORIGIN_FOLLOW,eEffect,0)

							end
						end


						self:EmitSound("ambient/explosions/explode_" .. math.random(7,9) .. ".wav",90)

						util.BlastDamage(self,IsValid(self.Owner) and self.Owner or self,self.vPos,350,120)


						self:Remove() -- It exploded, so there is no nerve gas left!

					end)


					return

				end
			end
		end
	end


	function ENT:Think()

		if not IsValid(self.Owner) then
			self:Remove()

			return
		end


		if self.bBroke then -- Damage stuff where it broke
			util.BlastDamage(self,self.Owner,self.vPos,225,70)
		end
	end
end


if CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end
end