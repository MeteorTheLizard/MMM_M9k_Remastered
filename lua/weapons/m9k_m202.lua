SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9kR: Specialties"
SWEP.PrintName = "M202"

SWEP.Slot = 4
SWEP.HoldType = "rpg"
SWEP.Spawnable = true

SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_m202.mdl"
SWEP.WorldModel = "models/weapons/w_m202.mdl"

SWEP.Primary.Sound = "gdc/rockets/m202f.wav"

SWEP.Primary.RPM = 200
SWEP.Primary.ClipSize = 4
SWEP.Primary.DefaultClip = 4
SWEP.Primary.KickUp = 2
SWEP.Primary.KickDown = 1
SWEP.Primary.KickHorizontal = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "RPG_Round"

SWEP.IronSightsPos = Vector(-4.7089,1.2661,-0.3572)
SWEP.IronSightsAng = Vector(-0.1801,0.985,0)

SWEP.bBlockIdleSight = true
SWEP.bBlockShellEject = true
SWEP.bBlockMuzzleFlash = true
SWEP.bFiresEntity = true


local sTag = "MMM_M9kr_Weapons_M202"


if SERVER then

	local aUpPunch = Angle(-13,0,0)
	local vCached1 = Vector(0,0,1)


	function SWEP:ThrowWeaponAway()

		self.Owner:DoAnimationEvent(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE)
		self.Owner:ViewPunch(aUpPunch)
		self.Owner:EmitSound("weapons/iceaxe/iceaxe_swing1.wav")


		timer.Create(sTag .. self:EntIndex(),0.15,1,function()

			if not IsValid(self) or not IsValid(self.Owner) or self.Owner:GetActiveWeapon() ~= self then return end


			local eOwner = self.Owner -- Optimization


			local eDropped = ents.Create("prop_physics")
			if not IsValid(eDropped) then return end

				SafeRemoveEntityDelayed(eDropped,20)


			eDropped:SetModel("models/weapons/w_m202.mdl")


			local aAng = eOwner:EyeAngles()
				aAng:SetUnpacked(aAng.p,aAng.y + 90,aAng.r)

			eDropped:SetAngles(aAng)


			eDropped:SetPos(eOwner:GetShootPos())

			eDropped:SetCollisionGroup(COLLISION_GROUP_WEAPON)
			eDropped:Spawn()


			eDropped.WasDropped = true -- MMM Compatibility


			if MMM_M9k_CPPIExists then
				eDropped:CPPISetOwner(eOwner)
			end


			local obj_Phys = eDropped:GetPhysicsObject()

			if IsValid(obj_Phys) then
				obj_Phys:SetVelocity(eOwner:GetAimVector() * 250)

				obj_Phys:AddAngleVelocity(VectorRand(-50,50))
			end


			if eOwner:GetAmmoCount(self.Primary.Ammo) > 0 then

				self:DefaultReload(ACT_VM_DRAW)


				self:CallOnClient("DeployHooked")
				self:DeployHooked()

				self._CanReload = true

			else -- Remove the Weapon when we are out of ammo!

				self:Remove()

			end
		end)
	end


	function SWEP:PrimaryAttackHooked()

		self.Owner:LagCompensation(true)

		local aAim = self.Owner:GetAimVector()
		local vSide = aAim:Cross(vCached1)


		local eProjectile = ents.Create("m9k_m202_rocket")

		if IsValid(eProjectile) then

			eProjectile:SetAngles(aAim:Angle())
			eProjectile:SetPos(self.Owner:GetShootPos() + vSide * 12 + vSide:Cross(aAim) * -5)

			eProjectile:SetOwner(self.Owner)

			if MMM_M9k_CPPIExists then
				eProjectile:CPPISetOwner(self.Owner)
			end

			eProjectile.M9kr_CreatedByWeapon = true -- Required
			eProjectile:SetNWBool("M9kR_Created",true) -- Mark it for Clients.

			eProjectile:Spawn()
			eProjectile:Activate()
		end

		self.Owner:LagCompensation(false)


		if self:Clip1() == 0 or (MMM_M9k_IsSinglePlayer and self:Clip1() == 1) then
			self:ThrowWeaponAway() -- Automatic Reload
		end
	end


	function SWEP:HolsterHooked() -- Remove when empty // Reload clip when possible.

		if self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0 and self:Clip1() <= 0 then -- Just dump it.
			self:Remove()

			return
		end


		local iClip = self:Clip1()

		if iClip < self.Primary.ClipSize then -- Refill magazine, make the holster act like a reload.

			local iReserve = self.Owner:GetAmmoCount(self.Primary.Ammo)

			self:SetClip1(iReserve + iClip >= self.Primary.ClipSize and self.Primary.ClipSize or (iReserve + iClip))
			self.Owner:RemoveAmmo(self.Primary.ClipSize - iClip,self.Primary.Ammo)

		end
	end


	function SWEP:ReloadHooked() -- Custom reload animation since this Weapon doesn't have one.

		if not self._CanReload or self:Clip1() >= self.Primary.ClipSize then return true end -- Don't reload when we can't or we are full.

		self._CanReload = false

		self:ThrowWeaponAway() -- Reload """"animation""""

		return true
	end
end


-- SHARED --

function SWEP:ResetInternalVarsHooked()
	timer.Remove(sTag .. self:EntIndex())
end


function SWEP:DeployHooked() -- Fix hand after deploying

	local vm = self.Owner:GetViewModel() -- Validity of self.Owner is checked in SWEP.Deploy

	if IsValid(vm) then -- SERVER and Owner only

		timer.Create(sTag .. self:EntIndex(),vm:SequenceDuration() + 0.1,1,function() -- Fixes buggy hand position after deploying
			if not IsValid(self) or not IsValid(self.Owner) or self.Owner:GetActiveWeapon() ~= self then return end

			self:SendWeaponAnim(ACT_VM_IDLE) -- Fix the hand.
		end)
	end
end