SWEP.Base = "bobs_scoped_base"
SWEP.Category = "M9K Submachine Guns"
SWEP.PrintName = "HK MP7"

SWEP.Slot = 2
SWEP.HoldType = "smg"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_mp7_silenced.mdl"
SWEP.WorldModel = "models/weapons/w_mp7_silenced.mdl"

SWEP.Primary.Sound = "Weapon_MP7.single"
SWEP.Primary.RPM = 600
SWEP.Primary.ClipSize = 30

SWEP.Primary.KickUp = 1.2
SWEP.Primary.KickDown = .6
SWEP.Primary.KickHorizontal = .7
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 11
SWEP.Primary.Spread = .023
SWEP.Primary.SpreadZoomed = .0115
SWEP.Primary.SpreadBefore = SWEP.Primary.Spread

SWEP.ScopeScale = 0.5
SWEP.ReticleScale = 0.5
SWEP.HasZoomStages = false

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
