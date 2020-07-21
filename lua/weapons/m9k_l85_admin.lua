SWEP.Base = "bobs_scoped_base"
SWEP.Category = "M9K Admin Weapons"
SWEP.PrintName = "L85 (ADMIN)"

SWEP.Slot = 3
SWEP.HoldType = "ar2"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = true

SWEP.ViewModel = "models/weapons/v_rif_l85.mdl"
SWEP.WorldModel = "models/weapons/w_l85a2.mdl"

SWEP.Primary.Sound = "Weapon_l85.Single"
SWEP.Primary.RPM = 800
SWEP.Primary.ClipSize = 100
SWEP.Primary.DefaultClip = 100

SWEP.Primary.KickUp = 0.25
SWEP.Primary.KickDown = 0.25
SWEP.Primary.KickHorizontal = 0.25
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "ar2"
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 100
SWEP.Primary.Spread = 0.01
SWEP.Primary.SpreadZoomed = 0
SWEP.Primary.SpreadBefore = SWEP.Primary.Spread

SWEP.ScopeScale = 0.5
SWEP.ReticleScale = 0.6

local MetaP = FindMetaTable("Player")
local IsDeveloperExists = MetaP.IsDeveloper or false

function SWEP:Initialize()
	util.PrecacheSound(self.Primary.Sound)
	util.PrecacheModel(self.ViewModel)
	util.PrecacheModel(self.WorldModel)

	self:SetHoldType(self.HoldType)
	self:SetWeaponHoldType(self.HoldType)
	self:SendWeaponAnim(ACT_VM_IDLE)

	if CLIENT then
		self.WepSelectIcon = surface.GetTextureID("vgui/hud/m9k_l85")

		local iScreenWidth = ScrW()
		local iScreenHeight = ScrH()

		self.ScopeTable = {}
		self.ScopeTable.l = iScreenHeight * self.ScopeScale
		self.ScopeTable.x1 = 0.5 * (iScreenWidth + self.ScopeTable.l)
		self.ScopeTable.y1 = 0.5 * (iScreenHeight - self.ScopeTable.l)
		self.ScopeTable.x2 = self.ScopeTable.x1
		self.ScopeTable.y2 = 0.5 * (iScreenHeight + self.ScopeTable.l)
		self.ScopeTable.x3 = 0.5 * (iScreenWidth - self.ScopeTable.l)
		self.ScopeTable.y3 = self.ScopeTable.y2
		self.ScopeTable.x4 = self.ScopeTable.x3
		self.ScopeTable.y4 = self.ScopeTable.y1
		self.ScopeTable.l = (iScreenHeight + 1) * self.ScopeScale
		self.QuadTable = {}
		self.QuadTable.x1 = 0
		self.QuadTable.y1 = 0
		self.QuadTable.w1 = iScreenWidth
		self.QuadTable.h1 = 0.5 * iScreenHeight - self.ScopeTable.l
		self.QuadTable.x2 = 0
		self.QuadTable.y2 = 0.5 * iScreenHeight + self.ScopeTable.l
		self.QuadTable.w2 = self.QuadTable.w1
		self.QuadTable.h2 = self.QuadTable.h1
		self.QuadTable.x3 = 0
		self.QuadTable.y3 = 0
		self.QuadTable.w3 = 0.5 * iScreenWidth - self.ScopeTable.l
		self.QuadTable.h3 = iScreenHeight
		self.QuadTable.x4 = 0.5 * iScreenWidth + self.ScopeTable.l
		self.QuadTable.y4 = 0
		self.QuadTable.w4 = self.QuadTable.w3
		self.QuadTable.h4 = self.QuadTable.h3
		self.LensTable = {}
		self.LensTable.x = self.QuadTable.w3
		self.LensTable.y = self.QuadTable.h1
		self.LensTable.w = 2 * self.ScopeTable.l
		self.LensTable.h = 2 * self.ScopeTable.l
		self.ReticleTable = {}
		self.ReticleTable.wdivider = 3.125
		self.ReticleTable.hdivider = 1.7579 / self.ReticleScale
		self.ReticleTable.x = (iScreenWidth / 2) - ((iScreenHeight / self.ReticleTable.hdivider) / 2)
		self.ReticleTable.y = (iScreenHeight / 2) - ((iScreenHeight / self.ReticleTable.hdivider) / 2)
		self.ReticleTable.w = iScreenHeight / self.ReticleTable.hdivider
		self.ReticleTable.h = iScreenHeight / self.ReticleTable.hdivider
	end
end

function SWEP:Deploy()
	self:SetHoldType(self.HoldType)
	self:SetWeaponHoldType(self.HoldType)
	self:SendWeaponAnim(ACT_VM_DRAW)

	local vm = self.Owner:GetViewModel()
	self:SetNextPrimaryFire(CurTime() + vm:SequenceDuration() + 0.1)
	self:SetNextSecondaryFire(CurTime() + vm:SequenceDuration() + 0.1)

	if not self.Owner:IsAdmin() and not self.Owner:IsSuperAdmin() and not (IsDeveloperExists and self.Owner:IsDeveloper() or false) then -- If the weapon is dropped by an admin, do not let non-admins use it!
		self.Owner:EmitSound("buttons/button11.wav")
		self:Remove()
		return
	end

	return true
end

if CLIENT then
	local CachedTextureID1 = surface.GetTextureID("scope/gdcw_closedsight")
	local CachedTextureID2 = surface.GetTextureID("scope/gdcw_acogchevron")
	local CachedTextureID3 = surface.GetTextureID("scope/gdcw_acogcross")

	function SWEP:DrawHUD()
		if self.ScopeState > 0 then
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