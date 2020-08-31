AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Nerve Gas"
ENT.Category = "M9K Ammunition"
ENT.Spawnable = true
ENT.AdminOnly = false

if SERVER then
	local MetaE = FindMetaTable("Entity")
	local CPPIExists = MetaE.CPPISetOwner and true or false
	local VectorCache1 = Vector(0,0,10)

	function ENT:Initialize()
		self.Owner = self:GetCreator()

		if IsValid(self.Owner) then -- We NEED to have an owner, otherwise we cannot 'splode
			self.CanSplode = true
		end

		self:SetModel("models/items/ammocrates/cratenervegas.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_NONE)
		self:PhysWake()
		self:SetUseType(SIMPLE_USE)

		timer.Simple(0,function()
			if not IsValid(self) then return end
			self:SetPos(self:GetPos() + VectorCache1)
			self:DropToFloor()
		end)

		self.iHealth = 100
	end

	function ENT:PhysicsCollide(Data)
		if Data.Speed > 80 and Data.DeltaTime > 0.2 then
			self:EmitSound("Wood.ImpactHard")

			if Data.Speed > 350 then
				self.iHealth = self.iHealth - math.Clamp(Data.Speed/20,0,100)
				self:Splode() -- Check if we should 'splode
			end
		end
	end

	function ENT:Use(Activator)
		if Activator:IsPlayer() then
			if Activator:GetWeapon("m9k_nerve_gas") == NULL then
				Activator:Give("m9k_nerve_gas")
				Activator:GiveAmmo(4,"NerveGas")
				Activator:SelectWeapon("m9k_nerve_gas") -- Has no effect in multiplayer in this case but is required in singleplayer!
			else
				Activator:GiveAmmo(5,"NerveGas")
			end

			self:Remove()
		end
	end

	function ENT:OnTakeDamage(dmginfo)
		local dmg = dmginfo:GetDamage()

		if isnumber(dmg) then
			self.iHealth = self.iHealth - dmg
			self:Splode() -- Check if we should 'splode
		end
	end

	function ENT:Splode()
		if not self.CanSplode then return end

		if self.iHealth <= 0 and not self.Sploded then
			self.Sploded = true -- Safeguard
			local Pos = self:GetPos()

			self:EmitSound("physics/wood/wood_plank_break" .. math.random(2,4) .. ".wav")

			for I = 1,5 do
				local DroppedEnt = ents.Create("m9k_nerve_gas")
				timer.Simple(10,function() -- We cannot use SafeRemoveEntityDelayed as it would otherwise delete the weapon a player is holding
					if IsValid(DroppedEnt) and not IsValid(DroppedEnt.Owner) then
						DroppedEnt:Remove()
					end
				end)

				DroppedEnt:SetMaterial("models/weapons/gv/nerve_vial.vmt")
				DroppedEnt:SetPos(Pos + VectorCache1)
				DroppedEnt:SetAngles(AngleRand())
				DroppedEnt:Spawn()
				DroppedEnt:SetCollisionGroup(COLLISION_GROUP_DEBRIS)

				if CPPIExists and IsValid(self.Owner) then
					DroppedEnt:CPPISetOwner(self.Owner)
				end

				local Phys = DroppedEnt:GetPhysicsObject()
				if IsValid(Phys) then
					Phys:SetVelocity(VectorRand(-250,250))
					Phys:AddAngleVelocity(VectorRand(-500,500))
				end
			end

			self:Remove()
		end
	end
end

if CLIENT then
	local LEDColor = Color(230,45,45)
	local VectorCache1 = Vector(0,90,90)
	local Text = "Nerve Gas"

	function ENT:Draw()
		self:DrawModel()

		local FixAngles = self:GetAngles()
		FixAngles:RotateAroundAxis(FixAngles:Right(),VectorCache1.x)
		FixAngles:RotateAroundAxis(FixAngles:Up(),VectorCache1.y)
		FixAngles:RotateAroundAxis(FixAngles:Forward(),VectorCache1.z)

		cam.Start3D2D(self:GetPos() + (self:GetUp() * 8) + (self:GetRight() * 7.25) + (self:GetForward() * 17),FixAngles,0.2)
			draw.SimpleText(Text,"DermaLarge",31,-22,LEDColor,1,1)
		cam.End3D2D()
	end
end