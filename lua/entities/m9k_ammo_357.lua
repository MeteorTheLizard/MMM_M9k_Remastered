AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = ".357 Ammo"
ENT.Category = "M9K Ammunition"
ENT.Spawnable = true
ENT.AdminOnly = false

if CLIENT then
	language.Add("357_ammo",".357 Ammo")
end

if SERVER then
	local VectorCache1 = Vector(0,0,10)
	local AngleCache1 = Angle(0,180,0)

	function ENT:Initialize()
		self:SetModel("models/items/357ammo.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_NONE)
		self:PhysWake()
		self:SetUseType(SIMPLE_USE)

		timer.Simple(0,function()
			if not IsValid(self) then return end
			self:SetPos(self:GetPos() + VectorCache1)
			self:SetAngles(self:GetAngles() + AngleCache1)
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
			Activator:GiveAmmo(12,"357")
			self:Remove()
		end
	end
end

if CLIENT then
	local LEDColor = Color(230,45,45)
	local VectorCache1 = Vector(48,-90,0)
	local Text = ".357 Ammo"

	function ENT:Draw()
		self:DrawModel()

		local FixAngles = self:GetAngles()
		FixAngles:RotateAroundAxis(FixAngles:Right(),VectorCache1.x)
		FixAngles:RotateAroundAxis(FixAngles:Up(),VectorCache1.y)
		FixAngles:RotateAroundAxis(FixAngles:Forward(),VectorCache1.z)

		cam.Start3D2D(self:GetPos() + self:GetUp() + (self:GetRight() * -2.5) + (self:GetForward() * -6.5),FixAngles,.07)
			draw.SimpleText(Text,"DermaLarge",31,-22,LEDColor,1,1)
		cam.End3D2D()
	end
end