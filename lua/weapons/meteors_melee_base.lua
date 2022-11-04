-- ----- ----- ----- ----- ------- ----- ----- ----- ----- -----
--[[ Dev Notes:

	It is recommended to look at the Default variables assigned to every SWEP as some variables may not be documented.


	This base inherits most of the functionality of bobs_gun_base.lua


	SWEP.IsBlade			- Whether or not the Weapon has a blade. Set to false for clubs/hammers or similar.
	SWEP.HitRange			- Defines how far the Weapon can reach when attacking.
	SWEP.SwingSound			- The sound that is played when nothing was hit.
	SWEP.DoViewPunch		- Set to false to disable view punch.
	SWEP.ViewPunchStrength	- Defines how strong the view punch is.
	SWEP.AttackDelay		- How many seconds to wait between each attack.
	SWEP.SwingDelay			- How many seconds it takes before the damage is done.
	SWEP.ThrowDelay			- How many seconds it takes before the Weapon is thrown.

	SWEP.iPrimaryAnim		- Can be set to a viewmodel animation ID to play a custom attack animation on primary attack.
	SWEP.iPrimaryMissAnim	- Can be set to a viewmodel animation ID to play on missing a primary attack.

	SWEP.tAttackSequences	- A table of sequences that are used for the viewmodel animations when attacking. (optional)
		Example:

		SWEP.tAttackSequences = { -- Taken from m9k_damascus.lua
			"midslash1",
			"midslash2"
		}


	SWEP.bCanThrow			- Can be set to true to allow a melee Weapon to be thrown when pressing the RELOAD key.
	SWEP.sProjectileClass	- The class of the thrown projectile.
	SWEP.sProjectileModel	- The model for the thrown projectile.
	SWEP.vProjectileForce	- The force applied to the projectile when throwing. (optional)
	SWEP.vForceAngle		- The angular force applied to the projectile when throwing. (optional)
	SWEP.aProjectileOffset	- Can be set to an angle to add to the spawn angle of the projectile. (optional)


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


	DO NOTE: Some of these functions may already be used by meteors_melee_base_model !!

	-- ----- ----- ----- ----- ------- ----- ----- ----- ----- -----

	meteors_melee_base.lua makes use of networking. It transmit Integers as an identifier.

	-- 1 = Deploy sound
	-- 2 = Weapon was dropped

]]
-- ----- ----- ----- ----- ------- ----- ----- ----- ----- -----

SWEP.Slot = 0

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

SWEP.HoldType = "melee"
SWEP.UseHands = false


SWEP.Primary.Sound = ""
SWEP.Primary.Damage = 1
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0

SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"


SWEP.Secondary.Sound = ""
SWEP.Secondary.Damage = 1
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0

SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"


-- Default vars
SWEP.IsBlade = true
SWEP.AttackDelay = 0.4
SWEP.SwingDelay = 0
SWEP.HitRange = 80
SWEP.DoViewPunch = true
SWEP.ViewPunchStrength = 2


SWEP._IsM9kRemasteredBased = true

-- ----- ----- ----- ----- ------- ----- ----- ----- ----- -----
-- Optimization
-- ----- ----- ----- ----- ------- ----- ----- ----- ----- -----

local sTag = "MMM_M9kr_Weapons_Melee"

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


	local vForceAngle = Vector(0,500,0)


	local tMatDecalTypes = {
		[45] = { -- Combine Visor apparently
			sDecal = "Blood",
			sSound = "physics/flesh/flesh_impact_bullet",
			iRange = 5,
			sEffect = "BloodImpact"
		},
		[50] = { -- Unknown
			sDecal = "Blood",
			sSound = "physics/flesh/flesh_impact_bullet",
			iRange = 5,
			sEffect = "BloodImpact"
		},
		[MAT_ANTLION] = {
			sDecal = "Impact.Antlion",
			sSound = "physics/flesh/flesh_impact_bullet",
			iRange = 5,
			sEffect = "AntlionGib"
		},
		[MAT_BLOODYFLESH] = {
			sDecal = "Blood",
			sSound = "physics/flesh/flesh_impact_bullet",
			iRange = 5,
			sEffect = "BloodImpact"
		},
		[MAT_FLESH] = {
			sDecal = "Blood",
			sSound = "physics/flesh/flesh_impact_bullet",
			iRange = 5,
			sEffect = "BloodImpact"
		},
		[MAT_ALIENFLESH] = {
			sDecal = "Blood",
			sSound = "physics/flesh/flesh_impact_bullet",
			iRange = 5,
			sEffect = "BloodImpact"
		},
		[MAT_CONCRETE] = {
			sDecal = "Impact.Concrete",
			sSound = "weapons/crowbar/crowbar_impact",
			iRange = 2,
			sEffect = "GlassImpact"
		},
		[MAT_GLASS] = {
			sDecal = "ManhackCut",
			sSound = "physics/glass/glass_impact_bullet",
			iRange = 4,
			sEffect = "GlassImpact"
		},
		[MAT_DIRT] = {
			sDecal = "ManhackCut",
			sSound = "physics/surfaces/sand_impact_bullet",
			iRange = 4
		},
		[MAT_SAND] = {
			sDecal = "ManhackCut",
			sSound = "physics/surfaces/sand_impact_bullet",
			iRange = 4
		},
		[MAT_GRASS] = {
			sDecal = "ManhackCut",
			sSound = "physics/surfaces/sand_impact_bullet",
			iRange = 4
		},
		[MAT_SNOW] = {
			sDecal = "ManhackCut",
			sSound = "physics/surfaces/sand_impact_bullet",
			iRange = 4
		},
		[MAT_FOLIAGE] = {
			sDecal = "ManhackCut",
			sSound = "physics/surfaces/sand_impact_bullet",
			iRange = 4
		},
		[MAT_EGGSHELL] = {
			sDecal = "ManhackCut",
			sSound = "phx/eggcrack.wav"
		},
		[MAT_GRATE] = {
			sSound = "physics/metal/metal_chainlink_impact_soft",
			iRange = 3,
			sEffect = "MetalSpark"
		},
		[MAT_VENT] = {
			sSound = "physics/metal/metal_chainlink_impact_soft",
			iRange = 3,
			sEffect = "MetalSpark"
		},
		[MAT_PLASTIC] = {
			sDecal = "Impact.Concrete",
			sSound = "physics/plastic/plastic_box_impact_bullet",
			iRange = 5,
			iImpactMat = MAT_PLASTIC
		},
		[MAT_COMPUTER] = {
			sDecal = "Impact.Concrete",
			sSound = "physics/plastic/plastic_box_impact_bullet",
			iRange = 5,
			sEffect = "MetalSpark"
		},
		[MAT_TILE] = {
			sDecal = "Impact.Concrete",
			sSound = "physics/plaster/ceiling_tile_impact_hard",
			iRange = 3,
			sEffect = "GlassImpact"
		},
		[MAT_WOOD] = {
			sDecal = "Impact.Concrete",
			sSound = "physics/wood/wood_plank_impact_hard",
			iRange = 4,
			sSound2 = "physics/wood/wood_solid_impact_bullet",
			iRange2 = 5
		},
		[MAT_METAL] = {
			sDecal = "ManhackCut",
			sSound = "weapons/crowbar/crowbar_impact",
			iRange = 2,
			sEffect = "MetalSpark"
		}
	}

	local tMatDecalTypesBlade = {
		[45] = { -- Combine Visor apparently
			sDecal = "Blood",
			sSound = "weapons/blades/slash.mp3",
			sEffect = "BloodImpact"
		},
		[MAT_ANTLION] = {
			sDecal = "Impact.Antlion",
			sSound = "weapons/blades/slash.mp3",
			sEffect = "AntlionGib"
		},
		[MAT_BLOODYFLESH] = {
			sDecal = "Blood",
			sSound = "weapons/blades/slash.mp3",
			sEffect = "BloodImpact"
		},
		[MAT_FLESH] = {
			sDecal = "Blood",
			sSound = "weapons/blades/slash.mp3",
			sEffect = "BloodImpact"
		},
		[MAT_ALIENFLESH] = {
			sDecal = "Blood",
			sSound = "weapons/blades/slash.mp3",
			sEffect = "BloodImpact"
		},
		[MAT_CONCRETE] = {
			sDecal = "ManhackCut",
			sSound = "weapons/blades/hitwall.mp3",
			sEffect = "GlassImpact"
		},
		[MAT_METAL] = {
			sDecal = "ManhackCut",
			sSound = "weapons/blades/clash.mp3",
			sEffect = "MetalSpark"
		}
	}


	SWEP.aProjectileOffset = Angle(0,0,0)


	function SWEP:Initialize()

		self:SetHoldType(self.HoldType)


		-- This timer is jank AF but its needed. Unfortunately if someone has a high ping this doesn't even do what it should be doing. This needs to be fixed later.
		-- When a Weapon is spawned through the spawnmenu.. the Deploy function is not called as the spawnmenu uses SelectWeapon which means it happens out of prediction.
		-- This makes it so that the DrawSound is not played which makes it very awkward.

		timer.Simple(0.1,function() -- Pray the weapon is valid on the client on runtime
			if not IsValid(self) or not IsValid(self.Owner) or self.Owner:GetActiveWeapon() ~= self then return end

			if self.DrawSound or self.tDrawSoundSequence then -- Network Deploy Sound
				net.Start(sTag)
					net.WriteEntity(self)
					net.WriteInt(1,6)
				net.Broadcast()
			end
		end)


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

		self.DrawCrosshair = true

		self:SetHoldType(self.HoldType)


		if self.ResetInternalVarsHooked then
			self:ResetInternalVarsHooked()
		end
	end


	function SWEP:Deploy()
		if not IsValid(self.Owner) then return end

		if MMM_M9k_IsSinglePlayer then
			self:CallOnClient("Deploy") -- Make sure that it runs on the CLIENT! (Singleplayer!)
		end


		self:SetHoldType(self.HoldType)


		self:SendWeaponAnim(ACT_VM_DRAW)


		local vm = self.Owner:GetViewModel()

		if IsValid(vm) then

			local iDur = CurTime() + vm:SequenceDuration() + 0.1 -- Action delay

			self:SetNextPrimaryFire(iDur)
			self:SetNextSecondaryFire(iDur)

		end


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


		if self.HolsterHooked then
			self:HolsterHooked()
		end


		self:ResetInternalVars()


		return true
	end


	function SWEP:OnDrop()

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
		if not self:CanPrimaryAttack() or not IsValid(self.Owner) then return end -- If somehow an NPC got it on their hands or similar.. this will cause huge problems!

		if MMM_M9k_IsSinglePlayer then
			self:CallOnClient("PrimaryAttack")-- Make sure that it runs on the CLIENT! (Singleplayer!)
		end


		-- Animations
		-- These need to be done for prediction


		local vShootPos = self.Owner:GetShootPos()
		local vAimVector = self.Owner:GetAimVector()

		local tTrace

		if self.Owner:WaterLevel() ~= 3 then -- We might be hitting the water surface!

			tTrace = util.TraceLine({
				start = vShootPos,
				endpos = vShootPos + (vAimVector * self.HitRange),
				filter = self.Owner,
				mask = MASK_SHOT_HULL + MASK_WATER
			})

		else -- We are inside of water

			tTrace = util.TraceLine({
				start = vShootPos,
				endpos = vShootPos + (vAimVector * self.HitRange),
				filter = self.Owner,
				mask = MASK_SHOT_HULL
			})

		end


		if tTrace.Hit or tTrace.HitSky or not self.iPrimaryMissAnim then -- We hit something, play hit sequence

			if not self.tAttackSequences then -- Just a normal attack

				self:SendWeaponAnim(not self.iPrimaryAnim and ACT_VM_PRIMARYATTACK or self.iPrimaryAnim)

			else -- Custom sequences!

				local vm = self.Owner:GetViewModel()

				if IsValid(vm) then
					self.iAttackSequence = self.iAttackSequence or 1
					self.iAttackSequence = self.iAttackSequence >= #self.tAttackSequences and 1 or self.iAttackSequence + 1

					vm:SendViewModelMatchingSequence(vm:LookupSequence(self.tAttackSequences[self.iAttackSequence]))
				end

			end

		elseif self.iPrimaryMissAnim then -- We missed so play the miss sequence if it exists

			self:SendWeaponAnim(self.iPrimaryMissAnim)

		end


		local iDur = CurTime() + self.AttackDelay
		self:SetNextPrimaryFire(iDur)
		self:SetNextSecondaryFire(iDur)


		do -- Calculate the stuff that does stuff

			timer.Simple(self.SwingDelay,function() -- We gotta swing first before doing damage.

				if not IsValid(self) or not IsValid(self.Owner) or self.Owner:GetActiveWeapon() ~= self then return end


				local vShootPos = self.Owner:GetShootPos()
				local vAimVector = self.Owner:GetAimVector()

				local tTrace

				if self.Owner:WaterLevel() ~= 3 then -- We might be hitting the water surface!

					tTrace = util.TraceLine({
						start = vShootPos,
						endpos = vShootPos + (vAimVector * self.HitRange),
						filter = self.Owner,
						mask = MASK_SHOT_HULL + MASK_WATER
					})

				else -- We are inside of water

					tTrace = util.TraceLine({
						start = vShootPos,
						endpos = vShootPos + (vAimVector * self.HitRange),
						filter = self.Owner,
						mask = MASK_SHOT_HULL
					})

				end


				if tTrace.Hit and not tTrace.HitSky then

					local obj_DamageInfo = DamageInfo()

					obj_DamageInfo:SetDamage((tTrace.Entity:IsPlayer() or tTrace.Entity:IsNPC()) and self.Primary.Damage or self.Primary.Damage / 2)
					obj_DamageInfo:SetAttacker(self.Owner)
					obj_DamageInfo:SetInflictor(self)
					obj_DamageInfo:SetDamageType(self.IsBlade and DMG_SLASH or DMG_CLUB)
					obj_DamageInfo:SetDamagePosition(tTrace.HitPos)
					obj_DamageInfo:SetDamageForce(vAimVector * 2500)

					tTrace.Entity:TakeDamageInfo(obj_DamageInfo)


					if not IsValid(self.Owner) or not self.Owner:Alive() then return end -- If they die, stop doing stuff (Hitting explosive barrel = errors)


					if self.MMM_IsOPWeapon and IsValid(tTrace.Entity) and tTrace.Entity:GetClass() ~= "mmm_object_detail" then -- MMM Compat

						local iCurTime = CurTime()


						self.MMM_NextOPExplosion = self.MMM_NextOPExplosion or iCurTime


						if self.MMM_NextOPExplosion < iCurTime then

							self.MMM_NextOPExplosion = iCurTime + 0.1


							if not (tTrace.Entity:IsPlayer() or tTrace.Entity:IsNPC()) then
								local obj_Phys = tTrace.Entity:GetPhysicsObject()

								if IsValid(obj_Phys) then
									obj_Phys:SetVelocity(vAimVector * 250000)
								end
							else
								tTrace.Entity:SetVelocity(vAimVector * 250000)
							end


							local obj_EffectData = EffectData()
							obj_EffectData:SetOrigin(tTrace.HitPos)

							util.Effect("Explosion",obj_EffectData,true,true)

						end
					end


					local bCanTakeDamage = tTrace.Entity:GetSaveTable()["m_takedamage"]

					if bCanTakeDamage == 0 and tTrace.Entity == game.GetWorld() then
						bCanTakeDamage = 1
					end


					-- They hit Water!

					if tTrace.MatType == MAT_SLOSH and self.Owner:WaterLevel() ~= 3 then

						local obj_EffectData = EffectData()
						obj_EffectData:SetOrigin(tTrace.HitPos)
						obj_EffectData:SetScale(5)

						util.Effect("waterripple",obj_EffectData,true,true)

						self.Owner:EmitSound("ambient/water/water_splash" .. math.random(3) .. ".wav")


					elseif not tMatDecalTypes[tTrace.MatType] then -- They hit an unknown material!

						local tEyeTrace = self.Owner:GetEyeTrace()


						if bCanTakeDamage == 1 or tTrace.Entity:Health() > 0 then
							util.Decal("ManhackCut",tEyeTrace.HitPos + tEyeTrace.HitNormal,tEyeTrace.HitPos - tEyeTrace.HitNormal,self.Owner)
						end

						self.Owner:EmitSound("weapons/crowbar/crowbar_impact" .. math.random(2) .. ".wav",75,100,0.5)


					elseif (bCanTakeDamage == 1 or tTrace.Entity:Health() > 0) then -- We have data stored about this material so do the stuff!


						local tMat = tMatDecalTypes[tTrace.MatType] -- Optimization

						-- Are we using a blade? If so, adjust!

							tMat = self.IsBlade and tMatDecalTypesBlade[tTrace.MatType] or tMat



						-- Create the Decal (If we should)

						if (tMat and tMat.sDecal) then
							local tEyeTrace = self.Owner:GetEyeTrace()

							util.Decal(self.IsBlade and "ManhackCut" or tMat.sDecal,tEyeTrace.HitPos + tEyeTrace.HitNormal,tEyeTrace.HitPos - tEyeTrace.HitNormal,self.Owner)
						end


						-- Play a Sound

						self.Owner:EmitSound( tMat.iRange and (((tMat.sSound2 and math.random(2) == 1 and tMat.sSound2) or tMat.sSound) .. math.random(tMat.iRange or 1) .. ".wav") or tMat.sSound)


						-- Do an effect

						if tMat.sEffect then

							local obj_EffectData = EffectData()
							obj_EffectData:SetOrigin(tTrace.HitPos)

							util.Effect(tMat.sEffect,obj_EffectData,true,true)

						elseif tMat.iImpactMat then

							local obj_EffectData = EffectData()
							obj_EffectData:SetEntity(tTrace.Entity)
							obj_EffectData:SetOrigin(tTrace.HitPos)
							obj_EffectData:SetStart(tTrace.HitPos)
							obj_EffectData:SetDamageType(self.IsBlade and DMG_SLASH or DMG_CLUB)
							obj_EffectData:SetSurfaceProp(tMat.iImpactMat or tTrace.MatType)

							util.Effect("Impact",obj_EffectData,true,true)

						end

					elseif bCanTakeDamage ~= 1 then -- Fallback

						self.Owner:EmitSound(self.IsBlade and "weapons/blades/slash.mp3" or "physics/flesh/flesh_impact_bullet" .. math.random(5) .. ".wav")

					end

				else -- Nothing was hit

					self.Owner:EmitSound(self.SwingSound or "weapons/iceaxe/iceaxe_swing1.wav")

				end


				if not self.Owner.MMM_HasOPWeapons and self.DoViewPunch then
					local aPunch = AngleRand(-self.ViewPunchStrength,self.ViewPunchStrength)
						aPunch:SetUnpacked(aPunch.p,aPunch.y,0)

					self.Owner:ViewPunch(aPunch)

				end
			end)


			if self.PrimaryAttackHooked then
				self:PrimaryAttackHooked(tTrace)
			end

		end


		self:AttackAnimation()

	end


	function SWEP:CanPrimaryAttack()
		return self:GetNextPrimaryFire() < CurTime()
	end


	function SWEP:Reload()
		if not self:CanPrimaryAttack() or not self.bCanThrow or not IsValid(self.Owner) then return end


		local iDur = CurTime() + self.AttackDelay
		self:SetNextPrimaryFire(iDur)
		self:SetNextSecondaryFire(iDur)


		self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
		self:AttackAnimation()


		do -- Calculate the stuff that does stuff

			timer.Simple(self.ThrowDelay or self.AttackDelay,function() -- We gotta swing first before doing damage.

				if not IsValid(self) or not IsValid(self.Owner) or self.Owner:GetActiveWeapon() ~= self then return end


				local eOwner = self.Owner -- Optimization
				local aEye = eOwner:EyeAngles()


				local eThrow = ents.Create(self.sProjectileClass)

					SafeRemoveEntityDelayed(eThrow,20)


				if IsValid(eThrow) then

					eThrow:SetModel(self.sProjectileModel)
					eThrow:SetPos(eOwner:GetPos() + (eOwner:Crouching() and eOwner:GetViewOffsetDucked() or eOwner:GetViewOffset()) + (aEye:Forward() * 8) + (aEye:Right() * 10))
					eThrow:SetAngles(aEye + self.aProjectileOffset)
					eThrow:SetCollisionGroup(COLLISION_GROUP_NONE)
					eThrow:SetGravity(0.4)
					eThrow:SetFriction(0.2)
					eThrow:SetElasticity(0.45)

					eThrow.M9kr_CreatedByWeapon = true
					eThrow:SetNWBool("M9kR_Created",true) -- Mark it for Clients.

					eThrow:Spawn()
					eThrow:PhysWake()


					eThrow.WasDropped = true -- MMM Compatibility
					eThrow.BuildZoneOverride = true


					eThrow:SetPhysicsAttacker(eOwner,60)
					eThrow:SetOwner(eOwner)

					if MMM_M9k_CPPIExists then
						eThrow:CPPISetOwner(eOwner)
					end


					eOwner:EmitSound("weapons/iceaxe/iceaxe_swing1.wav")


					local obj_Phys = eThrow:GetPhysicsObject()

					if IsValid(obj_Phys) then
						obj_Phys:SetVelocity(aEye:Forward() * (self.vProjectileForce or 1500))

						obj_Phys:AddAngleVelocity(self.vForceAngle or vForceAngle)
					end


					if not eOwner.MMM_HasOPWeapons then -- Only strip their Weapon if they don't have OP Weapons enabled. (MMM Compatibility)
						eOwner:StripWeapon(self:GetClass())
					end

				end
			end)
		end
	end


	function SWEP:Think()
		if self.ThinkHooked then
			self:ThinkHooked()
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
		end
	end)


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


	function SWEP:ResetInternalVars() -- Convenience

		self.DrawCrosshair = true

		self:SetHoldType(self.HoldType)


		self.ViewFlipped = false


		if self.ResetInternalVarsHooked then
			self:ResetInternalVarsHooked()
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


	function SWEP:PrimaryAttack()
		if not self:CanPrimaryAttack() or not IsValid(self.Owner) then return end -- If somehow an NPC got it on their hands or similar.. this will cause huge problems!

		if MMM_M9k_IsSinglePlayer then
			self:CallOnClient("PrimaryAttack")-- Make sure that it runs on the CLIENT! (Singleplayer!)
		end


		if not self.tAttackSequences then -- Just a normal attack

			self:SendWeaponAnim(not self.iPrimaryAnim and ACT_VM_PRIMARYATTACK or self.iPrimaryAnim)

		else -- Custom sequences!

			local vm = self.Owner:GetViewModel()

			if IsValid(vm) then
				self.iAttackSequence = self.iAttackSequence or 1
				self.iAttackSequence = self.iAttackSequence >= #self.tAttackSequences and 1 or self.iAttackSequence + 1

				vm:SendViewModelMatchingSequence(vm:LookupSequence(self.tAttackSequences[self.iAttackSequence]))
			end

		end


		local iDur = CurTime() + self.AttackDelay
		self:SetNextPrimaryFire(iDur)
		self:SetNextSecondaryFire(iDur)


		if self.PrimaryAttackHooked then
			self:PrimaryAttackHooked()
		end


		self:AttackAnimation()
	end


	function SWEP:CanPrimaryAttack()
		return self:GetNextPrimaryFire() < CurTime()
	end


	function SWEP:Reload()

	end


	function SWEP:Think()
		if self.ThinkHooked then
			self:ThinkHooked()
		end
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