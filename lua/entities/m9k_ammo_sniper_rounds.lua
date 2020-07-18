AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Sniper Ammo"
ENT.Category = "M9K Ammunition"
ENT.Spawnable = true
ENT.AdminOnly = false

if CLIENT then
	language.Add("SniperPenetratedRound_ammo","Sniper Ammo")
end

if SERVER then
	local VectorCache1 = Vector(0,0,10)
	local AngleCache1 = Angle(90,-90,180)

	function ENT:Initialize()
		self:SetModel("models/items/sniper_round_box.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
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
			Activator:GiveAmmo(8,"SniperPenetratedRound")
			self:Remove()
		end
	end
end

if CLIENT then
	local LEDColor = Color(230,45,45,255)
	local VectorCache1 = Vector(90,0,0)
	local Text = "Sniper Ammo"

	function ENT:Draw()
		self:DrawModel()

		local FixAngles = self:GetAngles()
		FixAngles:RotateAroundAxis(FixAngles:Right(),VectorCache1.x)
		FixAngles:RotateAroundAxis(FixAngles:Up(),VectorCache1.y)
		FixAngles:RotateAroundAxis(FixAngles:Forward(),VectorCache1.z)

		cam.Start3D2D(self:GetPos() + (self:GetUp() * 1.4) + (self:GetRight() * 1) + (self:GetForward() * -1.45),FixAngles,.07)
			draw.SimpleText(Text,"DermaDefaultBold",31,-22,LEDColor,1,1)
		cam.End3D2D()
	end
end