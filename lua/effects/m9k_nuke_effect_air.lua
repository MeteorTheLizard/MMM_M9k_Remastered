local renderUpdateRefractTexture = render.UpdateRefractTexture
local renderSetMaterial = render.SetMaterial
local renderGetDXLevel = render.GetDXLevel
local renderDrawSprite = render.DrawSprite
local ParticleEmitter = ParticleEmitter
local mathrandom = math.random
local VectorRand = VectorRand
local FrameTime = FrameTime
local mathRand = math.Rand
local Material = Material
local mathsin = math.sin
local CurTime = CurTime
local mathpi = math.pi
local Vector = Vector
local EyePos = EyePos
local Color = Color
local pairs = pairs

local mat_Glow1 = Material("sprites/nuke_light_glow02")
local mat_Glow2 = Material("sprites/nuke_yellowflare")
local mat_Glow3 = Material("sprites/nuke_redglow2")
local mat_Refract = Material("refract_ring")

local vCached1 = Vector(0,0,256)


function EFFECT:Init(obj_Data)

	local vPos = obj_Data:GetOrigin()

		vPos:SetUnpacked(vPos.x,vPos.y,vPos.z + 4)

	self.vPosStart = vPos -- Cache it for RENDER.


	self.iLifeTime = CurTime() + 24

	self.FAlpha = 255
	self.GAlpha = 254
	self.GSize = 100

	self.Refract = 0
	self.Size = 24

	self.tSmoke = {}


	if renderGetDXLevel() <= 81 then
		mat_Refract = Material("effects/strider_pinch_dudv")
	end


	local eParticleEmitter = ParticleEmitter(vPos)
	if not IsValid(eParticleEmitter) then return end

	for i = 1,280 do

		local vDirection = Vector(mathRand(-32,32),mathRand(-32,32),mathRand(-18,18)):GetNormalized()


		local obj_Particle = eParticleEmitter:Add("particles/flamelet" .. mathrandom(5),vPos * (vDirection * (mathRand(250,690))))

		if obj_Particle then

			vDirection:SetUnpacked(vDirection.x,vDirection.y,vDirection.z * 1.4)

			obj_Particle:SetVelocity(mathRand(30,33) * vDirection)
			obj_Particle:SetDieTime(mathRand(23,26))
			obj_Particle:SetStartAlpha(mathRand(230,250))
			obj_Particle:SetStartSize(mathRand(280,360))
			obj_Particle:SetEndSize(mathRand(540,630))
			obj_Particle:SetRoll(mathRand(480,540))
			obj_Particle:SetRollDelta(-1 * mathrandom(-1,1))
			obj_Particle:SetColor(mathrandom(150,255),mathrandom(100,150),100)

		end
	end

	for i = 1,27 do

		local vDirection = VectorRand(8)
		local vStart = vPos * 256 * vDirection


		for k = 5,26 do

			local obj_Particle = eParticleEmitter:Add("particles/flamelet" .. mathrandom(5),vStart - vDirection * 9 * k)

			if obj_Particle then

				obj_Particle:SetVelocity(vDirection * mathRand(2,3) + Vector(0,0,mathRand(15,20)))
				obj_Particle:SetDieTime(mathRand(22,24))
				obj_Particle:SetStartAlpha(mathRand(230,250))
				obj_Particle:SetStartSize((k * mathRand(3,4)) ^ 1.2)
				obj_Particle:SetEndSize((k * mathRand(5,6)) ^ 1.2)
				obj_Particle:SetRoll(mathRand(20,80))
				obj_Particle:SetRollDelta(-1 * mathrandom(-1,1))
				obj_Particle:SetColor(mathrandom(150,255),mathrandom(100,150),100)

			end
		end
	end

	for i = 1,320 do

		local vDirection = Vector(mathRand(-32,32),mathRand(-32,32),mathRand(-18,18)):GetNormalized()


		local obj_Particle = eParticleEmitter:Add("particles/smokey",vPos * (vDirection * (mathRand(2,665))))

		if obj_Particle then

			local iAlpha = mathRand(1,7)

			vDirection:SetUnpacked(vDirection.x,vDirection.y,vDirection.z * 1.5)

			obj_Particle:SetVelocity(mathRand(40,44) * vDirection)
			obj_Particle:SetLifeTime(mathRand(-16,-10))
			obj_Particle:SetDieTime(23)
			obj_Particle:SetStartAlpha(iAlpha)
			obj_Particle:SetEndAlpha(20 + iAlpha)
			obj_Particle:SetStartSize(mathRand(300,400))
			obj_Particle:SetEndSize(mathRand(600,800))
			obj_Particle:SetRoll(mathRand(480,540))
			obj_Particle:SetRollDelta(-1 * mathrandom(-1,1))
			obj_Particle:SetColor(230,230,230)


			self.tSmoke[obj_Particle] = true -- We have to use pairs anyway, so don't use table.insert !!

		end
	end

	eParticleEmitter:Finish()
end


function EFFECT:Think()

	local iTimeLeft = self.iLifeTime - CurTime()


	if iTimeLeft > 0 then

		local iTime = FrameTime()


		if self.FAlpha > 0 then
			self.FAlpha = self.FAlpha - 150 * iTime
		end


		self.GAlpha = self.GAlpha - 10.5 * iTime
		self.GSize = self.GSize - 0.12 * iTimeLeft * iTime
		self.Size = self.Size + 1200 * iTime
		self.Refract = self.Refract + 1.3 * iTime


		return true

	end


	for obj_Particle in pairs(self.tSmoke) do
		obj_Particle:SetStartAlpha(20)
		obj_Particle:SetEndAlpha(0)
	end


	return false

end


function EFFECT:Render()

	local vPos = self.vPosStart -- Optimization
	local iGSize = self.GSize
	local iGAlpha = self.GAlpha


	renderSetMaterial(mat_Glow1)
	renderDrawSprite(vPos,400 * iGSize,90 * iGSize,Color(255,240,220,iGAlpha))
	renderDrawSprite(vPos,70 * iGSize,280 * iGSize,Color(255,240,220,0.7 * iGAlpha))


	if self.FAlpha > 0 then
		renderDrawSprite(vPos + vCached1,50 * (iGSize ^ 2),35 * (iGSize ^ 2),Color(255,245,235,self.FAlpha))
	end


	renderSetMaterial(mat_Glow2)
	renderDrawSprite(vPos,700 * iGSize,550 * iGSize,Color(255,50,10,iGAlpha))

	renderSetMaterial(mat_Glow3)
	renderDrawSprite(vPos,56 * iGSize,600 * iGSize,Color(130,120,240,0.5 * iGAlpha))

	renderDrawSprite(vPos,700 * iGSize,70 * iGSize,Color(80,73,255,iGAlpha))


	if self.Size < 32768 then

		mat_Refract:SetFloat("$refractamount",mathsin(self.Refract * mathpi) * 0.1)

		renderSetMaterial(mat_Refract)
		renderUpdateRefractTexture()

		renderDrawSprite(self.Entity:GetPos() + (EyePos() - self.Entity:GetPos()):GetNormal() * EyePos():Distance(self.Entity:GetPos()) * (self.Refract ^ 0.3) * 0.8,self.Size,self.Size)

	end
end