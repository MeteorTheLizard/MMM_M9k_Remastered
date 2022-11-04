SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9kR: Specialties"
SWEP.PrintName = "Proximity Mine"

SWEP.Slot = 4
SWEP.HoldType = "slam"
SWEP.Spawnable = true

SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_px.mdl"
SWEP.WorldModel = "models/weapons/w_px.mdl"

SWEP.Primary.RPM = 15
SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "ProxMine"

SWEP.bBlockMuzzleFlash = true
SWEP.bBlockShellEject = true
SWEP.CanFireUnderwater = true

SWEP._UsesCustomModels = true


if SERVER then

	local sTag = "MMM_M9kr_Proximity_Mines"

	local aCached1 = Angle(90,180,0)


	function SWEP:PrimaryAttack()

		if not IsValid(self.Owner) or not self:CanPrimaryAttack() then return end -- If somehow an NPC got it on their hands or similar.. this will cause huge problems! // They can't attack yet!


		local vm = self.Owner:GetViewModel()
		if not IsValid(vm) then return end


		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)


		local iDur = vm:SequenceDuration()

		self:SetNextPrimaryFire(CurTime() + iDur + 0.1)


		timer.Create(sTag .. self:EntIndex(),iDur,1,function()

			if not IsValid(self) or not IsValid(self.Owner) or not self.Owner:Alive() or not IsValid(self.Owner:GetActiveWeapon()) or self.Owner:GetActiveWeapon():GetClass() ~= self:GetClass() then return end -- Monster.


			self:SetNextPrimaryFire(CurTime() + 1.25) -- Again!


			local tTrace = util.TraceLine({
				start = self.Owner:GetShootPos(),
				endpos = self.Owner:GetShootPos() + 100 * self.Owner:GetAimVector(),
				filter = self.Owner
			})


			local eProxy = ents.Create("m9k_proxy")
			if not IsValid(eProxy) then return end

				--SafeRemoveEntityDelayed(eProxy,300) -- 5 Minutes should be enough, right?


			eProxy:SetPos(tTrace.HitPos + tTrace.HitNormal)


			tTrace.HitNormal.z = -tTrace.HitNormal.z
			eProxy:SetAngles(tTrace.HitNormal:Angle() - aCached1)


			eProxy:SetOwner(self.Owner)

			if MMM_M9k_CPPIExists then
				eProxy:CPPISetOwner(self.Owner)
			end

			eProxy.M9kr_CreatedByWeapon = true -- Required
			eProxy:SetNWBool("M9kR_Created",true) -- Mark it for Clients.

			eProxy:Spawn()

			eProxy:SetMoveType(MOVETYPE_NONE)


			if self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0 then

				self.Owner:StripWeapon("m9k_proxy_mine")

			else

				self.Owner:RemoveAmmo(1,self.Primary.Ammo)
				self:SetClip1(1)

				self:SendWeaponAnim(ACT_VM_DRAW)

			end


			if not tTrace.Hit then
				eProxy:SetMoveType(MOVETYPE_VPHYSICS)

				eProxy.DynamicPos = true
			end
		end)
	end


	function SWEP:HolsterHooked() -- Remove when empty // Reload clip when possible.

		if self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0 and self:Clip1() <= 0 then -- Just dump it.
			self:Remove()

			return
		end


		local iClip = self:Clip1()

		if iClip < self.Primary.ClipSize then -- Refill magazine, make the holster act like a reload.

			local iReserve = self.Owner:GetAmmoCount(self.Primary.Ammo)

			self:SetClip1(iReserve + iClip >= self.Primary.ClipSize and self.Primary.ClipSize or (iReserve + iClip))
			self.Owner:RemoveAmmo(self.Primary.ClipSize - iClip,self.Primary.Ammo)

		end
	end


	function SWEP:ResetInternalVarsHooked()
		timer.Remove(sTag .. self:EntIndex())
	end
end


if CLIENT then
	function SWEP:PrimaryAttack()

	end
end


-- SHARED --

function SWEP:IronSight()

end

function SWEP:Reload()

end