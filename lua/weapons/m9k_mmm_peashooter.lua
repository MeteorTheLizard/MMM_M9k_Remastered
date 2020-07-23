SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9K Additions (MMM)"
SWEP.PrintName = "Peashooter"

SWEP.Slot = 1
SWEP.Spawnable = true

SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/c_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.ViewModelFOV = 50
SWEP.UseHands = true

SWEP.Primary.Sound = "weapons/mmm/peashooter-fire.mp3"
SWEP.Primary.RPM = 350
SWEP.Primary.ClipSize = 32
SWEP.Primary.DefaultClip = 32

SWEP.Primary.KickUp = 0.5
SWEP.Primary.KickDown = 0.5
SWEP.Primary.KickHorizontal = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 1
SWEP.Primary.Spread = 0.05

SWEP.IronSightsPos = Vector(-5.97,0,3.11)
SWEP.IronSightsAng = Vector(0,-1.15,1.1)

local OurClass = "m9k_mmm_peashooter"
local CachedColor1 = Color(255,189,6,255)
local ViewPunchUp = Angle(-13,0,0)
local MetaE = FindMetaTable("Entity")
local CPPIExists = MetaE.CPPISetOwner and true or false

function SWEP:DrawWeaponSelection(x,y,wide,tall)
	draw.SimpleText("-","HL2MPTypeDeath",x + wide / 2,y + tall * 0.2,CachedColor1,TEXT_ALIGN_CENTER)
end

function SWEP:Initialize()
	util.PrecacheSound(self.Primary.Sound)
	util.PrecacheModel(self.ViewModel)
	util.PrecacheModel(self.WorldModel)

	self:SetHoldType(self.HoldType)
	self:SetWeaponHoldType(self.HoldType)
	self:SendWeaponAnim(ACT_VM_IDLE)
end

function SWEP:PrimaryAttack()
	if self.Owner:WaterLevel() == 3 then -- No weapons may fire underwater
		self:EmitSound("Weapon_Pistol.Empty")
		self:SetNextPrimaryFire(CurTime() + 0.2)
		return
	end

	if self:CanPrimaryAttack() then
		self:SetNextPrimaryFire(CurTime() + 1 / (self.Primary.RPM / 60))
		self:TakePrimaryAmmo(1)
		self:ShootBullet(self.Primary.Damage,self.Primary.Recoil,self.Primary.NumShots,self.Primary.Spread)
		self.Owner:SetAnimation(PLAYER_ATTACK1)
		self:EmitSound(self.Primary.Sound,75,math.random(95,105))
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	elseif SERVER and self:Clip1() <= 0 then
		timer.Simple(0.1,function()
			if not IsValid(self) or not IsValid(self.Owner) or not IsValid(self.Owner:GetActiveWeapon()) or self.Owner:GetActiveWeapon():GetClass() ~= OurClass then return end

			self:SetHoldType("melee")

			timer.Simple(0.7,function()
				if not IsValid(self) or not IsValid(self.Owner) or not IsValid(self.Owner:GetActiveWeapon()) or self.Owner:GetActiveWeapon():GetClass() ~= OurClass then return end

				self.Owner:DoAnimationEvent(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE)
				self.Owner:ViewPunch(ViewPunchUp)
				self.Owner:EmitSound("weapons/iceaxe/iceaxe_swing1.wav")

				timer.Simple(0.15,function()
					if not IsValid(self) or not IsValid(self.Owner) or not IsValid(self.Owner:GetActiveWeapon()) or self.Owner:GetActiveWeapon():GetClass() ~= OurClass then return end
					self:SetHoldType("normal")

					local EffectEnt = ents.Create("prop_physics")
					EffectEnt:SetModel("models/weapons/w_pistol.mdl")

					local Ang = self.Owner:EyeAngles()
					Ang:SetUnpacked(Ang.p,Ang.y - 180,Ang.r)
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

					local Weapons = self.Owner:GetWeapons() -- We need to select a different weapon, otherwise the viewmodels might glitch out here
					if #Weapons > 0 then
						self.Owner:SelectWeapon(Weapons[1]:GetClass())
					end

					self:Remove()
				end)
			end)
		end)
	end
end

function SWEP:Reload()
	return false
end

if CLIENT then
	function SWEP:FireAnimationEvent(_,_,event) -- No shell ejection or muzzleflash
		if event == 21 or event == 22 or event == 6001 then return true end
	end
end