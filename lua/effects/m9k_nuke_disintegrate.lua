local ParticleEmitter = ParticleEmitter
local mathrandom = math.random
local VectorRand = VectorRand
local mathRand = math.Rand
local Vector = Vector


function EFFECT:Init(obj_Data)

	local vPos = obj_Data:GetOrigin()
	local aAng = obj_Data:GetNormal()

		aAng:SetUnpacked(aAng.x,aAng.y,0.4 * aAng.z)


	local eParticleEmitter = ParticleEmitter(vPos)
	if not IsValid(eParticleEmitter) then return end

	for i = 1,50 do

		local obj_Particle = eParticleEmitter:Add("effects/fleck_antlion" .. mathrandom(1,2),vPos + Vector(mathRand(-8,8),mathRand(-8,8),mathRand(-32,32)))

		if obj_Particle then

			obj_Particle:SetVelocity(aAng * mathRand(256,385) + VectorRand() * 64)
			obj_Particle:SetLifeTime(mathRand(-0.3,0.1))
			obj_Particle:SetDieTime(mathRand(0.7,1))
			obj_Particle:SetStartAlpha(255)
			obj_Particle:SetEndAlpha(0)
			obj_Particle:SetStartSize(mathRand(1.5,1.7))
			obj_Particle:SetEndSize(mathRand(1.8,2))
			obj_Particle:SetRoll(mathRand(360,520))
			obj_Particle:SetRollDelta(mathrandom(-2,2))
			obj_Particle:SetColor(30,30,30)

		end
	end

	for i = 1,20 do

		local obj_Particle = eParticleEmitter:Add("particles/smokey",vPos + Vector(mathRand(-8,9),mathRand(-8,8),mathRand(-32,32)) - aAng * 8)

		if obj_Particle then

			obj_Particle:SetVelocity(aAng * mathRand(256,385) + VectorRand() * 64)
			obj_Particle:SetDieTime(mathRand(0.4,0.8))
			obj_Particle:SetStartAlpha(255)
			obj_Particle:SetEndAlpha(0)
			obj_Particle:SetStartSize(mathRand(8,12))
			obj_Particle:SetEndSize(mathRand(24,32))
			obj_Particle:SetRoll(mathRand(360,520))
			obj_Particle:SetRollDelta(mathrandom(-2,2))
			obj_Particle:SetColor(20,20,20)

		end
	end

	eParticleEmitter:Finish()

end


function EFFECT:Think()
	return false
end

function EFFECT:Render()

end