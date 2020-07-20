SWEP.Base = "bobs_scoped_base"
SWEP.Category = "M9K Sniper Rifles"
SWEP.PrintName = "Intervention"

SWEP.HoldType = "ar2"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_snip_int.mdl"
SWEP.WorldModel = "models/weapons/w_snip_int.mdl"

SWEP.Primary.Sound = "Weapon_INT.Single"
SWEP.Primary.RPM = 35
SWEP.Primary.ClipSize = 5

SWEP.Primary.KickUp = 4
SWEP.Primary.KickDown = 2
SWEP.Primary.KickHorizontal = 9
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "SniperPenetratedRound"
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 110
SWEP.Primary.Spread = .15
SWEP.Primary.SpreadZoomed = .001
SWEP.Primary.SpreadBefore = SWEP.Primary.Spread

SWEP.ScopeScale = 0.7
SWEP.ReticleScale = 0.5

if CLIENT then
	local CachedTextureID1 = surface.GetTextureID("scope/gdcw_scopesight")

	function SWEP:DrawHUD()
		if self.ScopeState > 0 then
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