SWEP.Base = "meteors_grenade_base"
SWEP.Category = "M9K Specialties"
SWEP.PrintName = "Sticky Grenade"

SWEP.Slot = 4
SWEP.Spawnable = true
SWEP.UseHands = true

SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/v_sticky_grenade.mdl"
SWEP.WorldModel = "models/weapons/w_sticky_grenade.mdl"

SWEP.Primary.Ammo = "StickyGrenade"

if SERVER then
	local MetaE = FindMetaTable("Entity")
	local CPPIExists = MetaE.CPPISetOwner and true or false
	local CachedColor1 = Color(225,0,0)
	local CachedAngles1 = Angle(0,0,-45)

	function SWEP:CreateGrenadeProjectile(Pos)
		local Projectile = ents.Create("m9k_thrown_sticky_grenade")
			SafeRemoveEntityDelayed(Projectile,30)

		Projectile:SetModel("models/weapons/w_sticky_grenade.mdl")
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