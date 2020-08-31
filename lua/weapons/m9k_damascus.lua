SWEP.Base = "meteors_grenade_base_model" -- We use this as a base since its actually a good melee base but it also allows custom models
SWEP.Category = "M9K Specialties"
SWEP.PrintName = "Damascus"

SWEP.Slot = 0
SWEP.HoldType = "melee2"
SWEP.Spawnable = true
SWEP.UseHands = true

SWEP.ViewModelFOV = 55
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_dmascus.mdl"
SWEP.WorldModel = "models/weapons/w_damascus_sword.mdl"

SWEP.DoNotUseViewModel = true -- We tell the base to draw the default viewmodel (Needs to be set to true)
SWEP.DoNotUseWorldModel = true -- We tell the base to draw the default worldmodel (Needs to be set to true)
SWEP.DeploySound = "weapons/knife/knife_draw_x.mp3"

local damageInfo = DamageInfo()

function SWEP:PrimaryAttack() -- Stabby stab stab
	if self:CanPrimaryAttack() and self:GetNextPrimaryFire() < CurTime() then
		self:SetNextPrimaryFire(CurTime() + 0.4)

		timer.Remove("M9k_MMM_Grenade_Grenadethrow" .. self.OurIndex) -- Prevent the animation from being overwritten by the idle thing

		self:AttackAnimation()

		local vm = self.Owner:GetViewModel() -- We want to play the idle animation after we are done attacking!
		if SERVER or IsValid(vm) then -- The user attacking
			if not IsFirstTimePredicted() then return end -- Fixes weird prediction bugs.

			vm:ResetSequence(self.SlashAnim and "midslash2" or "midslash1") -- This is how you do efficient flip-flops in Lua
			self.SlashAnim = not self.SlashAnim

			local Dur = vm:SequenceDuration()

			timer.Create("M9k_MMM_Grenade_Grenadethrow" .. self.OurIndex,0.1,1,function() -- Attack damage is delayed!
				if SERVER then
					local Pos = self.Owner:EyePos()
					local tTrace = util.TraceHull({
						start = Pos,
						endpos = Pos + self.Owner:EyeAngles():Forward() * 115,
						filter = {self,self.Owner}
					})

					if tTrace.Hit then
						--local eyeTrace = self.Owner:GetEyeTrace()

						damageInfo:SetDamageType(DMG_SLASH)
						damageInfo:SetAttacker(self.Owner)
						damageInfo:SetInflictor(self)
						damageInfo:SetDamage(45 + math.random(-5,5))

						if IsValid(tTrace.Entity) and (tTrace.Entity:IsPlayer() or tTrace.Entity:IsNPC() or tTrace.Entity:GetClass() == "prop_ragdoll") then
							self:EmitSound(Brutal and "weapons/blades/nastystab.mp3" or "weapons/blades/slash.mp3")

							damageInfo:SetDamageForce(tTrace.Normal * (tTrace.Entity:GetClass() == "prop_ragdoll" and 100 or 25000))
							tTrace.Entity:TakeDamageInfo(damageInfo)

							-- util.Decal("Blood",eyeTrace.HitPos + eyeTrace.HitNormal,eyeTrace.HitPos - eyeTrace.HitNormal,self.Owner) -- Buggy
						elseif IsValid(tTrace.Entity) or tTrace.HitWorld then
							self:EmitSound("weapons/blades/hitwall.mp3")

							if not tTrace.HitWorld then
								damageInfo:SetDamageForce(tTrace.Normal * 100)
								tTrace.Entity:TakeDamageInfo(damageInfo)
							end

							local eyeTrace = self.Owner:GetEyeTrace() -- Comment this out when fixing player blood decals
							util.Decal("Impact.Concrete",eyeTrace.HitPos + eyeTrace.HitNormal,eyeTrace.HitPos - eyeTrace.HitNormal,self.Owner)
						end
					else
						self:EmitSound("weapons/blades/woosh.mp3")
					end
				end

				timer.Create("M9k_MMM_Grenade_Grenadethrow" .. self.OurIndex,Dur - 0.1,1,function() -- We use this timer since it gets removed on Holster etc
					if not IsValid(self) or not IsValid(self.Owner) or not IsValid(self.Owner:GetActiveWeapon()) or self.Owner:GetActiveWeapon():GetClass() ~= self:GetClass() then return end
					self:SendWeaponAnim(ACT_VM_IDLE)
				end)
			end)
		end
	end
end