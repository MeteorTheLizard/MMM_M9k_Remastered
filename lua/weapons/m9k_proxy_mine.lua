SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9K Specialties"
SWEP.PrintName = "Proximity Mine"

SWEP.Slot = 5
SWEP.HoldType = "slam"
SWEP.Spawnable = true

SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_px.mdl"
SWEP.WorldModel = "models/weapons/w_px.mdl"

SWEP.Primary.RPM = 15
SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.KickUp = 0
SWEP.Primary.KickDown = 0
SWEP.Primary.KickHorizontal = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "ProxMine"
SWEP.Primary.NumShots = 0
SWEP.Primary.Damage = 0
SWEP.Primary.Spread = 0

local AngleCache1 = Angle(90,180,0)
local MetaE = FindMetaTable("Entity")
local CPPIExists = MetaE.CPPIGetOwner and true or false

function SWEP:IronSight() -- This weapon should not have ironsights!
end

function SWEP:PrimaryAttack()
	if self:CanPrimaryAttack() then
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
		self:SetNextPrimaryFire(CurTime() + 1 / (self.Primary.RPM / 60))

		if CLIENT then return end

		local plant = self.Owner:GetViewModel():SequenceDuration()
		timer.Simple(plant,function()
			if not IsValid(self) or not IsValid(self.Owner) or not self.Owner:Alive() or not IsValid(self.Owner:GetActiveWeapon()) or self.Owner:GetActiveWeapon():GetClass() ~= self.ClassName then
				return
			end

			local trace = util.TraceLine({
				start = self.Owner:GetShootPos(),
				endpos = self.Owner:GetShootPos() + 100 * self.Owner:GetAimVector(),
				filter = {self.Owner}
			})

			local proxy = ents.Create("m9k_proxy")
			proxy:SetPos(trace.HitPos + trace.HitNormal)

			trace.HitNormal.z = -trace.HitNormal.z
			proxy:SetAngles(trace.HitNormal:Angle() - AngleCache1)

			proxy:SetOwner(self.Owner)

			if CPPIExists then
				proxy:CPPISetOwner(self.Owner)
			else
				proxy:SetNWEntity("my_owner",self.Owner) -- TinyCPPI Compatibility
			end

			proxy:Spawn()

			proxy:SetMoveType(MOVETYPE_NONE)

			if self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0 then
				self.Owner:StripWeapon("m9k_proxy_mine")
			else
				self.Owner:RemoveAmmo(1,self.Primary.Ammo)
				self:SendWeaponAnim(ACT_VM_DRAW)
			end

			if not trace.Hit then
				proxy:SetMoveType(MOVETYPE_VPHYSICS)
				proxy.DynamicPos = true
			end
		end)
	end
end