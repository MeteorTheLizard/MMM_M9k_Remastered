SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9kR: Specialties"
SWEP.PrintName = "RPG-7"

SWEP.Slot = 4
SWEP.HoldType = "rpg"
SWEP.Spawnable = true

SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_rl7.mdl"
SWEP.WorldModel = "models/weapons/w_rl7.mdl"

SWEP.Primary.Sound = "GDC/Rockets/RPGF.wav"

SWEP.Primary.RPM = 30
SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.KickUp = 3
SWEP.Primary.KickDown = 5
SWEP.Primary.KickHorizontal = 10
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "RPG_Round"

SWEP.IronSightsPos = Vector(-3.7384,-5.7481,-0.2713)
SWEP.IronSightsAng = Vector(1.1426,0.0675,0)

SWEP.bBlockIdleSight = true
SWEP.bBlockShellEject = true
SWEP.bBlockMuzzleFlash = true
SWEP.bFiresEntity = true


if SERVER then

	local vCached1 = Vector(0,0,1)


	function SWEP:PrimaryAttackHooked()

		self.Owner:LagCompensation(true)

		local aAim = self.Owner:GetAimVector()
		local vSide = aAim:Cross(vCached1)


		local eProjectile = ents.Create("m9k_ammo_rpg_heat")

		if IsValid(eProjectile) then

			eProjectile:SetAngles(aAim:Angle())
			eProjectile:SetPos(self.Owner:GetShootPos() + vSide * 6 + vSide:Cross(aAim) * -5)

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


		if self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 and not self.Owner.MMM_HasOPWeapons then -- MMM Compatibility

			timer.Simple(0,function() -- This needs to be delayed by one tick for singleplayer.
				if not IsValid(self) then return end

				self:Reload()

			end)
		end
	end
end