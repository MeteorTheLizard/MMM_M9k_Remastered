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
	self:SetHoldType(self.HoldType)
	self.OurIndex = self:EntIndex()

	if SERVER and game.SinglePlayer() then -- In singleplayer we need to force the weapon to be equipped after spawning
		timer.Simple(0,function()
			if not IsValid(self) then return end -- We need to abort when the owner already had the weapon!
			self.Owner:SelectWeapon(self:GetClass())
		end)
	end

	if CLIENT then
		self.WepSelectIcon = surface.GetTextureID("vgui/hud/m9k_mossberg590")

		if self.Owner == LocalPlayer() then
			self:SendWeaponAnim(ACT_VM_IDLE)

			if self.Owner:GetActiveWeapon() == self then -- Compat/Bugfix
				self:Equip()
				self:Deploy()
			end
		end
	end
end

function SWEP:Deploy()
	self:SetHoldType(self.HoldType)

	local vm = self.Owner:GetViewModel()
	if IsValid(vm) then -- This is required since the code should only run on the server or on the player holding the gun (Causes errors otherwise)
		self.CanReload = false
		self:SetNWBool("CanIronSights",false)
		self:SendWeaponAnim(ACT_VM_DRAW)

		local Dur = vm:SequenceDuration() + 0.1
		self:SetNextPrimaryFire(CurTime() + Dur)
		self:SetNextSecondaryFire(CurTime() + Dur)

		timer.Remove("MMM_M9k_Deploy_" .. self.OurIndex)
		timer.Create("MMM_M9k_Deploy_" .. self.OurIndex,Dur,1,function()
			if not IsValid(self) or not IsValid(self.Owner) or not IsValid(self.Owner:GetActiveWeapon()) or self.Owner:GetActiveWeapon():GetClass() ~= self:GetClass() then return end
			self:SetNWBool("CanIronSights",true)
			self.CanReload = true
		end)
	end

	if SERVER and not self.Owner:IsAdmin() and not self.Owner:IsSuperAdmin() and not (IsDeveloperExists and self.Owner:IsDeveloper() or false) then -- If the weapon is dropped by an admin, do not let non-admins use it!
		self.Owner:EmitSound("buttons/button11.wav")
		self.Owner:StripWeapon("m9k_mossberg590_admin")
		self:Remove() -- Just to make sure
		return
	end

	return true
end