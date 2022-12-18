local ParticleEmitter = ParticleEmitter
local FrameTime = FrameTime
local mathrandom = math.random
local mathRand = math.Rand
local mathceil = math.ceil
local CurTime = CurTime
local Vector = Vector


function EFFECT:Init(obj_Data)

	self.vPos = obj_Data:GetOrigin()


	self.iLifeTime = (CurTime() + 1) * 6


	self.SplodeDist = 2000
	self.BlastSpeed = 4000
	self.WaveResolution = 0.01


	self.iLastTick = CurTime() + 0.75

end


function EFFECT:Think()

	local iCur = CurTime()


	if self.iLifeTime > iCur then


		if self.iLastTick < iCur then


			self.iLastTick = iCur + self.WaveResolution
			self.SplodeDist = self.SplodeDist + self.BlastSpeed * (self.WaveResolution + FrameTime())

			local iIntensity = -8.2e-5 * self.SplodeDist + 2.5


			local eParticleEmitter = ParticleEmitter(self.vPos)
			if not IsValid(eParticleEmitter) then return end

			for i = 1,mathceil(70 / iIntensity) do


				local vDirection = Vector(mathRand(-32,32),mathRand(-32,32),0):GetNormalized()


				local vStart = self.vPos + vDirection * mathRand(0.97 * self.SplodeDist,1.03 * self.SplodeDist)

					vStart:SetUnpacked(vStart.x,vStart.y,vStart.z - 1 * 650)


				local obj_Particle = eParticleEmitter:Add("particles/smokey",vStart)

				if obj_Particle then
					obj_Particle:SetVelocity(mathRand(600,640) * iIntensity * vDirection + Vector(0,0,mathRand(30,40) * ((4 - iIntensity) ^ 2 + 15)))
					obj_Particle:SetDieTime(1 * iIntensity)
					obj_Particle:SetStartAlpha(110)
					obj_Particle:SetEndAlpha(0)
					obj_Particle:SetStartSize(mathRand(500,600))
					obj_Particle:SetEndSize(mathRand(700,800))
					obj_Particle:SetRoll(mathRand(480,540))
					obj_Particle:SetRollDelta(mathrandom(-1,1))
					obj_Particle:SetColor(160,152,120)
				end
			end

			eParticleEmitter:Finish()

		end


		return true

	end


	return false

end


function EFFECT:Render()

end