SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9K Admin Weapons"
SWEP.PrintName = "HK45C (ADMIN)"

SWEP.Slot = 1
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = true

SWEP.ViewModelFOV = 60
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_pist_hk45.mdl"
SWEP.WorldModel = "models/weapons/w_hk45c.mdl"

SWEP.Primary.Sound = "Weapon_hk45.Single"
SWEP.Primary.RPM = 465
SWEP.Primary.ClipSize = 225
SWEP.Primary.DefaultClip = 225

SWEP.Primary.KickUp = 1.7
SWEP.Primary.KickDown = 0.5
SWEP.Primary.KickHorizontal = 1.7
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "pistol"
SWEP.Primary.NumShots = 21
SWEP.Primary.Damage = 10
SWEP.Primary.Spread = 0.1

SWEP.IronSightsPos = Vector(-2.32,0,0.86)

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
		self.WepSelectIcon = surface.GetTextureID("vgui/hud/m9k_hk45")
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