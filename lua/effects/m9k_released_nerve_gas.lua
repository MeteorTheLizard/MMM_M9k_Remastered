function EFFECT:Init(data)
	self.Entity = data:GetEntity()
	local pos = data:GetOrigin()
	self.Emitter = ParticleEmitter(pos)

	for i = 1,50 do
		local particle = self.Emitter:Add("particle/smokesprites_000" .. math.random(1,9),pos)

		if particle then
			particle:SetVelocity(VectorRand():GetNormalized() * math.Rand(100,300))

			if i == 1 or i == 2 or i == 3 or i == 5 then
				particle:SetDieTime(20)
			else
				particle:SetDieTime(math.Rand(10,20))
			end

			particle:SetStartAlpha(math.Rand(40,60))
			particle:SetEndAlpha(0)
			particle:SetStartSize(math.Rand(40,50))
			particle:SetEndSize(math.Rand(200,250))
			particle:SetRoll(math.Rand(0,360))
			particle:SetRollDelta(math.Rand(-1,1))
			particle:SetColor(186,17,17)
			particle:SetAirResistance(100)
			particle:SetCollide(true)
			particle:SetBounce(1)
		end
	end
end

function EFFECT:Think()
	return false
end