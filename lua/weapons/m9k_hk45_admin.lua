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
		if self.Owner:GetActiveWeapon() == self then -- Compat/Bugfix
			self:Equip()
			self:Deploy()
		end

		self.WepSelectIcon = surface.GetTextureID("vgui/hud/m9k_hk45")
	end
end

function SWEP:Deploy()
	self.CanIronSights = false
	self.CanReload = false

	self:SetHoldType(self.HoldType)
	self:SetWeaponHoldType(self.HoldType)
	self:SendWeaponAnim(ACT_VM_DRAW)

	local vm = self.Owner:GetViewModel()
	if IsValid(vm) then -- This is required since the code should only run on the server or on the player holding the gun (Causes errors otherwise)
		local Dur = vm:SequenceDuration() + 0.1
		self:SetNextPrimaryFire(CurTime() + Dur)
		self:SetNextSecondaryFire(CurTime() + Dur)

		timer.Remove("MMM_M9k_Deploy_" .. self:EntIndex())
		timer.Create("MMM_M9k_Deploy_" .. self:EntIndex(),Dur,1,function()
			if not IsValid(self) or not IsValid(self.Owner) or not IsValid(self.Owner:GetActiveWeapon()) or self.Owner:GetActiveWeapon():GetClass() ~= self:GetClass() then return end
			self.CanIronSights = true
			self.CanReload = true
		end)
	end
	
	if SERVER and not self.Owner:IsAdmin() and not self.Owner:IsSuperAdmin() and not (IsDeveloperExists and self.Owner:IsDeveloper() or false) then -- If the weapon is dropped by an admin, do not let non-admins use it!
		self.Owner:EmitSound("buttons/button11.wav")
		self:Remove()
		return
	end

	return true
end