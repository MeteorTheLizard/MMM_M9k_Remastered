SWEP.Base = "bobs_scoped_base"
SWEP.Category = "M9K Assault Rifles"
SWEP.PrintName = "Steyr AUG A3"

SWEP.Slot = 3
SWEP.HoldType = "smg"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_auga3sa.mdl"
SWEP.WorldModel = "models/weapons/w_auga3.mdl"

SWEP.Primary.Sound = "aug_a3.Single"
SWEP.Primary.RPM = 345
SWEP.Primary.ClipSize = 30

SWEP.Primary.KickUp = 2.5
SWEP.Primary.KickDown = 1.9
SWEP.Primary.KickHorizontal = 1.75
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "ar2"
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 35
SWEP.Primary.Spread = .03
SWEP.Primary.SpreadZoomed = .0125
SWEP.Primary.SpreadBefore = SWEP.Primary.Spread

SWEP.ScopeScale = 0.5
SWEP.ReticleScale = 0.6
SWEP.HasZoomStages = false -- This weapon does not have variable zooms (No zoom stages)

if CLIENT then
	local CachedTextureID1 = surface.GetTextureID("scope/aimpoint")
	local CachedTextureID2 = surface.GetTextureID("scope/gdcw_closedsight")

	function SWEP:DrawHUD()
		if self.Owner:GetViewEntity() ~= self.Owner then return end

		if self:GetNWInt("ScopeState") > 0 then
			if self.DrawCrosshair then -- Only set the vars once (this is faster)
				self.Owner:DrawViewModel(false)
				self.DrawCrosshair = false
			end

			surface.SetDrawColor(0,0,0,255)
			surface.SetTexture(CachedTextureID1)
			surface.DrawTexturedRect(self.ReticleTable.x,self.ReticleTable.y,self.ReticleTable.w,self.ReticleTable.h)

			surface.SetTexture(CachedTextureID2)
			surface.DrawTexturedRect(self.LensTable.x,self.LensTable.y,self.LensTable.w,self.LensTable.h)
		elseif not self.DrawCrosshair then -- Only set the vars once (this is faster)
			self.Owner:DrawViewModel(true)
			self.DrawCrosshair = true
		end
	end
end