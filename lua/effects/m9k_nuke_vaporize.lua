local ParticleEmitter = ParticleEmitter
local utilTraceLine = util.TraceLine
local mathrandom = math.random
local VectorRand = VectorRand
local utilDecal = util.Decal
local mathRand = math.Rand
local mathceil = math.ceil
local IsValid = IsValid
local Vector = Vector

local vCached1 = Vector(0,0,32)
local vCached2 = vCached1 * 2


function EFFECT:Init(obj_Data)

	local eParent = obj_Data:GetEntity()
	if not IsValid(eParent) then return end

	local vPos = eParent:GetPos()


	local iHeight = eParent:BoundingRadius() * 2
	local iWidth = iHeight / 3


	local eParticleEmitter = ParticleEmitter(vPos)
	if not IsValid(eParticleEmitter) then return end

	for i = 1,mathceil(iHeight) do

		local obj_Particle = eParticleEmitter:Add("effects/fleck_antlion" .. mathrandom(2),vPos + Vector(mathRand(-iWidth,iWidth),mathRand(-iWidth,iWidth),mathRand(2,iHeight)))

		if obj_Particle then
			obj_Particle:SetVelocity(VectorRand(96))
			obj_Particle:SetDieTime(mathRand(0.4,0.8))
			obj_Particle:SetStartAlpha(255)
			obj_Particle:SetEndAlpha(0)
			obj_Particle:SetStartSize(mathRand(1.5,1.7))
			obj_Particle:SetEndSize(mathRand(1.8,2))
			obj_Particle:SetRoll(mathRand(360,520))
			obj_Particle:SetRollDelta(mathrandom(-2,2))
			obj_Particle:SetColor(30,30,30)
		end
	end

	for i = 1,mathceil(iWidth) do

		local obj_Particle = eParticleEmitter:Add("particles/smokey",vPos + Vector(mathRand(-iWidth,iWidth),mathRand(-iWidth,iWidth),mathRand(2,iHeight)))

		if obj_Particle then
			obj_Particle:SetVelocity(Vector(mathRand(-24,24),mathRand(-24,24),mathRand(32,64)))
			obj_Particle:SetDieTime(mathRand(0.4,0.8))
			obj_Particle:SetStartAlpha(255)
			obj_Particle:SetEndAlpha(0)
			obj_Particle:SetStartSize(mathRand(12,16))
			obj_Particle:SetEndSize(mathRand(32,48))
			obj_Particle:SetRoll(mathRand(360,520))
			obj_Particle:SetRollDelta(mathrandom(-2,2))
			obj_Particle:SetColor(20,20,20)
		end
	end

	eParticleEmitter:Finish()


	local vStart = vPos + vCached1

	local tTrace = {
		startpos = vStart,
		endpos = vStart - vCached2,
		filter = eParent
	}


	local tTraceRes = utilTraceLine(tTrace)

	utilDecal("Scorch",tTraceRes.HitPos + tTraceRes.HitNormal,tTraceRes.HitPos - tTraceRes.HitNormal)


	for i = 1,8 do

		tTrace.endpos = tTrace.startpos + Vector(mathRand(-48,48),mathRand(-48,48),-64)

		tTraceRes = utilTraceLine(tTrace)

		utilDecal("Blood",tTraceRes.HitPos + tTraceRes.HitNormal,tTraceRes.HitPos - tTraceRes.HitNormal)

	end
end


function EFFECT:Think()
	return false
end

function EFFECT:Render()

end