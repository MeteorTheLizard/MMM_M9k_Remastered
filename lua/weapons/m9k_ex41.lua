SWEP.Base = "bobs_shotty_base"
SWEP.Category = "M9kR: Specialties"
SWEP.PrintName = "EX41"

SWEP.Spawnable = true

SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_ex41.mdl"
SWEP.WorldModel = "models/weapons/w_ex41.mdl"

SWEP.ReloadSound = "weapons/ex41/m3_insertshell.mp3"
SWEP.ReloadSoundFinish = "weapons/ex41/m3_pump.mp3"

SWEP.DrawSound = "weapons/ex41/draw.mp3"

SWEP.Primary.Sound = "weapons/M79/40mmthump.wav"
SWEP.Primary.SoundPump = "weapons/ex41/m3_pump.mp3"
SWEP.Primary.SoundPumpDelay = 0.5

SWEP.Primary.RPM = 40
SWEP.Primary.ClipSize = 3
SWEP.Primary.KickUp = 5
SWEP.Primary.KickDown = 3
SWEP.Primary.KickHorizontal = 4
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "40mmGrenade"

SWEP.IronSightsPos = Vector(-2.85,-3,1.3)
SWEP.IronSightsAng = Vector(2,-1.1,0)

SWEP.bBlockIdleSight = true
SWEP.bBlockShellEject = true
SWEP.bBlockMuzzleFlash = true
SWEP.bFiresEntity = true

SWEP.iPrimaryAnimOnLast = ACT_VM_DRAW


-- These are required for firstperson

sound.Add({
	name = "EX41.Pump",
	channel = CHAN_ITEM,
	volume = 1.0,
	sound = "weapons/ex41/m3_pump.mp3"
})

sound.Add({
	name = "EX41.Insertshell",
	channel = CHAN_ITEM,
	volume = 1.0,
	sound = "weapons/ex41/m3_insertshell.mp3"
})


if SERVER then

	local aCached1 = Angle(90,0,0)
	local vCached1 = Vector(0,0,1)


	function SWEP:PrimaryAttackHooked2()

		self.Owner:LagCompensation(true)

		local aAim = self.Owner:GetAimVector()
		local vSide = aAim:Cross(vCached1)


		local eProjectile = ents.Create("m9k_launched_m79") -- We use the m79 entity here since its identical with the original EX41 one

		if IsValid(eProjectile) then

			SafeRemoveEntityDelayed(eProjectile,30)


			eProjectile:SetAngles(aAim:Angle() + aCached1)
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

	end
end