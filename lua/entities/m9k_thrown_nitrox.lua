AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Nitro Glycerine"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.DoNotDuplicate = true
ENT.DisableDuplicator = true

function ENT:CanTool() return false end

if SERVER then
	local MetaE = FindMetaTable("Entity")
	local CPPIExists = MetaE.CPPIGetOwner and true or false
	local CachedVector1 = Vector(0,0,-25)
	local angle_zero = Angle(0,0,0) -- Better safe than sorry

	function ENT:Initialize()
		self:PhysicsInit(SOLID_VPHYSICS)
		self.Phys = self:GetPhysicsObject()
	end

	function ENT:Think()

	end

	function ENT:PhysicsCollide(Data) -- Impact sounds and logic
		if Data.Speed > 100 and Data.DeltaTime > 0.1 then
			self:EmitSound("GlassBottle.Break")

			local Pos = self:GetPos()

			util.BlastDamage(self,self.Owner,Pos,300,600) -- This moves objects as well but not that much

			ParticleEffect("nitro_main_m9k",self:LocalToWorld(self:OBBCenter()),angle_zero,nil) -- This effect does not seem to be defined anywhere but it still works :thonking:
			self:EmitSound("ambient/explosions/explode_7.wav",95)
			util.ScreenShake(Pos,500,500,.25,500)
			util.Decal("Scorch",Pos,Pos + CachedVector1,self)

			local CachedOwner = self:GetOwner()
			for _,v in ipairs(ents.FindInSphere(Pos,300)) do -- Explosion makes object move (this respects prop ownership and MMM PVP states)
				local vOwner = CPPIExists and IsValid(v:CPPIGetOwner()) and v:CPPIGetOwner() or IsValid(v:GetOwner()) and v:GetOwner() or NULL

				if CPPIExists and v:CPPIGetOwner() == CachedOwner or (not CPPIExists or (MMM and (IsValid(vOwner) and CachedOwner:IsPVP() and vOwner:IsPVP()))) then
					local Phys = v:GetPhysicsObject()

					if IsValid(Phys) then
						local pTrace = util.TraceLine({
							start = Pos,
							endpos = v:GetPos(),
							filter = self
						})

						if not pTrace.HitWorld then
							Phys:AddVelocity(pTrace.Normal * 400)
						end
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