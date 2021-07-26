SWEP.Base = "bobs_scoped_base"
SWEP.Category = "M9K Assault Rifles"
SWEP.PrintName = "L85"

SWEP.Slot = 3
SWEP.HoldType = "ar2"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_rif_l85.mdl"
SWEP.WorldModel = "models/weapons/w_l85a2.mdl"

SWEP.Primary.Sound = "Weapon_l85.Single"
SWEP.Primary.RPM = 325
SWEP.Primary.ClipSize = 30

SWEP.Primary.KickUp = 2.5
SWEP.Primary.KickDown = 1.3
SWEP.Primary.KickHorizontal = 2
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "ar2"
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 38
SWEP.Primary.Spread = .02
SWEP.Primary.SpreadZoomed = .0115
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