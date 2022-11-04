-- ----- ----- ----- ----- ------- ----- ----- ----- ----- -----
--[[ Dev Notes:

	It is recommended to look at the Default variables assigned to every SWEP as some variables may not be documented.


	This base is based on meteors_grenade_base meaning that all features and Dev Notes are also valid here.

	Due to the nature of prediction, there are a lot of hacky things in this base, but it works reliably according to the excessive testing that I did.


	SWEP.ResetInternalVarsHooked2 = Can be set to a function that will be called after SWEP.ResetInternalVarsHooked - (CLIENT ONLY)


	These flags exist since sometimes you don't want a different viewmodel or you don't want a different worldmodel.

	SWEP.DoNotUseViewModel	- Can be set to true to hide the custom viewmodel.
	SWEP.DoNotUseWorldModel	- Can be set to true to hide the custom worldmodel.


	SWEP.WorldModelStr		- The model used for the World model.	(If unset, it will use SWEP.WorldModel)
	SWEP.ViewModelStr		- The model used for the View model.	(If unset, it will use SWEP.WorldModel)


	SWEP.WorldTexture		- The material used for the World model. (optional)
	SWEP.ViewTexture		- The material used for the View model. (optional)


	SWEP.WorldModelScale		- Vector Scale of the World model
	SWEP.ModelWorldForwardMult	- How many units the World model is moved forwards
	SWEP.ModelWorldRightMult	- How many units the World model is moved right
	SWEP.ModelWorldUpMult		- How many units the World model is moved up
	SWEP.ModelWorldAngForward	- How many units the World model is rotated forward
	SWEP.ModelWorldAngRight		- How many units the World model is rotated right
	SWEP.ModelWorldAngUp		- How many units the World model is rotated up

	SWEP.ViewModelScale			- Vector Scale of the View model
	SWEP.ModelViewForwardMult	- How many units the View model is moved forwards
	SWEP.ModelViewRightMult		- How many units the View model is moved right
	SWEP.ModelViewUpMult		- How many units the View model is moved up
	SWEP.ModelViewAngForward	- How many units the View model is rotated forward
	SWEP.ModelViewAngRight		- How many units the View model is rotated right
	SWEP.ModelViewAngUp			- How many units the View model is rotated up

	SWEP.ModelViewBlacklistedBones = { -- Table of bones that should be hidden from the base viewmodel used
		["v_weapon.Flashbang_Parent"] = true, -- Example bones taken from m9k_m61_frag.lua
		["v_weapon.strike_lever"] = true,
		["v_weapon.safety_pin"] = true,
		["v_weapon.pull_ring"] = true
	}


	SWEP.bShouldDrawModel	- Controls when the custom Viewmodel can be seen. (Used internally)


	If you're confused about how to make a proper custom view/world model throwable, I recommend checking out m9k_m61_frag.lua

]]
-- ----- ----- ----- ----- ------- ----- ----- ----- ----- -----

SWEP.Base = "meteors_grenade_base"

SWEP.UseHands = true

SWEP.WorldModelScale = Vector(1,1,1)
SWEP.ModelWorldForwardMult = 0
SWEP.ModelWorldRightMult = 0
SWEP.ModelWorldUpMult = 0
SWEP.ModelWorldAngForward = 0
SWEP.ModelWorldAngRight = 0
SWEP.ModelWorldAngUp = 0

SWEP.ViewModelScale = Vector(0.75,0.75,0.75)
SWEP.ModelViewForwardMult = 0
SWEP.ModelViewRightMult = 0
SWEP.ModelViewUpMult = -0
SWEP.ModelViewAngForward = 0
SWEP.ModelViewAngRight = 0
SWEP.ModelViewAngUp = 0
SWEP.ModelViewBlacklistedBones = {}

SWEP._UsesCustomModels = true

-- ----- ----- ----- ----- ------- ----- ----- ----- ----- -----
-- Compatibility
-- ----- ----- ----- ----- ------- ----- ----- ----- ----- -----

local sTag = "MMM_M9kr_Grenades_Model"

vector_zero = Vector(0,0,0) -- MMM Compat

-- ----- ----- ----- ----- ------- ----- ----- ----- ----- -----
-- SERVER
-- ----- ----- ----- ----- ------- ----- ----- ----- ----- -----

if SERVER then

	local tMetaPly = FindMetaTable("Player")


	-- We have to detour SelectWeapon since it messes with prediction and we have to let the clients know that their weapon was changed so that they don't have broken viewmodels.

	tMetaPly.SelectWeaponM9krBackup = tMetaPly.SelectWeaponM9krBackup or tMetaPly.SelectWeapon

	function tMetaPly:SelectWeapon(sStr) -- This function override is being used for multiple files.

		local eWep = self:GetActiveWeapon() -- Cache their current Weapon


		net.Start("MMM_M9kr_Weapons_FixMat") -- Notify client of Weapon change
		net.Send(self)


		self:SelectWeaponM9krBackup(sStr)


		if IsValid(eWep) and eWep._IsM9kRemasteredBased then -- Reset stuff if their cached Weapon was M9kR based

			net.Start("MMM_M9kr_Grenades") -- Pretend the Weapon was dropped which calls the Reset Variables function
				net.WriteEntity(eWep)
				net.WriteInt(2,6)
			net.Broadcast()

		end
	end
end

-- ----- ----- ----- ----- ------- ----- ----- ----- ----- -----
-- CLIENT
-- ----- ----- ----- ----- ------- ----- ----- ----- ----- -----

if CLIENT then

	angle_zero = Angle(0,0,0) -- Make sure nothing else fucked with this

	local vector_one = Vector(1,1,1)


	SWEP.bShouldDrawModel = false


	function SWEP:InitializeHooked()
		self.bShouldDrawModel = true
	end


	function SWEP:ResetInternalVarsHooked()

		if not self.bDeployed then -- Don't do this if we just deployed the weapon

			local us = LocalPlayer() -- Did you know LocalPlayer can be invalid during a fullupdate call? Now you do.

			if IsValid(us) and self.Owner == us then

				local vm = us:GetViewModel()

				if IsValid(vm) then

					for k = 0,vm:GetBoneCount() do -- Make sure to reset the bones! (very important!!)
						vm:ManipulateBoneScale(k,vector_one)
						vm:ManipulateBoneAngles(k,angle_zero)
						vm:ManipulateBonePosition(k,vector_zero)
					end
				end
			end
		end

		self.bDeployed = nil


		self.LastViewEntity = nil -- Save some RAM, even if its microscopic

		self.bShouldDrawModel = true


		if IsValid(self.WorldEnt) then
			self.WorldEnt:Remove()
		end

		if IsValid(self.ViewEnt) then
			self.ViewEnt:Remove()
		end


		if self.ResetInternalVarsHooked2 then
			self:ResetInternalVarsHooked2()
		end
	end


	function SWEP:DeployHooked()
		self.bShouldDrawModel = true

		self.bDeployed = true -- Required

	end


	function SWEP:ThinkHooked()

		if not IsValid(self.Owner) then return end


		self.bDeployed = nil -- Required


		-- Re-apply hiding the base viewmodel when cameras changed

		local eView = self.Owner:GetViewEntity()

		if eView ~= self.LastViewEntity then
			self:HideBaseViewModel()
		end

		self.LastViewEntity = eView

	end


	function SWEP:PinPullEvent()
		self.bShouldDrawModel = false
	end

	function SWEP:ThrowEvent()

		timer.Create(sTag .. self:EntIndex(),0.3,1,function()
			if not IsValid(self) or not IsValid(self.Owner) or self.Owner:GetActiveWeapon() ~= self then return end

			self.bShouldDrawModel = true
		end)
	end


	function SWEP:DrawWorldModel()

		if self.DoNotUseWorldModel or not IsValid(self.Owner) then -- Can be used to use the default worldmodel // Weapon is dropped
			self:DrawModel()

			return true
		end


		if not IsValid(self.WorldEnt) then
			self:CreateWorldModel()

			return -- Prevent error in the same tick
		end


		self.CachedWorldBone = self.CachedWorldBone or self.Owner:LookupBone("ValveBiped.Bip01_R_Hand") -- This is faster than looking it up every frame!
		if not self.CachedWorldBone then return end -- Thanks to wrefgtzweve on GitHub for finding this.


		local vPos, aAng = self.Owner:GetBonePosition(self.CachedWorldBone)

		self.WorldEnt:SetPos(vPos + aAng:Forward() * self.ModelWorldForwardMult + aAng:Right() * self.ModelWorldRightMult + aAng:Up() * self.ModelWorldUpMult)

		aAng:RotateAroundAxis(aAng:Forward(),self.ModelWorldAngForward)
		aAng:RotateAroundAxis(aAng:Right(),self.ModelWorldAngRight)
		aAng:RotateAroundAxis(aAng:Up(),self.ModelWorldAngUp)

		self.WorldEnt:SetAngles(aAng)
		self.WorldEnt:EnableMatrix("RenderMultiply",self.WorldMatrix)
		self.WorldEnt:DrawModel()
	end


	function SWEP:ViewModelDrawn(vm)
		if self.DoNotUseViewModel or not self.bShouldDrawModel then return true end -- Can be used to use the default viewmodel // hides when it should not been drawn


		if not IsValid(self.ViewEnt) then -- This is used fairly often

			self:CreateViewModel()
			self:HideBaseViewModel()

			return -- Prevent error in the same tick
		end


		self.CachedViewBone = self.CachedViewBone or vm:LookupBone("ValveBiped.Bip01_R_Hand") -- This is faster than looking it up every frame!
		if not self.CachedViewBone then return end -- Thanks to wrefgtzweve on GitHub for finding this.

		local mMatrix = vm:GetBoneMatrix(self.CachedViewBone)
		if not mMatrix then return end


		local vPos, aAng = mMatrix:GetTranslation(), mMatrix:GetAngles()

		self.ViewEnt:SetPos(vPos + aAng:Forward() * self.ModelViewForwardMult + aAng:Right() * self.ModelViewRightMult + aAng:Up() * self.ModelViewUpMult)

		aAng:RotateAroundAxis(aAng:Forward(),self.ModelViewAngForward)
		aAng:RotateAroundAxis(aAng:Right(),self.ModelViewAngRight)
		aAng:RotateAroundAxis(aAng:Up(),self.ModelViewAngUp)

		self.ViewEnt:SetAngles(aAng)
		self.ViewEnt:EnableMatrix("RenderMultiply",self.ViewMatrix)
		self.ViewEnt:DrawModel()
	end


	function SWEP:CreateWorldModel()
		if self.DoNotUseWorldModel then return end
		if IsValid(self.WorldEnt) then self.WorldEnt:Remove() end

		self.WorldEnt = ClientsideModel(self.WorldModelStr or self.WorldModel,RENDERGROUP_OPAQUE)
		self.WorldEnt:SetPos(self:GetPos())
		self.WorldEnt:SetAngles(self:GetAngles())
		self.WorldEnt:SetParent(self)
		self.WorldEnt:SetNoDraw(true)

		if self.WorldTexture then
			self.WorldEnt:SetMaterial(self.WorldTexture)
		end

		self.WorldMatrix = Matrix()
		self.WorldMatrix:Scale(self.WorldModelScale)
	end


	function SWEP:CreateViewModel()
		if self.DoNotUseViewModel then return end
		if IsValid(self.ViewEnt) then self.ViewEnt:Remove() end

		self.ViewEnt = ClientsideModel(self.ViewModelStr or self.WorldModel,RENDERGROUP_OPAQUE)
		self.ViewEnt:SetPos(self:GetPos())
		self.ViewEnt:SetAngles(self:GetAngles())
		self.ViewEnt:SetParent(self)
		self.ViewEnt:SetNoDraw(true)

		if self.ViewTexture then
			self.ViewEnt:SetMaterial(self.ViewTexture)
		end

		self.ViewMatrix = Matrix()
		self.ViewMatrix:Scale(self.ViewModelScale)
	end


	function SWEP:HideBaseViewModel()
		if self.DoNotUseViewModel then return end


		if self.Owner == LocalPlayer() then

			hook.Add("Think",sTag,function() -- We make a hook since we have to wait for the viewmodel to become valid!
				if not IsValid(self) or not IsValid(self.Owner) or self.Owner:GetActiveWeapon() ~= self then
					hook.Remove("Think",sTag)
					return
				end


				local vm = self.Owner:GetViewModel()

				if IsValid(vm) then

					hook.Remove("Think",sTag)


					local tIDs = {}

					for k = 1,vm:GetBoneCount() do -- Hide blacklisted bones
						if self.ModelViewBlacklistedBones[vm:GetBoneName(k)] then
							table.insert(tIDs,k)
						end
					end

					for _,v in ipairs(tIDs) do
						vm:ManipulateBoneScale(v,vector_zero)
					end
				end
			end)
		end
	end
end