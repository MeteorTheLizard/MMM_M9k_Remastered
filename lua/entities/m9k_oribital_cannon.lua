AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Orbital Strike"
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


local sTag = "M9kR_Orbital_Strike"


if SERVER then

	local SafeRemoveEntityDelayed = SafeRemoveEntityDelayed -- Optimization
	local utilTraceLine = util.TraceLine
	local mathrandom = math.random
	local entsCreate = ents.Create
	local utilEffect = util.Effect
	local EffectData = EffectData
	local IsValid = IsValid
	local Vector = Vector


	util.AddNetworkString(sTag)


	ENT.GravGunPickupAllowed = fReturnFalse -- This is Serverside only


	local vCached1 = Vector(0,-1000,0)
	local vCached2 = Vector(870,500,0)
	local vCached3 = Vector(-870,500,0)


	local fSmallExplosion = function(self,vPos)

		util.BlastDamage(self,self.Owner,vPos,1000,150)


		local obj_EffectData = EffectData()
		obj_EffectData:SetOrigin(vPos)
		obj_EffectData:SetRadius(100)
		obj_EffectData:SetMagnitude(100)

		utilEffect("HelicopterMegaBomb",obj_EffectData)


		local obj_EffectData = EffectData()
		obj_EffectData:SetOrigin(vPos)
		obj_EffectData:SetStart(vPos)

		utilEffect("Explosion",obj_EffectData,true,true)

	end


	function ENT:Initialize()

		SafeRemoveEntityDelayed(self,10)


		self:SetModel("models/hunter/plates/plate.mdl")

		self:SetNoDraw(true) -- Prevent Networking


		do

			self.Ground = IsValid(self.Target) and self.Target:GetPos() or self.Ground


			local eSprite = entsCreate("env_sprite")

				SafeRemoveEntityDelayed(eSprite,3)

			if IsValid(eSprite) then

				eSprite:SetKeyValue("model","light_glow01.vmt")
				eSprite:SetKeyValue("rendercolor","255 0 0")
				eSprite:SetKeyValue("scale",".1")
				eSprite:SetKeyValue("rendermode","9")


				eSprite:SetPos(self.Ground)

				if self.Target then
					eSprite:SetParent(self.Target)
				end


				eSprite:Spawn()
				eSprite:Activate()

			end


			timer.Simple(3,function()

				if not IsValid(self) then return end


				do

					self.Ground = IsValid(self.Target) and self.Target:GetPos() or self.Ground


					local eInfoTarget = entsCreate("info_target")

						SafeRemoveEntityDelayed(eInfoTarget,3)

					if IsValid(eInfoTarget) then

						eInfoTarget:SetKeyValue("targetname",tostring(eInfoTarget))

						eInfoTarget:SetPos(self.Ground)
						eInfoTarget:Spawn()

						if self.Target then
							eInfoTarget:SetParent(self.Target)
						end

					end


					local eLaser = entsCreate("env_laser")

						SafeRemoveEntityDelayed(eLaser,3)

					if IsValid(eLaser) then

						eLaser:SetKeyValue("texture","sprites/laserbeam.spr")
						eLaser:SetKeyValue("TextureScroll","30")
						eLaser:SetKeyValue("noiseamplitude","0")
						eLaser:SetKeyValue("width","1")
						eLaser:SetKeyValue("damage","0")
						eLaser:SetKeyValue("rendercolor","255 0 0")
						eLaser:SetKeyValue("renderamt","255")
						eLaser:SetKeyValue("lasertarget",tostring(eInfoTarget))
						eLaser:SetKeyValue("parent",tostring(self))

						eLaser:SetPos(self:GetPos())
						eLaser:SetParent(self)

						eLaser:Spawn()

						eLaser:Fire("turnon",0)

					end


					local eSprite = entsCreate("env_sprite")

						SafeRemoveEntityDelayed(eSprite,3)

					if IsValid(eSprite) then

						eSprite:SetKeyValue("model","light_glow01.vmt")
						eSprite:SetKeyValue("rendercolor","255 0 0")
						eSprite:SetKeyValue("scale",".1")
						eSprite:SetKeyValue("rendermode","9")

						eSprite:SetPos(self.Ground)
						eSprite:Spawn()
						eSprite:Activate()

					end


					timer.Simple(3,function()

						if not IsValid(self) then return end


						do

							self.Ground = IsValid(self.Target) and self.Target:GetPos() or self.Ground


							local eInfoTarget = entsCreate("info_target")

								SafeRemoveEntityDelayed(eInfoTarget,2.25)

							if IsValid(eInfoTarget) then

								eInfoTarget:SetKeyValue("targetname",tostring(eInfoTarget))

								eInfoTarget:SetPos(self.Ground)
								eInfoTarget:Spawn()

							end


							local eGlow = entsCreate("env_lightglow")

								SafeRemoveEntityDelayed(eGlow,2.25)

							if IsValid(eGlow) then

								eGlow:SetKeyValue("rendercolor","255 100 100")
								eGlow:SetKeyValue("VerticalGlowSize","1800")
								eGlow:SetKeyValue("HorizontalGlowSize","1000")
								eGlow:SetKeyValue("MaxDist","1000")
								eGlow:SetKeyValue("MinDist","4000")
								eGlow:SetKeyValue("OuterMaxDist","20000")

								eGlow:SetPos(self.Ground)
								eGlow:Spawn()

							end


							local obj_EffectData = EffectData()
							obj_EffectData:SetOrigin(self.Ground)

							utilEffect("m9k_orbital_smokering",obj_EffectData)


							local vSelfPos = self:GetPos()

							for I = 1,8 do -- Lasers!

								timer.Simple(I / 8,function()

									if not IsValid(self) then return end


									local eLaser = entsCreate("env_laser")

										SafeRemoveEntityDelayed(eLaser,1.5)

									if IsValid(eLaser) then

										eLaser:SetKeyValue("texture","sprites/laser.vmt")
										eLaser:SetKeyValue("TextureScroll","30")
										eLaser:SetKeyValue("noiseamplitude","0")
										eLaser:SetKeyValue("width","500")
										eLaser:SetKeyValue("damage","0")
										eLaser:SetKeyValue("rendercolor","100 100 255")
										eLaser:SetKeyValue("renderamt","255")
										eLaser:SetKeyValue("lasertarget",tostring(eInfoTarget))

										eLaser:SetPos(vSelfPos + Vector(mathrandom(-870,870),mathrandom(-500,500),0))
										eLaser:Spawn()

										eLaser:Fire("turnon",0)

									end
								end)
							end


							timer.Simple(1.5,function()

								if not IsValid(self) then return end


								net.Start(sTag) -- Play strider fire sound
									net.WriteBool(false)
								net.Broadcast()

							end)


							timer.Simple(2.25,function()

								if not IsValid(self) then return end


								do

									local vPos  = self:GetPos()


									local tTrace1 = utilTraceLine({
										start = vPos + vCached2,
										endpos = self.Ground,
										filter = self
									})

									if tTrace1.HitPos ~= self.Ground then
										fSmallExplosion(self,tTrace1.HitPos)
									end


									local tTrace2 = utilTraceLine({
										start = vPos + vCached3,
										endpos = self.Ground,
										filter = self
									})

									if tTrace2.HitPos ~= self.Ground then
										fSmallExplosion(self,tTrace2.HitPos)
									end


									local tTrace3 = utilTraceLine({
										start = vPos + vCached1,
										endpos = self.Ground,
										filter = self
									})

									if tTrace3.HitPos ~= self.Ground then
										fSmallExplosion(self,tTrace3.HitPos)
									end


									local obj_EffectData = EffectData()
									obj_EffectData:SetOrigin(self.Ground)
									obj_EffectData:SetRadius(5000)
									obj_EffectData:SetMagnitude(5000)

									utilEffect("HelicopterMegaBomb",obj_EffectData)


									local obj_EffectData = EffectData()
									obj_EffectData:SetOrigin(self.Ground)
									obj_EffectData:SetStart(self.Ground)

									utilEffect("Explosion",obj_EffectData,true,true)


									local obj_EffectData = EffectData()
									obj_EffectData:SetOrigin(self.Ground)
									obj_EffectData:SetNormal(Vector(0,0,1))
									obj_EffectData:SetEntity(self.Owner)
									obj_EffectData:SetScale(8)
									obj_EffectData:SetRadius(67)
									obj_EffectData:SetMagnitude(8)

									utilEffect("m9k_gdcw_cinematicboom",obj_EffectData)


									util.BlastDamage(self,self.Owner,self.Ground,4000,500)


									local eShake = entsCreate("env_shake")

										SafeRemoveEntityDelayed(eShake,3)

									if IsValid(eShake) then

										eShake:SetKeyValue("amplitude","4000")
										eShake:SetKeyValue("radius","5000")
										eShake:SetKeyValue("duration","2.5")
										eShake:SetKeyValue("frequency","255")
										eShake:SetKeyValue("spawnflags","4")

										eShake:SetPos(self.Ground)
										eShake:Spawn()
										eShake:Activate()

										eShake:Fire("StartShake","",0)

									end


									local obj_EffectData = EffectData()
									obj_EffectData:SetOrigin(self.Ground)

									utilEffect("m9k_orbital_smokering",obj_EffectData)


									self:Remove()


									net.Start(sTag) -- Play explosion sound
										net.WriteBool(true)
									net.Broadcast()

								end
							end)
						end
					end)
				end
			end)
		end
	end


	function ENT:Think()
		if not IsValid(self.Owner) then
			self:Remove()

			return
		end
	end
end


if CLIENT then
	net.Receive(sTag,function()
		surface.PlaySound(net.ReadBool() and "ambient/explosions/explode_6.wav" or "npc/strider/fire.wav")
	end)
end