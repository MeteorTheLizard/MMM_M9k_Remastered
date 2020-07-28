SWEP.Base = "bobs_shotty_base"
SWEP.Category = "M9K Specialties"
SWEP.PrintName = "M79 GL"

SWEP.Slot = 5
SWEP.HoldType = "shotgun"
SWEP.Spawnable = true

SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_m79_grenadelauncher.mdl"
SWEP.WorldModel = "models/weapons/w_m79_grenadelauncher.mdl"

SWEP.Primary.Sound = "40mmGrenade.Single"
SWEP.Primary.ClipSize = 1

SWEP.Primary.KickUp = 6
SWEP.Primary.KickDown = 3
SWEP.Primary.KickHorizontal = 5
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "40mmGrenade"
SWEP.ShellTime = .5

SWEP.IronSightsPos = Vector(-4.633,-7.651,2.108)
SWEP.IronSightsAng = Vector(1.294,0.15,0)

local AngleCache1 = Angle(90,0,0)
local VectorCache1 = Vector(0,0,1)
local MetaE = FindMetaTable("Entity")
local CPPIExists = MetaE.CPPISetOwner and true or false

function SWEP:PrimaryAttack()
	if self.Owner:WaterLevel() == 3 then -- No weapons may fire underwater
		self:EmitSound("Weapon_Pistol.Empty")
		self:SetNextPrimaryFire(CurTime() + 0.2)
		return
	end

	if self.InsertingShell and not self.CanceledReloadSuccess then
		self:FinishReloading()
	elseif self:CanPrimaryAttack() and not self.InsertingShell then
		self:SetNextPrimaryFire(CurTime() + 1.75)

		if SERVER then
			self:TakePrimaryAmmo(1)

			local aim = self.Owner:GetAimVector()
			local side = aim:Cross(VectorCache1)
			local pos = self.Owner:GetShootPos() + side * 6 + side:Cross(aim) * -5

			local rocket = ents.Create("m9k_launched_m79")
			rocket:SetAngles(aim:Angle() + AngleCache1)
			rocket:SetPos(pos)

			rocket:SetOwner(self.Owner)

			if CPPIExists then
				rocket:CPPISetOwner(self.Owner)
			else
				rocket:SetNWEntity("my_owner",self.Owner) -- TinyCPPI Compatibility
			end

			rocket:Spawn()
			rocket:Activate()
		end

		local KickUp = self.Primary.KickUp
		local KickDown = self.Primary.KickDown
		local KickHorizontal = self.Primary.KickHorizontal

		if self.Owner:KeyDown(IN_DUCK) then
			KickUp = self.Primary.KickUp / 2
			KickDown = self.Primary.KickDown / 2
			KickHorizontal = self.Primary.KickHorizontal / 2
		end

		local SharedRandom = Angle(util.SharedRandom("m9k_gun_kick1",-KickDown,-KickUp),util.SharedRandom("m9k_gun_kick2",-KickHorizontal,KickHorizontal),0)
		self.Owner:ViewPunch(SharedRandom) -- This needs to be shared

		if SERVER and game.SinglePlayer() or SERVER and self.Owner:IsListenServerHost() then -- This is specifically for the host or when in singleplayer
			local eyes = self.Owner:EyeAngles()
			eyes:SetUnpacked(eyes.pitch + SharedRandom.pitch,eyes.yaw + SharedRandom.yaw,0)
			self.Owner:SetEyeAngles(eyes)
		elseif CLIENT and not game.SinglePlayer() then -- This is for other players in multiplayer (Or anyone on the server if dedicated)
			local eyes = self.Owner:EyeAngles()
			eyes:SetUnpacked(eyes.pitch + (SharedRandom.pitch/5),eyes.yaw + (SharedRandom.yaw/5),0)
			self.Owner:SetEyeAngles(eyes)
		end

		self:AttackAnimation()
		self:EmitSound(self.Primary.Sound)
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	end
end