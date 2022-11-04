-- ----- ----- ----- ----- ------- ----- ----- ----- ----- -----
--[[ Dev Notes:

	It is recommended to look at the Default variables assigned to every SWEP as some variables may not be documented.


	This base inherits most of the functionality of bobs_gun_base.lua
		It is compatible with CPPI (Prop protection) Addons.

	The throwing logic is taken from the TTT Gamemode but was heavily optimized.


	Required:

	SWEP.GrenadeClassEnt	- The entity class that should be thrown.
	SWEP.GrenadeModelStr	- The model used by the thrown entity.
	SWEP.GrenadeMaterialStr	- The material that should be applied to the thrown entity. (optional)


	Not required:

	SWEP.GrenadeThrowAng	- Starting angle of the thrown entity.

	SWEP.bAlwaysTrail		- Can be set to true for a Trail to be applied to the thrown entity.
	SWEP.GrenadeTrailCol	- Trail color.


	SWEP.GrenadeNoPin		- Can be set to skip the pin pulling, useful for throwables that can be thrown without needing to be activated.
	SWEP.bDontStripWeapon	- Can be set to true to prevent the Weapons from being removed when running out of ammo.


	SWEP.iThrowAnim			- Can be set to a viewmodel sequence to use when throwing the object.
	SWEP.iThrowDelay		- How long it takes for the object to be thrown after primary attack.


	SWEP.iPinAnim			- Can be set to a viewmodel sequence to use when pulling the pin of the grenade.


	SWEP.ProjectileModifications - Can be set to a function to modify the projectile after creation. (SERVERSIDE ONLY)


	CLIENT:

	SWEP.PinPullEvent		- Is a function that runs when the Pin is pulled.
	SWEP.ThrowEvent			- Is a function that runs when the Grenade was thrown.


	Weapons have a custom animation layer that is added on top of ACT_VM sequences. This is impossibly hard to see when not playing ACT_VM_IDLE.
	> Search: Idle Sway

	-- ----- ----- ----- ----- ------- ----- ----- ----- ----- -----

	Almost all SWEP functions have a function they call that you can hook into in your SWEP script.
	Simply assign a function to (X)Hooked to make said function run on (X) event.

	Note: Some Hooks may not be listed. It is best to check the source code.


	SERVER & CLIENT - Shared

	Initialize			> IntializeHooked
	ResetInternalVars	> ResetInternalVarsHooked
	Deploy				> DeployHooked
	Equip				> EquipHooked
	Think				> ThinkHooked

	SERVER

	OnDrop				> OnDropHooked
	PrimaryAttack		> PrimaryAttackHooked


	DO NOTE: Some of these functions may already be used by meteors_grenade_base_model and meteors_grenade_base_model_instant !!

	-- ----- ----- ----- ----- ------- ----- ----- ----- ----- -----

	meteors_grenade_base.lua makes use of networking. It transmit Integers as an identifier.

	-- 1 = Deploy sound
	-- 2 = Weapon was dropped
	-- 3 = Pull pin
	-- 4 = Throw

]]
-- ----- ----- ----- ----- ------- ----- ----- ----- ----- -----

SWEP.Slot = 4

SWEP.Spawnable = false
SWEP.AdminSpawnable = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.DrawAmmo = true
SWEP.DrawCrosshair = true
SWEP.DrawWeaponInfoBox = false
SWEP.BounceWeaponIcon = false

SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = true

SWEP.HoldType = "grenade"
SWEP.UseHands = false


SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Ammo = "none"


SWEP.bAlwaysTrail = false


SWEP._IsM9kRemasteredBased = true

-- ----- ----- ----- ----- ------- ----- ----- ----- ----- -----
-- Optimization
-- ----- ----- ----- ----- ------- ----- ----- ----- ----- -----

local sTag = "MMM_M9kr_Grenades"

-- ----- ----- ----- ----- ------- ----- ----- ----- ----- -----
-- Compatibility
-- ----- ----- ----- ----- ------- ----- ----- ----- ----- -----

function SWEP:AttackAnimation()
	if not IsValid(self.Owner) then return end

	self.Owner:SetAnimation(PLAYER_ATTACK1)
end


function SWEP:CanSecondaryAttack()
	return false
end


local fBlank = function() end

SWEP.SecondaryAttack = fBlank
SWEP.ShootBullet = fBlank
SWEP.ShootEffects = fBlank
SWEP.DoImpactEffect = fBlank
SWEP.SetDeploySpeed = fBlank

-- ----- ----- ----- ----- ------- ----- ----- ----- ----- -----
-- SERVER
-- ----- ----- ----- ----- ------- ----- ----- ----- ----- -----

if SERVER then

	util.AddNetworkString(sTag)


	angle_zero = Angle(0,0,0) -- Make sure nothing else fucked with this


	local cColorTrailFallback = Color(255,255,255)


	local fSaveStrip = function(self) -- This function strips the weapon when called but makes the player switch to a different one first! This is needed.

		if not IsValid(self.Owner) or not self.Owner:Alive() or self.bDontStripWeapon then return end


		local tWeapons = self.Owner:GetWeapons()
		local eWep = NULL


		-- Attempt to return a weapon that isn't us.

		for k,v in ipairs(tWeapons) do
			if self ~= v then
				eWep = v

				break
			end
		end


		if IsValid(eWep) then -- Select a Weapon that isn't us.

			self.Owner:SelectWeapon(MMM and "none" or eWep:GetClass())

		else -- They don't have any other weapons. So we just give them an invalid one temporarily.

			self.Owner:Give("meteors_notmounted_base")

			self.Owner:SelectWeapon("meteors_notmounted_base")

		end


		timer.Simple(0,function()
			if not IsValid(self) or not IsValid(self.Owner) then return end

			self.Owner:StripWeapon(self:GetClass())
		end)
	end


	local fSetDelay = function(self,iDeduct) -- Let's not have the same code like 10 times, alright?
		if not IsValid(self.Owner) then return end


		iDeduct = iDeduct or 0


		local vm = self.Owner:GetViewModel()

		if IsValid(vm) then

			local iDur = CurTime() + vm:SequenceDuration() + 0.1 - iDeduct -- Action delay

			self:SetNextPrimaryFire(iDur)
			self:SetNextSecondaryFire(iDur)

		end
	end


	local fCreateThrowable = function(self,vOverride)
		if not IsValid(self) or not IsValid(self.Owner) then return end


		local eOwner = self.Owner -- Optimization!


		local aEye = eOwner:EyeAngles()
		local vPos = eOwner:GetPos() + (eOwner:Crouching() and eOwner:GetViewOffsetDucked() or eOwner:GetViewOffset()) + (aEye:Forward() * 8) + (aEye:Right() * 10)


		local aAng = (eOwner:GetEyeTraceNoCursor().HitPos - vPos):Angle()

		if aAng.p < 90 then -- This should be a SetUnpacked instead ideally. But my brain capacity to translate this is just not enough right now.
			aAng.p = -10 + aAng.p * ((90 + 10) / 90)
		else
			aAng.p = 360 - aAng.p
			aAng.p = -10 + aAng.p * -((90 + 10) / 90)
		end

		aAng.p = math.Clamp(aAng.p,-90,90)


		local vVel = math.min(800,(90 - aAng.p) * 6)
		local vThr = aAng:Forward() * vVel + eOwner:GetVelocity()



		local ent_Projectile = ents.Create(self.GrenadeClassEnt) -- Create projectile
		if not IsValid(ent_Projectile) then return end

			SafeRemoveEntityDelayed(ent_Projectile,30)

		ent_Projectile:SetModel(self.GrenadeModelStr)

		ent_Projectile:SetPos(vOverride or vPos)
		ent_Projectile:SetAngles(eOwner:EyeAngles() + (self.GrenadeThrowAng or angle_zero))

		if self.GrenadeMaterialStr then
			ent_Projectile:SetMaterial(self.GrenadeMaterialStr)
		end


		ent_Projectile.M9kr_CreatedByWeapon = true
		ent_Projectile:SetNWBool("M9kR_Created",true) -- Mark it for Clients.

		ent_Projectile:SetOwner(eOwner) -- Blocks collision with the thrower and IS required to fix a few bugs. (BEFORE SPAWN)
		ent_Projectile:Spawn()


		ent_Projectile:SetCollisionGroup(COLLISION_GROUP_WEAPON) -- Required


		ent_Projectile.WasDropped = true -- MMM Compatibility
		ent_Projectile.BuildZoneOverride = true


		if self.GrenadeTrailCol and (not self.bAlwaysTrail and MMM or self.bAlwaysTrail) then -- Apply a trail if desired, forced in an MMM environment
			util.SpriteTrail(ent_Projectile,0,self.GrenadeTrailCol or cColorTrailFallback,true,5,5,1,1 / ( 5 + 5 ) * 0.5,"trails/laser.vmt")
		end


		if MMM_M9k_CPPIExists then
			ent_Projectile:CPPISetOwner(eOwner)
		end


		local obj_Phys = ent_Projectile:GetPhysicsObject()

		if IsValid(obj_Phys) then
			obj_Phys:SetMass(100)

			obj_Phys:SetVelocity(vThr)
			obj_Phys:AddAngleVelocity(Vector(600,math.random(-1200,1200),0))
		end


		if self.ProjectileModifications then
			self:ProjectileModifications(ent_Projectile)
		end
	end


	function SWEP:Initialize()

		self:SetHoldType(self.HoldType)


		-- Instead of overwriting the Initialize function, we expand on it!

		if self.InitializeHooked then
			self:InitializeHooked()
		end


		if MMM_M9k_IsSinglePlayer then -- In singleplayer we need to force the weapon to be equipped after spawning
			timer.Simple(0,function()
				if not IsValid(self) or not IsValid(self.Owner) then return end

				self.Owner:SelectWeapon(self:GetClass())
			end)
		end
	end


	function SWEP:ResetInternalVars() -- Convenience

		timer.Remove(sTag .. self:EntIndex())


		self:SetHoldType(self.HoldType)


		self.PinPulled = nil
		self.GrenadeThrow = nil


		if self.ResetInternalVarsHooked then
			self:ResetInternalVarsHooked()
		end
	end


	function SWEP:Deploy()
		if not IsValid(self.Owner) then return end

		if MMM_M9k_IsSinglePlayer then
			self:CallOnClient("Deploy") -- Make sure that it runs on the CLIENT! (Singleplayer!)
		end


		if self:Clip1() <= 0 and self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0 and not self.bDontStripWeapon then -- Make sure we can not equip a Grenade when we do not even have one!

			fSaveStrip(self)

			return
		end


		self:SetHoldType(self.HoldType)


		self:SendWeaponAnim(ACT_VM_DRAW)

		fSetDelay(self)


		if self.DrawSound then -- Network Deploy Sound
			net.Start(sTag)
				net.WriteEntity(self)
				net.WriteInt(1,6)
			net.Broadcast()
		end


		self:ResetInternalVars()


		if self.DeployHooked then
			self:DeployHooked()
		end


		return true
	end


	function SWEP:Equip()
		if not IsValid(self.Owner) then return end

		if not self.Owner:IsPlayer() then -- NPCs cannot have M9kR Weapons! Also prevents invalid spawning
			self:Remove()

			return
		end


		if self.EquipHooked then
			self:EquipHooked()
		end
	end


	function SWEP:Holster()
		if not IsValid(self.Owner) then return end

		if MMM_M9k_IsSinglePlayer then
			self:CallOnClient("Holster") -- Make sure that it runs on the CLIENT! (Singleplayer!)
		end


		if self:Clip1() <= 0 and self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 then -- Refill on 0

			self:SetClip1(1)

			self.Owner:RemoveAmmo(1,self.Primary.Ammo)

		end


		if self.HolsterHooked then
			self:HolsterHooked()
		end


		self:ResetInternalVars()


		return true
	end


	function SWEP:OnDrop()


		-- The owner died, so create an armed grenade at their spot!

		if IsValid(self.Owner) and not self.Owner:Alive() and self.PinPulled then -- Depending on the environment, this most likely wont work.
			fCreateThrowable(self,self.Owner:GetPos())
		end


		net.Start(sTag) -- Notify clients that this weapon was dropped
			net.WriteEntity(self)
			net.WriteInt(2,6)
		net.Broadcast()


		if self.OnDropHooked then
			self:OnDropHooked()
		end


		self:ResetInternalVars()

	end


	function SWEP:PrimaryAttack()
		if not IsValid(self.Owner) or self.PinPulled or self.GrenadeThrow then return end -- If somehow an NPC got it on their hands or similar.. this will cause huge problems! Also don't do stuff if we're already throwing!

		if MMM_M9k_IsSinglePlayer then
			self:CallOnClient("PrimaryAttack")-- Make sure that it runs on the CLIENT! (Singleplayer!)
		end


		if not self:CanPrimaryAttack() then return end


		-- Animations
		-- These need to be done for prediction

		if not self.GrenadeNoPin and not self.Owner.MMM_HasOPWeapons then -- Delayed throw // MMM Compatibility

			self:SendWeaponAnim(not self.iPinAnim and ACT_VM_PULLPIN or self.iPinAnim)

			self.PinPulled = true


			fSetDelay(self)

		else -- Just throw it right away

			self:SendWeaponAnim(not self.iThrowAnim and ACT_VM_THROW or self.iThrowAnim)

			self.GrenadeThrow = true


			timer.Create(sTag .. self:EntIndex(),0.2,1,function() -- We still need to call this even if we skip the event internally!
				if not IsValid(self) or not IsValid(self.Owner) or self.Owner:GetActiveWeapon() ~= self then return end

				net.Start(sTag) -- PinPull event
					net.WriteEntity(self)
					net.WriteInt(3,6)
				net.Broadcast()
			end)


			fSetDelay(self,0.5 - (self.iThrowDelay or 0))

		end


		if self.PrimaryAttackHooked then
			self:PrimaryAttackHooked()
		end
	end


	function SWEP:Think()

		if not IsValid(self.Owner) then return end


		local bAction = (self:GetNextPrimaryFire() < CurTime()) and (not self.Owner:KeyDown(IN_ATTACK) or self.GrenadeNoPin) or self.Owner.MMM_HasOPWeapons


		if self.PinPulled and bAction then -- Throw the Grenade


			self:SendWeaponAnim(not self.iThrowAnim and ACT_VM_THROW or self.iThrowAnim)

			self.PinPulled = nil
			self.GrenadeThrow = true

			fSetDelay(self,0.45)


			net.Start(sTag) -- PinPull event
				net.WriteEntity(self)
				net.WriteInt(3,6)
			net.Broadcast()


		elseif self.GrenadeThrow and bAction then -- Create the grenade


			self:TakePrimaryAmmo(1)


			timer.Create(sTag .. self:EntIndex(),0.5,1,function()
				if not IsValid(self) or not IsValid(self.Owner) or self.Owner:GetActiveWeapon() ~= self then return end

				self:SendWeaponAnim(ACT_VM_DRAW)
			end)


			self.PinPulled = nil
			self.GrenadeThrow = nil

			fSetDelay(self,-0.5) -- This adds time to it


			net.Start(sTag) -- Throw event
				net.WriteEntity(self)
				net.WriteInt(4,6)
			net.Broadcast()


			self:AttackAnimation()


			self.Owner:LagCompensation(true)

			fCreateThrowable(self)

			self.Owner:LagCompensation(false)


			if self:Clip1() <= 0 and self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0 then -- Remove Weapon when we threw the last grenade

				fSaveStrip(self)

				return

			else
				self.Owner:RemoveAmmo(1,self.Primary.Ammo) -- 'Equip' next grenade
				self:SetClip1(1)
			end

		end


		if self.ThinkHooked then
			self:ThinkHooked()
		end
	end


	function SWEP:CanPrimaryAttack()
		if self:GetNextPrimaryFire() > CurTime() or (self.Primary.ClipSize >= 0 and self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0 and self:Clip1() <= 0) then
			return false
		end

		return true
	end


	function SWEP:OnRemove()
		if IsValid(self.Owner) then
			fSaveStrip(self)
		end
	end
end

-- ----- ----- ----- ----- ------- ----- ----- ----- ----- -----
-- CLIENT
-- ----- ----- ----- ----- ------- ----- ----- ----- ----- -----

if CLIENT then

	-- Optimizations

	angle_zero = Angle(0,0,0) -- Make sure nothing else fucked with this

	SWEP.ViewAngIdleRead = angle_zero
	SWEP.ViewAngStart = 0


	local cvar_LeftHanded = CreateConVar("m9k_lefthanded","0",FCVAR_ARCHIVE,"0 = Right handed - 1 = Left handed",0,1)


	-- Networking

	net.Receive(sTag,function() -- This is a mess, thanks garry!
		local eWep = net.ReadEntity()
		if not IsValid(eWep) or not eWep._IsM9kRemasteredBased then return end

		local iEvent = net.ReadInt(6)

		if iEvent == 1 and eWep.DrawSound then -- Deploy sound!
			eWep:EmitSound(eWep.DrawSound,65)
		elseif iEvent == 2 then -- Weapon was dropped!
			eWep:ResetInternalVars()
		elseif iEvent == 3 then -- Pull-pin
			if IsValid(eWep.Owner) and (eWep.Owner ~= LocalPlayer() or eWep.Owner:GetViewEntity() ~= eWep.Owner) then
				eWep.Owner:EmitSound(eWep.PinPullSound or "weapons/pinpull.wav",eWep.PinPullSoundVolume or 70,100,1,CHAN_ITEM)
			end

			if eWep.PinPullEvent then
				eWep:PinPullEvent()
			end
		elseif iEvent == 4 then -- Throw
			if IsValid(eWep.Owner) then
				eWep.Owner:SetAnimation(PLAYER_ATTACK1)

				if eWep.ThrowSound then
					eWep.Owner:EmitSound(eWep.ThrowSound,eWep.ThrowSoundVolume or 70,100,1,CHAN_ITEM)
				end
			end

			if eWep.ThrowEvent then
				eWep:ThrowEvent()
			end
		end
	end)


	function SWEP:ResetInternalVars() -- Convenience

		self:SetHoldType(self.HoldType)


		self.ViewFlipped = false


		if self.ResetInternalVarsHooked then
			self:ResetInternalVarsHooked()
		end
	end


	function SWEP:Initialize()

		self:SetHoldType(self.HoldType)


		self.OurIndex = self:EntIndex() -- Only needed on CLIENT for the muzzle effects
		self.WepSelectIcon = surface.GetTextureID(string.gsub("vgui/hud/name","name",self:GetClass()))


		-- Instead of overwriting the Initialize function, we expand on it!

		if self.InitializeHooked then
			self:InitializeHooked()
		end


		if self.Owner == LocalPlayer() then
			self:SendWeaponAnim(ACT_VM_IDLE)

			if self.Owner:GetActiveWeapon() == self then
				self:Deploy()
			end
		end
	end


	function SWEP:Deploy()
		if not IsValid(self.Owner) then return end

		self:SetHoldType(self.HoldType)


		local vm = self.Owner:GetViewModel()

		if IsValid(vm) then -- Anything past this should only run on the client that has the gun

			self:ResetInternalVars()


			if cvar_LeftHanded:GetInt() == 1 and not self.ViewFlipped and not self._UsesCustomModels then
				self.ViewModelFlip = not self.ViewModelFlip

				self.ViewFlipped = true
			end


			self:SendWeaponAnim(ACT_VM_DRAW)


			local iDur = CurTime() + vm:SequenceDuration() + 0.1 -- Action delay

			self:SetNextPrimaryFire(iDur)
			self:SetNextSecondaryFire(iDur)

		end


		if self.DeployHooked then
			self:DeployHooked()
		end


		return true
	end


	function SWEP:Equip()
		if self.EquipHooked then
			self:EquipHooked()
		end
	end


	function SWEP:Holster()

		self:ResetInternalVars()

		if self.HolsterHooked then
			self:HolsterHooked()
		end

		return true
	end


	function SWEP:Think()
		if self.ThinkHooked then
			self:ThinkHooked()
		end
	end


	function SWEP:PrimaryAttack()

	end


	function SWEP:CanPrimaryAttack()
		if self:GetNextPrimaryFire() > CurTime() or (self.Primary.ClipSize >= 0 and self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0 and self:Clip1() <= 0) then
			return false
		end

		return true
	end


	function SWEP:CalcViewModelView(_,vPos,aAng,vEye,aEye)
		if not IsValid(self.Owner) then return end


		vPos:SetUnpacked(vPos.x + (vEye.x - vPos.x) * 0.55,vPos.y + (vEye.y - vPos.y) * 0.55,vPos.z + (vEye.z - vPos.z) * 0.55)
		aAng:SetUnpacked(aAng.p + (aEye.p - aAng.p) * 0.55,aAng.y + (aEye.y - aAng.y) * 0.55,aAng.r + aEye.r * 0.55)


		-- Add a bit of swaying to the viewmodel, this simulates an idle animation!
		-- This is way better than using pre-made animations!
		-- Idle Sway

		local iCur = RealTime()

		if self.ViewAngStart < iCur then
			self.ViewAngStart = iCur + math.Rand(0.2,1.1)

			self.LastViewAngTick = iCur

			self.ViewAngDestination = AngleRand(-0.3,0.3)
		end


		self.ViewAngIdleRead = LerpAngle(iCur - self.LastViewAngTick,self.ViewAngIdleRead,self.ViewAngDestination) + (AngleRand() * 0.00001) + (AngleRand() * 0.00001)

		self.LastViewAngTick = iCur


		aAng:SetUnpacked(aAng.p + self.ViewAngIdleRead.p,aAng.y + self.ViewAngIdleRead.y,aAng.r + self.ViewAngIdleRead.r)


		return vPos, aAng
	end
end