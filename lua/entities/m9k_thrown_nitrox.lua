AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Nitro Glycerine"
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


game.AddParticles("particles/nitro_main.pcf")


if SERVER then

	local utilTraceLine = util.TraceLine -- Optimization

	local vCached1 = Vector(0,0,-1)
	local angle_zero = Angle(0,0,0) -- Who knows if someone messed with it.


	function ENT:Initialize()

		if not self.M9kr_CreatedByWeapon then -- Prevents exploiting it
			self:Remove()

			return
		end


		self:PhysicsInit(SOLID_VPHYSICS)

	end


	function ENT:PhysicsCollide(obj_Data)

		if obj_Data.Speed > 100 and obj_Data.DeltaTime > 0.1 then

			self.PhysicsCollide = nil -- Don't explode twice.

			self:EmitSound("physics/glass/glass_bottle_break" .. math.random(2) .. ".wav")


			local vPos = self:GetPos()


			ParticleEffect("nitro_main_m9k",self:LocalToWorld(self:OBBCenter()),angle_zero,nil)

			self:EmitSound("ambient/explosions/explode_7.wav",95)


			util.ScreenShake(vPos,500,500,.25,500)
			util.Decal("Scorch",vPos,vPos + vCached1,self)

			util.BlastDamage(self,self.Owner,vPos,300,600)


			for _,v in ipairs(ents.FindInSphere(vPos,300)) do -- Explosion makes object move (this respects prop ownership and MMM PVP states)

				local obj_Phys = v:GetPhysicsObject()


				if IsValid(obj_Phys) then

					local pTrace = utilTraceLine({
						start = vPos,
						endpos = v:GetPos(),
						filter = self
					})

					if not pTrace.HitWorld then
						obj_Phys:AddVelocity(pTrace.Normal * 400)
					end
				end
			end


			self:Remove()

		end
	end
end

if CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end
end