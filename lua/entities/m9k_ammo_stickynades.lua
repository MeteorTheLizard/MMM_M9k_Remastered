AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Sticky Grenades"
ENT.Category = "M9K Ammunition"
ENT.Spawnable = true
ENT.AdminOnly = false

if SERVER then
	local VectorCache1 = Vector(0,0,10)

	function ENT:Initialize()
		self:SetModel("models/items/ammocrates/cratestickys.mdl")
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
	end

	function ENT:PhysicsCollide(Data)
		if Data.Speed > 80 and Data.DeltaTime > 0.2 then
			self:EmitSound("Wood.ImpactHard")
		end
	end

	function ENT:Use(Activator)
		if Activator:IsPlayer() then
			if Activator:GetWeapon("m9k_sticky_grenade") == NULL then
				Activator:Give("m9k_sticky_grenade")
				Activator:GiveAmmo(4,"StickyGrenade")
			else
				Activator:GiveAmmo(5,"StickyGrenade")
			end

			self:Remove()
		end
	end
end

if CLIENT then
	local LEDColor = Color(230,45,45)
	local VectorCache1 = Vector(0,90,90)
	local Text = "Sticky Grenades"

	function ENT:Draw()
		self:DrawModel()

		local FixAngles = self:GetAngles()
		FixAngles:RotateAroundAxis(FixAngles:Right(),VectorCache1.x)
		FixAngles:RotateAroundAxis(FixAngles:Up(),VectorCache1.y)
		FixAngles:RotateAroundAxis(FixAngles:Forward(),VectorCache1.z)

		cam.Start3D2D(self:GetPos() + (self:GetUp() * 9) + (self:GetRight() * 5.5) + (self:GetForward() * 17),FixAngles,0.15)
			draw.SimpleText(Text,"DermaLarge",31,-22,LEDColor,1,1)
		cam.End3D2D()
	end
end