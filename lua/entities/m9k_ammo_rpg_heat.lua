AddCSLuaFile()

ENT.Base = "m9k_m202_rocket" -- We only have very slight changes here.

if SERVER then

	local utilTraceLine = util.TraceLine -- Optimizations
	local mathRand = math.Rand
	local CurTime = CurTime
	local Vector = Vector

	local vCached1 = Vector(0,0,-0.5)


	function ENT:Think()

		if self.iLifeTime < CurTime() then
			self:Remove()

			return
		end


		local vPos = self:GetPos()

		local tTrace = utilTraceLine({
			start = vPos,
			endpos = vPos + self.vFlight,
			filter = self.tFilters
		})


		if tTrace.Hit then

			local obj_EffectData = EffectData()

			obj_EffectData:SetMagnitude(18)
			obj_EffectData:SetScale(1.3)
			obj_EffectData:SetOrigin(tTrace.HitPos)
			obj_EffectData:SetNormal(tTrace.HitNormal)
			obj_EffectData:SetRadius(tTrace.MatType)

			util.Effect("m9k_gdcw_cinematicboom",obj_EffectData)


			util.ScreenShake(tTrace.HitPos,10,5,1,3000)

			util.Decal("Scorch",tTrace.HitPos + tTrace.HitNormal,tTrace.HitPos - tTrace.HitNormal)

			util.BlastDamage(self,self.Owner,tTrace.HitPos,600,150)


			self:Remove()


			return

		end


		self.vFlight = self.vFlight - self.vFlight / ((147 * 39.37) / 66) + self:GetForward() * 2 + Vector(mathRand(-0.3,0.3),mathRand(-0.3,0.3),mathRand(-0.1,0.1)) + vCached1

		self:SetPos(vPos + self.vFlight)
		self:SetAngles(self.vFlight:Angle())


		self:NextThink(CurTime() + 0.03)
		return true
	end
end