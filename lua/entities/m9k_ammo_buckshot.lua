AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Shotgun Ammo"
ENT.Category = "M9K Ammunition"
ENT.Spawnable = true
ENT.AdminOnly = false

if CLIENT then
	language.Add("Buckshot_ammo","Shotgun Ammo")
end

if SERVER then
	local VectorCache1 = Vector(0,0,10)

	function ENT:Initialize()
		self:SetModel("models/items/boxbuckshot.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		self:PhysWake()
		self:SetUseType(SIMPLE_USE)

		timer.Simple(0,function()
			if not IsValid(self) then return end
			self:SetPos(self:GetPos() + VectorCache1)
			self:DropToFloor()
		end)
	end

	function ENT:PhysicsCollide(Data)
		if Data.Speed > 80 and Data.DeltaTime > 0.2 then
			self:EmitSound("Default.ImpactSoft")
		end
	end

	function ENT:Use(Activator)
		if Activator:IsPlayer() then
			Activator:GiveAmmo(8,"buckshot")
			self:Remove()
		end
	end
end

if CLIENT then
	local LEDColor = Color(230,45,45,255)
	local VectorCache1 = Vector(0,90,90)
	local Text = "Shotgun Ammo"

	function ENT:Draw()
		self:DrawModel()

		local FixAngles = self:GetAngles()
		FixAngles:RotateAroundAxis(FixAngles:Right(),VectorCache1.x)
		FixAngles:RotateAroundAxis(FixAngles:Up(),VectorCache1.y)
		FixAngles:RotateAroundAxis(FixAngles:Forward(),VectorCache1.z)

		cam.Start3D2D(self:GetPos() + (self:GetUp() * 3) + (self:GetRight() * 2) + (self:GetForward() * 4),FixAngles,.07)
			draw.SimpleText(Text,"DermaLarge",31,-22,LEDColor,1,1)
		cam.End3D2D()
	end
end