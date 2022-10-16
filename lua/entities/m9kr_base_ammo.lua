AddCSLuaFile()

ENT.Type			= "anim"
ENT.Base			= "base_anim"
ENT.Category		= "M9kR: Ammunition"
ENT.Spawnable		= false
ENT.AdminOnly		= false

ENT.AmmoClass		= ""
ENT.AmmoModel		= ""
ENT.AmmoCount		= 1
ENT.ImpactSound		= ""

ENT.bDrawText		= false
ENT.bDropOnDestroy	= false
ENT.bExplOnDestroy	= false

ENT.Text 			= ""
ENT.TextPos			= Vector(0,0,0)
ENT.TextColor		= Color(255,255,255)
ENT.TextScale		= 1

ENT.OffsetUp		= 1
ENT.OffsetRight		= 1
ENT.OffsetForward	= 1


if SERVER then

	ENT.iHealth = 100


	local SOLID_VPHYSICS = SOLID_VPHYSICS
	local SIMPLE_USE = SIMPLE_USE


	local vCached1 = Vector(0,0,10)


	local fExplode = function(self)

		if not self.bCanSplode or (not self.bDropOnDestroy and not self.bExplOnDestroy) then return end


		if not self.bSploded and self.iHealth <= 0 then

			self.bSploded = true -- Safeguard since BlastDamage causes an infinite loop otherwise


			timer.Simple(math.Rand(0,0.1),function() -- Makes it lag less when there's multiple boxes exploding at once

				local vPos = self:GetPos()

				self:EmitSound("physics/wood/wood_plank_break" .. math.random(2,4) .. ".wav")


				if self.bDropOnDestroy and self.DropClass then

					for I = 1,(self.AmmoCount or 5) do


						local eDropped = ents.Create(self.DropClass)

						timer.Simple(10,function() -- We cannot use SafeRemoveEntityDelayed as it would otherwise delete the weapon a player is holding
							if IsValid(eDropped) and not IsValid(eDropped.Owner) then
								eDropped:Remove()
							end
						end)


						if eDropped then

							eDropped:SetMaterial(self.sDropMat and self.sDropMat or "")
							eDropped:SetPos(vPos + VectorRand(3))
							eDropped:SetAngles(AngleRand())
							eDropped:Spawn()

							eDropped:SetCollisionGroup(COLLISION_GROUP_DEBRIS)


							if MMM_M9k_CPPIExists and IsValid(self.Owner) then
								eDropped:CPPISetOwner(self.Owner)
							end


							local obj_Phys = eDropped:GetPhysicsObject()

							if IsValid(obj_Phys) then
								obj_Phys:SetVelocity(VectorRand(-75,75))
								obj_Phys:AddAngleVelocity(VectorRand(-100,100))
							end
						end
					end

				elseif self.bExplOnDestroy then

					util.BlastDamage(self,self.Owner,vPos,600,150)


					local obj_EffectData = EffectData()
					obj_EffectData:SetMagnitude(18)
					obj_EffectData:SetScale(1.3)
					obj_EffectData:SetOrigin(vPos)
					obj_EffectData:SetRadius(1)

					util.Effect("m9k_gdcw_tpaboom",obj_EffectData)


					util.ScreenShake(vPos,10,5,1,3000)
					util.Decal("Scorch",vPos + vCached1,vPos - vCached1,self)

				end


				self:Remove()

			end)
		end
	end


	function ENT:Initialize()

		self:SetModel(self.AmmoModel)


		self:PhysicsInit(SOLID_VPHYSICS)
		self:PhysWake()


		self:SetUseType(SIMPLE_USE)


		timer.Simple(0,function() -- Position it properly on the floor
			if not IsValid(self) then return end

			self:SetPos(self:GetPos() + vCached1)
			self:DropToFloor()
		end)


		self.Owner = self:GetCreator()

		if IsValid(self.Owner) then -- We NEED to have an owner, otherwise we cannot 'splode
			self.bCanSplode = true
		end


		if self.InitializeHooked then
			self:InitializeHooked()
		end
	end


	function ENT:PhysicsCollide(obj_Data)

		if obj_Data.Speed > 80 and obj_Data.DeltaTime > 0.2 then

			self:EmitSound(self.ImpactSound)

			if obj_Data.Speed > 350 then
				self.iHealth = (self.iHealth - math.Clamp(obj_Data.Speed / 20,0,100))

				fExplode(self) -- Check if we should 'splode
			end
		end
	end


	function ENT:Use(eActivator)
		if eActivator:IsPlayer() then

			if self.AmmoWeapon and eActivator:GetWeapon(self.AmmoWeapon) == NULL then

				eActivator:GiveAmmo(self.AmmoCount - 1,self.AmmoClass) -- The Weapon itself already has 1 ammo, so we deduct one.

				eActivator:Give(self.AmmoWeapon)
				eActivator:SelectWeapon(self.AmmoWeapon)

			else

				eActivator:GiveAmmo(self.AmmoCount,self.AmmoClass)

			end


			self:Remove()

		end
	end


	function ENT:OnTakeDamage(obj_DamageInfo)
		local iDamage = obj_DamageInfo:GetDamage()

		if isnumber(iDamage) then
			self.iHealth = self.iHealth - iDamage

			fExplode(self) -- Check if we should 'splode
		end
	end
end


if CLIENT then

	local drawSimpleText = draw.SimpleText
	local camStart3D2D = cam.Start3D2D
	local camEnd3D2D = cam.End3D2D


	function ENT:Initialize()
		self:SetModel(self.AmmoModel)
	end


	function ENT:Draw()

		self:DrawModel()

		if self.bDrawText then

			local aAng = self:GetAngles()
				aAng:RotateAroundAxis(aAng:Right(),self.TextPos.x)
				aAng:RotateAroundAxis(aAng:Up(),self.TextPos.y)
				aAng:RotateAroundAxis(aAng:Forward(),self.TextPos.z)


			camStart3D2D(self:GetPos() + (self:GetUp() * self.OffsetUp) + (self:GetRight() * self.OffsetRight) + (self:GetForward() * self.OffsetForward),aAng,self.TextScale)
				drawSimpleText(self.Text,"DermaLarge",0,0,self.TextColor,1,1)
			camEnd3D2D()

		end
	end
end