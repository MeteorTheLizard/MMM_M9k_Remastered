SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9kR: Other"
SWEP.PrintName = "Flaregun"

SWEP.Slot = 1
SWEP.HoldType = "revolver"
SWEP.Spawnable = true

SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_flaregun.mdl"
SWEP.WorldModel = "models/weapons/w_357.mdl"

SWEP.Primary.Sound = "weapons/mmm/flaregun-fire.mp3"
SWEP.Primary.SoundVolume = 95

SWEP.Primary.RPM = 120
SWEP.Primary.ClipSize = 1
SWEP.Primary.KickUp = 12
SWEP.Primary.KickDown = 5
SWEP.Primary.KickHorizontal = 6
SWEP.Primary.Automatic = false
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 0
SWEP.Primary.Spread = 0
SWEP.Primary.Ammo = "rzmflaregun"

SWEP.IronSightsPos = Vector(-5.7,0,2)
SWEP.IronSightsAng = Vector(2,0,0)
SWEP.bBlockIronSights = true

SWEP.bBlockShellEject = true
SWEP.bBlockMuzzleFlash = true
SWEP.bFiresEntity = true


if SERVER then

	local aCached1 = Angle(90,0,0)
	local vCached1 = Vector(0,0,1)
	local cCached1 = Color(255,93,0)


	function SWEP:InitializeHooked()
		self:SetColor(cCached1)
		self:SetMaterial("models/debug/debugwhite")
	end


	function SWEP:ResetInternalVarsHooked()
		self.iReloadTime = nil

		if IsValid(self.Owner) then
			self.Owner:StopSound("weapons/mmm/flaregun-reload1.mp3")
		end
	end


	function SWEP:PrimaryAttackHooked()

		self.Owner:LagCompensation(true)

		local aAim = self.Owner:GetAimVector()
		local vSide = aAim:Cross(vCached1)


		local eProjectile = ents.Create("m9k_launched_flare")

			SafeRemoveEntityDelayed(eProjectile,10)


		if IsValid(eProjectile) then

			eProjectile:SetAngles(aAim:Angle() + aCached1)
			eProjectile:SetPos(self.Owner:GetShootPos() + vSide * 12 + vSide:Cross(aAim) * -5)

			eProjectile:SetOwner(self.Owner)

			if MMM_M9k_CPPIExists then
				eProjectile:CPPISetOwner(self.Owner)
			end

			eProjectile.M9kr_CreatedByWeapon = true -- Required
			eProjectile:SetNWBool("M9kR_Created",true) -- Mark it for Clients.

			eProjectile:Spawn()
			eProjectile:Activate()


			eProjectile.BuildZoneOverride = true -- MMM Compat
			eProjectile.WasDropped = true


			local obj_Phys = eProjectile:GetPhysicsObject()

			if IsValid(obj_Phys) then
				obj_Phys:SetVelocity(aAim * 2500)
				obj_Phys:SetDragCoefficient(10)
			end
		end

		self.Owner:LagCompensation(false)

	end


	function SWEP:ReloadHooked() -- Custom reload animation since this Weapon doesn't have one.

		if not self._CanReload then return true end -- Don't reload when we can't or we are full.

		self._CanReload = false


		-- Put remaining mag in player inventory
		self.Owner:GiveAmmo(self:Clip1(),self.Primary.Ammo,true)

		self:SetClip1(0)


		net.Start("MMM_M9kr_Weapons")
			net.WriteEntity(self)
			net.WriteInt(3,6)
		net.Broadcast()


		self:SendWeaponAnim(ACT_VM_HOLSTER)

		self.iReloadTime = CurTime() + 2.5
		self:SetNextPrimaryFire(self.iReloadTime)


		self.Owner:EmitSound("weapons/mmm/flaregun-reload1.mp3",65)


		return true
	end


	function SWEP:ThinkHooked()
		if self.iReloadTime and self.iReloadTime < CurTime() then

			self.iReloadTime = nil
			self._CanReload = true

			self:DefaultReload(ACT_VM_DRAW)

		end
	end
end


if CLIENT then
	function SWEP:ReloadHooked()
		if self:Clip1() >= self.Primary.ClipSize then -- Don't reload when we can't or we are full.
			return true
		end
	end

	function SWEP:FireAnimationEvent() -- No effects!
		return true
	end
end