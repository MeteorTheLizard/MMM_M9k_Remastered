-- ----- ----- ----- ----- ------- ----- ----- ----- ----- -----
--[[ Dev Notes:

	It is recommended to look at the Default variables assigned to every SWEP as some variables may not be documented.


	There is no more bob here. This base is 100% custom.

	Shotguns are not capable of Dynamic Reloading. Instead they use basic networking to transmit the Sounds.
	Because of this, Sound Scripts are still needed for Shotguns and should be added to their SWEP file.
	Sounds are also affected by PING. (Bad, but what can ya do!)


	Setting any of these is NOT required! But recommended so that other players can hear the sounds as well!

	-- Sound before loading in the shells.
	SWEP.ReloadSoundStart
	SWEP.ReloadSoundStartVolume

	-- Sound of loading the shells.
	SWEP.ReloadSound
	SWEP.ReloadSoundVolume

	-- Sound after loading the shells.
	SWEP.ReloadSoundFinish
	SWEP.ReloadSoundFinishVolume


	SWEP.Primary.SoundPump			- Sound that is played after firing a round. (optional)
	SWEP.Primary.SoundPumpDelay		- Delay of SoundPump. (optional)


	SWEP.bShouldHearReload			- Can be set to true to make the holder of the Weapon hear ALL reload sounds no matter what, useful if your Viewmodel does not make use of sound scripts.


	SWEP.ReloadInstantly			- Can be set to true to make the Weapon have a full Magazine instantly instead of putting each round in individually.

	SWEP.iShellTime					- Can be set to a number for a custom shell loading delay.


	SWEP.PrimaryAttackHooked2		- Can be set to a function that is called after SWEP.PrimaryAttackHooked which is used in this base. ( Example can be found in m9k_ex41.lua )


	Shotguns are not affected by movement spread by default so setting SWEP.ShouldDoMoveSpread in the SWEP file to false is pointless.

	Shotguns do have IronSights but they're pointless (gameplay-wise) and usually make the shooting look really bad. SWEP.bShotgunNoIron can be set to true to disable IronSights.
		> It's recommended to set this var to true on Shotguns that have a cocking animation.

	If your Weapon is a Shotgun but uses a Magazine, it is recommended to use bobs_gun_base instead.

	-- ----- ----- ----- ----- ------- ----- ----- ----- ----- -----

	bobs_shotty_base.lua makes use of networking. It transmit Integers as an identifier.

	-- 1 = Reload Start sound
	-- 2 = Reload sound
	-- 3 = Reload Finish sound
	-- 4 = Reset vars
	-- 5 = After PrimaryAttack sound

]]
-- ----- ----- ----- ----- ------- ----- ----- ----- ----- -----

SWEP.Base = "bobs_gun_base"
SWEP.Slot = 3

SWEP.HoldType = "shotgun"

SWEP.ShouldDoMoveSpread = false

-- ----- ----- ----- ----- ------- ----- ----- ----- ----- -----
-- Optimization
-- ----- ----- ----- ----- ------- ----- ----- ----- ----- -----

local sTag = "MMM_M9kr_Weapons_Shotguns"

-- ----- ----- ----- ----- ------- ----- ----- ----- ----- -----
-- SERVER
-- ----- ----- ----- ----- ------- ----- ----- ----- ----- -----

if SERVER then

	util.AddNetworkString(sTag)


	SWEP.iShotgunReloadState = 0
	SWEP.iShotgunNextAction = 0
	SWEP.iNextShellTime = 0 -- Required


	local fSetDelay = function(self) -- Let's not have the same code like 10 times, alright?
		if not IsValid(self.Owner) then return end


		local vm = self.Owner:GetViewModel()

		if IsValid(vm) then

			local iDur = CurTime() + vm:SequenceDuration() + 0.1 -- Action delay

			self:SetNextPrimaryFire(iDur)
			self:SetNextSecondaryFire(iDur)

			self.iShotgunNextAction = iDur - 0.1 -- Next action should be able to happen sooner than shooting, intentional!

			self.iNextShellTime = (self.iShellTime and CurTime() + self.iShellTime) or self.iShotgunNextAction -- Custom reload duration when it exists

		end
	end


	local fNetEvent = function(self,iNumber)

		net.Start(sTag)
			net.WriteEntity(self)
			net.WriteInt(iNumber,6)
		net.Broadcast()

	end


	function SWEP:ResetInternalVarsHooked()

		self._CanReload = true
		self.iShotgunReloadState = 0
		self.iShotgunNextAction = 0
		self.bBlockIronSights = nil

		self:SetHoldType(self.HoldType)

		fNetEvent(self,4)

	end


	function SWEP:PrimaryAttackHooked()

		fNetEvent(self,5)

		self:SetHoldType(self.HoldType)
		fNetEvent(self,4) -- For some reason we have to remind the client that this is a shotgun.


		if self.PrimaryAttackHooked2 then
			self:PrimaryAttackHooked2()
		end

	end


	function SWEP:ReloadHooked()

		if not self._CanReload or not self.ReloadInstantly and self:Clip1() >= self.Primary.ClipSize then return true end


		self._CanReload = false


		if self.ReloadInstantly then -- Refund ammo
			self.Owner:GiveAmmo(self:Clip1(),self.Primary.Ammo,true)

			self:SetClip1(0)

			fNetEvent(self,2) -- Network reload animation
		end


		if self.iShotgunReloadState == 0 then -- Start reloading

			self.iShotgunReloadState = 1
			self.bBlockIronSights = true

			self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_START)
			self:SetHoldType("ar2")

			fSetDelay(self)
			fNetEvent(self,1) -- Network start
		end


		return true
	end


	function SWEP:ThinkHooked()

		if (self.iShotgunNextAction > CurTime() and self.iNextShellTime > CurTime()) or not IsValid(self.Owner) then return end -- Don't do anything if we are still doing stuff // Owner not valid??


		if not self._CanReload and self.iShotgunNextAction < CurTime() then -- Reset reload state when we finished reloading
			self._CanReload = true
		end


		if not self.ReloadInstantly and ((self.Owner:KeyDown(IN_ATTACK) and self.iShotgunReloadState ~= 0) or (self.iShotgunReloadState ~= 0 and self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0)) then -- Cancel reloading

			self:ResetInternalVarsHooked()
			self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)
			self._CanReload = false

			fSetDelay(self)
			fNetEvent(self,3) -- Network finish

			return
		end


		if self.iShotgunReloadState == 1 and (self:GetNextPrimaryFire() <= CurTime() or self.iNextShellTime <= CurTime()) then

			if self:Clip1() == self.Primary.ClipSize or self.ReloadInstantly then -- Reload finished


				if self.ReloadInstantly then

					local iAmount = self.Primary.ClipSize
					local sType = self.Primary.Ammo

					self:SetClip1(self.Owner:GetAmmoCount(sType) >= iAmount and iAmount or self.Owner:GetAmmoCount(sType))

					self.Owner:SetAmmo(self.Owner:GetAmmoCount(sType) - iAmount,sType)

				end


				self:ResetInternalVarsHooked()
				self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)
				self._CanReload = false

				fSetDelay(self)
				fNetEvent(self,3) -- Network finish

				return
			end


			self.Owner:SetAnimation(PLAYER_RELOAD)
			self:SendWeaponAnim(ACT_VM_RELOAD)


			fSetDelay(self)
			fNetEvent(self,2) -- Network round load


			local sType = self.Primary.Ammo

			self:SetClip1(self:Clip1() + 1)

			self.Owner:SetAmmo(self.Owner:GetAmmoCount(sType) - 1,sType)

		end
	end
end

-- ----- ----- ----- ----- ------- ----- ----- ----- ----- -----
-- CLIENT
-- ----- ----- ----- ----- ------- ----- ----- ----- ----- -----

if CLIENT then

	net.Receive(sTag,function() -- Prediction is for losers anyway. I never had such a fluid coding experience when working on SWEPs since I started using the NET library instead.

		local eWep = net.ReadEntity()
		if not IsValid(eWep) or not eWep._IsM9kRemasteredBased then return end


		eWep:SetHoldType("ar2")


		local bIsValidOwner = IsValid(eWep.Owner)
		local bShouldHear = bIsValidOwner and ((eWep.Owner == LocalPlayer() and eWep.Owner:GetViewEntity() ~= eWep.Owner) and true) or (eWep.Owner ~= LocalPlayer() and true) or eWep.bShouldHearReload or false


		local iEvent = net.ReadInt(6)

		if iEvent == 1 then

			eWep.bBlockIronSights = true

			if bIsValidOwner and bShouldHear and eWep.ReloadSoundStart then
				eWep.Owner:EmitSound(eWep.ReloadSoundStart,eWep.ReloadSoundStartVolume or 70,100,1,CHAN_ITEM)
			end

		elseif iEvent == 2 then

			if bIsValidOwner and bShouldHear and eWep.ReloadSound then
				eWep.Owner:SetAnimation(PLAYER_RELOAD)

				eWep.Owner:EmitSound(eWep.ReloadSound,eWep.ReloadSoundVolume or 70,100,1,CHAN_ITEM)
			end

		elseif iEvent == 3 then

			if bIsValidOwner and bShouldHear and eWep.ReloadSoundFinish then
				eWep.Owner:EmitSound(eWep.ReloadSoundFinish,eWep.ReloadSoundFinishVolume or 70,100,1,CHAN_ITEM)
			end

			eWep:SetHoldType(eWep.HoldType)

		elseif iEvent == 4 then -- Used to reset stuff

			eWep.bBlockIronSights = nil

			eWep:SetHoldType(eWep.HoldType)

			return -- Required

		elseif iEvent == 5 and bIsValidOwner and eWep.Primary.SoundPump and bShouldHear then -- After PrimaryAttack

			eWep.NextPumpSound = CurTime() + (eWep.Primary.SoundPumpDelay or 0)

		end
	end)


	function SWEP:ReloadHooked()
		return true
	end


	function SWEP:ThinkHooked()
		if self.NextPumpSound and self.NextPumpSound < CurTime() then

			self.NextPumpSound = nil

			if IsValid(self.Owner) then
				self.Owner:EmitSound(self.Primary.SoundPump,75,100,1,CHAN_ITEM)
			end
		end
	end
end

-- ----- ----- ----- ----- ------- ----- ----- ----- ----- -----
-- SHARED
-- ----- ----- ----- ----- ------- ----- ----- ----- ----- -----

local fBlank = function() end


function SWEP:InitializeHooked()
	if self.bShotgunNoIron then -- This weapon should not have ironsights
		self.bShotgunNoIron = nil -- Save a microscopic amount of ram

		self.IronSight = fBlank
	end
end