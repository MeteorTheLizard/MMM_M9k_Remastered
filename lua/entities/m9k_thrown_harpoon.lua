AddCSLuaFile()

ENT.Base = "m9k_thrown_spec_knife"
ENT.PrintName = "Harpoon"

if SERVER then

	function ENT:Initialize()

		if not self.M9kr_CreatedByWeapon then -- Prevents exploiting it
			self:Remove()

			return
		end


		self:PhysicsInit(SOLID_VPHYSICS)

		self:SetUseType(SIMPLE_USE)


		self.iNextSound = 0
		self.tFilters = {self,self.Owner} -- Don't recreate this over and over again.


		self.vStartForwardOffset = 35
		self.vStartUpOffset = 0

		self.vEndForwardOffset = 58
		self.vEndUpOffset = 0

	end


	function ENT:Use(eActivator) -- We may pick the Harpoon back up
		if eActivator:IsPlayer() and eActivator:GetWeapon("m9k_harpoon") == NULL then
			eActivator:Give("m9k_harpoon")

			self:Remove()
		end
	end
end

if CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end
end