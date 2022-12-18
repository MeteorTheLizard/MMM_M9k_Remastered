local mathrandom = math.random
local mathRand = math.Rand
local Vector = Vector


function EFFECT:Init(obj_Data)

	local vPos = obj_Data:GetOrigin()


	local eParticleEmitter = ParticleEmitter(vPos)
	if not IsValid(eParticleEmitter) then return end

	if obj_Data:GetScale() == 1 then

		for i=1, 300 do

			local obj_Particle = eParticleEmitter:Add("particle/smokesprites_000" .. mathrandom(9),vPos)

			if obj_Particle then
				obj_Particle:SetVelocity(Vector(mathrandom(-10,10),mathrandom(-10,10),0):GetNormal() * 10000)
				obj_Particle:SetDieTime(2.5)
				obj_Particle:SetStartAlpha(mathRand(40,60))
				obj_Particle:SetEndAlpha(0)
				obj_Particle:SetStartSize(mathRand(100,150))
				obj_Particle:SetEndSize(mathRand(300,350))
				obj_Particle:SetRoll(mathRand(0,360))
				obj_Particle:SetRollDelta(mathRand(-1,1))
				obj_Particle:SetColor(90,83,68)
				obj_Particle:SetAirResistance(50)
				obj_Particle:SetCollide(false)
				obj_Particle:SetBounce(0)
			end
		end

		eParticleEmitter:Finish()

	else

		local obj_Particle = eParticleEmitter:Add("pincher.vmt",vPos)

		if obj_Particle then
			obj_Particle:SetDieTime(2)
			obj_Particle:SetStartAlpha(255)
			obj_Particle:SetEndAlpha(255)
			obj_Particle:SetStartSize(1)
			obj_Particle:SetEndSize(2000)
			obj_Particle:SetRoll(0)
			obj_Particle:SetRollDelta(0)
			obj_Particle:SetAirResistance(0)
			obj_Particle:SetCollide(false)
			obj_Particle:SetBounce(0)
		end


		timer.Simple(2,function()

			local obj_Particle = eParticleEmitter:Add("effects/strider_bulge_dudv.vmt",vPos)

			if obj_Particle then
				obj_Particle:SetDieTime(.25)
				obj_Particle:SetStartAlpha(255)
				obj_Particle:SetEndAlpha(255)
				obj_Particle:SetStartSize(5000)
				obj_Particle:SetEndSize(1)
				obj_Particle:SetRoll(0)
				obj_Particle:SetRollDelta(0)
				obj_Particle:SetAirResistance(0)
				obj_Particle:SetCollide(false)
				obj_Particle:SetBounce(0)
			end

			eParticleEmitter:Finish()

		end)
	end
end


function EFFECT:Think()
	return false
end


function EFFECT:Render()

end