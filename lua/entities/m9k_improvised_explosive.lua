AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "IED"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.DoNotDuplicate = true
ENT.DisableDuplicator = true


local fReturnFalse = function() -- Save some ram
	return false
end

ENT.CanTool = fReturnFalse -- Restrict certain things
ENT.CanProperty = fReturnFalse
ENT.PhysgunPickup = fReturnFalse


if SERVER then

	local vCached1 = Vector(0,0,1)
	local vCached2 = Vector(0,0,-1)


	ENT.GravGunPickupAllowed = fReturnFalse -- This is Serverside only


	function ENT:Initialize()

		if not self.M9kr_CreatedByWeapon then -- Prevents exploiting it
			self:Remove()

			return
		end

		self:PhysicsInit(SOLID_VPHYSICS)

	end


	function ENT:Explosion(bTiny)
		if not IsValid(self) then return end

		if not IsValid(self.IEDOwner) then
			self:Remove()

			return
		end


		local vPos = self:GetPos()


		local obj_EffectData = EffectData()
		obj_EffectData:SetOrigin(vPos)
		obj_EffectData:SetNormal(vCached1)
		obj_EffectData:SetEntity(self)
		obj_EffectData:SetScale(1)
		obj_EffectData:SetRadius(67)
		obj_EffectData:SetMagnitude(18)

		util.Effect("m9k_gdcw_tpaboom",obj_EffectData,true,true)
		util.Effect("HelicopterMegaBomb",obj_EffectData,true,true)
		util.Effect("ThumperDust",obj_EffectData,true,true)


		if not bTiny then

			util.BlastDamage(self,self.IEDOwner,vPos,500,170)
			util.ScreenShake(vPos,3000,255,2.25,2000)

		else

			util.BlastDamage(self,self.IEDOwner,vPos,100,60)
			util.ScreenShake(vPos,1500,255,2.25,800)

		end


		self:EmitSound("ambient/explosions/explode_" .. math.random(4) .. ".wav")


		if not bTiny then
			util.Decal("Scorch",vPos + (vCached1 * 5),vPos + (vCached2 * 5))
		end


		self:Remove()

	end


	function ENT:OnTakeDamage(obj_DamageInfo)

		local eInflictor = obj_DamageInfo:GetInflictor()

		if not IsValid(eInflictor) then -- Fallback
			eInflictor = obj_DamageInfo:GetAttacker()
		end


		if eInflictor ~= self and eInflictor:GetClass() ~= self:GetClass() then


			local iLuck = math.random(10) -- Hideous.

			if iLuck == 1 then

				self:Explosion()

			elseif iLuck == 5 then

				self:Explosion(true)

			end
		end
	end
end


if CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end
end