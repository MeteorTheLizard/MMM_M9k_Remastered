SWEP.Base = "bobs_shotty_base"
SWEP.Category = "M9kR: Specialties"
SWEP.PrintName = "M79 GL"

SWEP.Spawnable = true

SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_m79_grenadelauncher.mdl"
SWEP.WorldModel = "models/weapons/w_m79_grenadelauncher.mdl"

SWEP.ReloadSoundStart = "weapons/M79/barrelup.mp3"
SWEP.ReloadSound = "weapons/M79/xm_insert.mp3"
SWEP.ReloadSoundFinish = "weapons/M79/m79_close.mp3"

SWEP.DrawSound = "weapons/M79/m79_close.mp3"
SWEP.DrawCantHear = true

SWEP.Primary.Sound = "weapons/M79/40mmthump.wav"

SWEP.Primary.RPM = 34
SWEP.Primary.ClipSize = 1
SWEP.Primary.KickUp = 6
SWEP.Primary.KickDown = 3
SWEP.Primary.KickHorizontal = 5
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "40mmGrenade"

SWEP.IronSightsPos = Vector(-4.633,-7.651,2.108)
SWEP.IronSightsAng = Vector(1.294,0.15,0)

SWEP.bBlockShellEject = true
SWEP.bBlockMuzzleFlash = true
SWEP.bFiresEntity = true


-- These are required for firstperson

sound.Add({
	name = "M79_launcher.close",
	channel = CHAN_ITEM,
	volume = 1.0,
	sound = "weapons/M79/m79_close.mp3"
})

sound.Add({
	name = "M79_glauncher.barrelup",
	channel = CHAN_ITEM,
	volume = 1.0,
	sound = "weapons/M79/barrelup.mp3"
})

sound.Add({
	name = "M79_glauncher.InsertShell",
	channel = CHAN_ITEM,
	volume = 1.0,
	sound = "weapons/M79/xm_insert.mp3"
})

sound.Add({
	name = "M79_launcher.draw",
	channel = CHAN_ITEM,
	volume = 1.0,
	sound = "weapons/M79/m79_close.mp3"
})


if SERVER then

	local aCached1 = Angle(90,0,0)
	local vCached1 = Vector(0,0,1)


	function SWEP:PrimaryAttackHooked2()

		self.Owner:LagCompensation(true)

		local aAim = self.Owner:GetAimVector()
		local vSide = aAim:Cross(vCached1)


		local eProjectile = ents.Create("m9k_launched_m79")

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