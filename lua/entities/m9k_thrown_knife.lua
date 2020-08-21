AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Machete"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.DoNotDuplicate = true
ENT.DisableDuplicator = true

function ENT:CanTool() return false end

if SERVER then
	local MetaE = FindMetaTable("Entity")
	local CPPIExists = MetaE.CPPIGetOwner and true or false
	local vector_zero = Vector(0,0,0) -- Imagine having MMM
	local VectorCache1 = Vector(0,10,0)
	local effectData = EffectData()
	effectData:SetScale(1)

	local BodyHitSounds = {
		"physics/metal/metal_grenade_impact_hard1.wav",
		"physics/metal/metal_grenade_impact_hard2.wav",
		"physics/metal/metal_grenade_impact_hard3.wav"
	}

	function ENT:Initialize()
		self:PhysicsInit(SOLID_VPHYSICS)
		self.Phys = self:GetPhysicsObject()

		self.InFlight = true
		self.NextSound = CurTime()

		self:SetUseType(SIMPLE_USE)
	end

	function ENT:Think()
		if self.InFlight and self:GetAngles().p <= 55 then
			self.Phys:AddAngleVelocity(VectorCache1)
		end
	end

	function ENT:Use(Activator)
		if Activator:IsPlayer() and Activator == self.PickupOwner and Activator:GetWeapon("m9k_machete") == NULL then
			Activator:Give("m9k_machete")
			self:Remove()
		end
	end

	function ENT:PhysicsCollide(Data) -- Impact sounds and logic
		local Pos = self:GetPos()
		local Ang = self:GetAngles()

		local tTrace = util.TraceHull({
			start = Pos,
			endpos = Pos + Ang:Forward() * 100,
			filter = self
		})

		if tTrace.Hit then

			-- The function calls are put within a one-tick timer to prevent the 'Changing collision rules within a callback is likely to cause crashes!' error

			if IsValid(tTrace.Entity) then
				local CachedOwner = self:GetOwner()
				local vOwner = CPPIExists and IsValid(tTrace.Entity:CPPIGetOwner()) and tTrace.Entity:CPPIGetOwner() or IsValid(tTrace.Entity:GetOwner()) and tTrace.Entity:GetOwner() or NULL

				if tTrace.Entity:IsPlayer() and (MMM and tTrace.Entity:IsPVP() and self.Owner:IsPVP() or not MMM) then -- If we hit a player
					timer.Simple(0,function()
						if not IsValid(self) or not IsValid(tTrace.Entity) then return end
						self.InFlight = false

						self.Phys:SetVelocity(vector_zero)
						self:SetCollisionGroup(COLLISION_GROUP_WEAPON)

						tTrace.Entity:TakeDamage(80,self.Owner,self)

						effectData:SetStart(Data.HitPos)
						effectData:SetOrigin(Data.HitPos)
						util.Effect("BloodImpact",effectData)

						util.Decal("Blood",Data.HitPos - Data.HitNormal,Data.HitPos + Data.HitNormal,self)
						self:EmitSound(table.Random(BodyHitSounds))
						self:EmitSound("weapons/blades/impact.mp3")
					end)

					self.PhysicsCollide = nil
				elseif CPPIExists and tTrace.Entity:CPPIGetOwner() == CachedOwner or (not CPPIExists or (MMM and (IsValid(vOwner) and CachedOwner:IsPVP() and vOwner:IsPVP()))) then
					timer.Simple(0,function()
						if not IsValid(self) or not IsValid(tTrace.Entity) then return end
						self.InFlight = false

						self.Phys:EnableMotion(false)
						self:SetCollisionGroup(COLLISION_GROUP_WEAPON)

						tTrace.Entity:TakeDamage(80,self.Owner,self)

						if tTrace.Entity:GetClass() == "prop_ragdoll" or tTrace.Entity:IsNPC() then
							effectData:SetStart(Data.HitPos)
							effectData:SetOrigin(Data.HitPos)
							util.Effect("BloodImpact",effectData)

							util.Decal("Blood",Data.HitPos - Data.HitNormal,Data.HitPos + Data.HitNormal,self)
							self:EmitSound(table.Random(BodyHitSounds))
						end

						self:EmitSound("weapons/blades/impact.mp3")

						if tTrace.Entity:Health() < 0 then -- If we killed the target we want to drop to the ground! ( < 0 is intentional so that it can stick to unbreakable props)
							self.PickupOwner = self:GetOwner()
							self.Phys:EnableMotion(true)
							self:SetCollisionGroup(COLLISION_GROUP_NONE)
							self.Phys:SetVelocity(vector_zero)
						else
							self:SetParent(tTrace.Entity)
						end
					end)

					self.PhysicsCollide = nil
				end
			elseif tTrace.HitWorld then
				timer.Simple(0,function()
					if not IsValid(self) then return end
					self.InFlight = false

					self.Phys:EnableMotion(false)
					self:SetCollisionGroup(COLLISION_GROUP_WEAPON)

					self.PickupOwner = self:GetOwner()

					util.Decal("Impact.Concrete",Data.HitPos - Data.HitNormal,Data.HitPos + Data.HitNormal,self)
					self:EmitSound("weapons/blades/impact.mp3")
				end)

				self.PhysicsCollide = nil
			end
		elseif self.InFlight and Data.Speed > 10 and Data.DeltaTime > 0.1 and self.NextSound < CurTime() then -- Impact sounds
			self:EmitSound("physics/metal/metal_grenade_impact_hard" .. math.random(1,3) .. ".wav",65)
			self.NextSound = CurTime() + 0.2
		end
	end
end

if CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end
end