SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9K Specialties"
SWEP.PrintName = "RPG-7"

SWEP.Slot = 5
SWEP.HoldType = "rpg"
SWEP.Spawnable = true

SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_rl7.mdl"
SWEP.WorldModel = "models/weapons/w_rl7.mdl"

SWEP.Primary.Sound = "RPGF.single"
SWEP.Primary.RPM = 30
SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.KickUp = 3
SWEP.Primary.KickDown = 5
SWEP.Primary.KickHorizontal = 10
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "RPG_Round"

SWEP.IronSightsPos = Vector(-3.7384,-5.7481,-0.2713)
SWEP.IronSightsAng = Vector(1.1426,0.0675,0)

local MetaE = FindMetaTable("Entity")
local CPPIExists = MetaE.CPPISetOwner and true or false
local VectorCache1 = Vector(0,0,1)

function SWEP:PrimaryAttack()
	if self.Owner:WaterLevel() == 3 then -- No weapons may fire underwater
		self:EmitSound("Weapon_Pistol.Empty")
		self:SetNextPrimaryFire(CurTime() + 0.2)
		return
	end

	if self:CanPrimaryAttack() then
		self:SetNextPrimaryFire(CurTime() + 1 / (self.Primary.RPM / 60))
		self:TakePrimaryAmmo(1)

		local aim = self.Owner:GetAimVector()
		local side = aim:Cross(VectorCache1)
		local pos = self.Owner:GetShootPos() + side * 6 + side:Cross(aim) * -5

		if SERVER then
			util.ScreenShake(self.Owner:GetShootPos(),1000,10,0.3,500)

			local rocket = ents.Create("m9k_ammo_rpg_heat")
			rocket:SetAngles(aim:Angle())
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