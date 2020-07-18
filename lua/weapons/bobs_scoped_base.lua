SWEP.Base = "bobs_gun_base"
SWEP.Slot = 4
SWEP.SlotPos = 1

SWEP.ScopeState = 0
SWEP.ScopeCD = 0

function SWEP:Think()
	if self.ScopeState > 0 and self.Owner:GetVelocity():Length() < 100 then
		self.Primary.Spread = self.Primary.SpreadZoomed
	else
		self.Primary.Spread = self.Primary.SpreadBefore
	end
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
	if self.ScopeCD > CurTime() then return false end

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
	if self.ScopeState > 0 and self.ScopeCD < CurTime() then
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