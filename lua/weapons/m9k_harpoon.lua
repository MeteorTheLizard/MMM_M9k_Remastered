SWEP.Base = "meteors_grenade_base_model_instant"
SWEP.Category = "M9K Specialties"
SWEP.PrintName = "Harpoon"

SWEP.Slot = 0
SWEP.HoldType = "melee"
SWEP.Spawnable = true
SWEP.UseHands = true

SWEP.ViewModelFOV = 55
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/cstrike/c_knife_t.mdl" -- Does not require any game apart from Garry's Mod even though it is from CS:S
SWEP.WorldModel = "models/props_junk/harpoon002a.mdl" -- We make our own since the original is horrible

SWEP.Primary.Ammo = "Harpoon"

SWEP.WorldModelScale = Vector(1,1,1)
SWEP.ModelWorldForwardMult = 3.25
SWEP.ModelWorldRightMult = 2
SWEP.ModelWorldUpMult = 0
SWEP.ModelWorldAngForward = 20
SWEP.ModelWorldAngRight = -20
SWEP.ModelWorldAngUp = -95

SWEP.ViewModelScale = Vector(0.6,0.6,0.6)
SWEP.ModelViewForwardMult = -3.6
SWEP.ModelViewRightMult = 2.65
SWEP.ModelViewUpMult = 7.5
SWEP.ModelViewAngForward = -60
SWEP.ModelViewAngRight = -25
SWEP.ModelViewAngUp = 50
SWEP.ModelViewBlacklistedBones = {
	["v_weapon.Knife_Handle"] = true,
	["v_weapon.Right_Arm"] = true
}

local damageInfo = DamageInfo()

function SWEP:PrimaryAttack() -- Stabby stab stab
	if self:CanPrimaryAttack() and self:GetNextPrimaryFire() < CurTime() then
		self:SetNextPrimaryFire(CurTime() + 1)

		timer.Remove("M9k_MMM_Grenade_Grenadethrow" .. self.OurIndex) -- Prevent the animation from being overwritten by the idle thing

		self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
		self:AttackAnimation()

		local vm = self.Owner:GetViewModel() -- We want to play the idle animation after we are done attacking!
		if SERVER or IsValid(vm) then -- The user attacking
			if not IsFirstTimePredicted() then return end -- Fixes weird prediction bugs.
			local Dur = vm:SequenceDuration()

			timer.Create("M9k_MMM_Grenade_Grenadethrow" .. self.OurIndex,0.1,1,function() -- Attack damage is delayed!

				if SERVER then
					local Pos = self.Owner:EyePos()
					local tTrace = util.TraceHull({
						start = Pos,
						endpos = Pos + self.Owner:EyeAngles():Forward() * 100,
						filter = {self,self.Owner}
					})

					if tTrace.Hit then
						--local eyeTrace = self.Owner:GetEyeTrace()

						damageInfo:SetDamageType(DMG_SLASH)
						damageInfo:SetAttacker(self.Owner)
						damageInfo:SetInflictor(self)
						damageInfo:SetDamage(30 + math.random(-5,5))

						if IsValid(tTrace.Entity) and (tTrace.Entity:IsPlayer() or tTrace.Entity:IsNPC() or tTrace.Entity:GetClass() == "prop_ragdoll") then
							self:EmitSound("weapons/blades/nastystab.mp3")

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
						self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav")
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

function SWEP:SecondaryAttack() -- This is defined here since we have a specific velocity apply function
	if self:CanPrimaryAttack() and self:GetNextPrimaryFire() < CurTime() then -- We use the primary thingies here since we do not want both happen at once!
		self:SetNextPrimaryFire(CurTime() + 2)

		timer.Remove("M9k_MMM_Grenade_Grenadethrow" .. self.OurIndex) -- Prevent the animation from being overwritten by the idle thing

		self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
		self:AttackAnimation()

		local vm = self.Owner:GetViewModel()
		if SERVER or IsValid(vm) then -- SERVER or the CLIENT throwing the grenade
			if not IsFirstTimePredicted() then return end -- Fixes weird prediction bugs.
			local Dur = vm:SequenceDuration() - 1.25

			timer.Simple(0.1,function()
				if not IsValid(self) then return end
				self:SetNWBool("ShouldDraw",false)
			end)

			timer.Create("M9k_MMM_Grenade_Grenadethrow" .. self.OurIndex,Dur,1,function()
				if not IsValid(self) or not IsValid(self.Owner) or not IsValid(self.Owner:GetActiveWeapon()) or self.Owner:GetActiveWeapon():GetClass() ~= self:GetClass() then return end

				if SERVER then
					self:TakePrimaryAmmo(1)
					self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav")

					local Ang = self.Owner:EyeAngles() -- Taken from TTT base grenade since it is quite good in my opinion
					local Src = self.Owner:GetPos() + (self.Owner:Crouching() and self.Owner:GetViewOffsetDucked() or self.Owner:GetViewOffset()) + (Ang:Forward() * 8) + (Ang:Right() * 10)

					local Projectile = self:CreateGrenadeProjectile(Src)

					if IsValid(Projectile) and IsValid(Projectile.Phys) then
						Projectile.Phys:SetVelocity(Ang:Forward() * 1250)
					end
				end

				timer.Simple(0.3,function() -- No overwrites/cancels
					if not IsValid(self) or not IsValid(self.Owner) then return end

					if (self:Clip1() <= 0 and self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0) then
						if SERVER then
							self.Owner:StripWeapon(self:GetClass())
						end
					else
						self:Deploy()
						self.Owner:RemoveAmmo(1,self.Primary.Ammo)
						self:SetClip1(1)
					end

					self:SetNWBool("ShouldDraw",true)
				end)
			end)
		end
	end
end

if SERVER then
	local MetaE = FindMetaTable("Entity")
	local CPPIExists = MetaE.CPPISetOwner and true or false
	local CachedAngles1 = Angle(0,0,-45)

	function SWEP:CreateGrenadeProjectile(Pos)
		local Projectile = ents.Create("m9k_thrown_harpoon")
			SafeRemoveEntityDelayed(Projectile,20)

		Projectile:SetModel("models/props_junk/harpoon002a.mdl")
		Projectile:SetPos(Pos)
		local Ang = self.Owner:EyeAngles() + CachedAngles1
		Ang.p = Ang.p + 10
		Projectile:SetAngles(Ang)
		Projectile:SetCollisionGroup(COLLISION_GROUP_NONE)
		Projectile:SetGravity(0.4)
		Projectile:SetFriction(0.2)
		Projectile:SetElasticity(0.45)
		Projectile:Spawn()
		Projectile:PhysWake()

		Projectile.WasDropped = true -- MMM Compatibility

		Projectile:SetPhysicsAttacker(self.Owner,60)
		Projectile:SetOwner(self.Owner)

		if CPPIExists then
			Projectile:CPPISetOwner(self.Owner)
		end

		return Projectile
	end
end