SWEP.Base = "bobs_shotty_base"
SWEP.Category = "M9K Admin Weapons"
SWEP.PrintName = "Mossberg 590 (ADMIN)"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = true

SWEP.ViewModelFOV = 60
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_shot_mberg_590.mdl"
SWEP.WorldModel = "models/weapons/w_mossberg_590.mdl"

SWEP.Primary.Sound = "Mberg_590.Single"
SWEP.Primary.RPM = 800
SWEP.Primary.ClipSize = 100
SWEP.Primary.DefaultClip = 100

SWEP.Primary.KickUp = 0.25
SWEP.Primary.KickDown = 0.25
SWEP.Primary.KickHorizontal = 0.25
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "buckshot"
SWEP.Primary.NumShots = 10
SWEP.Primary.Damage = 35
SWEP.Primary.Spread = .15
SWEP.ShellTime = 0

SWEP.IronSightsPos = Vector(-2.72,-3.143,1.28)
SWEP.IronSightsAng = Vector(0,-0.75,3)

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
		self.WepSelectIcon = surface.GetTextureID("vgui/hud/m9k_mossberg590")
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