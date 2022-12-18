local VectorRand = VectorRand
local mathrandom = math.random
local mathRand = math.Rand
local Vector = Vector

local vCached1 = Vector(0,0,-600)
local vCached2 = Vector(0,0,-60)
local vCached3 = Vector(0,0,-50)


local tMaterials = {
	[MAT_ALIENFLESH] = {5,9},
	[MAT_ANTLION] = {5,9},
	[MAT_BLOODYFLESH] = {5,8},
	[MAT_CLIP] = {3,5},
	[MAT_COMPUTER] = {4,5},
	[MAT_FLESH] = {5,8},
	[MAT_GRATE] = {3,4},
	[MAT_METAL] = {3,4},
	[MAT_PLASTIC] = {2,5},
	[MAT_SLOSH] = {5,5},
	[MAT_VENT] = {3,4},
	[MAT_FOLIAGE] = {1,5},
	[MAT_TILE] = {2,5},
	[MAT_CONCRETE] = {2,1},
	[MAT_DIRT] = {1,2},
	[MAT_SAND] = {1,3},
	[MAT_WOOD] = {2,6},
	[MAT_GLASS] = {4,7}
}


function EFFECT:Init(obj_Data)

	self.Pos = obj_Data:GetOrigin()
	self.Scale = obj_Data:GetScale()
	self.DirVec = obj_Data:GetNormal()
	self.Particles = obj_Data:GetMagnitude()
	self.Angle = self.DirVec:Angle()
	self.Debris = 10 + obj_Data:GetScale()
	self.Size = 5 * self.Scale


	if self.Scale < 1.2 then
		sound.Play("ambient/explosions/explode_" .. mathrandom(4) .. ".wav",self.Pos,100,100)
	else
		sound.Play("Explosion.Boom",self.Pos)
		sound.Play("ambient/explosions/explode_" .. mathrandom(4) .. ".wav",self.Pos,100,100)
	end


	self.Mat = math.ceil(obj_Data:GetRadius() or 1)


	local foundTheMat = (tMaterials[self.Mat] and true) or false

	if not foundTheMat then
		self.Mat = MAT_TILE
	end


	self.eParticleEmitter = ParticleEmitter(self.Pos)
	if not IsValid(self.eParticleEmitter) then return end

	if tMaterials[self.Mat][2] == 1 then
		self:obj_Particle()
	elseif tMaterials[self.Mat][2] == 2 then
		self:Dirt()
	elseif tMaterials[self.Mat][2] == 3 then
		self:Sand()
	elseif tMaterials[self.Mat][2] == 4 then
		self:Metal()
	elseif tMaterials[self.Mat][2] == 5 then
		self:obj_Particle()
	elseif tMaterials[self.Mat][2] == 6 then
		self:Wood()
	elseif tMaterials[self.Mat][2] == 7 then
		self:Glass()
	elseif tMaterials[self.Mat][2] == 8 then
		self:Blood()
	elseif tMaterials[self.Mat][2] == 9 then
		self:YellowBlood()
	else
		self:obj_Particle()
	end

	self.eParticleEmitter:Finish()

end


function EFFECT:obj_Particle()

	for i = 1,5 do

		local obj_Particle = self.eParticleEmitter:Add("effects/muzzleflash" .. mathrandom(4),self.Pos)

		if obj_Particle then
			obj_Particle:SetVelocity(self.DirVec * 100)
			obj_Particle:SetAirResistance(200)
			obj_Particle:SetDieTime(0.15)
			obj_Particle:SetStartAlpha(255)
			obj_Particle:SetEndAlpha(0)
			obj_Particle:SetStartSize(self.Scale * 300)
			obj_Particle:SetEndSize(0)
			obj_Particle:SetRoll(mathRand(180,480))
			obj_Particle:SetRollDelta(mathRand(-1,1))
			obj_Particle:SetColor(255,255,255)
		end
	end

	for i = 1,20 * self.Scale do

		local obj_Particle = self.eParticleEmitter:Add("particle/particle_composite",self.Pos)

		if obj_Particle then
			obj_Particle:SetVelocity(self.DirVec * mathrandom(100,400) * self.Scale + ((VectorRand():GetNormalized() * 300) * self.Scale))
			obj_Particle:SetDieTime(mathRand(2,3))
			obj_Particle:SetStartAlpha(230)
			obj_Particle:SetEndAlpha(0)
			obj_Particle:SetStartSize(50 * self.Scale)
			obj_Particle:SetEndSize(100 * self.Scale)
			obj_Particle:SetRoll(mathRand(150,360))
			obj_Particle:SetRollDelta(mathRand(-1,1))
			obj_Particle:SetAirResistance(150)
			obj_Particle:SetGravity(Vector(0,0,mathRand(-100,-400)))
			obj_Particle:SetColor(80,80,80)
		end
	end

	for i = 1,15 * self.Scale do

		local obj_Particle = self.eParticleEmitter:Add("particle/smokesprites_000" .. mathrandom(9),self.Pos)

		if obj_Particle then
			obj_Particle:SetVelocity(self.DirVec * mathrandom(100,400) * self.Scale + ((VectorRand():GetNormalized() * 400) * self.Scale))
			obj_Particle:SetDieTime(mathRand(1,5) * self.Scale)
			obj_Particle:SetStartAlpha(50)
			obj_Particle:SetEndAlpha(0)
			obj_Particle:SetStartSize(80 * self.Scale)
			obj_Particle:SetEndSize(100 * self.Scale)
			obj_Particle:SetRoll(mathRand(150,360))
			obj_Particle:SetRollDelta(mathRand(-1,1))
			obj_Particle:SetAirResistance(250)
			obj_Particle:SetGravity(Vector(mathRand(-200,200),mathRand(-200,200),mathRand(10,100)))
			obj_Particle:SetColor(90,85,75)
		end
	end

	for i = 1,25 * self.Scale do

		local obj_Particle = self.eParticleEmitter:Add("effects/fleck_cement" .. mathrandom(2),self.Pos)

		if obj_Particle then
			obj_Particle:SetVelocity(self.DirVec * mathrandom(0,700) * self.Scale + VectorRand():GetNormalized() * mathrandom(0,700) * self.Scale)
			obj_Particle:SetDieTime(mathrandom(2) * self.Scale)
			obj_Particle:SetStartAlpha(255)
			obj_Particle:SetEndAlpha(0)
			obj_Particle:SetStartSize(mathrandom(5,10) * self.Scale)
			obj_Particle:SetRoll(mathRand(0,360))
			obj_Particle:SetRollDelta(mathRand(-5,5))
			obj_Particle:SetAirResistance(40)
			obj_Particle:SetColor(60,60,60)
			obj_Particle:SetGravity(vCached1)
		end
	end


	local aAng = self.DirVec:Angle()

	for i = 1,self.Debris do

		aAng:RotateAroundAxis(aAng:Forward(),360 / self.Debris)

		local DustRing = aAng:Up()
		local RanVec = self.DirVec * mathRand(1,5) + (DustRing * mathRand(2,5))

		for k = 3,self.Particles do

			local Rcolor = mathrandom(-20,20)

			local obj_Particle = self.eParticleEmitter:Add("particle/smokesprites_000" .. mathrandom(9),self.Pos)

			obj_Particle:SetVelocity((VectorRand():GetNormalized() * mathRand(1,2) * self.Size) + (RanVec * self.Size * k * 3.5))
			obj_Particle:SetDieTime(mathRand(0.5,4) * self.Scale)
			obj_Particle:SetStartAlpha(mathRand(90,100))
			obj_Particle:SetEndAlpha(0)
			obj_Particle:SetGravity((VectorRand():GetNormalized() * mathRand(5,10) * self.Size) + vCached3)
			obj_Particle:SetAirResistance(200 + self.Scale * 20)
			obj_Particle:SetStartSize((5 * self.Size) - ((k / self.Particles) * self.Size * 3))
			obj_Particle:SetEndSize((20 * self.Size) - ((k / self.Particles) * self.Size))
			obj_Particle:SetRoll(mathrandom(-500,500) / 100)
			obj_Particle:SetRollDelta(mathrandom(-0.5,0.5))
			obj_Particle:SetColor(90 + Rcolor,87 + Rcolor,80 + Rcolor)
		end
	end
end

function EFFECT:Dirt()

	for i = 1,5 do

		local obj_Particle = self.eParticleEmitter:Add("effects/muzzleflash" .. mathrandom(4),self.Pos)

		if obj_Particle then
			obj_Particle:SetVelocity(self.DirVec * 100)
			obj_Particle:SetAirResistance(200)
			obj_Particle:SetDieTime(0.15)
			obj_Particle:SetStartAlpha(255)
			obj_Particle:SetEndAlpha(0)
			obj_Particle:SetStartSize(self.Scale * 300)
			obj_Particle:SetEndSize(0)
			obj_Particle:SetRoll(mathRand(180,480))
			obj_Particle:SetRollDelta(mathRand(-1,1))
			obj_Particle:SetColor(255,255,255)
		end
	end

	for i = 1,20 * self.Scale do

		local obj_Particle = self.eParticleEmitter:Add("particle/particle_composite",self.Pos)

		if obj_Particle then
			obj_Particle:SetVelocity(self.DirVec * mathrandom(100,400) * self.Scale + ((VectorRand():GetNormalized() * 300) * self.Scale))
			obj_Particle:SetDieTime(mathRand(2,3))
			obj_Particle:SetStartAlpha(230)
			obj_Particle:SetEndAlpha(0)
			obj_Particle:SetStartSize(50 * self.Scale)
			obj_Particle:SetEndSize(100 * self.Scale)
			obj_Particle:SetRoll(mathRand(150,360))
			obj_Particle:SetRollDelta(mathRand(-1,1))
			obj_Particle:SetAirResistance(150)
			obj_Particle:SetGravity(Vector(0,0,mathRand(-100,-400)))
			obj_Particle:SetColor(90,83,68)
		end
	end

	for i = 1,15 * self.Scale do

		local obj_Particle = self.eParticleEmitter:Add("particle/smokesprites_000" .. mathrandom(9),self.Pos)

		if obj_Particle then
			obj_Particle:SetVelocity(self.DirVec * mathrandom(100,400) * self.Scale + ((VectorRand():GetNormalized() * 400) * self.Scale))
			obj_Particle:SetDieTime(mathRand(1,5) * self.Scale)
			obj_Particle:SetStartAlpha(50)
			obj_Particle:SetEndAlpha(0)
			obj_Particle:SetStartSize(80 * self.Scale)
			obj_Particle:SetEndSize(100 * self.Scale)
			obj_Particle:SetRoll(mathRand(150,360))
			obj_Particle:SetRollDelta(mathRand(-1,1))
			obj_Particle:SetAirResistance(250)
			obj_Particle:SetGravity(Vector(mathRand(-200,200),mathRand(-200,200),mathRand(10,100)))
			obj_Particle:SetColor(90,83,68)
		end
	end

	for i = 1,25 * self.Scale do

		local obj_Particle = self.eParticleEmitter:Add("effects/fleck_cement" .. mathrandom(2),self.Pos)

		if obj_Particle then
			obj_Particle:SetVelocity(self.DirVec * mathrandom(0,700) * self.Scale + VectorRand():GetNormalized() * mathrandom(0,700) * self.Scale)
			obj_Particle:SetDieTime(mathrandom(2) * self.Scale)
			obj_Particle:SetStartAlpha(255)
			obj_Particle:SetEndAlpha(0)
			obj_Particle:SetStartSize(mathrandom(5,10) * self.Scale)
			obj_Particle:SetRoll(mathRand(0,360))
			obj_Particle:SetRollDelta(mathRand(-5,5))
			obj_Particle:SetAirResistance(40)
			obj_Particle:SetColor(50,53,45)
			obj_Particle:SetGravity(vCached1)
		end
	end


	local aAng = self.DirVec:Angle()

	for i = 1,self.Debris do

		aAng:RotateAroundAxis(aAng:Forward(),360 / self.Debris)

		local DustRing = aAng:Up()
		local RanVec = self.DirVec * mathRand(2,6) + (DustRing * mathRand(1,4))

		for k = 3,self.Particles do

			local Rcolor = mathrandom(-20,20)

			local obj_Particle = self.eParticleEmitter:Add("particle/smokesprites_000" .. mathrandom(9),self.Pos)

			obj_Particle:SetVelocity((VectorRand():GetNormalized() * mathRand(1,2) * self.Size) + (RanVec * self.Size * k * 3.5))
			obj_Particle:SetDieTime(mathRand(0.5,4) * self.Scale)
			obj_Particle:SetStartAlpha(mathRand(90,100))
			obj_Particle:SetEndAlpha(0)
			obj_Particle:SetGravity((VectorRand():GetNormalized() * mathRand(5,10) * self.Size) + vCached3)
			obj_Particle:SetAirResistance(200 + self.Scale * 20)
			obj_Particle:SetStartSize((5 * self.Size) - ((k / self.Particles) * self.Size * 3))
			obj_Particle:SetEndSize((20 * self.Size) - ((k / self.Particles) * self.Size))
			obj_Particle:SetRoll(mathrandom(-500,500) / 100)
			obj_Particle:SetRollDelta(mathrandom(-0.5,0.5))
			obj_Particle:SetColor(90 + Rcolor,83 + Rcolor,68 + Rcolor)
		end
	end
end

function EFFECT:Sand()

	for i = 0,45 * self.Scale do

		local obj_Particle = self.eParticleEmitter:Add("particle/smokesprites_000" .. mathrandom(9),self.Pos)

		if obj_Particle then
			obj_Particle:SetVelocity(self.DirVec * mathrandom(50,1000 * self.Scale) + VectorRand():GetNormalized() * 300 * self.Scale)
			obj_Particle:SetDieTime(mathRand(1,5) * self.Scale)
			obj_Particle:SetStartAlpha(mathRand(100,120))
			obj_Particle:SetEndAlpha(0)
			obj_Particle:SetStartSize(50 * self.Scale)
			obj_Particle:SetEndSize(120 * self.Scale)
			obj_Particle:SetRoll(mathRand(150,360))
			obj_Particle:SetRollDelta(mathRand(-1,1))
			obj_Particle:SetAirResistance(200)
			obj_Particle:SetGravity(Vector(0,0,mathRand(-100,-400)))
			obj_Particle:SetColor(90,83,68)
		end
	end

	for i = 0,20 * self.Scale do

		local obj_Particle = self.eParticleEmitter:Add("particle/particle_composite",self.Pos)

		if obj_Particle then
			obj_Particle:SetVelocity(self.DirVec * mathrandom(100,700) * self.Scale + VectorRand():GetNormalized() * 250 * self.Scale)
			obj_Particle:SetDieTime(mathRand(0.5,1,5))
			obj_Particle:SetStartAlpha(200)
			obj_Particle:SetEndAlpha(0)
			obj_Particle:SetStartSize(60 * self.Scale)
			obj_Particle:SetEndSize(90 * self.Scale)
			obj_Particle:SetRoll(mathRand(150,360))
			obj_Particle:SetRollDelta(mathRand(-1,1))
			obj_Particle:SetAirResistance(200)
			obj_Particle:SetGravity(Vector(0,0,mathRand(-100,-400)))
			obj_Particle:SetColor(90,83,68)
		end
	end

	for i = 0,25 * self.Scale do

		local obj_Particle = self.eParticleEmitter:Add("effects/fleck_cement" .. mathrandom(2),self.Pos)

		if obj_Particle then
			obj_Particle:SetVelocity(self.DirVec * mathrandom(50,900) * self.Scale + VectorRand():GetNormalized() * mathrandom(0,700) * self.Scale)
			obj_Particle:SetDieTime(mathrandom(2) * self.Scale)
			obj_Particle:SetStartAlpha(255)
			obj_Particle:SetEndAlpha(0)
			obj_Particle:SetStartSize(mathrandom(5,8) * self.Scale)
			obj_Particle:SetRoll(mathRand(0,360))
			obj_Particle:SetRollDelta(mathRand(-5,5))
			obj_Particle:SetAirResistance(40)
			obj_Particle:SetColor(53,50,45)
			obj_Particle:SetGravity(vCached1)
		end
	end

	for i = 0,25 * self.Scale do

		local Shrapnel = self.eParticleEmitter:Add("effects/fleck_cement" .. mathrandom(2),self.Pos + self.DirVec)

		if Shrapnel then
			Shrapnel:SetVelocity((self.DirVec * 700 * self.Scale) + (VectorRand():GetNormalized() * 1000 * self.Scale))
			Shrapnel:SetDieTime(mathrandom(0.3,0.5) * self.Scale)
			Shrapnel:SetStartAlpha(255)
			Shrapnel:SetEndAlpha(0)
			Shrapnel:SetStartSize(mathrandom(4,7) * self.Scale)
			Shrapnel:SetRoll(mathRand(0,360))
			Shrapnel:SetRollDelta(mathRand(-5,5))
			Shrapnel:SetAirResistance(10)
			Shrapnel:SetColor(53,50,45)
			Shrapnel:SetGravity(vCached1)
			Shrapnel:SetCollide(true)
			Shrapnel:SetBounce(0.8)
		end
	end

	for i = 1,5 do

		local obj_Particle = self.eParticleEmitter:Add("effects/muzzleflash" .. mathrandom(4),self.Pos)

		if obj_Particle then
			obj_Particle:SetVelocity(self.DirVec * 100)
			obj_Particle:SetAirResistance(200)
			obj_Particle:SetDieTime(0.10)
			obj_Particle:SetStartAlpha(255)
			obj_Particle:SetEndAlpha(0)
			obj_Particle:SetStartSize(self.Scale * 200)
			obj_Particle:SetEndSize(0)
			obj_Particle:SetRoll(mathRand(180,480))
			obj_Particle:SetRollDelta(mathRand(-1,1))
			obj_Particle:SetColor(255,255,255)
		end
	end

	for i = 0,10 * self.Scale do

		local obj_Particle = self.eParticleEmitter:Add("particle/smokesprites_000" .. mathrandom(9),self.Pos)

		if obj_Particle then
			obj_Particle:SetVelocity(self.DirVec * mathrandom(30,120 * self.Scale) + VectorRand():GetNormalized() * mathrandom(50,100 * self.Scale))
			obj_Particle:SetDieTime(mathRand(0.5,1) * self.Scale)
			obj_Particle:SetStartAlpha(mathRand(80,100))
			obj_Particle:SetEndAlpha(0)
			obj_Particle:SetStartSize(10 * self.Scale)
			obj_Particle:SetEndSize(30 * self.Scale)
			obj_Particle:SetRoll(mathRand(150,360))
			obj_Particle:SetRollDelta(mathRand(-2,2))
			obj_Particle:SetAirResistance(100)
			obj_Particle:SetGravity(Vector(mathrandom(-20,20) * self.Scale,mathrandom(-20,20) * self.Scale,250))
			obj_Particle:SetColor(90,83,68)
		end
	end

	for i = 0,5 * self.Scale do

		local obj_Particle = self.eParticleEmitter:Add("particle/smokesprites_000" .. mathrandom(9),self.Pos)

		if obj_Particle then
			obj_Particle:SetVelocity(VectorRand():GetNormalized() * mathrandom(300,600 * self.Scale))
			obj_Particle:SetDieTime(mathRand(4,10) * self.Scale / 2)
			obj_Particle:SetStartAlpha(mathRand(30,40))
			obj_Particle:SetEndAlpha(0)
			obj_Particle:SetStartSize(70 * self.Scale)
			obj_Particle:SetEndSize(100 * self.Scale)
			obj_Particle:SetRoll(mathRand(150,360))
			obj_Particle:SetRollDelta(mathRand(-2,2))
			obj_Particle:SetAirResistance(300)
			obj_Particle:SetGravity(Vector(mathrandom(-40,40) * self.Scale,mathrandom(-40,40) * self.Scale,0))
			obj_Particle:SetColor(150,150,150)
		end
	end


	local Density = 40 * self.Scale
	local aAng = self.DirVec:Angle()

	for i = 0,Density do

		aAng:RotateAroundAxis(aAng:Forward(),360 / Density)

		local ShootVector = aAng:Up()

		local obj_Particle = self.eParticleEmitter:Add("particle/smokesprites_000" .. mathrandom(9),self.Pos)

		if obj_Particle then
			obj_Particle:SetVelocity(ShootVector * mathRand(50,700 * self.Scale))
			obj_Particle:SetDieTime(mathRand(1,4) * self.Scale)
			obj_Particle:SetStartAlpha(mathRand(90,120))
			obj_Particle:SetEndAlpha(0)
			obj_Particle:SetStartSize(40 * self.Scale)
			obj_Particle:SetEndSize(70 * self.Scale)
			obj_Particle:SetRoll(mathRand(0,360))
			obj_Particle:SetRollDelta(mathRand(-1,1))
			obj_Particle:SetAirResistance(200)
			obj_Particle:SetGravity(Vector(mathRand(-200,200),mathRand(-200,200),mathRand(10,100)))
			obj_Particle:SetColor(90,83,68)
		end
	end
end

function EFFECT:Metal()

	sound.Play("Bullet.Impact",self.Pos)

	for i = 1,5 do

		local obj_Particle = self.eParticleEmitter:Add("effects/muzzleflash" .. mathrandom(4),self.Pos)

		if obj_Particle then
			obj_Particle:SetVelocity(self.DirVec * 100)
			obj_Particle:SetAirResistance(200)
			obj_Particle:SetDieTime(0.15)
			obj_Particle:SetStartAlpha(255)
			obj_Particle:SetEndAlpha(0)
			obj_Particle:SetStartSize(self.Scale * 200)
			obj_Particle:SetEndSize(0)
			obj_Particle:SetRoll(mathRand(180,480))
			obj_Particle:SetRollDelta(mathRand(-1,1))
			obj_Particle:SetColor(255,255,255)
		end
	end

	for i = 0,30 * self.Scale do

		local obj_Particle = self.eParticleEmitter:Add("particle/smokesprites_000" .. mathrandom(9),self.Pos)

		if obj_Particle then
			obj_Particle:SetVelocity(VectorRand():GetNormalized() * mathrandom(200,1000 * self.Scale))
			obj_Particle:SetDieTime(mathRand(4,10) * self.Scale / 2)
			obj_Particle:SetStartAlpha(mathRand(50,70))
			obj_Particle:SetEndAlpha(0)
			obj_Particle:SetStartSize(70 * self.Scale)
			obj_Particle:SetEndSize(100 * self.Scale)
			obj_Particle:SetRoll(mathRand(150,360))
			obj_Particle:SetRollDelta(mathRand(-2,2))
			obj_Particle:SetAirResistance(300)
			obj_Particle:SetGravity(Vector(mathrandom(-40,40) * self.Scale,mathrandom(-40,40) * self.Scale,0))
			obj_Particle:SetColor(120,120,120)
		end
	end

	for i = 0,30 * self.Scale do

		local obj_Particle = self.eParticleEmitter:Add("effects/spark",self.Pos)

		if obj_Particle then
			obj_Particle:SetVelocity(((self.DirVec * 0.75) + VectorRand()) * mathRand(200,600) * self.Scale)
			obj_Particle:SetDieTime(mathRand(0.3,1))
			obj_Particle:SetStartAlpha(255)
			obj_Particle:SetStartSize(mathRand(7,15) * self.Scale)
			obj_Particle:SetEndSize(0)
			obj_Particle:SetRoll(mathRand(0,360))
			obj_Particle:SetRollDelta(mathRand(-5,5))
			obj_Particle:SetAirResistance(20)
			obj_Particle:SetGravity(vCached1)
		end
	end

	for i = 0,10 * self.Scale do

		local obj_Particle = self.eParticleEmitter:Add("effects/yellowflare",self.Pos)

		if obj_Particle then
			obj_Particle:SetVelocity(VectorRand() * mathRand(200,600) * self.Scale)
			obj_Particle:SetDieTime(mathRand(1,1.7))
			obj_Particle:SetStartAlpha(200)
			obj_Particle:SetStartSize(mathRand(10,13) * self.Scale)
			obj_Particle:SetEndSize(0)
			obj_Particle:SetRoll(mathRand(0,360))
			obj_Particle:SetRollDelta(mathRand(-5,5))
			obj_Particle:SetAirResistance(100)
			obj_Particle:SetGravity(vCached2)
		end
	end
end

function EFFECT:obj_Particle()

	sound.Play("Bullet.Impact",self.Pos)

	for i = 1,5 do
		local obj_Particle = self.eParticleEmitter:Add("effects/muzzleflash" .. mathrandom(4),self.Pos)

		if obj_Particle then
			obj_Particle:SetVelocity(self.DirVec * 100)
			obj_Particle:SetAirResistance(200)
			obj_Particle:SetDieTime(0.15)
			obj_Particle:SetStartAlpha(255)
			obj_Particle:SetEndAlpha(0)
			obj_Particle:SetStartSize(self.Scale * 200)
			obj_Particle:SetEndSize(0)
			obj_Particle:SetRoll(mathRand(180,480))
			obj_Particle:SetRollDelta(mathRand(-1,1))
			obj_Particle:SetColor(255,255,255)
		end
	end

	for i = 0,30 * self.Scale do

		local obj_Particle = self.eParticleEmitter:Add("particle/smokesprites_000" .. mathrandom(9),self.Pos)

		if obj_Particle then
			obj_Particle:SetVelocity(VectorRand():GetNormalized() * mathrandom(200,1200 * self.Scale))
			obj_Particle:SetDieTime(mathRand(4,10) * self.Scale / 2)
			obj_Particle:SetStartAlpha(mathRand(35,50))
			obj_Particle:SetEndAlpha(0)
			obj_Particle:SetStartSize(70 * self.Scale)
			obj_Particle:SetEndSize(100 * self.Scale)
			obj_Particle:SetRoll(mathRand(150,360))
			obj_Particle:SetRollDelta(mathRand(-2,2))
			obj_Particle:SetAirResistance(300)
			obj_Particle:SetGravity(Vector(mathrandom(-40,40) * self.Scale,mathrandom(-40,40) * self.Scale,0))
			obj_Particle:SetColor(120,120,120)
		end
	end

	for i = 1,25 * self.Scale do

		local obj_Particle = self.eParticleEmitter:Add("effects/fleck_tile" .. mathrandom(2),self.Pos)

		if obj_Particle then
			obj_Particle:SetVelocity(self.DirVec * mathrandom(100,600) * self.Scale + VectorRand():GetNormalized() * mathrandom(100,1200) * self.Scale)
			obj_Particle:SetDieTime(mathrandom(3) * self.Scale)
			obj_Particle:SetStartAlpha(255)
			obj_Particle:SetEndAlpha(0)
			obj_Particle:SetStartSize(mathrandom(5,10) * self.Scale)
			obj_Particle:SetRoll(mathRand(0,360))
			obj_Particle:SetRollDelta(mathRand(-5,5))
			obj_Particle:SetAirResistance(40)
			obj_Particle:SetColor(70,70,70)
			obj_Particle:SetGravity(vCached1)
		end
	end


	local aAng = self.DirVec:Angle()

	for i = 1,self.Debris do

		aAng:RotateAroundAxis(aAng:Forward(),360 / self.Debris)

		local DustRing = aAng:Up()
		local RanVec = self.DirVec * mathRand(1,4) + (DustRing * mathRand(3,4))

		for k = 3,self.Particles do

			local Rcolor = mathrandom(-20,20)

			local obj_Particle = self.eParticleEmitter:Add("particle/smokesprites_000" .. mathrandom(9),self.Pos)

			obj_Particle:SetVelocity((VectorRand():GetNormalized() * mathRand(1,2) * self.Size) + (RanVec * self.Size * k * 3.5))
			obj_Particle:SetDieTime(mathRand(0,3) * self.Scale)
			obj_Particle:SetStartAlpha(mathRand(90,100))
			obj_Particle:SetEndAlpha(0)
			obj_Particle:SetGravity((VectorRand():GetNormalized() * mathRand(5,10) * self.Size) + vCached3)
			obj_Particle:SetAirResistance(200 + self.Scale * 20)
			obj_Particle:SetStartSize((5 * self.Size) - ((k / self.Particles) * self.Size * 3))
			obj_Particle:SetEndSize((20 * self.Size) - ((k / self.Particles) * self.Size))
			obj_Particle:SetRoll(mathrandom(-500,500) / 100)
			obj_Particle:SetRollDelta(mathrandom(-0.5,0.5))
			obj_Particle:SetColor(90 + Rcolor,85 + Rcolor,75 + Rcolor)
		end
	end
end

function EFFECT:Wood()

	for i = 1,5 do

		local obj_Particle = self.eParticleEmitter:Add("effects/muzzleflash" .. mathrandom(4),self.Pos)

		if obj_Particle then
			obj_Particle:SetVelocity(self.DirVec * 100)
			obj_Particle:SetAirResistance(200)
			obj_Particle:SetDieTime(0.15)
			obj_Particle:SetStartAlpha(255)
			obj_Particle:SetEndAlpha(0)
			obj_Particle:SetStartSize(self.Scale * 200)
			obj_Particle:SetEndSize(0)
			obj_Particle:SetRoll(mathRand(180,480))
			obj_Particle:SetRollDelta(mathRand(-1,1))
			obj_Particle:SetColor(255,255,255)
		end
	end

	for i = 0,30 * self.Scale do

		local obj_Particle = self.eParticleEmitter:Add("particle/smokesprites_000" .. mathrandom(9),self.Pos)

		if obj_Particle then
			obj_Particle:SetVelocity(VectorRand():GetNormalized() * mathrandom(200,1000) * self.Scale)
			obj_Particle:SetDieTime(mathRand(4,10) * self.Scale / 2)
			obj_Particle:SetStartAlpha(mathRand(70,90))
			obj_Particle:SetEndAlpha(0)
			obj_Particle:SetStartSize(70 * self.Scale)
			obj_Particle:SetEndSize(100 * self.Scale)
			obj_Particle:SetRoll(mathRand(150,360))
			obj_Particle:SetRollDelta(mathRand(-2,2))
			obj_Particle:SetAirResistance(300)
			obj_Particle:SetGravity(Vector(mathrandom(-40,40) * self.Scale,mathrandom(-40,40) * self.Scale,0))
			obj_Particle:SetColor(90,85,75)
		end
	end

	for i = 0,20 * self.Scale do

		local obj_Particle = self.eParticleEmitter:Add("effects/fleck_wood" .. mathrandom(2),self.Pos + self.DirVec)

		if obj_Particle then
			obj_Particle:SetVelocity(self.DirVec * mathrandom(50,500) * self.Scale + VectorRand():GetNormalized() * mathrandom(200,900) * self.Scale)
			obj_Particle:SetDieTime(mathrandom(0.75,2))
			obj_Particle:SetStartAlpha(255)
			obj_Particle:SetEndAlpha(0)
			obj_Particle:SetStartSize(mathrandom(10,15) * self.Scale)
			obj_Particle:SetRoll(mathRand(0,360))
			obj_Particle:SetRollDelta(mathRand(-5,5))
			obj_Particle:SetAirResistance(70)
			obj_Particle:SetColor(90,85,75)
			obj_Particle:SetGravity(vCached1)
		end
	end
end

function EFFECT:Glass()

	for i = 1,5 do

		local obj_Particle = self.eParticleEmitter:Add("effects/muzzleflash" .. mathrandom(4),self.Pos)

		if obj_Particle then
			obj_Particle:SetVelocity(self.DirVec * 100)
			obj_Particle:SetAirResistance(200)
			obj_Particle:SetDieTime(0.15)
			obj_Particle:SetStartAlpha(255)
			obj_Particle:SetEndAlpha(0)
			obj_Particle:SetStartSize(self.Scale * 200)
			obj_Particle:SetEndSize(0)
			obj_Particle:SetRoll(mathRand(180,480))
			obj_Particle:SetRollDelta(mathRand(-1,1))
			obj_Particle:SetColor(255,255,255)
		end
	end

	for i = 0,30 * self.Scale do

		local obj_Particle = self.eParticleEmitter:Add("effects/fleck_glass" .. mathrandom(3),self.Pos)

		if obj_Particle then
			obj_Particle:SetVelocity(VectorRand():GetNormalized() * mathrandom(100,600) * self.Scale)
			obj_Particle:SetDieTime(mathrandom(2.5))
			obj_Particle:SetStartAlpha(255)
			obj_Particle:SetEndAlpha(0)
			obj_Particle:SetStartSize(mathrandom(3,7) * self.Scale)
			obj_Particle:SetRoll(mathRand(0,360))
			obj_Particle:SetRollDelta(mathRand(-15,15))
			obj_Particle:SetAirResistance(50)
			obj_Particle:SetColor(200,200,200)
			obj_Particle:SetGravity(vCached1)
			obj_Particle:SetCollide(true)
			obj_Particle:SetBounce(0.5)
		end
	end

	for i = 0,30 * self.Scale do

		local obj_Particle = self.eParticleEmitter:Add("particle/smokesprites_000" .. mathrandom(9),self.Pos)

		if obj_Particle then
			obj_Particle:SetVelocity(VectorRand():GetNormalized() * mathrandom(200,800 * self.Scale))
			obj_Particle:SetDieTime(mathRand(4,10) * self.Scale / 2)
			obj_Particle:SetStartAlpha(mathRand(35,50))
			obj_Particle:SetEndAlpha(0)
			obj_Particle:SetStartSize(70 * self.Scale)
			obj_Particle:SetEndSize(100 * self.Scale)
			obj_Particle:SetRoll(mathRand(150,360))
			obj_Particle:SetRollDelta(mathRand(-2,2))
			obj_Particle:SetAirResistance(300)
			obj_Particle:SetGravity(Vector(mathrandom(-40,40) * self.Scale,mathrandom(-40,40) * self.Scale,0))
			obj_Particle:SetColor(150,150,150)
		end
	end
end

function EFFECT:Blood()

	for i = 0,30 * self.Scale do

		local obj_Particle = self.eParticleEmitter:Add("particle/particle_composite",self.Pos)

		if obj_Particle then
			obj_Particle:SetVelocity(VectorRand():GetNormalized() * mathrandom(100,600) * self.Scale)
			obj_Particle:SetDieTime(mathRand(1,2))
			obj_Particle:SetStartAlpha(80)
			obj_Particle:SetEndAlpha(0)
			obj_Particle:SetStartSize(30 * self.Scale)
			obj_Particle:SetEndSize(100 * self.Scale)
			obj_Particle:SetRoll(mathRand(150,360))
			obj_Particle:SetRollDelta(mathRand(-2,2))
			obj_Particle:SetAirResistance(400)
			obj_Particle:SetGravity(Vector(mathRand(-50,50) * self.Scale,mathRand(-50,50) * self.Scale,mathRand(0,-200)))
			obj_Particle:SetColor(70,35,35)
		end
	end

	for i = 0,20 * self.Scale do

		local obj_Particle = self.eParticleEmitter:Add("particle/smokesprites_000" .. mathrandom(9),self.Pos)

		if obj_Particle then
			obj_Particle:SetVelocity(VectorRand():GetNormalized() * mathrandom(200,600) * self.Scale)
			obj_Particle:SetDieTime(mathRand(1,4))
			obj_Particle:SetStartAlpha(120)
			obj_Particle:SetEndAlpha(0)
			obj_Particle:SetStartSize(30 * self.Scale)
			obj_Particle:SetEndSize(100 * self.Scale)
			obj_Particle:SetRoll(mathRand(150,360))
			obj_Particle:SetRollDelta(mathRand(-2,2))
			obj_Particle:SetAirResistance(400)
			obj_Particle:SetGravity(Vector(mathRand(-50,50) * self.Scale,mathRand(-50,50) * self.Scale,mathRand(-50,-300)))
			obj_Particle:SetColor(70,35,35)
		end
	end

	for i = 1,5 do

		local obj_Particle = self.eParticleEmitter:Add("effects/muzzleflash" .. mathrandom(4),self.Pos)

		if obj_Particle then
			obj_Particle:SetVelocity(self.DirVec * 100)
			obj_Particle:SetAirResistance(200)
			obj_Particle:SetDieTime(0.15)
			obj_Particle:SetStartAlpha(255)
			obj_Particle:SetEndAlpha(0)
			obj_Particle:SetStartSize(self.Scale * 300)
			obj_Particle:SetEndSize(0)
			obj_Particle:SetRoll(mathRand(180,480))
			obj_Particle:SetRollDelta(mathRand(-1,1))
			obj_Particle:SetColor(255,255,255)
		end
	end

	for i = 1,20 * self.Scale do

		local obj_Particle = self.eParticleEmitter:Add("effects/fleck_cement" .. mathrandom(2),self.Pos - (self.DirVec * 5))

		if obj_Particle then
			obj_Particle:SetVelocity(VectorRand():GetNormalized() * 400 * self.Scale)
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
end

function EFFECT:YellowBlood()

	for i = 0,30 * self.Scale do

		local obj_Particle = self.eParticleEmitter:Add("particle/particle_composite",self.Pos)

		if obj_Particle then
			obj_Particle:SetVelocity(VectorRand():GetNormalized() * mathrandom(100,600) * self.Scale)
			obj_Particle:SetDieTime(mathRand(1,2))
			obj_Particle:SetStartAlpha(80)
			obj_Particle:SetEndAlpha(0)
			obj_Particle:SetStartSize(30 * self.Scale)
			obj_Particle:SetEndSize(100 * self.Scale)
			obj_Particle:SetRoll(mathRand(150,360))
			obj_Particle:SetRollDelta(mathRand(-2,2))
			obj_Particle:SetAirResistance(400)
			obj_Particle:SetGravity(Vector(mathRand(-50,50) * self.Scale,mathRand(-50,50) * self.Scale,mathRand(0,-200)))
			obj_Particle:SetColor(120,120,0)
		end
	end

	for i = 0,20 * self.Scale do

		local obj_Particle = self.eParticleEmitter:Add("particle/smokesprites_000" .. mathrandom(9),self.Pos)

		if obj_Particle then
			obj_Particle:SetVelocity(VectorRand():GetNormalized() * mathrandom(200,600) * self.Scale)
			obj_Particle:SetDieTime(mathRand(1,4))
			obj_Particle:SetStartAlpha(120)
			obj_Particle:SetEndAlpha(0)
			obj_Particle:SetStartSize(30 * self.Scale)
			obj_Particle:SetEndSize(100 * self.Scale)
			obj_Particle:SetRoll(mathRand(150,360))
			obj_Particle:SetRollDelta(mathRand(-2,2))
			obj_Particle:SetAirResistance(400)
			obj_Particle:SetGravity(Vector(mathRand(-50,50) * self.Scale,mathRand(-50,50) * self.Scale,mathRand(-50,-300)))
			obj_Particle:SetColor(120,120,0)
		end
	end

	for i = 1,5 do

		local obj_Particle = self.eParticleEmitter:Add("effects/muzzleflash" .. mathrandom(4),self.Pos)

		if obj_Particle then
			obj_Particle:SetVelocity(self.DirVec * 100)
			obj_Particle:SetAirResistance(200)
			obj_Particle:SetDieTime(0.15)
			obj_Particle:SetStartAlpha(255)
			obj_Particle:SetEndAlpha(0)
			obj_Particle:SetStartSize(self.Scale * 300)
			obj_Particle:SetEndSize(0)
			obj_Particle:SetRoll(mathRand(180,480))
			obj_Particle:SetRollDelta(mathRand(-1,1))
			obj_Particle:SetColor(255,255,255)
		end
	end

	for i = 1,20 * self.Scale do

		local obj_Particle = self.eParticleEmitter:Add("effects/fleck_cement" .. mathrandom(2),self.Pos - (self.DirVec * 5))

		if obj_Particle then
			obj_Particle:SetVelocity(VectorRand():GetNormalized() * 400 * self.Scale)
			obj_Particle:SetDieTime(mathrandom(0.3,0.6))
			obj_Particle:SetStartAlpha(255)
			obj_Particle:SetEndAlpha(0)
			obj_Particle:SetStartSize(8)
			obj_Particle:SetEndSize(9)
			obj_Particle:SetRoll(mathRand(0,360))
			obj_Particle:SetRollDelta(mathRand(-5,5))
			obj_Particle:SetAirResistance(30)
			obj_Particle:SetColor(120,120,0)
			obj_Particle:SetGravity(vCached1)
			obj_Particle:SetCollide(true)
			obj_Particle:SetBounce(0.2)
		end
	end
end


function EFFECT:Think()
	return false
end


function EFFECT:Render()

end