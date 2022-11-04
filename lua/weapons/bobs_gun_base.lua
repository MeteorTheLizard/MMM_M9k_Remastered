-- ----- ----- ----- ----- ------- ----- ----- ----- ----- -----
--[[ Dev Notes:

	It is recommended to look at the Default variables assigned to every SWEP as some variables may not be documented.


	There is no more bob here. This base is 100% custom.

	Formatting Notes:
		My IDE is on the smallest text-size. This makes it so that having multiple lines of empty space between code look a lot cleaner and more readable. Cry about it.
		There is no strict formatting rule when it comes to spacing. I just do whatever looks the cleanest, most readable, and most pleasing.
		Even though this is gLua which has C operators frankensteined into it, it is best to avoid using them especially since they actually slow down code.
		Do not use continue in loops. They do not work reliably within gLua. Use goto (tag) instead: goto continued (some code) ::continued:: - Another example can be found in the code below. Search: Loop jump
		Make sure to put the type of a variable in front of its name, example: fFunction, iInteger, tTable, obj_EffectData, etc..
			> obj_ indicates userdata or other objects with no strict type.
			> vm = viewmodel - It never had a special typing for me. It's an entity but eh.


	SWEP.DrawSound			- Sound that is played when deploying the weapon. (optional)
	SWEP.DrawCantHear		- Set to true to suppress the DrawSound for the owner. (optional)
	SWEP.CanFireUnderwater	- Can be set to true to allow the weapon to fire under water.
	SWEP.ShouldDoMoveSpread	- Can be set to false to disable spread from moving around.
	SWEP.iPrimaryAnimOnLast - Can be set to a viewmodel animation ID that will be played on the last shot fired.

	SWEP.bFiresEntity		- Can be set to true to block FireBullets from being called. A custom firing logic can be set using SWEP.PrimaryAttackHooked
	SWEP.bBlockIronSights	- Can be used to block ironsights, useful during animation sequences.
	SWEP.bBlockMuzzleFlash	- Can be set to true to prevent the muzzleflash from happening when aiming down the sights. Used in m9k_mp9.lua
	SWEP.bBlockShellEject	- Can be set to true to block the shell eject animation from being played.
	SWEP.bBlockIdleSight	- Can be set to true to block ACT_VM_IDLE from playing when using the ironsights and firing the Weapon which allows you to use the PrimaryAttack animation instead.
	SWEP.bNoTracers			- Can be set to true to make FireBullets not make any tracers. Useful for bugged Weapons (Looking at you M9k Plus..)
	SWEP.bAr2Tracer			- Can be set to true to use AR2 Tracers.


	SWEP._UsesCustomModels	- Can be set to true to indicate that the SWEP uses a custom Viewmodel. This is required when using a custom model.


	self.OurIndex			- Can be used to get the Entity Index of the Weapon after it has been initialized. (CLIENTSIDE ONLY) - If you want this serverside create a InitializeHooked function in your SWEP script and assign it using self:EntIndex()


	SWEP.Primary.SoundVolume - Can be used to change the volume of the Primary Attack sound. ( Default: 75 db )


	SWEP.DynamicLightScale - Can be used to increase the size of the muzzleflash, useful for powerful weapons like sniper rifles. ( This only affects the thirdperson flash! )


	The Sound used for an invalid / impossible action is: weapons/masadamagpul/safety.mp3
	> This for example is used when it is attempted to fire the weapon under water when it cannot be fired under water or the player is out of ammo.. etc.


	Weapons have a custom animation layer that is added on top of ACT_VM sequences. This is impossibly hard to see when not playing ACT_VM_IDLE.
	> Search: Idle Sway

	-- ----- ----- ----- ----- ------- ----- ----- ----- ----- -----

	Almost all SWEP functions have a function they call that you can hook into in your SWEP script.
	Simply assign a function to (X)Hooked to make said function run on (X) event.

	Note: Some Hooks may not be listed. It is best to check the source code.


	SERVER & CLIENT - Shared

	Initialize			> IntializeHooked
	ResetInternalVars	> ResetInternalVarsHooked
	Deploy				> DeployHooked
	Equip				> EquipHooked
	Reload				> ReloadHooked - Note: Reloading can be blocked by returning true in ReloadHooked (Serverside only)
	Think				> ThinkHooked

	SERVER

	OnDrop				> OnDropHooked
	PrimaryAttack		> PrimaryAttackHooked


	SWEP.PostReloadCall - Can be set to a function that will be called when the reload finished. (Serverside only) - Only works in combination with dynamic reload. - An example can be found in m9k_minigun.lua


	DO NOTE: Some of these functions may already be used by bobs_scoped_base and bobs_shotty_base !!

	-- ----- ----- ----- ----- ------- ----- ----- ----- ----- -----

	The following is NOT required! But recommended so that other players can hear the sounds as well!
	> If this is not set it will simply perform a normal reload like any other SWEP.


	SWEP.tReloadDynamic Contains sound sequence data for reloading. Example:


	Taken from m9k_aw50.lua:

	SWEP.tReloadDynamic = {
		{ -- First sound
			sSound = "weapons/aw50/awp_magout.mp3",
			iDelay = 0.40 -- Delay before playing the sound.
		},
		{ -- Second sound
			sSound = "weapons/aw50/awp_magin.mp3",
			iDelay = 0.40 + 0.55
		},
		{
			sSound = "weapons/aw50/m24_boltback.mp3",
			iDelay = 0.40 + 0.55 + 0.60
		},
		{
			sSound = "weapons/aw50/m24_boltforward.mp3",
			iDelay = 0.40 + 0.55 + 0.60 + 0.55 -- Add the delay of previous sounds to it.
		}
	}


	SWEP.tDrawSoundSequence -- Can be used to define a deploy sound sequence using the same logic as Reload Dynamic.


	Do note that the Weapon holder can hear these sounds as well. If your Weapon makes use of sound scripts, it is recommended to replace the sound scripts with this instead to avoid playing sounds twice.

	-- ----- ----- ----- ----- ------- ----- ----- ----- ----- -----

	bobs_gun_base.lua makes use of networking. It transmit Integers as an identifier.

	-- 1 = Deploy sound
	-- 2 = Primary Attack Effects
	-- 3 = Dynamic Reload Start
	-- 4 = Balance changes
	-- 5 = Dynamic Reload Finish
	-- 6 = Weapon Drop (Reset vars)

]]
-- ----- ----- ----- ----- ------- ----- ----- ----- ----- -----

MMM_M9k_IsBaseInstalled = true -- Absolutely avoid global variables like this whenever possible and if there is no way around it, make it as unique as possible.

SWEP.Slot = 0
SWEP.SlotPos = 1

SWEP.Author = ""
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Spawnable = false
SWEP.AdminSpawnable = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.DrawAmmo = true
SWEP.DrawCrosshair = true
SWEP.DrawWeaponInfoBox = false
SWEP.BounceWeaponIcon = false

SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = true

SWEP.HoldType = "pistol"
SWEP.UseHands = false

SWEP.Primary.Sound = ""
SWEP.Primary.Damage = 1
SWEP.Primary.Spread = 0
SWEP.Primary.NumShots = 1
SWEP.Primary.RPM = 0
SWEP.Primary.ClipSize = 0
SWEP.Primary.DefaultClip = 0

SWEP.Primary.KickUp = 0
SWEP.Primary.KickDown = 0
SWEP.Primary.KickHorizontal = 0
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.Sound = ""
SWEP.Secondary.Damage = 1
SWEP.Secondary.Spread = 0
SWEP.Secondary.NumShots = 1
SWEP.Secondary.RPM = 0
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0

SWEP.Secondary.KickUp = 0
SWEP.Secondary.KickDown = 0
SWEP.Secondary.KickHorizontal = 0
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"


SWEP.MuzzleFlashCol = {
	r = 255,
	g = 175,
	b = 0
}


-- Some internal vars

SWEP.CanFireUnderwater = false
SWEP.ShouldDoMoveSpread = true

SWEP._IsM9kRemasteredBased = true


-- These can be used to override animations if needed

SWEP.iIdleAnim = ACT_VM_IDLE
SWEP.iDeployAnim = ACT_VM_DRAW
SWEP.iPrimaryAnim = ACT_VM_PRIMARYATTACK
SWEP.iReloadAnim = ACT_VM_RELOAD


local ConVar_BalanceMode = CreateConVar("m9k_balancemode","0",FCVAR_ARCHIVE,"When set to 0, M9kr will use the legacy balancing. When set to 1, M9kr will use the rebalanced balancing.",0,1)
local ConVar_SpawnAmmo = CreateConVar("m9k_spawn_with_ammo","1",FCVAR_ARCHIVE,"When set to 1, any weapon acquired will have a full magazine.",0,1)
local ConVar_SpawnReserve = CreateConVar("m9k_spawn_with_reserve","1",FCVAR_ARCHIVE,"When set to 1, any weapon acquired will give 3 magazines for that weapon.",0,1)

-- ----- ----- ----- ----- ------- ----- ----- ----- ----- -----
-- Optimization
-- ----- ----- ----- ----- ------- ----- ----- ----- ----- -----

local sTag = "MMM_M9kr_Weapons"
local sTagFix = sTag .. "_FixMat" -- Used in this file and meteors_grenade_base_model.lua


local fSetOnetimeVars = function()

	hook.Remove("PostGamemodeLoaded",sTag)


	-- Global vars suck but it is what it is. Having a class makes it slower :>
	-- Avoid them whenever you can

	MMM_M9k_IsBaseInstalled = true

	MMM_M9k_IsSinglePlayer = game.SinglePlayer()


	-- MMM Compat

	vector_zero = Vector(0,0,0)


	-- CPPI Compat

	local tMetaEntity = FindMetaTable("Entity")

	MMM_M9k_CPPIExists = tMetaEntity.CPPISetOwner and true or false

end

if MMM_M9k_IsBaseInstalled then -- Reloading the file should force the vars to be set
	fSetOnetimeVars()
end

hook.Add("PostGamemodeLoaded",sTag,fSetOnetimeVars)

-- ----- ----- ----- ----- ------- ----- ----- ----- ----- -----
-- Compatibility
-- ----- ----- ----- ----- ------- ----- ----- ----- ----- -----

function SWEP:AttackAnimation()
	if not IsValid(self.Owner) then return end

	self.Owner:SetAnimation(PLAYER_ATTACK1)
end


function SWEP:CanSecondaryAttack()
	return false
end


local fBlank = function() end

SWEP.SecondaryAttack = fBlank
SWEP.ShootBullet = fBlank
SWEP.ShootEffects = fBlank
SWEP.DoImpactEffect = fBlank
SWEP.SetDeploySpeed = fBlank

-- ----- ----- ----- ----- ------- ----- ----- ----- ----- -----
-- SERVER
-- ----- ----- ----- ----- ------- ----- ----- ----- ----- -----

if SERVER then

	cvars.RemoveChangeCallback("m9k_balancemode_callback")
	cvars.AddChangeCallback("m9k_balancemode",function()

		-- Here we update all currently existing weapons

		for _,v in ipairs(ents.GetAll()) do
			if v:IsWeapon() and v._IsM9kRemasteredBased then

				v:ApplyWeaponBalance()

				net.Start("MMM_M9kr_Weapons") -- Notify clients
					net.WriteEntity(v)
					net.WriteInt(4,6)
				net.Broadcast()
			end
		end

	end,"m9k_balancemode_callback")


	-- ----- ----- ----- ----- ------- ----- ----- ----- ----- -----


	util.AddNetworkString(sTag)
	util.AddNetworkString(sTagFix)


	hook.Add("PlayerSwitchWeapon",sTagFix,function(ePly)

		net.Start("MMM_M9kr_Weapons_FixMat") -- Notify client of Weapon change
		net.Send(ePly)

	end)


	SWEP._CanReload = true


	function SWEP:Initialize()

		self:SetHoldType(self.HoldType)

		self:ApplyWeaponBalance() -- You guys asked for it.. Enjoy!


		if ConVar_SpawnAmmo:GetInt() == 1 then -- Make the weapon start with full clips if desired

			self.Primary.DefaultClip = self.Primary.ClipSize -- Compatibility
			self:SetClip1(self.Primary.DefaultClip)

			if self.Secondary and (self.Secondary.DefaultClip and self.Secondary.ClipSize) then

				self.Secondary.DefaultClip = self.Secondary.ClipSize -- Compatibility
				self:SetClip2(self.Secondary.DefaultClip)

			end
		end


		if ConVar_SpawnReserve:GetInt() == 1 then -- Give the Weapon Owner some clips if desired

			timer.Simple(0,function() -- We need to wait one tick so that self.Owner becomes valid
				if not IsValid(self) or not IsValid(self.Owner) then return end

				self.Owner:GiveAmmo(self.Primary.ClipSize * 3,self.Primary.Ammo,true) -- 3 Clips
			end)
		end


		-- This timer is jank AF but its needed. Unfortunately if someone has a high ping this doesn't even do what it should be doing. This needs to be fixed later.
		-- When a Weapon is spawned through the spawnmenu.. the Deploy function is not called as the spawnmenu uses SelectWeapon which means it happens out of prediction.
		-- This makes it so that the DrawSound is not played which makes it very awkward.

		timer.Simple(0.1,function() -- Pray the weapon is valid on the client on runtime
			if not IsValid(self) or not IsValid(self.Owner) or self.Owner:GetActiveWeapon() ~= self then return end

			if self.DrawSound or self.tDrawSoundSequence then -- Network Deploy Sound
				net.Start(sTag)
					net.WriteEntity(self)
					net.WriteInt(1,6)
				net.Broadcast()
			end
		end)


		-- Instead of overwriting the Initialize function, we expand on it!

		if self.InitializeHooked then
			self:InitializeHooked()
		end


		if MMM_M9k_IsSinglePlayer then -- In singleplayer we need to force the weapon to be equipped after spawning
			timer.Simple(0,function()
				if not IsValid(self) or not IsValid(self.Owner) then return end

				self.Owner:SelectWeapon(self:GetClass())
			end)
		end
	end


	function SWEP:ResetInternalVars() -- Convenience
		if self.IronSightState and self.Owner and IsValid(self.Owner) then
			self.Owner:SetFOV(0,0.3) -- Setting this at all times is bad as it causes screen spazz
		end


		self.IronSightState = false
		self._CanReload = true
		self.DynamicReloadThink = nil


		self.DrawCrosshair = true


		self:SetHoldType(self.HoldType)


		if self.ResetInternalVarsHooked then
			self:ResetInternalVarsHooked()
		end
	end


	function SWEP:Deploy()
		if not IsValid(self.Owner) then return end

		if MMM_M9k_IsSinglePlayer then
			self:CallOnClient("Deploy") -- Make sure that it runs on the CLIENT! (Singleplayer!)
		end


		self:SetHoldType(self.HoldType)


		self:SendWeaponAnim(self.iDeployAnim)


		local vm = self.Owner:GetViewModel()

		if IsValid(vm) then -- Action delay

			local iDur = CurTime() + vm:SequenceDuration() + 0.2

			self:SetNextPrimaryFire(iDur)
			self:SetNextSecondaryFire(iDur)

		end


		if self.DrawSound or self.tDrawSoundSequence then -- Network Deploy Sound
			net.Start(sTag)
				net.WriteEntity(self)
				net.WriteInt(1,6)
			net.Broadcast()
		end


		self:ResetInternalVars()


		if self.DeployHooked then
			self:DeployHooked()
		end


		return true
	end


	function SWEP:Equip()
		if not IsValid(self.Owner) then return end

		if not self.Owner:IsPlayer() then -- NPCs cannot have M9kR Weapons! Also prevents invalid spawning
			self:Remove()

			return
		end


		if self.EquipHooked then
			self:EquipHooked()
		end
	end


	function SWEP:Holster()
		if not IsValid(self.Owner) then return end

		if MMM_M9k_IsSinglePlayer then
			self:CallOnClient("Holster") -- Make sure that it runs on the CLIENT! (Singleplayer!)
		end


		if self.HolsterHooked then
			self:HolsterHooked()
		end


		self:ResetInternalVars()


		return true
	end


	function SWEP:OnDrop()

		net.Start(sTag) -- Notify clients that this weapon was dropped
			net.WriteEntity(self)
			net.WriteInt(6,6)
		net.Broadcast()


		if self.OnDropHooked then
			self:OnDropHooked()
		end


		self:ResetInternalVars()

	end


	function SWEP:PrimaryAttack()
		if not IsValid(self.Owner) then return end -- If somehow an NPC got it on their hands or similar.. this will cause huge problems!

		if MMM_M9k_IsSinglePlayer then
			self:CallOnClient("PrimaryAttack")-- Make sure that it runs on the CLIENT! (Singleplayer!)
		end


		if self.Owner:WaterLevel() == 3 and not self.CanFireUnderwater then -- Cannot fire underwater
			self.Owner:EmitSound("weapons/masadamagpul/safety.mp3")

			self:SetNextPrimaryFire(CurTime() + 0.5)

			return
		end


		if not self:CanPrimaryAttack() then return end


		if not MMM_M9k_IsSinglePlayer then

			self:SetNextPrimaryFire(CurTime() + (1 / (self.Primary.RPM / 60)))

			self:TakePrimaryAmmo(1)

		else

			timer.Simple(0,function() -- This needs to be delayed by one tick in singleplayer.

				if not IsValid(self) then return end


				self:SetNextPrimaryFire(CurTime() + (1 / (self.Primary.RPM / 60)))

				self:TakePrimaryAmmo(1)

			end)
		end


		-- Animations
		-- These need to be done for prediction

		if self.IronSightState and not self.bBlockIdleSight then
			self:SendWeaponAnim(self.iIdleAnim)
		else
			self:SendWeaponAnim(not self.iPrimaryAnimOnLast and self.iPrimaryAnim or (self:Clip1() == 1 and self.iPrimaryAnimOnLast) or self.iPrimaryAnim)
		end


		if self.PrimaryAttackHooked then
			self:PrimaryAttackHooked()
		end


		-- Do the stuff


		if not self.bFiresEntity then

			local iDamage = (1 * self.Primary.Damage) * math.Rand(.85,1.3)
			local iSpread = (not self.ShouldDoMoveSpread and self.Primary.Spread) or (self.Owner:GetVelocity():Length() > 100 and self.Primary.Spread * 2) or (self.Owner:KeyDown(IN_DUCK) and self.Primary.Spread / 2) or self.Primary.Spread


			self.Owner:LagCompensation(true) -- Apparently this is called internally by FireBullets, however I get way better results with a high ping when this is called beforehand which means it might not be called internally at all

			self.Owner:FireBullets({
				Num = self.Primary.NumShots or 1,
				Src = self.Owner:GetShootPos(),
				Dir = self.Owner:GetAimVector(),
				Spread = Vector(iSpread or 0,iSpread or 0,0),
				Tracer = not self.bNoTracers and (self.Primary.NumShots == 1 and 1 or 4) or 1e9,
				TracerName = not self.bAr2Tracer and "Tracer" or "AR2Tracer",
				Force = iDamage * 0.3,
				Damage = iDamage,
				AmmoType = self.Primary.Ammo,
				IgnoreEntity = self.Owner
			})

			self.Owner:LagCompensation(false)

		end


		self:AttackAnimation()


		net.Start(sTag) -- Network Primary Effects
			net.WriteEntity(self)
			net.WriteInt(2,6)
		net.Broadcast()


		-- Recoil logic

		local bDuck = self.Owner:KeyDown(IN_DUCK)

		local KickUp			= (not bDuck and self.Primary.KickUp			or self.Primary.KickUp / 2)
		local KickDown			= (not bDuck and self.Primary.KickDown			or self.Primary.KickDown / 2)
		local KickHorizontal	= (not bDuck and self.Primary.KickHorizontal	or self.Primary.KickHorizontal / 2)


		local aRecoil = Angle(math.random(-KickDown,-KickUp),math.random(-KickHorizontal,KickHorizontal),0)

		self.Owner:ViewPunch(aRecoil)

	end


	function SWEP:Reload()
		if not IsFirstTimePredicted() or not self._CanReload then return end


		if self.Owner:GetAmmoCount(self.Primary.Ammo) >= 1 or self:Clip1() >= 1 then


			-- Reset ironsights

			if self.IronSightState then
				self.Owner:SetFOV(0,0.3) -- Setting this at all times is bad as it causes screen spazz
			end

			self.IronSightState = false


			if self.ReloadHooked then
				local bReturn = self:ReloadHooked()

				if bReturn then -- Prevent code from running
					return
				end
			end


			-- Put remaining mag in player inventory
			self.Owner:GiveAmmo(self:Clip1(),self.Primary.Ammo,true)

			self:SetClip1(0)


			self.Owner:SetAnimation(PLAYER_RELOAD)


			if self.tReloadDynamic then -- We are doing a dynamic reload, so we override the DefaultReload function!


				self:SendWeaponAnim(self.iReloadAnim)

				self._CanReload = false


				net.Start(sTag) -- Network Reload Effects
					net.WriteEntity(self)
					net.WriteInt(3,6)
				net.Broadcast()


				local vm = self.Owner:GetViewModel()

				if IsValid(vm) then -- Reload Delay
					local iDelay = CurTime() + vm:SequenceDuration()

					self:SetNextPrimaryFire(iDelay + 0.2) -- The offset is required!

					self.DynamicReloadThink = iDelay
				end

			else -- Standard reload

				self:DefaultReload(self.iReloadAnim)


				if MMM_M9k_IsSinglePlayer then -- Singleplayer is a special snowflake. (This blocks ironsights)

					self.DynamicReloadThink = true


					self:CallOnClient("Reload") -- Make sure its called, this is required


					local vm = self.Owner:GetViewModel()

					if IsValid(vm) then -- Reload Delay
						local iDelay = vm:SequenceDuration()

						self:SetNextPrimaryFire(CurTime() + iDelay + 0.2) -- The offset is required!

						timer.Simple(iDelay,function()
							if not IsValid(self) or not IsValid(self.Owner) or self.Owner:GetActiveWeapon() ~= self then return end

							self.DynamicReloadThink = nil

							net.Start(sTag) -- Notify client that the reload finished
								net.WriteEntity(self)
								net.WriteInt(5,6)
							net.Send(self.Owner)
						end)
					end
				end
			end

			return
		end


		-- Out of ammo!

		if self:GetNextPrimaryFire() < CurTime() and self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0 then
			self.Owner:EmitSound("weapons/masadamagpul/safety.mp3")

			self:SetNextPrimaryFire(CurTime() + 0.5)
		end
	end


	function SWEP:CanPrimaryAttack()

		if self:GetNextPrimaryFire() > CurTime() then
			return false
		end


		if self:Clip1() <= 0 then

			if MMM_M9k_IsSinglePlayer and self.IsScoping then -- Singleplayer is special.
				self:ResetInternalVarsHooked()
			end

			self:Reload()

			return false
		end


		return true

	end


	function SWEP:IronSight()
		if self.Owner:GetViewEntity() ~= self.Owner or self.DynamicReloadThink then return end


		if self.bBlockIronSights then
			if self.IronSightState then
				self.IronSightState = false
			end

			return
		end


		if self.Owner:KeyPressed(IN_ATTACK2) and not self.IronSightState then
			self.IronSightState = true

			self.Owner:SetFOV(80,0.2)
		elseif self.Owner:KeyReleased(IN_ATTACK2) then
			self.IronSightState = false

			self.Owner:SetFOV(0,0.1)
		end
	end


	function SWEP:Think()


		self:IronSight()


		if self.DynamicReloadThink and type(self.DynamicReloadThink) == "number" and CurTime() > self.DynamicReloadThink then -- Number check is required for Singleplayer compatibility


			-- Finish reloading

			local iAmount = self.Primary.ClipSize
			local sType = self.Primary.Ammo


			self:SetClip1(self.Owner:GetAmmoCount(sType) >= iAmount and iAmount or self.Owner:GetAmmoCount(sType))

			self.Owner:SetAmmo(self.Owner:GetAmmoCount(sType) - iAmount,sType)


			self._CanReload = true
			self.DynamicReloadThink = nil


			if self.PostReloadCall then
				self:PostReloadCall()
			end


			-- Notify clients that the reload finished

			net.Start(sTag)
				net.WriteEntity(self)
				net.WriteInt(5,6)
			net.Broadcast()
		end


		if self.ThinkHooked then
			self:ThinkHooked()
		end
	end
end

-- ----- ----- ----- ----- ------- ----- ----- ----- ----- -----
-- CLIENT
-- ----- ----- ----- ----- ------- ----- ----- ----- ----- -----

if CLIENT then

	SWEP.AimMul = 0.2
	SWEP.LastCurTick = 0
	SWEP.PrimaryAnimationInt = 0
	SWEP.IsReloading = false -- Used for dynamic reload locking


	-- Optimizations
	angle_zero = Angle(0,0,0) -- Make sure nothing else fucked with this

	SWEP.ViewAngIdleRead = angle_zero
	SWEP.ViewAngStart = 0


	local cvar_LeftHanded = CreateConVar("m9k_lefthanded","0",FCVAR_ARCHIVE,"0 = Right handed - 1 = Left handed",0,1)

	cvars.RemoveChangeCallback("m9k_lefthanded_callback")
	cvars.AddChangeCallback("m9k_lefthanded",function()

		local me = LocalPlayer()
		if not IsValid(me) then return end

		local wep = me:GetActiveWeapon()
		if not IsValid(wep) or not wep._IsM9kRemasteredBased or wep._UsesCustomModels then return end


		local iVar = cvar_LeftHanded:GetInt()

		wep.ViewOriginal = wep.ViewOriginal or wep.ViewModelFlip

		wep.ViewModelFlip = (iVar == 1 and wep.ViewOriginal) or not wep.ViewOriginal

	end,"m9k_lefthanded_callback")


	-- Variables
	local tShellTypes = {
		["pistol"] = "ShellEject",
		["smg"] = "RifleShellEject",
		["ar2"] = "RifleShellEject",
		["shotgun"] = "ShotgunShellEject"
	}


	local fFixViewMaterials = function()

		local me = LocalPlayer()
		if not IsValid(me) then return end -- During joining / Fullupdate, this is not valid.


		local vm = me:GetViewModel()
		if not IsValid(vm) then return end


		for k = 0,50 do -- Reset Material overrides
			vm:SetSubMaterial(k,"")
		end


		local eWep_Old = me:GetActiveWeapon()


		-- The CLIENT is ALWAYS at least one tick behind which means we have to wait for the new Weapon to become valid first.

		hook.Add("Tick",sTagFix,function()

			local eWep_New = me:GetActiveWeapon()


			if eWep_Old ~= eWep_New or MMM_M9k_IsSinglePlayer then -- Singleplayer is ahead by one tick.

				hook.Remove("Tick",sTagFix)


				if not IsValid(eWep_New) or not eWep_New._IsM9kRemasteredBased then return end


				-- Replace missing materials with sleeve texture (gj original creators btw, 11/10)

				for k,v in ipairs(vm:GetMaterials()) do
					if v == "___error" then
						vm:SetSubMaterial(k - 1,"models/weapons/v_models/hands/sleeve_black_1")
					end
				end

			end
		end)
	end


	net.Receive(sTagFix,fFixViewMaterials)


	-- Networking

	net.Receive(sTag,function() -- This is a mess, thanks garry!
		local eWep = net.ReadEntity()
		if not IsValid(eWep) or not eWep._IsM9kRemasteredBased then return end

		local iEvent = net.ReadInt(6)

		if iEvent == 1 and (eWep.DrawSound or eWep.tDrawSoundSequence) then -- Deploy sound!

			if IsValid(eWep.Owner) and not (eWep.DrawCantHear and eWep.Owner == LocalPlayer() and eWep.Owner:GetViewEntity() == eWep.Owner) then

				if not eWep.tDrawSoundSequence then

					eWep.Owner:EmitSound(eWep.DrawSound,65)

				else

					local iStart = CurTime()
					local tPlayed = {}


					local sStr = sTag .. "_Deploy_" .. eWep.OurIndex


					hook.Add("Tick",sStr,function() -- The fact I have to do this is just sad. Improvising a Think here is.. needed


						-- This hook gets removed as soon as the weapon / owner becomes invalid or the deploy finished / was canceled / or they're reloading the weapon


						if IsValid(eWep) and IsValid(eWep.Owner) and eWep.Owner:GetActiveWeapon() == eWep and not eWep.IsReloading then

							local iPassed = CurTime() - iStart


							for k,v in ipairs(eWep.tDrawSoundSequence) do

								if tPlayed[k] then -- We already played that one
									goto continued
								end


								if iPassed > v.iDelay then


									eWep.Owner:EmitSound(v.sSound,v.iVolume or 70,math.random(95,105),1,CHAN_ITEM) -- Random pitch = Better


									tPlayed[k] = true


									if k == #eWep.tDrawSoundSequence then
										hook.Remove("Tick",sStr)
									end
								end


								::continued:: -- Loop jump

							end


							return

						end

						hook.Remove("Tick",sStr)

					end)
				end

			end
		elseif iEvent == 2 then -- Primary Firing Effects!
			eWep:PrimaryShootEffects()
		elseif iEvent == 3 then -- Dynamic Reload Effects!
			local bState = IsValid(eWep.Owner) and eWep.Owner == LocalPlayer() and true or nil

			if bState then
				eWep:Reload(true)
			else
				eWep:ReloadDynamic()
			end
		elseif iEvent == 4 then -- Apply balance changes!
			eWep:ApplyWeaponBalance()
		elseif iEvent == 5 then -- Reload finished notify!
			eWep.IsReloading = false
			eWep.bCanFireOverride = true -- This is needed due to ping
		elseif iEvent == 6 then -- Weapon was dropped!
			eWep:ResetInternalVars()
		end
	end)


	function SWEP:Initialize()

		self:SetHoldType(self.HoldType)

		self:ApplyWeaponBalance()


		self.OurIndex = self:EntIndex() -- Only needed on CLIENT for the muzzle effects
		self.WepSelectIcon = surface.GetTextureID(string.gsub("vgui/hud/name","name",self:GetClass()))


		-- Instead of overwriting the Initialize function, we expand on it!

		if self.InitializeHooked then
			self:InitializeHooked()
		end


		if self.Owner == LocalPlayer() then
			self:SendWeaponAnim(self.iIdleAnim)

			if self.Owner:GetActiveWeapon() == self then
				self:Deploy()
			end
		end
	end


	function SWEP:ResetInternalVars() -- Convenience
		if self.IronSightState and IsValid(self.Owner) then
			self.Owner:SetFOV(0,0.3) -- Setting this at all times is bad as it causes screen spazz
		end


		self.IronSightState = false
		self.DrawCrosshair = true


		self.AimMul = 0.2
		self.LastCurTick = 0
		self.PrimaryAnimationInt = 0
		self.IsReloading = false
		self.bCanFireOverride = nil


		self:SetHoldType(self.HoldType)


		self.ViewFlipped = false


		if self.ResetInternalVarsHooked then
			self:ResetInternalVarsHooked()
		end
	end


	function SWEP:Deploy()
		if not IsValid(self.Owner) then return end

		self:SetHoldType(self.HoldType)


		local vm = self.Owner:GetViewModel()

		if IsValid(vm) then -- Anything past this should only run on the client that has the gun


			if cvar_LeftHanded:GetInt() == 1 and not self.ViewFlipped and not self._UsesCustomModels then
				self.ViewModelFlip = not self.ViewModelFlip

				self.ViewFlipped = true
			end


			self:ResetInternalVars()


			self:SendWeaponAnim(ACT_VM_DRAW)


			local iDur = CurTime() + vm:SequenceDuration() + 0.2 -- Action delay

			self:SetNextPrimaryFire(iDur)
			self:SetNextSecondaryFire(iDur)

		end


		if self.DeployHooked then
			self:DeployHooked()
		end


		return true
	end


	function SWEP:Equip()
		if self.EquipHooked then
			self:EquipHooked()
		end
	end


	function SWEP:Holster()

		self:ResetInternalVars()

		if self.HolsterHooked then
			self:HolsterHooked()
		end

		return true
	end


	function SWEP:PrimaryAttack()
		if not IsValid(self.Owner) then return end


		if self.Owner:WaterLevel() == 3 and not self.CanFireUnderwater then -- Cannot fire underwater
			self:SetNextPrimaryFire(CurTime() + 0.2)

			return
		end


		if not self:CanPrimaryAttack() then return end


		self:SetNextPrimaryFire(CurTime() + (1 / (self.Primary.RPM / 60)))


		if self.IronSightState then -- When we aim down the sights the muzzleflash and shell ejection need to be simulated


			self:SendWeaponAnim(not self.bBlockIdleSight and self.iIdleAnim or (not self.iPrimaryAnimOnLast and self.iPrimaryAnim or (self:Clip1() == 1 and self.iPrimaryAnimOnLast) or self.iPrimaryAnim))


			if IsFirstTimePredicted() or MMM_M9k_IsSinglePlayer then


				local vm = self.Owner:GetViewModel()

				if IsValid(vm) then


					local vmAttachment = vm:GetAttachment("1")

					if istable(vmAttachment) then -- Viewmodel muzzleflash


						if not self.bBlockMuzzleFlash then

							local obj_EffectData = EffectData()

							obj_EffectData:SetScale(1)
							obj_EffectData:SetEntity(vm)
							obj_EffectData:SetMagnitude(1)
							obj_EffectData:SetAttachment(1)
							obj_EffectData:SetOrigin(vmAttachment.Pos)
							obj_EffectData:SetAngles(vmAttachment.Ang)

							util.Effect("CS_MuzzleFlash",obj_EffectData)

						end


						if not MMM_M9k_IsSinglePlayer and not self.bBlockShellEject then -- Since shell ejections don't work in singleplayer, save some cycles! // Shell ejections are blocked


							local obj_Shell = tShellTypes[self.HoldType] or false

							if obj_Shell then -- Viewmodel shell ejection


								vmAttachment = vm:GetAttachment("2")

								if istable(vmAttachment) then

									local obj_EffectData = EffectData()

									obj_EffectData:SetAttachment(2)
									obj_EffectData:SetOrigin(vmAttachment.Pos)
									obj_EffectData:SetAngles(vmAttachment.Ang)

									util.Effect(obj_Shell,obj_EffectData,true,true)

								end
							end
						end
					end
				end
			end

			self.PrimaryAnimationInt = 3 -- Recoil

		else
			self:SendWeaponAnim(self.iPrimaryAnim)
		end


		--self:MuzzleFlash() -- Creates a cheap dynamic light, only visible to the person firing which is why only the client calls it


		self:PrimaryShootEffects(true) -- Call for owner only (There is no ping delay for them that way!)


		self:TakePrimaryAmmo(1)


		if MMM_M9k_IsSinglePlayer then return end -- In singleplayer, we don't need to continue


		-- Do the stuff (Prediction)

		self:AttackAnimation()


		if self.bFiresEntity then return end -- We have a custom firing logic


		-- Fire a bullet on the CLIENT. Note that the impact position differs from the server! Just like every other SWEP out there pretty much

		local iSpread = ( (not self.ShouldDoMoveSpread and self.Primary.Spread) or (self.Owner:GetVelocity():Length() > 100 and self.Primary.Spread * 2) or (self.Owner:KeyDown(IN_DUCK) and self.Primary.Spread / 2) or self.Primary.Spread )


		self.Owner:FireBullets({
			Num = self.Primary.NumShots or 1,
			Src = self.Owner:GetShootPos(),
			Dir = self.Owner:GetAimVector(),
			Spread = Vector(iSpread or 0,iSpread or 0,0),
			Tracer = not self.bNoTracers and (self.Primary.NumShots == 1 and 1 or 4) or 1e9,
			TracerName = not self.bAr2Tracer and "Tracer" or "AR2Tracer",
			Force = self.Primary.Damage * 0.3,
			Damage = self.Primary.Damage,
			AmmoType = self.Primary.Ammo,
			IgnoreEntity = self.Owner
		})
	end


	function SWEP:PrimaryShootEffects(bBool)
		if (not bBool and self.Owner == LocalPlayer()) then return end -- It already played for them!


		self:EmitSound(self.Primary.Sound,self.Primary.SoundVolume or 75,math.random(95,105))


		-- Third person effects / Multiplayer effects

		if self.bBlockMuzzleFlash then return end


		if IsValid(self.Owner) then


			-- Recoil logic

			local bDuck = self.Owner:KeyDown(IN_DUCK)

			local KickUp			= (not bDuck and self.Primary.KickUp			or self.Primary.KickUp / 2)
			local KickDown			= (not bDuck and self.Primary.KickDown			or self.Primary.KickDown / 2)
			local KickHorizontal	= (not bDuck and self.Primary.KickHorizontal	or self.Primary.KickHorizontal / 2)


			local aRecoil = Angle(math.random(-KickDown,-KickUp),math.random(-KickHorizontal,KickHorizontal),0)

			--self.Owner:ViewPunch(aRecoil) -- Not needed.


			local aEyes = self.Owner:EyeAngles()
				aEyes:SetUnpacked(aEyes.p + aRecoil.p,aEyes.y + aRecoil.y,0)

			self.Owner:SetEyeAngles(aEyes)



			--local vm = self.Owner:GetViewModel() -- All of this is commented out for now since not restricting it seems to be better.

			--if not IsValid(vm) or (IsValid(vm) and self.Owner:GetViewEntity() ~= self.Owner) then -- Everyone except the Owner when they are in first person


				-- Muzzle flash

				local obj_DynLight = DynamicLight(self.OurIndex)

				if obj_DynLight then

					obj_DynLight.pos = self.Owner:GetShootPos() + self.Owner:EyeAngles():Forward() * 30

					obj_DynLight.r = self.MuzzleFlashCol.r
					obj_DynLight.g = self.MuzzleFlashCol.g
					obj_DynLight.b = self.MuzzleFlashCol.b

					obj_DynLight.brightness = 6
					obj_DynLight.Size = 128 * (self.DynamicLightScale or 1)

					obj_DynLight.Decay = 2000
					obj_DynLight.DieTime = CurTime()

				end


				-- Here is where the muzzle fire would go, but I cba to code that right now, you do it, yes??

			--end
		end
	end


	function SWEP:Reload(bNet) -- Reloading is handled by the server unless there is no dynamic reload defined

		if not self.tReloadDynamic then
			if self.Owner:GetAmmoCount(self.Primary.Ammo) >= 1 or self:Clip1() >= 1 then


				-- Reset ironsights

				if self.IronSightState then
					self.Owner:SetFOV(0,0.3) -- Setting this at all times is bad as it causes screen spazz
				end

				self.IronSightState = false
				self.DrawCrosshair = true


				if self.ReloadHooked then
					local bReturn = self:ReloadHooked()

					if bReturn then -- Prevent code from running
						return
					end
				end


				self.Owner:SetAnimation(PLAYER_RELOAD)

				self:DefaultReload(self.iReloadAnim)


				if MMM_M9k_IsSinglePlayer then -- Singleplayer is a special snowflake. (This blocks ironsights)
					self.IsReloading = true
				end

			end

			return
		end


		if not bNet then return end -- Bypass prediction


		-- Reset ironsights

		if self.IronSightState then
			self.Owner:SetFOV(0,0.3) -- Setting this at all times is bad as it causes screen spazz
		end

		self.IronSightState = false
		self.DrawCrosshair = true


		if self.ReloadHooked then
			self:ReloadHooked()
		end


		self:ReloadDynamic(true) -- Call for owner only (There is no ping delay for them that way!)


		self.Owner:SetAnimation(PLAYER_RELOAD)
		self:SendWeaponAnim(self.iReloadAnim)

	end


	function SWEP:ReloadDynamic(bBool)
		if not bBool and (self.Owner == LocalPlayer()) then return end -- It already played for them!


		-- If the weapon supports dynamic reload sounds then.. make them dynamic!

		if self.tReloadDynamic then

			self:SendWeaponAnim(self.iReloadAnim) -- For some reason we have to call this again for listen hosts


			self.IsReloading = true


			local iStart = CurTime()
			local tPlayed = {}


			local sStr = sTag .. "_Reload_" .. self.OurIndex


			hook.Add("Tick",sStr,function() -- The fact I have to do this is just sad. Improvising a Think here is.. needed


				-- This hook gets removed as soon as the weapon / owner becomes invalid or the reload finished / was canceled


				if self.IsReloading and IsValid(self) and IsValid(self.Owner) then

					local iPassed = CurTime() - iStart


					for k,v in ipairs(self.tReloadDynamic) do

						if tPlayed[k] then -- We already played that one
							goto continued
						end


						if iPassed > v.iDelay then


							self.Owner:EmitSound(v.sSound,v.iVolume or 70,math.random(95,105),1,CHAN_ITEM) -- Random pitch = Better


							tPlayed[k] = true


							if k == #self.tReloadDynamic then
								hook.Remove("Tick",sStr)
							end
						end


						::continued:: -- Loop jump

					end


					return

				end

				hook.Remove("Tick",sStr)

			end)
		end
	end


	function SWEP:CanPrimaryAttack()

		if self:GetNextPrimaryFire() > CurTime() or (self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0 and self:Clip1() <= 0) then
			return false
		end


		if self:Clip1() <= 0 then

			if MMM_M9k_IsSinglePlayer and self.IsScoping then -- Singleplayer is special.
				self:ResetInternalVarsHooked()
			end


			self:Reload() -- Needs to be called here as well for prediction for non-dynamic reload weapons!


			return false

		end


		return true

	end


	function SWEP:IronSight()
		if self.Owner:GetViewEntity() ~= self.Owner or self.IsReloading then return end


		if self.bBlockIronSights then
			if self.IronSightState then
				self.IronSightState = false
			end

			return
		end


		if self.Owner:KeyPressed(IN_ATTACK2) and not self.IronSightState then
			self.IronSightState = true
			self.DrawCrosshair = false

			self.LastCurTick = RealTime()
		elseif self.Owner:KeyReleased(IN_ATTACK2) then
			self.IronSightState = false

			self.DrawCrosshair = true
		end
	end


	function SWEP:Think()

		self:IronSight()

		if self.ThinkHooked then
			self:ThinkHooked()
		end
	end


	function SWEP:CalcViewModelView(_,vPos,aAng,vEye,aEye)
		if not IsValid(self.Owner) then return end

		if not self.IronSightState and not self.IronSightsPos or (not self.IronSightState and self.AimMul == 0) then -- This reduces the non-ironsighted sway

			vPos:SetUnpacked(vPos.x + (vEye.x - vPos.x) * 0.55,vPos.y + (vEye.y - vPos.y) * 0.55,vPos.z + (vEye.z - vPos.z) * 0.55)
			aAng:SetUnpacked(aAng.p + (aEye.p - aAng.p) * 0.55,aAng.y + (aEye.y - aAng.y) * 0.55,aAng.r + aEye.r * 0.55)


			-- Add a bit of swaying to the viewmodel, this simulates an idle animation!
			-- This is way better than using pre-made animations!
			-- Idle Sway

			local iCur = RealTime()

			if self.ViewAngStart < iCur then
				self.ViewAngStart = iCur + math.Rand(0.2,1.1)

				self.LastViewAngTick = iCur

				self.ViewAngDestination = AngleRand(-0.2,0.2)
			end


			self.ViewAngIdleRead = LerpAngle(iCur - self.LastViewAngTick,self.ViewAngIdleRead,self.ViewAngDestination) + (AngleRand() * 0.00001) + (AngleRand() * 0.00001)

			self.LastViewAngTick = iCur


			aAng:SetUnpacked(aAng.p + self.ViewAngIdleRead.p,aAng.y + self.ViewAngIdleRead.y,aAng.r + self.ViewAngIdleRead.r)


			return vPos, aAng
		end


		-- We do want a bit of sway just not so extreme
		vPos:SetUnpacked(vPos.x + (vEye.x - vPos.x) * 0.05,vPos.y + (vEye.y - vPos.y) * 0.05,vPos.z + (vEye.z - vPos.z) * 0.05)
		aAng:SetUnpacked(aAng.p + (aEye.p - aAng.p) * 0.25,aAng.y + (aEye.y - aAng.y) * 0.25,aAng.r + aEye.r * 0.25)


		self.AimMul = self.IronSightState and (self.AimMul + math.abs(self.LastCurTick - RealTime()) * 5) or (self.AimMul - math.abs(self.LastCurTick - RealTime()) * 5)
		self.AimMul = math.Clamp(self.AimMul,0,1)


		self.LastCurTick = RealTime()


		if self.IronSightsAng then
			aAng:RotateAroundAxis(aAng:Right(),self.IronSightsAng.x * self.AimMul)
			aAng:RotateAroundAxis(aAng:Up(),self.IronSightsAng.y * self.AimMul)
			aAng:RotateAroundAxis(aAng:Forward(),self.IronSightsAng.z * self.AimMul)
		end


		if self.IronSightsPos then
			vPos = vPos + self.IronSightsPos.x * aAng:Right() * self.AimMul
			vPos = vPos + self.IronSightsPos.y * aAng:Forward() * self.AimMul - (aAng:Forward() * math.Clamp(self.PrimaryAnimationInt,0,10))
			vPos = vPos + self.IronSightsPos.z * aAng:Up() * self.AimMul
		end


		if self.PrimaryAnimationInt >= 0 then
			self.PrimaryAnimationInt = self.PrimaryAnimationInt - 0.05
		end


		return vPos, aAng
	end


	function SWEP:FireAnimationEvent(_,_,event) -- Shell ejections
		if event == 5001 or event == 5011 or event == 5021 or event == 5031 then
			if self.Owner:GetViewEntity() ~= self.Owner then return true end


			if self.bBlockMuzzleFlash then return true end -- No custom muzzleflash!


			local vm = self.Owner:GetViewModel()
			if not IsValid(vm) then return end

			local vmAttachment = vm:GetAttachment("1")
			if not istable(vmAttachment) then return end


			local obj_EffectData = EffectData()

			obj_EffectData:SetAttachment(1)
			obj_EffectData:SetEntity(vm)
			obj_EffectData:SetScale(1)
			obj_EffectData:SetMagnitude(1)
			obj_EffectData:SetOrigin(vmAttachment.Pos)
			obj_EffectData:SetAngles(vmAttachment.Ang)

			util.Effect("CS_MuzzleFlash",obj_EffectData)


			return true
		end
	end
end

-- ----- ----- ----- ----- ------- ----- ----- ----- ----- -----
-- SHARED
-- ----- ----- ----- ----- ------- ----- ----- ----- ----- -----

function SWEP:ApplyWeaponBalance()

	if ConVar_BalanceMode:GetInt() == 0 and self.LegacyBalance and self.LegacyBalance.Primary then -- Apply original balance!

		local tLegacy = self.LegacyBalance.Primary -- Optimization

		self.Primary.Original = table.Copy(self.Primary) -- Store old balancing


		--															Fallbacks

		self.Primary.RPM				= tLegacy.RPM				or self.Primary.RPM
		self.Primary.ClipSize			= tLegacy.ClipSize			or self.Primary.ClipSize
		self.Primary.KickUp				= tLegacy.KickUp			or self.Primary.KickUp
		self.Primary.KickDown			= tLegacy.KickDown			or self.Primary.KickDown
		self.Primary.KickHorizontal		= tLegacy.KickHorizontal	or self.Primary.KickHorizontal
		self.Primary.Automatic			= tLegacy.Automatic			or self.Primary.Automatic
		self.Primary.Ammo				= tLegacy.Ammo				or self.Primary.Ammo
		self.Primary.NumShots			= tLegacy.NumShots			or self.Primary.NumShots
		self.Primary.Damage				= tLegacy.Damage			or self.Primary.Damage
		self.Primary.Spread				= tLegacy.Spread			or self.Primary.Spread


		self.Primary.SpreadBefore = self.Primary.Spread


	elseif self.Primary.Original then -- Restore old balance

		self.Primary = self.Primary.Original

		self.Primary.SpreadBefore = self.Primary.Spread

	end
end