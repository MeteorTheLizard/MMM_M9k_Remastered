AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Nerve Gas"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.DoNotDuplicate = true
ENT.DisableDuplicator = true

function ENT:CanTool() return false end

if SERVER then
	local CachedColor1 = Color(255,255,255,0)
	local effectData = EffectData()

	function ENT:Initialize()
		self:PhysicsInit(SOLID_VPHYSICS)
		self.Phys = self:GetPhysicsObject()
	end

	function ENT:PhysicsCollide(Data) -- Impact sounds
		if Data.Speed > 50 and Data.DeltaTime > 0.1 then
			self.PhysicsCollide = nil -- Stop collide logic
			SafeRemoveEntityDelayed(self,18)

			self:EmitSound("GlassBottle.Break")

			local Pos = self:GetPos()

			-- Instead of creating a new entity to do the damage logic we keep the nerve gas grenade and make it the source of the damage!
			self:SetRenderMode(RENDERMODE_TRANSALPHA)
			self:SetColor(CachedColor1)
			self:DrawShadow(false)

			self.Phys:EnableMotion(false)
			self.ExplodePos = Pos
			self.DidBreak = true

			effectData:SetOrigin(Pos)

			-- NEW! When this is thrown into the flames of a Molotov/Incendiary from the Throwables extension, it causes a huge explosion!
			for _,v in ipairs(ents.FindInSphere(Pos,200)) do
				if v:GetClass() == "m9k_mmm_flame" then
					timer.Simple(0,function() -- This needs to be delayed by one tick to prevent the 'Changing collision rules within a callback is likely to cause crashes!' error!
						if not IsValid(self) then return end

						for I = 1,10 do
							local EffectCarrier = ents.Create("prop_physics")
							SafeRemoveEntityDelayed(EffectCarrier,2)
							EffectCarrier:SetModel("models/hunter/plates/plate.mdl")
							EffectCarrier:SetPos(Pos)
							EffectCarrier:Spawn()
							EffectCarrier:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
							EffectCarrier:SetRenderMode(RENDERMODE_TRANSALPHA)
							EffectCarrier:SetColor(CachedColor1)
							EffectCarrier:DrawShadow(false)

							local Phys = EffectCarrier:GetPhysicsObject()
							if IsValid(Phys) then
								Phys:SetMass(100)
								Phys:SetVelocity(Vector(math.random(-250,250),math.random(-250,250),350))
							end

							ParticleEffectAttach("fire_large_01",PATTACH_ABSORIGIN_FOLLOW,EffectCarrier,0)
						end

						self:EmitSound("ambient/explosions/explode_" .. math.random(7,9) .. ".wav",90)
						util.BlastDamage(self,IsValid(self.Owner) and self.Owner or self,self.ExplodePos,350,120)

						self:Remove() -- We do not want a poison effect
					end)

					return -- Do not create the effect and stop the loop
				end
			end

			effectData:SetOrigin(Pos)
			util.Effect("m9k_released_nerve_gas",effectData)
		end
	end

	function ENT:Think()
		if self.DidBreak then
			util.BlastDamage(self,IsValid(self.Owner) and self.Owner or self,self.ExplodePos,225,70)
		end
	end
end

if CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end
end