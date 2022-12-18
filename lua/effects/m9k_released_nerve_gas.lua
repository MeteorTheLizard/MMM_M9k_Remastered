local mathRand = math.Rand


function EFFECT:Init(obj_Data)

	local vPos = obj_Data:GetOrigin()


	local eParticleEmitter = ParticleEmitter(vPos)
	if not IsValid(eParticleEmitter) then return end

	for i = 1,50 do

		local obj_Particle = eParticleEmitter:Add("particle/smokesprites_000" .. math.random(9),vPos)

		if obj_Particle then

			obj_Particle:SetVelocity(VectorRand():GetNormalized() * mathRand(100,300))

			if i <= 5 then
				obj_Particle:SetDieTime(20)
			else
				obj_Particle:SetDieTime(mathRand(10,20))
			end

			obj_Particle:SetStartAlpha(mathRand(40,60))
			obj_Particle:SetEndAlpha(0)
			obj_Particle:SetStartSize(mathRand(40,50))
			obj_Particle:SetEndSize(mathRand(200,250))
			obj_Particle:SetRoll(mathRand(0,360))
			obj_Particle:SetRollDelta(mathRand(-1,1))
			obj_Particle:SetColor(186,17,17)
			obj_Particle:SetAirResistance(100)
			obj_Particle:SetCollide(true)
			obj_Particle:SetBounce(1)

		end
	end

	eParticleEmitter:Finish()

end


function EFFECT:Think()
	return false
end


function EFFECT:Render()

end