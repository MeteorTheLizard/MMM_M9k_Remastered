-- This base can and is used by extensions for weapons that should not be spawnable
-- Commonly used for weapons that should only work when a required game is mounted

SWEP.Category = "" -- Not categorized
SWEP.PrintName = "Unavailable"

SWEP.Primary.Ammo = "" -- Needs to be defined so we do not spawn ammo!
SWEP.Secondary.Ammo = ""

if SERVER then
	util.AddNetworkString("M9k_Spawnerror")

	local RemoveCheckFunc = function(self)
		if not IsValid(self) then return end

		if IsValid(self.Owner) then -- Sometimes it was spawned through the Creator or other means!
			net.Start("M9k_Spawnerror")
			net.Send(self.Owner)

			self.Owner:StripWeapon(self:GetClass())
		end

		self:Remove()
	end

	function SWEP:Initialize()
		self:SetNoDraw(true) -- This is the true magic

		timer.Simple(0,function() -- Delayed by one tick so that self.Owner becomes valid if used
			RemoveCheckFunc(self)
		end)
	end

	function SWEP:Deploy()
		RemoveCheckFunc(self)
	end

	function SWEP:Equip()
		RemoveCheckFunc(self)
	end
end

function SWEP:Holster()
	return true
end

if CLIENT then
	net.Receive("M9k_Spawnerror",function()
		chat.AddText("Sorry, that weapon is unavailable!")
		surface.PlaySound("buttons/button11.wav")
	end)
end