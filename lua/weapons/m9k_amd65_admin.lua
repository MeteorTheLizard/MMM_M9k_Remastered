SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9K Admin Weapons"
SWEP.PrintName = "AMD 65 (ADMIN)"

SWEP.Slot = 3
SWEP.HoldType = "ar2"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = true

SWEP.ViewModel = "models/weapons/v_amd_65.mdl"
SWEP.WorldModel = "models/weapons/w_amd_65.mdl"

SWEP.Primary.Sound = "amd65.single"
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
SWEP.Primary.Spread = .01

SWEP.IronSightsPos = Vector(3.5,-2.21,2.115)
SWEP.IronSightsAng = Vector(-3.701,0,0)

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
		self.WepSelectIcon = surface.GetTextureID("vgui/hud/m9k_amd65")
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