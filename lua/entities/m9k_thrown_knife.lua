AddCSLuaFile()

ENT.Base = "m9k_thrown_spec_knife"
ENT.PrintName = "Machete"

if SERVER then

	ENT.iNextSound = 0

	ENT.vStartForwardOffset = 10
	ENT.vStartUpOffset = 10

	ENT.vEndForwardOffset = 15.5
	ENT.vEndUpOffset = 19


	function ENT:Initialize()

		if not self.M9kr_CreatedByWeapon then -- Prevents exploiting it
			self:Remove()

			return
		end


		self:PhysicsInit(SOLID_VPHYSICS)

		self:SetUseType(SIMPLE_USE)


		self.tFilters = {self,self.Owner} -- Don't recreate this over and over again.

	end


	function ENT:Use(eActivator) -- We may pick the Machete back up
		if eActivator:IsPlayer() and eActivator:GetWeapon("m9k_machete") == NULL then
			eActivator:Give("m9k_machete")

			self:Remove()
		end
	end
end

if CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end
end