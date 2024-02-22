AddCSLuaFile() -- This file was made compatible and is slightly more optimized than the original but was not fully optimized yet. TODO

ENT.Type = "anim"
ENT.PrintName = "Davy Crockett (Explosion)"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.DoNotDuplicate = true
ENT.DisableDuplicator = true


local fReturnFalse = function() -- Save some ram
	return false
end

ENT.CanTool = fReturnFalse -- Restrict certain things
ENT.CanProperty = fReturnFalse
ENT.PhysgunPickup = fReturnFalse


if SERVER then

	-- Major optimizations
	local utilBlastDamage = util.BlastDamage
	local utilTraceLine = util.TraceLine
	local stringfind = string.find
	local mathrandom = math.random
	local utilEffect = util.Effect
	local IsValid = IsValid
	local Vector = Vector


	local vCached1 = Vector(0,0,4)
	local vCached2 = Vector(0,0,4096)
	local vCached3 = Vector(0,0,1)


	ENT.GravGunPickupAllowed = fReturnFalse -- This is Serverside only


	local tValidMoveTypes = {
		[MOVETYPE_WALK] = true,
		[MOVETYPE_STEP] = true,
		[MOVETYPE_FLYGRAVITY] = true,
		[MOVETYPE_VPHYSICS] = true,
		[MOVETYPE_LADDER] = true -- Is this really a good idea? ..
	}


	local tBlacklist = { -- List of blacklisted entities, traces cannot go through these.
		["mmm_object_detail"] = true -- Protective shield.
	}


	local fLoSCheck = function(eNuke,eTarget,vTarget)

		local tTrace = {
			start = vTarget,
			endpos = eNuke.SplodePos,
			filter = eTarget
		}


		local tTraceRes = utilTraceLine(tTrace)


		if tBlacklist[tTraceRes.Entity ~= NULL and tTraceRes.Entity:GetClass()] then -- Nope!
			return false
		end


		if (tTraceRes.Entity ~= eNuke) and math.abs(eNuke.SplodePos.z - vTarget.z) < 800 then -- What an American way to fix this..

			tTrace.start = Vector(eNuke.SplodePos.x,eNuke.SplodePos.y,vTarget.z)
			tTraceRes = utilTraceLine(tTrace)

		end


		return tTraceRes.Entity == eNuke

	end


	local fGetEntityInfo = function(eEnt)

		local tEntInfo = {
			eEnt = eEnt,
			bPlayer = eEnt:IsPlayer(),
			bNPC = eEnt:IsNPC(),
			bHumanoid = false,
			bRagdoll = false,
			sClass = eEnt:GetClass(),
			iMoveType = eEnt:GetMoveType(),
			bValid = true
		}


		-- Make sure their movetype is valid

		tEntInfo.bValid = (tValidMoveTypes[tEntInfo.iMoveType] and true) or false

		if not tEntInfo.bValid then return tEntInfo end


		-- Is it a ragdoll?

		if string.find(tEntInfo.sClass,"ragdoll") ~= nil then
			tEntInfo.bRagdoll = true
			tEntInfo.bValid = false -- Ragdolls are too expensive to apply force to.
		end


		-- Is it.. human? O:

		tEntInfo.bHumanoid = (tEntInfo.bPlayer or tEntInfo.bNPC and true) or false


		return tEntInfo

	end


	function ENT:Initialize()

		if not self.bWasFiredWithWeapon then
			self:Remove() -- This ensures that nukes can only be created with the SWEP. Damn exploiters!

			return
		end


		SafeRemoveEntityDelayed(self,6)


		self:SetModel("models/hunter/blocks/cube1x1x1.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)

		local obj_Phys = self:GetPhysicsObject()

		if IsValid(obj_Phys) then
			obj_Phys:EnableMotion(false)
		end


		self:SetNoDraw(true) -- Suppress networking to clients!


		self.SplodePos = self:GetPos() + vCached1 -- Cache it.


		local iBlastRadius = 2300

			iBlastRadius = iBlastRadius > 14000 and 14000 or iBlastRadius



		do -- Did we explode in the air or on the ground? // Explosion effects

			local tTrace = {
				start = self.SplodePos,
				endpos = self.SplodePos - vCached2,
				mask = MASK_SOLID_BRUSHONLY
			}


			local tTraceRes
			local iShortest = 4096
			local iLongCount = 0


			for i = 1,6 do
				for k = -1,1,2 do
					for j = -1,1,2 do

						local iDist = (k * i * j * 120)

						tTrace.start = self.SplodePos + Vector(iDist,iDist,0)
						tTrace.endpos = tTrace.start - Vector(iDist,iDist,4096)

						tTraceRes = utilTraceLine(tTrace)


						local iLength = tTraceRes.Fraction * 4096


						iShortest = (iLength < iShortest and iLength) or iShortest
						iLongCount = (iLength > 2048 and (iLongCount + 1)) or iLongCount

					end
				end
			end


			-- Explosion effects

			local obj_EffectData = EffectData()


			obj_EffectData:SetOrigin(Vector(self.SplodePos.x,self.SplodePos.y,self.SplodePos.z - iShortest))
			obj_EffectData:SetScale(iShortest)


			if iLongCount < 10 then -- Explosion on the ground!

				utilEffect("m9k_nuke_effect_ground",obj_EffectData)
				utilEffect("m9k_nuke_blastwave",obj_EffectData)

			else -- Explosion in the air!

				utilEffect("m9k_nuke_effect_air",obj_EffectData)

			end
		end


		-- Vaporize / Disintegrate nearby living entities

		for _,v in ipairs(ents.FindInSphere(self.SplodePos,iBlastRadius)) do

			local tEntity = fGetEntityInfo(v)


			if tEntity.bValid then


				local obj_EffectData = EffectData()


				if tEntity.bNPC then

					obj_EffectData:SetEntity(v)

					utilEffect("m9k_nuke_vaporize",obj_EffectData)

					v:Fire("kill")

				elseif tEntity.bPlayer then

					local vPos = v:GetPos()

					obj_EffectData:SetOrigin(vPos)
					obj_EffectData:SetNormal(vCached3)

					utilEffect("m9k_nuke_disintegrate",obj_EffectData)

					utilBlastDamage(self,IsValid(self.Owner) and self.Owner or self,vPos,256,512)

				end
			end
		end



		do -- Additional effects // Explosion radius damage

			util.ScreenShake(self.SplodePos,16,230,6,16384)


			local iRadius = (iBlastRadius * 7) -- Shatter glass / Destroy breakables

			for _,v in ipairs(ents.FindByClass("func_breakable_surf")) do
				local iDist = (v:GetPos() - self.SplodePos):Length()

				if iDist < iRadius then
					v:Fire("Shatter")
				end
			end

			for _,v in ipairs(ents.FindByClass("func_breakable")) do
				local iDist = (v:GetPos() - self.SplodePos):Length()

				if iDist < iRadius then
					v:Fire("break")
				end
			end


			utilBlastDamage(self,IsValid(self.Owner) and self.Owner or self,self.SplodePos,iBlastRadius,65536) -- Are you near the explosion? Bruh, that's gonna hurt!

		end


		self.SplodeDist = 100
		self.BlastSpeed = 4000

		self.lastThink = CurTime() + 0.2
		self.SplodeTime = self.lastThink + 5

		self.Sploding = true

	end


	function ENT:Think()
		if not self.Sploding then return end


		local iCur = CurTime()


		local iTime = iCur - self.lastThink
		if iTime < 0.2 then return end


		self.SplodeDist = self.SplodeDist + self.BlastSpeed * iTime
		self.lastThink = iCur


		if self.SplodeTime < iCur then
			self.SplodeTime = 0
			self.SplodeDist = 100
			self.Sploding = false

			return
		end


		for _,v in ipairs(ents.FindInSphere(self.SplodePos,self.SplodeDist)) do -- Entities returned by this cannot be invalid.


			local tEntity = fGetEntityInfo(v)

			if not tEntity.bValid then -- ... But we have our custom valid check!
				goto continued -- Don't do anything with it!
			end


			local vPos = tEntity.eEnt:LocalToWorld(tEntity.eEnt:OBBCenter()) -- Apparently more accurate than GetPos. Doubt.

			if fLoSCheck(self,v,vPos) then -- No line of sight? No hurtin'


				local vDirection = vPos - self.SplodePos

				vDirection:SetUnpacked(vDirection.x,vDirection.y,(vDirection.z < 0 and 0) or vDirection.z)

					vDirection:Normalize()


				local iDPS = 150000000000 / (4 * math.pi * self.SplodeDist ^ 2) -- They love gigantic numbers..
				local iDamage = iDPS * iTime


				if iDPS >= 250 then
					if tEntity.sClass == "npc_strider" then

						tEntity.eEnt:Fire("break","","0.3")

					elseif tEntity.bHumanoid then

						local obj_EffectData = EffectData()
						obj_EffectData:SetOrigin(vPos)
						obj_EffectData:SetNormal(vDirection)

						utilEffect("m9k_nuke_disintegrate",obj_EffectData)

					end
				end


				local obj_Phys = tEntity.eEnt:GetPhysicsObject()


				if stringfind(tEntity.sClass,"prop") ~= nil then

					constraint.RemoveAll(tEntity.eEnt) -- Bye bye constraints!

					if IsValid(obj_Phys) then -- Unfreeze
						obj_Phys:EnableMotion(true)
					end
				end


				local vForce = vDirection * (8e4 * iDamage)

				if IsValid(obj_Phys) then
					obj_Phys:ApplyForceOffset(vForce,vPos + Vector(mathrandom(-20,20),mathrandom(-20,20),mathrandom(20,40)))
				end



				-- It do be hurting!

				local eAttacker = IsValid(self.Owner) and self.Owner or self

				local obj_DamageInfo = DamageInfo()
				obj_DamageInfo:SetInflictor(self)
				obj_DamageInfo:SetAttacker(eAttacker)
				obj_DamageInfo:SetDamageType(DMG_BLAST)
				obj_DamageInfo:SetReportedPosition(self.SplodePos)
				obj_DamageInfo:SetDamage(iDamage)
				obj_DamageInfo:SetDamageForce(vForce)

				v:TakeDamageInfo(obj_DamageInfo)


				--[[ We don't do that yet.
				if MMM and v:IsPlayer() and hook.Run("PlayerShouldTakeDamage",v,eAttacker) then -- Black magic!
					MMM.Poison(v)
				end
				]]
			end


			::continued::

		end
	end
end


if CLIENT then -- CLIENT does the sound stuff, the original code was (for the most part) well done.

	function ENT:Initialize()

		self.SplodeDist = 1000
		self.BlastSpeed = 4000

		self.lastThink = CurTime() + 0.2
		self.SplodeTime = (self.lastThink + 7 * 100)


		self.vPos = self:GetPos() -- Cache it.


		self.bIncSnd = false
		self.bBlastSnd = false
		self.bSlopSnd = false
		self.bInitSnd = false

	end


	function ENT:Think()

		if (CurTime() - self.lastThink) < 0.1 then return end


		if not self.bInitSnd then
			self.bInitSnd = true

			self:EmitSound("ambient/explosions/exp1.wav",0)
		end


		local iTime = CurTime() - self.lastThink

		self.lastThink = CurTime()


		local me = LocalPlayer()
		if not IsValid(me) then return end -- LocalPlayer can be invalid during a fullupdate call.


		self.SplodeDist = self.SplodeDist + self.BlastSpeed * iTime


		local iDist = (self.vPos - me:GetPos()):Length()

		if iDist < (900 + self.BlastSpeed) then
			self.bIncSnd = true
		end


		if not self.bSlopSnd then

			local iVolume = (7e5 / iDist)


			self.bSlopSnd = true


			timer.Simple(iDist / 18e3,function()
				if not IsValid(me) then return end

				me:EmitSound("ambient/explosions/explode_6.wav",(iVolume > 400 and 0) or (iVolume < 60 and 60) or iVolume)

			end)
		end


		if self.lastThink < self.SplodeTime then

			if (not self.bIncSnd) and (self.SplodeDist + self.BlastSpeed * 1.6) > iDist then
				self:EmitSound("ambient/levels/labs/teleport_preblast_suckin1.wav",0)

				self.bIncSnd = true
			end

			if (not self.bBlastSnd) and (self.SplodeDist + self.BlastSpeed * 0.2) > iDist then
				self:EmitSound("ambient/levels/streetwar/city_battle11.wav",0)

				self.bBlastSnd = true
			end
		end
	end


	function ENT:Draw()

	end
end