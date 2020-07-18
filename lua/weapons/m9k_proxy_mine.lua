SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9K Specialties"
SWEP.PrintName = "Proximity Mine"

SWEP.Slot = 5
SWEP.SlotPos = 26
SWEP.HoldType = "slam"
SWEP.Spawnable = true

SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_px.mdl"
SWEP.WorldModel = "models/weapons/w_px.mdl"

--SWEP.Primary.Sound = ""
SWEP.Primary.RPM = 15
SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.KickUp = 0
SWEP.Primary.KickDown = 0
SWEP.Primary.KickHorizontal = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "ProxMine"
SWEP.Primary.Round = "m9k_proxy_mine"
SWEP.Primary.NumShots = 0
SWEP.Primary.Damage = 0
SWEP.Primary.Spread = 0

local AngleCache1 = Angle(90,180,0)
local MetaE = FindMetaTable("Entity")
local CPPIExists = MetaE.CPPISetOwner and true or false

function SWEP:PrimaryAttack()
	if self:CanPrimaryAttack() then
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
		self:SetNextPrimaryFire(CurTime() + 1 / (self.Primary.RPM / 60))

		local plant = self.Owner:GetViewModel():SequenceDuration()
		timer.Simple(plant,function()
			if not IsValid(self) or not IsValid(self.Owner) or not self.Owner:Alive() or not IsValid(self.Owner:GetActiveWeapon()) or self.Owner:GetActiveWeapon():GetClass() ~= self:GetClass() then
				return -- ^ What a messy line
			end

			local trace = util.TraceLine({
				start = self.Owner:GetShootPos(),
				endpos = self.Owner:GetShootPos() + 100 * self.Owner:GetAimVector(),
				filter = {self.Owner}
			})

			if CLIENT then return end

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
				self:Remove()

				local Weapons = self.Owner:GetWeapons() -- We need to select a different weapon, otherwise the viewmodels might glitch out here
				if #Weapons > 0 then
					self.Owner:SelectWeapon(Weapons[1]:GetClass())
				end
			else
				self.Owner:RemoveAmmo(1,self.Primary.Ammo)
				self:SendWeaponAnim(ACT_VM_DRAW)
			end

			if not trace.Hit then
				proxy:SetMoveType(MOVETYPE_VPHYSICS)
			end
		end)
	end
end