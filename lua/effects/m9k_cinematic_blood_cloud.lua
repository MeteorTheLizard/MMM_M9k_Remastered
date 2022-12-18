local mathrandom = math.random
local VectorRand = VectorRand
local mathRand = math.Rand
local Vector = Vector

local vCached1 = Vector(0,0,-600)


function EFFECT:Init(obj_Data)

	local vPos = obj_Data:GetOrigin()
	local vDir = obj_Data:GetNormal()


	sound.Play("physics/flesh/flesh_squishy_impact_hard" .. mathrandom(4) .. ".wav",vPos,180,100)


	local eParticleEmitter = ParticleEmitter(vPos)
	if not IsValid(eParticleEmitter) then return end

	for i = 0,30 do

		local obj_Particle = eParticleEmitter:Add("particle/particle_composite",vPos)

		if obj_Particle then
			obj_Particle:SetVelocity(VectorRand():GetNormalized() * mathrandom(100,600))
			obj_Particle:SetDieTime(mathRand(1,2))
			obj_Particle:SetStartAlpha(80)
			obj_Particle:SetEndAlpha(0)
			obj_Particle:SetStartSize(30)
			obj_Particle:SetEndSize(100)
			obj_Particle:SetRoll(mathRand(150,360))
			obj_Particle:SetRollDelta(mathRand(-2,2))
			obj_Particle:SetAirResistance(400)
			obj_Particle:SetGravity(Vector(mathRand(-50,50),mathRand(-50,50),mathRand(0,-200)))
			obj_Particle:SetColor(70,35,35)
		end
	end

	for i = 0,20 do

		local obj_Particle = eParticleEmitter:Add("particle/smokesprites_000" .. mathrandom(9),vPos)

		if obj_Particle then
			obj_Particle:SetVelocity(VectorRand():GetNormalized() * mathrandom(200,600))
			obj_Particle:SetDieTime(mathRand(1,4))
			obj_Particle:SetStartAlpha(120)
			obj_Particle:SetEndAlpha(0)
			obj_Particle:SetStartSize(30)
			obj_Particle:SetEndSize(100)
			obj_Particle:SetRoll(mathRand(150,360))
			obj_Particle:SetRollDelta(mathRand(-2,2))
			obj_Particle:SetAirResistance(400)
			obj_Particle:SetGravity(Vector(mathRand(-50,50),mathRand(-50,50),mathRand(-50,-300)))
			obj_Particle:SetColor(70,35,35)
		end
	end

	for i = 1,5 do

		local obj_Particle = eParticleEmitter:Add("effects/muzzleflash" .. mathrandom(4),vPos)

		if obj_Particle then
			obj_Particle:SetVelocity(vDir * 100)
			obj_Particle:SetAirResistance(200)
			obj_Particle:SetDieTime(0.15)
			obj_Particle:SetStartAlpha(255)
			obj_Particle:SetEndAlpha(0)
			obj_Particle:SetStartSize(300)
			obj_Particle:SetEndSize(0)
			obj_Particle:SetRoll(mathRand(180,480))
			obj_Particle:SetRollDelta(mathRand(-1,1))
			obj_Particle:SetColor(255,255,255)
		end
	end

	for i = 1,20 do

		local obj_Particle = eParticleEmitter:Add("effects/fleck_cement" .. mathrandom(2),vPos - (vDir * 5))

		if obj_Particle then
			obj_Particle:SetVelocity(VectorRand():GetNormalized() * 400)
			obj_Particle:SetDieTime(mathrandom(0.3,0.6))
			obj_Particle:SetStartAlpha(255)
			obj_Particle:SetEndAlpha(0)
			obj_Particle:SetStartSize(8)
			obj_Particle:SetEndSize(9)
			obj_Particle:SetRoll(mathRand(0,360))
			obj_Particle:SetRollDelta(mathRand(-5,5))
			obj_Particle:SetAirResistance(30)
			obj_Particle:SetColor(70,35,35)
			obj_Particle:SetGravity(vCached1)
			obj_Particle:SetCollide(true)
			obj_Particle:SetBounce(0.2)
		end
	end

	eParticleEmitter:Finish()

end


function EFFECT:Think()
	return false
end


function EFFECT:Render()

end