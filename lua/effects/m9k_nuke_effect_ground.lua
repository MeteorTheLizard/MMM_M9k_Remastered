local renderUpdateRefractTexture = render.UpdateRefractTexture
local renderDrawQuadEasy = render.DrawQuadEasy
local renderSetMaterial = render.SetMaterial
local renderDrawSprite = render.DrawSprite
local renderGetDXLevel = render.GetDXLevel
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
local Color = Color
local pairs = pairs

local mat_Glow1 = Material("sprites/nuke_light_glow02")
local mat_Glow2 = Material("sprites/nuke_yellowflare")
local mat_Glow3 = Material("sprites/nuke_redglow2")
local mat_Refract = Material("refract_ring")
	mat_Refract:SetInt("$nocull",1)

local vCached1 = Vector(0,0,128)
local vCached2 = Vector(0,0,256)
local vCached3 = Vector(0,0,800)
local vCached4 = Vector(0,0,1)


function EFFECT:Init(obj_Data)

	local vPos = obj_Data:GetOrigin()

		vPos:SetUnpacked(vPos.x,vPos.y,vPos.z + 5)

	self.vPosStart = vPos -- Cache it for RENDER.


	self.iLifeTime = CurTime() + 27

	self.GAlpha = 255
	self.GSize = 100
	self.FAlpha = 254
	self.CloudHeight = obj_Data:GetScale()

	self.CloudHeight = (self.CloudHeight < 100 and 100) or self.CloudHeight

	self.Refract = 0.5
	self.DeltaRefract = 0.06
	self.Size = 0
	self.MaxSize = 4e5

	self.tSmoke = {}

	if renderGetDXLevel() <= 81 then
		mat_Refract = Material("effects/strider_pinch_dudv")

		self.Refract = 0.3
		self.DeltaRefract = 0.03
		self.MaxSize = 2e5
	end


	local eParticleEmitter = ParticleEmitter(vPos)
	if not IsValid(eParticleEmitter) then return end

	for i = 1,150 do

		local vDirection = Vector(mathRand(-32,32),mathRand(-32,32),mathRand(-18,18)):GetNormalized()


		local obj_Particle = eParticleEmitter:Add("particles/flamelet" .. mathrandom(5),vPos + 1 * (vDirection * (mathRand(200,600)) + Vector(0,0,self.CloudHeight)))

		if obj_Particle then

			vDirection:SetUnpacked(vDirection.x,vDirection.y,vDirection.z + 1 * 3.5)

			obj_Particle:SetVelocity(mathRand(30,33) * vDirection)
			obj_Particle:SetDieTime(mathRand(23,32))
			obj_Particle:SetStartAlpha(mathRand(230,250))
			obj_Particle:SetStartSize(mathRand(200,300))
			obj_Particle:SetEndSize(mathRand(350,450))
			obj_Particle:SetRoll(mathRand(150,170))
			obj_Particle:SetRollDelta(-1 * mathrandom(-1,1))
			obj_Particle:SetColor(mathrandom(150,255),mathrandom(100,150),100)

		end
	end

	for i = 1,84 do

		local vDirection = Vector(mathRand(-32,32),mathRand(-32,32),mathRand(-16,24)):GetNormalized()


		local obj_Particle = eParticleEmitter:Add("particles/flamelet" .. mathrandom(5),vPos + 1 * (vDirection * (mathRand(2,340)) + Vector(0,0,mathrandom(-30,60))))

		if obj_Particle then

			vDirection:SetUnpacked(vDirection.x,vDirection.y,0.2 * vDirection.z)

			obj_Particle:SetVelocity(mathRand(24,32) * vDirection)
			obj_Particle:SetDieTime(mathRand(20,23))
			obj_Particle:SetStartAlpha(mathRand(230,250))
			obj_Particle:SetStartSize(mathRand(200,300))
			obj_Particle:SetEndSize(mathRand(350,450))
			obj_Particle:SetRoll(mathRand(150,170))
			obj_Particle:SetRollDelta(-1 * mathRand(-1,1))
			obj_Particle:SetColor(mathrandom(150,255),mathrandom(100,150),100)

		end
	end

	for i = 1,72 do

		local vSpawn = 1 * Vector(mathrandom(-72,72),mathrandom(-72,72),mathrandom(0,self.CloudHeight))


		local obj_Particle = eParticleEmitter:Add("particles/flamelet" .. mathrandom(5),vPos + vSpawn)

		if obj_Particle then

			obj_Particle:SetVelocity(1 * Vector(0,0,mathRand(2,96)) + 1 * 6 * VectorRand())
			obj_Particle:SetDieTime(mathRand(24,27))
			obj_Particle:SetStartAlpha(mathRand(230,250))
			obj_Particle:SetStartSize(mathRand(130,150))
			obj_Particle:SetEndSize(mathRand(190,210))
			obj_Particle:SetRoll(mathRand(150,170))
			obj_Particle:SetRollDelta(-1 * mathRand(-1,1))
			obj_Particle:SetColor(mathrandom(150,255),mathrandom(100,150),100)

		end
	end

	for i = 1,160 do

		local vDirection = Vector(mathRand(-32,32),mathRand(-32,32),mathRand(-18,18)):GetNormalized()


		local obj_Particle = eParticleEmitter:Add("particles/smokey",vPos + 1 * (vDirection * (mathRand(4,685)) + Vector(0,0,self.CloudHeight)))

		if obj_Particle then

			local iAlpha = mathRand(0,5)

			vDirection:SetUnpacked(vDirection.x,vDirection.y,vDirection.z + 1 * 4.2)

			obj_Particle:SetVelocity(mathRand(24,26) * vDirection)
			obj_Particle:SetLifeTime(mathRand(-23,-14))
			obj_Particle:SetDieTime(62)
			obj_Particle:SetStartAlpha(iAlpha)
			obj_Particle:SetEndAlpha(250 + iAlpha)
			obj_Particle:SetStartSize(mathRand(300,380))
			obj_Particle:SetEndSize(mathRand(450,550))
			obj_Particle:SetRoll(mathRand(150,170))
			obj_Particle:SetRollDelta(-1 * mathrandom(-2,2))
			obj_Particle:SetColor(60,58,54)


			self.tSmoke[obj_Particle] = true -- We have to use pairs anyway, so don't use table.insert !!

		end
	end

	for i = 1,100 do

		local vDirection = Vector(mathRand(-32,32),mathRand(-32,32),mathRand(-2,4)):GetNormalized()


		local obj_Particle = eParticleEmitter:Add("particles/smokey",vPos + 1 * (vDirection * (mathRand(2,650))))

		if obj_Particle then

			local iAlpha = mathRand(0,5)

			obj_Particle:SetVelocity(mathRand(8,32) * vDirection)
			obj_Particle:SetLifeTime(mathRand(-21,-12))
			obj_Particle:SetDieTime(62)
			obj_Particle:SetStartAlpha(iAlpha)
			obj_Particle:SetEndAlpha(250 + iAlpha)
			obj_Particle:SetStartSize(mathRand(300,380))
			obj_Particle:SetEndSize(mathRand(400,500))
			obj_Particle:SetRoll(mathRand(150,170))
			obj_Particle:SetRollDelta(-1 * mathRand(-1,1))
			obj_Particle:SetColor(60,58,54)


			self.tSmoke[obj_Particle] = true -- We have to use pairs anyway, so don't use table.insert !!

		end
	end

	for i = 1,115 do

		local vSpawn = 1 * Vector(mathrandom(-68,68),mathrandom(-68,68),mathRand(0,self.CloudHeight))


		local obj_Particle = eParticleEmitter:Add("particles/smokey",vPos + vSpawn)

		if obj_Particle then

			local iAlpha = mathRand(0,5)

			obj_Particle:SetVelocity(1 * Vector(0,0,mathRand(0,96)) + 1 * mathRand(4,9) * VectorRand())
			obj_Particle:SetLifeTime(mathRand(-22,-13))
			obj_Particle:SetDieTime(62)
			obj_Particle:SetStartAlpha(iAlpha)
			obj_Particle:SetEndAlpha(250 + iAlpha)
			obj_Particle:SetStartSize(mathRand(240,260))
			obj_Particle:SetEndSize(mathRand(270,300))
			obj_Particle:SetRoll(mathRand(150,170))
			obj_Particle:SetRollDelta(-1 * mathRand(-1,1))
			obj_Particle:SetColor(60,58,54)


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
			self.FAlpha = self.FAlpha - 100 * iTime
		end


		self.GAlpha = self.GAlpha - 9.48 * iTime
		self.GSize = self.GSize - 0.1 * iTimeLeft * iTime
		self.CloudHeight = self.CloudHeight + 120 * iTime
		self.Refract = self.Refract - self.DeltaRefract * iTime
		self.Size = self.Size + 2e4 * iTime


		return true

	end


	for obj_Particle in pairs(self.tSmoke) do
		obj_Particle:SetStartAlpha(70)
		obj_Particle:SetEndAlpha(0)
	end


	return false

end


function EFFECT:Render()

	local vPos = self.vPosStart -- Optimization
	local iGSize = self.GSize
	local iGAlpha = self.GAlpha


	renderSetMaterial(mat_Glow1)
	renderDrawSprite(vPos + vCached1,450 * iGSize,60 * iGSize,Color(255,240,220,iGAlpha))
	renderDrawSprite(vPos + Vector(0,0,self.CloudHeight),140 * iGSize,90 * iGSize,Color(255,240,220,0.7 * iGAlpha))


	if self.FAlpha > 0 then
		renderDrawSprite(vPos + vCached2,80 * (iGSize ^ 2),55 * (iGSize ^ 2),Color(255,247,238,self.FAlpha))
	end


	renderSetMaterial(mat_Glow2)
	renderDrawSprite(vPos + vCached3,600 * iGSize,500 * iGSize,Color(255,50,10,0.7 * iGAlpha))

	renderSetMaterial(mat_Glow3)
	renderDrawSprite(vPos + Vector(0,0,self.CloudHeight),40 * iGSize,500 * iGSize,Color(130,120,240,0.23 * iGAlpha))
	renderDrawSprite(vPos + Vector(0,0,self.CloudHeight),700 * iGSize,60 * iGSize,Color(80,73,255,iGAlpha))


	if self.Size < self.MaxSize then

		mat_Refract:SetFloat("$refractamount",mathsin(self.Refract * mathpi) * 0.2)

		renderSetMaterial(mat_Refract)
		renderUpdateRefractTexture()

		renderDrawQuadEasy(vPos,vCached4,self.Size,self.Size)

	end
end