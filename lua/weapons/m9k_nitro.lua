SWEP.Base = "meteors_grenade_base_model_instant"
SWEP.Category = "M9K Specialties"
SWEP.PrintName = "Nitro Glycerine"

SWEP.Slot = 4
SWEP.Spawnable = true
SWEP.UseHands = true

SWEP.ViewModelFOV = 55
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/cstrike/c_eq_fraggrenade.mdl"
SWEP.WorldModel = "models/weapons/w_nitro.mdl"

SWEP.Primary.Ammo = "nitroG"

SWEP.WorldModelScale = Vector(1,1,1)
SWEP.ModelWorldForwardMult = 2
SWEP.ModelWorldRightMult = 24
SWEP.ModelWorldUpMult = 8
SWEP.ModelWorldAngForward = 0
SWEP.ModelWorldAngRight = 190
SWEP.ModelWorldAngUp = 185

SWEP.ViewModelScale = Vector(0.75,0.75,0.75)
SWEP.ModelViewForwardMult = -11.5
SWEP.ModelViewRightMult = 9
SWEP.ModelViewUpMult = 4
SWEP.ModelViewAngForward = -5
SWEP.ModelViewAngRight = 190
SWEP.ModelViewAngUp = -110
SWEP.ModelViewBlacklistedBones = {
	["v_weapon.Flashbang_Parent"] = true,
	["v_weapon.strike_lever"] = true,
	["v_weapon.safety_pin"] = true,
	["v_weapon.pull_ring"] = true
}

if SERVER then
	local MetaE = FindMetaTable("Entity")
	local CPPIExists = MetaE.CPPISetOwner and true or false
	local CachedColor1 = Color(225,225,0)
	local CachedAngles1 = Angle(0,0,-45)

	function SWEP:CreateGrenadeProjectile(Pos)
		local Projectile = ents.Create("m9k_thrown_nitrox")
			SafeRemoveEntityDelayed(Projectile,30)

		Projectile:SetModel("models/weapons/w_nitro.mdl")
		Projectile:SetPos(Pos)
		Projectile:SetAngles(self.Owner:EyeAngles() + CachedAngles1)
		Projectile:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		Projectile:SetGravity(0.4)
		Projectile:SetFriction(0.2)
		Projectile:SetElasticity(0.45)
		Projectile:Spawn()
		Projectile:PhysWake()

		Projectile.WasDropped = true -- MMM Compatibility

		if MMM then util.SpriteTrail(Projectile,0,CachedColor1,true,5,5,1,1 / ( 5 + 5 ) * 0.5,"trails/laser.vmt") end -- In MMM environments, we want a clear indicator what this nade is!

		Projectile:SetOwner(self.Owner)

		if CPPIExists then
			Projectile:CPPISetOwner(self.Owner)
		end

		return Projectile
	end
end