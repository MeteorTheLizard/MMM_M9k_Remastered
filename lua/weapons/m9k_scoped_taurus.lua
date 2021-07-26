SWEP.Base = "bobs_scoped_base"
SWEP.Category = "M9K Pistols"
SWEP.PrintName = "Raging Bull - Scoped"

SWEP.HoldType = "revolver"
SWEP.Spawnable = true

SWEP.ViewModelFOV = 65
SWEP.ViewModel = "models/weapons/v_raging_bull_scoped.mdl"
SWEP.WorldModel = "models/weapons/w_raging_bull_scoped.mdl"

SWEP.Primary.Sound = "weapon_r_bull.single"
SWEP.Primary.RPM = 115
SWEP.Primary.ClipSize = 6

SWEP.Primary.KickUp = 9
SWEP.Primary.KickDown = 4
SWEP.Primary.KickHorizontal = 6.5
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "357"
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 75
SWEP.Primary.Spread = .018
SWEP.Primary.SpreadBefore = SWEP.Primary.Spread

SWEP.ScopeScale = 0.7
SWEP.ReticleScale = 0.6

if CLIENT then
	local CachedTextureID1 = surface.GetTextureID("scope/gdcw_scopesight")

	function SWEP:DrawHUD()
		if self.Owner:GetViewEntity() ~= self.Owner then return end

		if self:GetNWInt("ScopeState") > 0 then
			if self.DrawCrosshair then -- Only set the vars once (this is faster)
				self.Owner:DrawViewModel(false)
				self.DrawCrosshair = false
			end

			surface.SetDrawColor(0,0,0,255)
			surface.SetTexture(CachedTextureID1)
			surface.DrawTexturedRect(self.LensTable.x,self.LensTable.y,self.LensTable.w,self.LensTable.h)
		elseif not self.DrawCrosshair then -- Only set the vars once (this is faster)
			self.Owner:DrawViewModel(true)
			self.DrawCrosshair = true
		end
	end
end