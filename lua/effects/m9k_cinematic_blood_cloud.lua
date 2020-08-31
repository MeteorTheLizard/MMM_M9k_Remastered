function EFFECT:Init(data)
	self.Pos = data:GetOrigin()
	self.DirVec = data:GetNormal()

	sound.Play("physics/flesh/flesh_squishy_impact_hard" .. math.random(1,4) .. ".wav",self.Pos,180,100)

	self.Emitter = ParticleEmitter(self.Pos)

	for i = 0,30 do
		local Smoke = self.Emitter:Add("particle/particle_composite",self.Pos)

		if Smoke then
			Smoke:SetVelocity(VectorRand():GetNormalized() * math.random(100,600))
			Smoke:SetDieTime(math.Rand(1,2))
			Smoke:SetStartAlpha(80)
			Smoke:SetEndAlpha(0)
			Smoke:SetStartSize(30)
			Smoke:SetEndSize(100)
			Smoke:SetRoll(math.Rand(150,360))
			Smoke:SetRollDelta(math.Rand(-2,2))
			Smoke:SetAirResistance(400)
			Smoke:SetGravity(Vector(math.Rand(-50,50),math.Rand(-50,50),math.Rand(0,-200)))
			Smoke:SetColor(70,35,35)
		end
	end

	for i = 0,20 do
		local Smoke = self.Emitter:Add("particle/smokesprites_000" .. math.random(1,9),self.Pos)

		if Smoke then
			Smoke:SetVelocity(VectorRand():GetNormalized() * math.random(200,600))
			Smoke:SetDieTime(math.Rand(1,4))
			Smoke:SetStartAlpha(120)
			Smoke:SetEndAlpha(0)
			Smoke:SetStartSize(30)
			Smoke:SetEndSize(100)
			Smoke:SetRoll(math.Rand(150,360))
			Smoke:SetRollDelta(math.Rand(-2,2))
			Smoke:SetAirResistance(400)
			Smoke:SetGravity(Vector(math.Rand(-50,50),math.Rand(-50,50),math.Rand(-50,-300)))
			Smoke:SetColor(70,35,35)
		end
	end

	for i = 1,5 do
		local Flash = self.Emitter:Add("effects/muzzleflash" .. math.random(1,4),self.Pos)

		if Flash then
			Flash:SetVelocity(self.DirVec * 100)
			Flash:SetAirResistance(200)
			Flash:SetDieTime(0.15)
			Flash:SetStartAlpha(255)
			Flash:SetEndAlpha(0)
			Flash:SetStartSize(300)
			Flash:SetEndSize(0)
			Flash:SetRoll(math.Rand(180,480))
			Flash:SetRollDelta(math.Rand(-1,1))
			Flash:SetColor(255,255,255)
		end
	end

	for i = 1,20 do
		local Debris = self.Emitter:Add("effects/fleck_cement" .. math.random(1,2),self.Pos - (self.DirVec * 5))

		if Debris then
			Debris:SetVelocity(VectorRand():GetNormalized() * 400)
			Debris:SetDieTime(math.random(0.3,0.6))
			Debris:SetStartAlpha(255)
			Debris:SetEndAlpha(0)
			Debris:SetStartSize(8)
			Debris:SetEndSize(9)
			Debris:SetRoll(math.Rand(0,360))
			Debris:SetRollDelta(math.Rand(-5,5))
			Debris:SetAirResistance(30)
			Debris:SetColor(70,35,35)
			Debris:SetGravity(Vector(0,0,-600))
			Debris:SetCollide(true)
			Debris:SetBounce(0.2)
		end
	end
end

function EFFECT:Think()
	return false
end

function EFFECT:Render() -- Required, otherwise there will be a 1 tick error model!
end