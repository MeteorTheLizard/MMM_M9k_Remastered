SWEP.Base = "bobs_scoped_base"
SWEP.Category = "M9K Specialties"
SWEP.PrintName = "Matador"

SWEP.Slot = 5
SWEP.SlotPos = 33
SWEP.HoldType = "rpg"
SWEP.Spawnable = true

SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_MAT.mdl"
SWEP.WorldModel = "models/weapons/w_GDCW_MATADOR_RL.mdl"

SWEP.Primary.Sound = Sound("MATADORF.single")
SWEP.Primary.RPM = 60
SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.KickUp = 0
SWEP.Primary.KickDown = 0
SWEP.Primary.KickHorizontal = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "RPG_Round"
SWEP.Primary.NumShots = 0
SWEP.Primary.Damage = 0
SWEP.Primary.Spread = 0

local AngleCache1 = Angle(90,0,0)
local MetaE = FindMetaTable("Entity")
local CPPIExists = MetaE.CPPISetOwner and true or false

function SWEP:PrimaryAttack()
	if self:CanPrimaryAttack() then
		self:SetNextPrimaryFire(CurTime() + 1 / (self.Primary.RPM / 60))
		self:TakePrimaryAmmo(1)
		local aim = self.Owner:GetAimVector()
		local pos = self.Owner:GetShootPos()

		if SERVER then
			local rocket = ents.Create("m9k_ammo_matador_90mm")
			rocket:SetAngles(aim:Angle() + AngleCache1)
			rocket:SetPos(pos)

			rocket:SetOwner(self.Owner)

			if CPPIExists then
				rocket:CPPISetOwner(self.Owner)
			else
				rocket:SetNWEntity("my_owner",self.Owner) -- TinyCPPI Compatibility
			end

			rocket:Spawn()
			rocket:Activate()

			util.ScreenShake(self.Owner:GetShootPos(),1000,10,0.3,500)
		end

		self.Owner:SetAnimation(PLAYER_ATTACK1)
		self:EmitSound(self.Primary.Sound)
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)

		if CLIENT then return end

		timer.Simple(0.2,function()
			if not IsValid(self) or not IsValid(self.Owner) then return end

			self:SendWeaponAnim(ACT_VM_RELOAD)

			timer.Simple(0.5,function()
				if not IsValid(self) or not IsValid(self.Owner) then return end

				local EffectEnt = ents.Create("prop_physics")
				EffectEnt:SetPos(self.Owner:GetShootPos() + (self.Owner:GetRight() * 15))

				local Ang = self.Owner:EyeAngles()
				Ang:SetUnpacked(Ang.p,Ang.y + 180,Ang.r)
				EffectEnt:SetAngles(Ang)

				EffectEnt:SetModel(self.WorldModel)
				EffectEnt:Spawn()
				EffectEnt:SetCollisionGroup(COLLISION_GROUP_WEAPON)
				EffectEnt.WasDropped = true -- MMM Compatibility

				EffectEnt:SetOwner(self.Owner)

				if CPPIExists then
					EffectEnt:CPPISetOwner(self.Owner)
				else
					EffectEnt:SetNWEntity("my_owner",self.Owner) -- TinyCPPI Compatibility
				end

				SafeRemoveEntityDelayed(EffectEnt,5)

				local Phys = EffectEnt:GetPhysicsObject()
				if IsValid(Phys) then
					Phys:SetVelocity(-(self.Owner:EyeAngles():Forward() * 25) + self.Owner:EyeAngles():Right() * 100)
				end

				timer.Simple(0.2,function()
					if not IsValid(self) or not IsValid(self.Owner) then return end

					if self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0 then
						self:Remove()

						local Weapons = self.Owner:GetWeapons() -- We need to select a different weapon, otherwise the viewmodels might glitch out here
						if #Weapons > 0 then
							self.Owner:SelectWeapon(Weapons[1]:GetClass())
						end
					else
						self:SetClip1(1)
						self.Owner:RemoveAmmo(1,self.Primary.Ammo)
					end
				end)
			end)
		end)
	end
end

function SWEP:Reload()
	return false
end