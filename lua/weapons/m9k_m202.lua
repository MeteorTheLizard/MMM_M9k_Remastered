SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9K Specialties"
SWEP.PrintName = "M202"

SWEP.Slot = 5
SWEP.HoldType = "rpg"
SWEP.Spawnable = true

SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_m202.mdl"
SWEP.WorldModel = "models/weapons/w_m202.mdl"

SWEP.Primary.Sound = "RPGF.single"
SWEP.Primary.RPM = 50
SWEP.Primary.ClipSize = 4
SWEP.Primary.DefaultClip = 4
SWEP.Primary.KickUp = 2
SWEP.Primary.KickDown = 1
SWEP.Primary.KickHorizontal = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "RPG_Round"

SWEP.IronSightsPos = Vector(-4.7089,1.2661,-0.3572)
SWEP.IronSightsAng = Vector(-0.1801,0.985,0)

SWEP.M202IsReloading = false

local MetaE = FindMetaTable("Entity")
local CPPIExists = MetaE.CPPIGetOwner and true or false
local VectorCache1 = Vector(0,0,1)
local ViewPunchUp = Angle(-13,0,0)

function SWEP:Deploy()
	self:SetHoldType(self.HoldType)

	local vm = self.Owner:GetViewModel()
	if IsValid(vm) then -- This is required since the code should only run on the server or on the player holding the gun (Causes errors otherwise)
		self.CanReload = false
		self:SetNWBool("CanIronSights",false)
		self:SendWeaponAnim(ACT_VM_DRAW)

		local Dur = vm:SequenceDuration() + 0.1
		timer.Create("M202_DeployFix_" .. self.OurIndex,Dur,1,function() -- Fixes buggy hand position after deploying
			if not IsValid(self) or not IsValid(self.Owner) or not IsValid(self.Owner:GetActiveWeapon()) or self.Owner:GetActiveWeapon():GetClass() ~= self.ClassName then return end
			self:SendWeaponAnim(ACT_VM_IDLE)
			self:SetNWBool("CanIronSights",true)
			self.CanReload = true
		end)

		self:SetNextPrimaryFire(CurTime() + Dur)
		self:SetNextSecondaryFire(CurTime() + Dur)
	end

	return true
end

function SWEP:PrimaryAttack()
	if self.Owner:WaterLevel() == 3 then -- No weapons may fire underwater
		self:EmitSound("Weapon_Pistol.Empty")
		self:SetNextPrimaryFire(CurTime() + 0.2)
		return
	end

	if self:CanPrimaryAttack() and self:GetNextPrimaryFire() < CurTime() then
		self:SetNextPrimaryFire(CurTime() + 1 / (self.Primary.RPM / 60))

		if SERVER then
			self:TakePrimaryAmmo(1)

			local aim = self.Owner:GetAimVector()
			local side = aim:Cross(VectorCache1)
			local pos = self.Owner:GetShootPos() + side * 6 + side:Cross(aim) * -5

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

		local KickUp = self.Primary.KickUp
		local KickDown = self.Primary.KickDown
		local KickHorizontal = self.Primary.KickHorizontal

		if self.Owner:KeyDown(IN_DUCK) then
			KickUp = self.Primary.KickUp / 2
			KickDown = self.Primary.KickDown / 2
			KickHorizontal = self.Primary.KickHorizontal / 2
		end

		local SharedRandom = Angle(util.SharedRandom("m9k_gun_kick1",-KickDown,-KickUp),util.SharedRandom("m9k_gun_kick2",-KickHorizontal,KickHorizontal),0)
		self.Owner:ViewPunch(SharedRandom) -- This needs to be shared

		if SERVER and game.SinglePlayer() or SERVER and self.Owner:IsListenServerHost() then -- This is specifically for the host or when in singleplayer
			local eyes = self.Owner:EyeAngles()
			eyes:SetUnpacked(eyes.pitch + SharedRandom.pitch,eyes.yaw + SharedRandom.yaw,0)
			self.Owner:SetEyeAngles(eyes)
		elseif CLIENT and not game.SinglePlayer() then -- This is for other players in multiplayer (Or anyone on the server if dedicated)
			local eyes = self.Owner:EyeAngles()
			eyes:SetUnpacked(eyes.pitch + (SharedRandom.pitch/5),eyes.yaw + (SharedRandom.yaw/5),0)
			self.Owner:SetEyeAngles(eyes)
		end

		self:AttackAnimation()
		self:EmitSound(self.Primary.Sound)
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	end
end

function SWEP:Holster()
	if not SERVER and self.Owner ~= LocalPlayer() then return end

	if self.IronSightState then
		self.Owner:SetFOV(0,0.3)
		self.IronSightState = false
		self.DrawCrosshair = true
	end

	if self.M202IsReloading == 2 then
		self:SetClip1(self.Owner:GetAmmoCount(self.Primary.Ammo) >= 4 and 4 or self.Owner:GetAmmoCount(self.Primary.Ammo))
	end

	self.M202IsReloading = false
	timer.Remove("M202_DeployFix_" .. self.OurIndex)
	timer.Remove("M202_Reload_" .. self.OurIndex)
	return true
end

function SWEP:IronSight()
	if self.Owner:GetViewEntity() ~= self.Owner or self.M202IsReloading or not self:GetNWBool("CanIronSights") then return end

	if self.Owner:KeyPressed(IN_ATTACK2) and not self.IronSightState then
		self.Owner:SetFOV(80,0.2)
		self.IronSightState = true
		self.DrawCrosshair = false
		self.LastCurTick = RealTime()
	elseif self.Owner:KeyReleased(IN_ATTACK2) then
		self.Owner:SetFOV(0,0.1)
		self.IronSightState = false
		self.DrawCrosshair = true
	end
end

if SERVER then
	function SWEP:Reload() -- This special snowflake got its own reload animation that I stitched together, neat huh?
		if self.CanReload and not self.M202IsReloading and self.Owner:GetAmmoCount(self.Primary.Ammo) >= 1 and self:Clip1() < self.Primary.ClipSize then
			self.M202IsReloading = true

			if self.IronSightState then
				self.Owner:SetFOV(0,0.1)
				self.IronSightState = false
				self.DrawCrosshair = true
			end

			local TimerName = "M202_Reload_" .. self.OurIndex
			timer.Create(TimerName,0.7,1,function()
				if not IsValid(self) or not IsValid(self.Owner) or not IsValid(self.Owner:GetActiveWeapon()) or self.Owner:GetActiveWeapon():GetClass() ~= self.ClassName then return end

				self.Owner:DoAnimationEvent(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE)
				self.Owner:ViewPunch(ViewPunchUp)
				self.Owner:EmitSound("weapons/iceaxe/iceaxe_swing1.wav")

				timer.Create(TimerName,0.15,1,function()
					if not IsValid(self) or not IsValid(self.Owner) or not IsValid(self.Owner:GetActiveWeapon()) or self.Owner:GetActiveWeapon():GetClass() ~= self.ClassName then return end

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

					timer.Create("M202_DeployFix_" .. self.OurIndex,self.Owner:GetViewModel():SequenceDuration() + 0.1,1,function() -- Fixes buggy hand position after deploying
						if not IsValid(self) or not IsValid(self.Owner) or not IsValid(self.Owner:GetActiveWeapon()) or self.Owner:GetActiveWeapon():GetClass() ~= self.ClassName then return end
						self:SendWeaponAnim(ACT_VM_IDLE)
						self.M202IsReloading = false
					end)
				end)
			end)
		end
	end
end