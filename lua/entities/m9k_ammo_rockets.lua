AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "RPG Rockets"
ENT.Category = "M9K Ammunition"
ENT.Spawnable = true
ENT.AdminOnly = false

if SERVER then
	local VectorCache1 = Vector(0,0,10)
	local effectData = EffectData()

	function ENT:Initialize()
		self.Owner = self:GetCreator()

		if IsValid(self.Owner) then -- We NEED to have an owner, otherwise we cannot 'splode
			self.CanSplode = true
		end

		self:SetModel("models/items/ammocrates/craterockets.mdl")
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
			Activator:GiveAmmo(3,"RPG_Round")
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
			self.Sploded = true -- Safeguard since BlastDamage causes an infinite loop otherwise
			local Pos = self:GetPos()

			self:EmitSound("physics/wood/wood_plank_break" .. math.random(2,4) .. ".wav")

			util.BlastDamage(self,self.Owner,Pos,600,150)

			effectData:SetMagnitude(18)
			effectData:SetScale(1.3)
			effectData:SetOrigin(Pos)
			effectData:SetRadius(1)

			util.Effect("m9k_gdcw_tpaboom",effectData)
			util.ScreenShake(Pos,10,5,1,3000)
			util.Decal("Scorch",Pos + VectorCache1,Pos - VectorCache1,self)

			self:Remove()
		end
	end
end

if CLIENT then
	language.Add("RPG_round_ammo","RPG Rocket")

	local LEDColor = Color(230,45,45)
	local VectorCache1 = Vector(0,90,90)
	local Text = "RPG Rockets"

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