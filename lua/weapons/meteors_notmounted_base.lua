-- This base can be and is used by extensions for weapons that should not be spawnable
-- Commonly used for weapons that should only work when a required game is mounted

SWEP.Category = "" -- Not categorized
SWEP.PrintName = "Unavailable"

SWEP.Primary.Ammo = "" -- Needs to be defined so we do not spawn ammo!
SWEP.Secondary.Ammo = ""

local sTag = "M9kr_Weapon_Spawnerror"

if SERVER then

	util.AddNetworkString(sTag)

	local fRemove = function(self)
		if not IsValid(self) then return end

		if IsValid(self.Owner) and self.Owner:IsPlayer() then -- Sometimes it was spawned through the Creator or other means!

			net.Start(sTag)
			net.Send(self.Owner)

			self.Owner:StripWeapon(self:GetClass())
		end

		self:Remove()
	end

	function SWEP:Initialize()

		self:SetNoDraw(true) -- This is the true magic

		timer.Simple(0,function() -- Delayed by one tick so that self.Owner becomes valid if used
			fRemove(self)
		end)
	end

	function SWEP:Deploy()
		fRemove(self)
	end

	function SWEP:Equip()
		fRemove(self)
	end
end

function SWEP:Holster()
	return true
end

if CLIENT then

	net.Receive(sTag,function()

		chat.AddText("Sorry, that weapon is unavailable!")

		surface.PlaySound("buttons/button11.wav")

	end)
end