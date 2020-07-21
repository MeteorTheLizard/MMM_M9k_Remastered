SWEP.Base = "bobs_gun_base"
SWEP.Slot = 4

SWEP.Primary.SpreadZoomed = .001

SWEP.ScopeState = 0
SWEP.ScopeCD = 0
SWEP.ScopeScale = 0.5
SWEP.ReticleScale = 0.5

if CLIENT then
	function SWEP:Initialize()
		util.PrecacheSound(self.Primary.Sound)
		util.PrecacheModel(self.ViewModel)
		util.PrecacheModel(self.WorldModel)

		self:SetHoldType(self.HoldType)
		self:SetWeaponHoldType(self.HoldType)
		self:SendWeaponAnim(ACT_VM_IDLE)

		if CLIENT then
			self.WepSelectIcon = surface.GetTextureID(string.gsub("vgui/hud/name","name",self:GetClass()))
		end

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

function SWEP:Think()
	if self.ScopeState > 0 and self.Owner:GetVelocity():Length() < 100 then
		self.Primary.Spread = self.Primary.SpreadZoomed
	else
		self.Primary.Spread = self.Primary.SpreadBefore
	end
end

function SWEP:Holster()
	self.Owner:DrawViewModel(true)
	self.ScopeState = 0
	return true
end

function SWEP:AdjustMouseSensitivity()
	if self.ScopeState == 0 then
		return 1
	elseif self.ScopeState == 1 then
		return 0.75
	elseif self.ScopeState == 2 then
		return 0.35
	elseif self.ScopeState == 3 then
		return 0.1
	end
end

function SWEP:SecondaryAttack()
	if self.ScopeCD > CurTime() or self.Owner:GetViewEntity() ~= self.Owner then return false end

	self.ScopeState = self.ScopeState  + 1
	if self.ScopeState > 3 then
		self.ScopeState = 0
	end
	self.ScopeCD = CurTime() + 0.2

	if self.ScopeState == 0 then
		self.Owner:SetFOV(0,0.1)
	elseif self.ScopeState == 1 then
		self.Owner:SetFOV(50,0.1)
	elseif self.ScopeState == 2 then
		self.Owner:SetFOV(25,0.1)
	elseif self.ScopeState == 3 then
		self.Owner:SetFOV(10,0.1)
	end

	self.Owner:EmitSound("weapons/zoom.wav")
end

function SWEP:Reload()
	if self.ScopeState > 0 then
		self.Owner:SetFOV(0,0.1)
		self.ScopeState = 0
		self.ScopeCD = CurTime() + 0.2
		self.Owner:EmitSound("weapons/zoom.wav")
	end

	if self.Owner:GetAmmoCount(self.Primary.Ammo) >= 1 and self:Clip1() < self:GetMaxClip1() then
		self:DefaultReload(ACT_VM_RELOAD)
		self.Owner:SetAnimation(PLAYER_RELOAD)
	end
end