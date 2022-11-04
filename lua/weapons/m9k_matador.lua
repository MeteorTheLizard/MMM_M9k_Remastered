SWEP.Base = "bobs_scoped_base"
SWEP.Category = "M9kR: Specialties"
SWEP.PrintName = "Matador"

SWEP.DynamicLightScale = 1 -- Set to Default

SWEP.Slot = 4
SWEP.HoldType = "rpg"
SWEP.Spawnable = true

SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_mat.mdl"
SWEP.WorldModel = "models/weapons/w_gdcw_matador_rl.mdl"

SWEP.Primary.Sound = "GDC/Rockets/MATADORF.wav"

SWEP.Primary.RPM = 60
SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.KickUp = 10
SWEP.Primary.KickDown = 8
SWEP.Primary.KickHorizontal = 10
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "RPG_Round"

SWEP.ScopeType ="rocketscope"
SWEP.ScopeStages = 3
SWEP.ScopeScale = 1.25
SWEP.ReticleScale = 0.5

SWEP.bBlockIdleSight = true
SWEP.bBlockShellEject = true
SWEP.bBlockMuzzleFlash = true
SWEP.bFiresEntity = true


if SERVER then

	local sTag = "MMM_M9kr_Matador"

	local vCached1 = Vector(0,0,1)


	function SWEP:ThrowWeaponAway()

		self:SendWeaponAnim(ACT_VM_RELOAD)

		timer.Create(sTag .. self:EntIndex(),0.6,1,function()

			if not IsValid(self) or not IsValid(self.Owner) or self.Owner:GetActiveWeapon() ~= self then return end


			local eOwner = self.Owner -- Optimization


			local eDropped = ents.Create("prop_physics")
			if not IsValid(eDropped) then return end

				SafeRemoveEntityDelayed(eDropped,20)


			eDropped:SetModel("models/weapons/w_gdcw_matador_rl.mdl")


			local aEye = eOwner:EyeAngles() -- Needs to be done twice

			local aAng = eOwner:EyeAngles() -- It doesn't copy
				aAng:SetUnpacked(aAng.p,aAng.y + 180,aAng.r)

			eDropped:SetAngles(aAng)


			eDropped:SetPos(eOwner:GetShootPos() + (eOwner:GetRight() * 15))

			eDropped:SetCollisionGroup(COLLISION_GROUP_WEAPON)
			eDropped:Spawn()


			eDropped.WasDropped = true -- MMM Compatibility


			if MMM_M9k_CPPIExists then
				eDropped:CPPISetOwner(eOwner)
			end


			local obj_Phys = eDropped:GetPhysicsObject()

			if IsValid(obj_Phys) then
				obj_Phys:SetVelocity(-(aEye:Forward() * 25) + aEye:Right() * 100)

				--obj_Phys:AddAngleVelocity(VectorRand(-50,50))
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


		local eProjectile = ents.Create("m9k_ammo_matador_90mm")

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


		util.ScreenShake(self.Owner:GetShootPos(),1000,10,0.3,500)


		if self:Clip1() == 0 or (MMM_M9k_IsSinglePlayer and self:Clip1() == 1) then


			-- Reset scope

			if self.IsScoping then
				self.Owner:SetFOV(0,0)
			end

			self.IsScoping = false
			self.ScopeStage = 0

			net.Start("MMM_M9kr_Weapons_Snipers")
				net.WriteEntity(self) -- Network update
				net.WriteBool(self.IsScoping)
				net.WriteInt(self.ScopeStage,6)
			net.Broadcast()


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

function SWEP:Reload() -- Reloading? Pft. That's for losers!
	return true
end