SWEP.Base = "meteors_grenade_base_model_instant"
SWEP.Category = "M9K Specialties"
SWEP.PrintName = "Nerve Gas"

SWEP.Slot = 4
SWEP.Spawnable = true
SWEP.UseHands = true

SWEP.ViewModel = "models/weapons/cstrike/c_eq_fraggrenade.mdl"
SWEP.WorldModel = "models/healthvial.mdl"
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 55

SWEP.Primary.Ammo = "NerveGas"

SWEP.WorldModelScale = Vector(1,1,1)
SWEP.ModelWorldForwardMult = 4.25
SWEP.ModelWorldRightMult = 1.75
SWEP.ModelWorldUpMult = -5.5
SWEP.ModelWorldAngForward = 5
SWEP.ModelWorldAngRight = 15
SWEP.ModelWorldAngUp = -80

SWEP.ViewModelScale = Vector(0.6,0.6,0.6)
SWEP.ModelViewForwardMult = 4
SWEP.ModelViewRightMult = 2.5
SWEP.ModelViewUpMult = -4
SWEP.ModelViewAngForward = -5
SWEP.ModelViewAngRight = 10
SWEP.ModelViewAngUp = -100
SWEP.ModelViewBlacklistedBones = {
	["v_weapon.Flashbang_Parent"] = true,
	["v_weapon.strike_lever"] = true,
	["v_weapon.safety_pin"] = true,
	["v_weapon.pull_ring"] = true
}

if CLIENT then -- These functions have to be defined here as well since we have to change the material!
	local VectorCache1 = Vector(1,1,1)
	local VectorCache2 = Vector(0.6,0.6,0.6)

	function SWEP:CreateWorldModel() -- We need to create these like that since a player could join and these would be invalid!
		if IsValid(self.WorldEnt) then self.WorldModel:Remove() end

		self.WorldEnt = ClientsideModel("models/healthvial.mdl",RENDERGROUP_VIEWMODEL_TRANSLUCENT)
		self.WorldEnt:SetMaterial("models/weapons/gv/nerve_vial.vmt")
		self.WorldEnt:SetPos(self:GetPos())
		self.WorldEnt:SetAngles(self:GetAngles())
		self.WorldEnt:SetParent(self)
		self.WorldEnt:SetNoDraw(true)

		self.WorldMatrix = Matrix()
		self.WorldMatrix:Scale(VectorCache1)
	end

	function SWEP:CreateViewModel() -- We need to create these like that since a player could join and these would be invalid!
		if IsValid(self.ViewEnt) then self.ViewEnt:Remove() end

		self.ViewEnt = ClientsideModel("models/healthvial.mdl",RENDERGROUP_VIEWMODEL_TRANSLUCENT)
		self.ViewEnt:SetMaterial("models/weapons/gv/nerve_vial.vmt")
		self.ViewEnt:SetPos(self:GetPos())
		self.ViewEnt:SetAngles(self:GetAngles())
		self.ViewEnt:SetParent(self)
		self.ViewEnt:SetNoDraw(true)

		self.ViewMatrix = Matrix()
		self.ViewMatrix:Scale(VectorCache2)
	end
end

if SERVER then
	local MetaE = FindMetaTable("Entity")
	local CPPIExists = MetaE.CPPISetOwner and true or false
	local CachedColor1 = Color(225,0,0)
	local CachedAngles1 = Angle(0,0,-45)

	function SWEP:CreateGrenadeProjectile(Pos)
		local Projectile = ents.Create("m9k_nervegasnade")
			SafeRemoveEntityDelayed(Projectile,30)

		Projectile:SetModel("models/healthvial.mdl")
		Projectile:SetMaterial("models/weapons/gv/nerve_vial.vmt")
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

	function SWEP:OnDrop()
		if self.PinPulled or not self.CanPullPin then -- The owner died and the pin was pulled, so we do whatever the throwable does!
			self.Owner = self.LastOwner
			self:CreateGrenadeProjectile(self:GetPos())
			self:Remove()
		else
			self:Holster()
			self:SetMaterial("models/weapons/gv/nerve_vial.vmt")

			-- HACK!! At the time of coding this, WEAPON:OwnerChanged does not work for the first spawn and drop! (Which causes issues!!)
			-- https://github.com/Facepunch/garrysmod-issues/issues/4639
			if IsValid(self.LastOwner) then -- This is done to fix the viewmodel after dropping
				self.LastOwner:SendLua("local Ent = Entity(" .. self.OurIndex .. "); if IsValid(Ent) then Ent:Holster() end")
			end
		end
	end
end