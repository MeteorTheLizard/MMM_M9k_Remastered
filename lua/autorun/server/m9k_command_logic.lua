if SERVER then
	local cVar_M9k_WeaponsSpawnWithAmmo = CreateConVar("m9k_spawn_with_ammo","1",FCVAR_ARCHIVE,"When set to 1, any weapon acquired will spawn with a full magazine",0,1)
	local cVar_M9k_WeaponsSpawnWithReserve = CreateConVar("m9k_spawn_with_reserve","1",FCVAR_ARCHIVE,"When set to 1, any weapon acquired will give its' ammo type to the player",0,1)
	local cVar_M9k_UpdateInformation = CreateConVar("m9k_annoying_serverprint","1",FCVAR_ARCHIVE,"Set this to 0 to disable the magazine and reserve information",0,1)

	local iAmmoMultiplier = 3 -- We take the magazine size and give that to the player times the multiplier (Default: 3 in magazine = 9 in reserve)

	if cVar_M9k_UpdateInformation:GetInt() == 1 then
		MsgC(Color(255,128,128),"[M9k Remastered]: Server owners beware!! If your server runs DarkRP you might want to set the following commands to 0\n\t",Color(255,255,255),"m9k_spawn_with_ammo\n\tm9k_spawn_with_reserve\n",Color(255,128,128),"> By default, these commands are turned on meaning all M9k related weapons will be forced to start with a full magazine and ammo in reserve!!!\n")
	end

	hook.Add("WeaponEquip","m9k_ammo_logic",function(eWep,ePly)
		timer.Simple(0,function() -- Needs to happen in the next tick due to prediction stuffs
			if not IsValid(eWep) or not IsValid(ePly) or not eWep._IsM9kRemasteredBased then return end

			if cVar_M9k_WeaponsSpawnWithAmmo:GetInt() == 1 then
				eWep:SetClip1(eWep.Primary.ClipSize or 0)
				eWep:SetClip2(eWep.Secondary.ClipSize or 0)
			end

			if cVar_M9k_WeaponsSpawnWithReserve:GetInt() == 1 then
				ePly:GiveAmmo((eWep.Primary.ClipSize or 0) * iAmmoMultiplier,eWep.Primary.Ammo or "",true)
				ePly:GiveAmmo((eWep.Secondary.ClipSize or 0) * iAmmoMultiplier,eWep.Secondary.Ammo or "",true)
			end
		end)
	end)
end