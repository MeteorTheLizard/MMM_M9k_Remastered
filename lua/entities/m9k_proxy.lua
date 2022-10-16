AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Proximity mine"
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

	local entsFindInSphere = ents.FindInSphere
	local utilTraceLine = util.TraceLine
	local CurTime = CurTime
	local ipairs = ipairs


	local fExplode = function(self)

		if not IsValid(self.Owner) or not self.bCanExplode then
			self:Remove()

			return
		end


		self.bCanExplode = false -- Failsafe


		local vPos = self:GetPos() -- Update the explosion position


		local obj_EffectData = EffectData()

		obj_EffectData:SetOrigin(vPos)

		util.Effect("HelicopterMegaBomb",obj_EffectData)
		util.Effect("ThumperDust",obj_EffectData)
		util.Effect("Explosion",obj_EffectData)

		obj_EffectData:SetScale(1) -- We can re-use the EffectData object here
		obj_EffectData:SetRadius(67)
		obj_EffectData:SetMagnitude(18)

		util.Effect("m9k_gdcw_cinematicboom",obj_EffectData)


		util.ScreenShake(vPos,2000,255,2.5,1250)

		util.BlastDamage(self,self.Owner,vPos,200,250)


		self:EmitSound("ambient/explosions/explode_" .. math.random(4) .. ".wav",100)


		self:Remove()

	end


	function ENT:Initialize()

		if not self.M9kr_CreatedByWeapon then -- Prevents exploiting it
			self:Remove()

			return
		end


		self:SetModel("models/weapons/w_px_planted.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)

		self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		self:PhysWake()


		self.iLifeTime = CurTime() + 3 -- Grace period
		self.bCanExplode = true

		self.OurPos = self:GetPos()
		self.iHealth = 25

		self.tTrace = {
			start = self.OurPos,
			endpos = self.OurPos,
			filter = self
		}

	end


	function ENT:Think()

		local iCur = CurTime()


		if self.iLifeTime < iCur then


			if self.DynamicPos then -- We want to update the position if the proxy mine is not mounted to a wall
				self.OurPos = self:GetPos()

				self.tTrace.start = self.OurPos
			end


			for _,v in ipairs(entsFindInSphere(self.OurPos,200)) do

				if v:IsPlayer() or v:IsNPC() then

					self.tTrace.endpos = v:GetPos()


					local tTrace = utilTraceLine(self.tTrace)

					if tTrace.Entity:IsPlayer() or tTrace.Entity:IsNPC() then
						fExplode(self)

						break
					end
				end
			end

		end


		self:NextThink(iCur + 0.3)
		return true
	end


	function ENT:OnTakeDamage(obj_DamageInfo)

		self.iHealth = self.iHealth - (obj_DamageInfo:GetDamage() or 25)

		if self.iHealth <= 0 then
			fExplode(self)
		end
	end
end