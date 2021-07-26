SWEP.Base = "bobs_scoped_base"
SWEP.Category = "M9K Assault Rifles"
SWEP.PrintName = "HK SL8"

SWEP.HoldType = "ar2"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_hk_sl8.mdl"
SWEP.WorldModel = "models/weapons/w_hk_sl8.mdl"

SWEP.Primary.Sound = "Weapon_hksl8.Single"
SWEP.Primary.RPM = 410
SWEP.Primary.ClipSize = 30

SWEP.Primary.KickUp = 1.4
SWEP.Primary.KickDown = 0.9
SWEP.Primary.KickHorizontal = 1.5
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "ar2"
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 27
SWEP.Primary.Spread = .025
SWEP.Primary.SpreadZoomed = .005
SWEP.Primary.SpreadBefore = SWEP.Primary.Spread

SWEP.ScopeScale = 0.5
SWEP.ReticleScale = 0.6
SWEP.HasZoomStages = false

if CLIENT then
	local CachedTextureID1 = surface.GetTextureID("scope/gdcw_closedsight")
	local CachedTextureID2 = surface.GetTextureID("scope/gdcw_acogchevron")
	local CachedTextureID3 = surface.GetTextureID("scope/gdcw_acogcross")

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

			surface.SetTexture(CachedTextureID2)
			surface.DrawTexturedRect(self.ReticleTable.x,self.ReticleTable.y,self.ReticleTable.w,self.ReticleTable.h)

			surface.SetTexture(CachedTextureID3)
			surface.DrawTexturedRect(self.ReticleTable.x, self.ReticleTable.y, self.ReticleTable.w, self.ReticleTable.h)
		elseif not self.DrawCrosshair then -- Only set the vars once (this is faster)
			self.Owner:DrawViewModel(true)
			self.DrawCrosshair = true
		end
	end
end