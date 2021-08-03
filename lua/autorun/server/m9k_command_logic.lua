if SERVER then

	-- Base stuff
	local cVar_M9k_UpdateInformation = CreateConVar("m9k_annoying_serverprint","1",FCVAR_ARCHIVE,"Set this to 0 to disable the magazine and reserve information",0,1)

	if cVar_M9k_UpdateInformation:GetInt() == 1 then
		MsgC(Color(255,128,128),"[M9k Remastered]: Server owners beware!! If your server runs DarkRP you might want to set the following commands to 0\n\t",Color(255,255,255),"m9k_spawn_with_ammo\n\tm9k_spawn_with_reserve\n",Color(255,128,128),"> By default, these commands are turned on meaning all M9k related weapons will be forced to start with a full magazine and ammo in reserve!!!\n")
	end



	-- Ammo based stuff
	local cVar_M9k_WeaponsSpawnWithAmmo = CreateConVar("m9k_spawn_with_ammo","1",FCVAR_ARCHIVE,"When set to 1, any weapon acquired will spawn with a full magazine",0,1)
	local cVar_M9k_WeaponsSpawnWithReserve = CreateConVar("m9k_spawn_with_reserve","1",FCVAR_ARCHIVE,"When set to 1, any weapon acquired will give its' ammo type to the player",0,1)



	-- Scope-based stuff
	local cVar_M9k_WeaponsNoZooms = CreateConVar("m9k_zoomstages","0",FCVAR_ARCHIVE,"When set to 1, scoped weapons will make use of their zoom stages.",0,1)

	cvars.RemoveChangeCallback("m9k_zoomstages_callback")
	cvars.AddChangeCallback("m9k_zoomstages",function(_,_,iNew)
		iNew = iNew or 0
		iNew = tonumber(iNew)

		if iNew <= 0 then iNew = 0 end
		if iNew >= 1 then iNew = 1 end

		local bState = (iNew == 0 and true or false)

		-- Here we update all currently existing weapons
		for _,v in ipairs(ents.GetAll()) do
			if v:IsWeapon() and string.Left(v:GetClass(),4) == "m9k_" then
				v:SetNWBool("M9kr_OvrZoomStage",bState) -- This needs to be networked to clients for some code
				v.OverrideMaxZoomStage = bState
			end
		end
	end,"m9k_zoomstages_callback")

	local cVar_M9k_WeaponsNoToggleZooms = CreateConVar("m9k_zoomtoggle","0",FCVAR_ARCHIVE,"When set to 1, scoped weapons will remain scoped until the secondary attack key is pressed again.",0,1)

	cvars.RemoveChangeCallback("m9k_zoomtoggle_callback")
	cvars.AddChangeCallback("m9k_zoomtoggle",function(_,_,iNew)
		iNew = iNew or 0
		iNew = tonumber(iNew)

		if iNew <= 0 then iNew = 0 end
		if iNew >= 1 then iNew = 1 end

		-- Here we update all currently existing weapons
		for _,v in ipairs(ents.GetAll()) do
			if v:IsWeapon() and string.Left(v:GetClass(),4) == "m9k_" then
				v:SetNWBool("M9kr_OvrZoomToggl",bState) -- This needs to be networked to clients for some code
				v.OverrideZoomToggle = (iNew == 0 and true or false)
			end
		end
	end,"m9k_zoomtoggle_callback")

	-- -----  -----  -----  -----  ----- --

	local iAmmoMultiplier = 3 -- We take the magazine size and give that to the player times the multiplier (Default: 3 in magazine = 9 in reserve)

	hook.Add("WeaponEquip","m9k_mmm_command_logic",function(eWep,ePly)
		timer.Simple(0,function() -- Needs to happen in the next tick due to prediction stuffs
			if not IsValid(eWep) or not IsValid(ePly) or not eWep._IsM9kRemasteredBased then return end

			if cVar_M9k_WeaponsSpawnWithAmmo:GetInt() == 1 then -- Whether or not the weapon should start fully loaded
				eWep:SetClip1(eWep.Primary.ClipSize or 0)
				eWep:SetClip2(eWep.Secondary.ClipSize or 0)
			end

			if cVar_M9k_WeaponsSpawnWithReserve:GetInt() == 1 then -- Whether the player should receive ammo for this weapon
				ePly:GiveAmmo((eWep.Primary.ClipSize or 0) * iAmmoMultiplier,eWep.Primary.Ammo or "",true)
				ePly:GiveAmmo((eWep.Secondary.ClipSize or 0) * iAmmoMultiplier,eWep.Secondary.Ammo or "",true)
			end

			if cVar_M9k_WeaponsNoZooms:GetInt() == 0 then -- Zooms are disabled, so all weapons only have ONE zoom which is their max!
				eWep:SetNWBool("M9kr_OvrZoomStage",true)
				eWep.OverrideMaxZoomStage = true
			end

			if cVar_M9k_WeaponsNoToggleZooms:GetInt() == 0 then -- If set to 0, scoped weapons will only remain scoped while holding the secondary attack key
				eWep:SetNWBool("M9kr_OvrZoomToggl",true)
				eWep.OverrideZoomToggle = true
			end
		end)
	end)
end