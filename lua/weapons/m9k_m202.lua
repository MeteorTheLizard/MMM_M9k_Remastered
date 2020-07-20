SWEP.Base = "bobs_scoped_base"
SWEP.Category = "M9K Specialties"
SWEP.PrintName = "M202"

SWEP.Slot = 5
SWEP.HoldType = "rpg"
SWEP.Spawnable = true

SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_m202.mdl"
SWEP.WorldModel = "models/weapons/w_m202.mdl"

SWEP.Primary.Sound = "RPGF.single"
SWEP.Primary.RPM = 50
SWEP.Primary.ClipSize = 4
SWEP.Primary.DefaultClip = 4
SWEP.Primary.KickUp = 0
SWEP.Primary.KickDown = 0
SWEP.Primary.KickHorizontal = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "RPG_Round"
SWEP.Primary.NumShots = 0
SWEP.Primary.Damage = 0
SWEP.Primary.Spread = 0

SWEP.M202IsReloading = false

local OurClass = "m9k_m202"
local MetaE = FindMetaTable("Entity")
local CPPIExists = MetaE.CPPISetOwner and true or false
local VectorCache1 = Vector(0,0,1)
local ViewPunchUp = Angle(-13,0,0)

function SWEP:PrimaryAttack()
	if self.Owner:WaterLevel() == 3 then -- No weapons may fire underwater
		self:EmitSound("Weapon_Pistol.Empty")
		self:SetNextPrimaryFire(CurTime() + 0.2)
		return
	end

	if self:CanPrimaryAttack() then
		self:SetNextPrimaryFire(CurTime() + 1 / (self.Primary.RPM / 60))
		self:TakePrimaryAmmo(1)

		local aim = self.Owner:GetAimVector()
		local side = aim:Cross(VectorCache1)
		local pos = self.Owner:GetShootPos() + side * 6 + side:Cross(aim) * -5

		if SERVER then
			util.ScreenShake(self.Owner:GetShootPos(),1000,10,0.3,500)

			local rocket = ents.Create("m9k_m202_rocket")
			rocket:SetAngles(aim:Angle())
			rocket:SetPos(pos)

			rocket:SetOwner(self.Owner)

			if CPPIExists then
				rocket:CPPISetOwner(self.Owner)
			else
				rocket:SetNWEntity("my_owner",self.Owner) -- TinyCPPI Compatibility
			end

			rocket:Spawn()
			rocket:Activate()
		end

		self.Owner:SetAnimation(PLAYER_ATTACK1)
		self:EmitSound(self.Primary.Sound)
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	end
end

function SWEP:Holster()
	self.ScopeState = 0

	if self.M202IsReloading == 2 then
		self:SetClip1(self.Owner:GetAmmoCount(self.Primary.Ammo) >= 4 and 4 or self.Owner:GetAmmoCount(self.Primary.Ammo))
	end

	self.M202IsReloading = false
	timer.Remove("M202_Reload_" .. self:EntIndex())
	return true
end

-- This special snowflake got its own reload animation that I stitched together, neat huh?
function SWEP:Reload()
	if self.ScopeState > 0 then
		self.Owner:SetFOV(0,0.1)
		self.ScopeState = 0
		self.ScopeCD = CurTime() + 0.2
		self.Owner:EmitSound("weapons/zoom.wav")
	end

	if not self.M202IsReloading and self.Owner:GetAmmoCount(self.Primary.Ammo) >= 1 and self:Clip1() < self.Primary.ClipSize then

		self.ScopeCD = CurTime() + 2

		if CLIENT then return end

		self.M202IsReloading = true

		local TimerName = "M202_Reload_" .. self:EntIndex()

		timer.Create(TimerName,0.7,1,function()
			if not IsValid(self) or not IsValid(self.Owner) or not IsValid(self.Owner:GetActiveWeapon()) or self.Owner:GetActiveWeapon():GetClass() ~= OurClass then return end

			self.Owner:DoAnimationEvent(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE)
			self.Owner:ViewPunch(ViewPunchUp)
			self.Owner:EmitSound("weapons/iceaxe/iceaxe_swing1.wav")

			timer.Create(TimerName,0.15,1,function()
				if not IsValid(self) or not IsValid(self.Owner) or not IsValid(self.Owner:GetActiveWeapon()) or self.Owner:GetActiveWeapon():GetClass() ~= OurClass then return end

				self.M202IsReloading = 2

				local EffectEnt = ents.Create("prop_physics")
				EffectEnt:SetModel("models/weapons/w_m202.mdl")

				local Ang = self.Owner:EyeAngles()
				Ang:SetUnpacked(Ang.p,Ang.y + 90,Ang.r)
				EffectEnt:SetAngles(Ang)

				EffectEnt:SetPos(self.Owner:GetShootPos())
				EffectEnt:Spawn()
				EffectEnt:SetCollisionGroup(COLLISION_GROUP_WEAPON)
				EffectEnt.WasDropped = true -- MMM Compatibility

				if CPPIExists then
					EffectEnt:CPPISetOwner(self.Owner)
				else
					EffectEnt:SetNWEntity("my_owner",self.Owner) -- TinyCPPI Compatibility
				end

				SafeRemoveEntityDelayed(EffectEnt,5)

				local Phys = EffectEnt:GetPhysicsObject()
				if IsValid(Phys) then
					Phys:SetVelocity(self.Owner:GetAimVector() * 250)
					Phys:AddAngleVelocity(VectorRand(-50,50))
				end

				self:DefaultReload(ACT_VM_DRAW)

				timer.Simple(0.3,function()
					if not IsValid(self) or not IsValid(self.Owner) or not IsValid(self.Owner:GetActiveWeapon()) or self.Owner:GetActiveWeapon():GetClass() ~= OurClass then return end
					self.M202IsReloading = false
				end)
			end)
		end)
	end
end