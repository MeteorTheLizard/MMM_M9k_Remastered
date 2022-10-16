SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9kR: Other"
SWEP.PrintName = "Peashooter Rifle"

SWEP.Slot = 2
SWEP.HoldType = "ar2"
SWEP.Spawnable = true
SWEP.UseHands = true

SWEP.ViewModelFOV = 50
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/c_irifle.mdl"
SWEP.WorldModel = "models/weapons/w_irifle.mdl"

SWEP.Primary.Sound = "weapons/mmm/peashooter-fire.mp3"

SWEP.Primary.RPM = 600
SWEP.Primary.ClipSize = 100
SWEP.Primary.DefaultClip = 100
SWEP.Primary.KickUp = 0.25
SWEP.Primary.KickDown = 0.25
SWEP.Primary.KickHorizontal = 0.5
SWEP.Primary.Automatic = true
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 1
SWEP.Primary.Spread = 0.05
SWEP.Primary.Ammo = ""

SWEP.IronSightsPos = Vector(-3.5,-7,2)
SWEP.IronSightsAng = Vector(0,0,0)

SWEP.bBlockMuzzleFlash = true


if SERVER then

	local vPunch = Angle(-13,0,0)


	function SWEP:PrimaryAttackHooked() -- Logic to throw away the Weapon when it is empty

		if self:Clip1() > 1 then return end


		self:SetHoldType("melee")


		timer.Simple(0.7,function()

			if not IsValid(self) or not IsValid(self.Owner) or self.Owner:GetActiveWeapon() ~= self then return end


			self.Owner:DoAnimationEvent(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE)
			self.Owner:ViewPunch(vPunch)
			self.Owner:EmitSound("weapons/iceaxe/iceaxe_swing1.wav")


			timer.Simple(0.15,function()

				if not IsValid(self) or not IsValid(self.Owner) or self.Owner:GetActiveWeapon() ~= self then return end


				self:SetHoldType("normal")


				local eDropped = ents.Create("prop_physics")

					SafeRemoveEntityDelayed(eDropped,5)


				if IsValid(eDropped) then

					eDropped:SetModel("models/weapons/w_irifle.mdl")


					local aAng = self.Owner:EyeAngles()

					aAng:SetUnpacked(aAng.p,aAng.y - 180,aAng.r)

					eDropped:SetAngles(aAng)


					eDropped:SetPos(self.Owner:GetShootPos())
					eDropped:Spawn()

					eDropped:SetCollisionGroup(COLLISION_GROUP_WEAPON)


					eDropped.WasDropped = true -- MMM Compatibility
					eDropped.BuildZoneOverride = true


					if MMM_M9k_CPPIExists then
						eDropped:CPPISetOwner(self.Owner)
					end


					local obj_Phys = eDropped:GetPhysicsObject()

					if IsValid(obj_Phys) then
						obj_Phys:SetVelocity(self.Owner:GetAimVector() * 250)
						obj_Phys:AddAngleVelocity(VectorRand(-50,50))
					end

				end


				self.Owner:StripWeapon("m9k_mmm_peashooter_rifle")

			end)
		end)
	end


	function SWEP:Reload()
		return
	end
end


if CLIENT then

	local drawSimpleText = draw.SimpleText -- Optimizations
	local TEXT_ALIGN_CENTER = TEXT_ALIGN_CENTER

	local cCached1 = Color(255,235,0)


	function SWEP:DrawWeaponSelection(iX,iY,iWide,iTall)
		drawSimpleText("l","WeaponIconsSelected_m9k",iX + iWide / 2,iY + iTall * 0.02,cCached1,TEXT_ALIGN_CENTER)
		drawSimpleText("l","WeaponIcons_m9k",iX + iWide / 2,iY + iTall * 0.02,cCached1,TEXT_ALIGN_CENTER)
	end


	function SWEP:FireAnimationEvent(_,_,iEvent) -- No shell ejection or Muzzleflash
		if iEvent == 21 or iEvent == 22 then return end
	end


	function SWEP:Reload()
		return
	end
end