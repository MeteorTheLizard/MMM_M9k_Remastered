AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Proximity mine"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.DoNotDuplicate = true
ENT.DisableDuplicator = true

if SERVER then
	local effectdataBase = EffectData()
	local effectdata = EffectData()
	effectdata:SetScale(1)
	effectdata:SetRadius(67)
	effectdata:SetMagnitude(18)

	function ENT:Initialize()
		self:SetModel("models/weapons/w_px_planted.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		self:PhysWake()
		self.timeleft = CurTime() + 3
		self.OurPos = self:GetPos()
		self.health = 25
		self.Tr = {
			start = self.OurPos,
			endpos = self.OurPos,
			filter = self
		}
	end

	function ENT:Think()
		if self.timeleft < CurTime() then
			for _,v in ipairs(ents.FindInSphere(self.OurPos,200)) do
				if v:IsPlayer() or v:IsNPC() then
					self.Tr.endpos = v:GetPos()
					local Trace = util.TraceLine(self.Tr)

					if Trace.Entity:IsPlayer() or Trace.Entity:IsNPC() then
						self:Explosion()
					end
				end
			end
		end

		self:NextThink(CurTime() + 0.3)
		return true
	end

	function ENT:Explosion()
		if not IsValid(self.Owner) then
			self:Remove()
			return
		end

		self.Explosion = nil -- Do not call this twice.. ever
		self.OnTakeDamage = nil -- Stack overflow protection.

		effectdataBase:SetOrigin(self.OurPos)
		util.Effect("HelicopterMegaBomb",effectdataBase)
		util.Effect("ThumperDust",effectdataBase)
		util.Effect("Explosion",effectdataBase)
		effectdata:SetOrigin(self.OurPos)
		effectdata:SetEntity(self)
		util.Effect("m9k_gdcw_cinematicboom",effectdata)
		util.BlastDamage(self,self.Owner,self.OurPos,200,250)
		util.ScreenShake(self.OurPos,2000,255,2.5,1250)
		self:EmitSound("ambient/explosions/explode_" .. math.random(1,4) .. ".wav",self.Pos,100,100)
		self:Remove()
	end

	function ENT:OnTakeDamage(DMG)
		self.health = self.health - DMG:GetDamage() or 25

		if self.health <= 0 then
			self:Explosion()
		end
	end

	function ENT:PhysgunPickup()
		return false
	end

	function ENT:CanTool()
		return false
	end
end