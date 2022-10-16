AddCSLuaFile()

local sTag = "M9kR_Initialize_Addon"

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- --
-- Base Init
-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- --

hook.Add("PreGamemodeLoaded",sTag,function()

	hook.Remove("PreGamemodeLoaded",sTag)


	MMM_M9k_IsBaseInstalled = true -- Absolutely avoid global variables like this whenever possible and if there is no way around it, make it as unique as possible.


	if SERVER then


		MsgC(Color(255,128,128),[[
 ________________________________________________________________________________________________________________________
|  __  __  ___  _  _      ____  ____  __  __    __    ___  ____  ____  ____  ____  ____  
| (  \/  )/ _ \( )/ )()  (  _ \( ___)(  \/  )  /__\  / __)(_  _)( ___)(  _ \( ___)(  _ \ 
|  )    ( \_  / )  (      )   / )__)  )    (  /(__)\ \__ \  )(   )__)  )   / )__)  )(_) )
| (_/\/\_) (_/ (_)\_)()  (_)\_)(____)(_/\/\_)(__)(__)(___/ (__) (____)(_)\_)(____)(____/ 
|
|__ Made with love. -MeteorTheLizard.
|
|
|__ All ConVars below are Serverside and dictate the behavior on the clients.
|
|__ RP Servers >> We recommend setting m9k_balancemode to 1 and both m9k_spawn_with_ammo, m9k_spawn_with_reserve to 0.
|
|__ m9k_balancemode		Disable/Enable Remastered Balance.	0 = Legacy | 1 = Remastered
|
|__ m9k_spawn_with_ammo		Disable/Enable Ammo in Magazine.	0 = No Ammo | 1 = Full Magazine on Equip
|
|__ m9k_spawn_with_reserve	Disable/Enable Giving Ammo on pickup.	0 = No Ammo | 1 = 3 Magazines on Equip
|
|__ m9k_zoomstages		Disable/Enable Zoomstages on weapons.	0 = One zoom level | 1 = Multiple zoom levels
|
|__ m9k_zoomtoggle		Disable/Enable Zoomtoogle on weapons.	0 = Hold to zoom | 1 = Toggle to zoom/unzoom
|

]])


		resource.AddWorkshop("2169649722") -- If you don't want others to automatically download M9k Remastered content on joining, remove this line or comment it out.

	end


	if CLIENT then

		MsgC(Color(255,128,128),[[
 ________________________________________________________________________________________________________________________
|  __  __  ___  _  _      ____  ____  __  __    __    ___  ____  ____  ____  ____  ____  
| (  \/  )/ _ \( )/ )()  (  _ \( ___)(  \/  )  /__\  / __)(_  _)( ___)(  _ \( ___)(  _ \ 
|  )    ( \_  / )  (      )   / )__)  )    (  /(__)\ \__ \  )(   )__)  )   / )__)  )(_) )
| (_/\/\_) (_/ (_)\_)()  (_)\_)(____)(_/\/\_)(__)(__)(___/ (__) (____)(_)\_)(____)(____/ 
|
|__ Made with love. -MeteorTheLizard.
|
|
|__ Console Commands:
|
|__ m9k_lefthanded		Disable/Enable lefthanded weapons.	0 = Right-handed | 1 = Left-handed
|

]])

	end


end) -- This is needed for M9k Remastered weapon packs to tell them that the base is installed and loaded.

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- --
-- Kill icons
-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- --

if CLIENT then

	local tData = {
		["m9k_acr"] = "vgui/hud/m9k_acr",
		["m9k_ak47"] = "vgui/hud/m9k_ak47",
		["m9k_ak74"] = "vgui/hud/m9k_ak74",
		["m9k_amd65"] = "vgui/hud/m9k_amd65",
		["m9k_an94"] = "vgui/hud/m9k_an94",
		["m9k_auga3"] = "vgui/hud/m9k_auga3",
		["m9k_f2000"] = "vgui/hud/m9k_f2000",
		["m9k_fal"] = "vgui/hud/m9k_fal",
		["m9k_famas"] = "vgui/hud/m9k_famas",
		["m9k_g3a3"] = "vgui/hud/m9k_g3a3",
		["m9k_g36"] = "vgui/hud/m9k_g36",
		["m9k_l85"] = "vgui/hud/m9k_l85",
		["m9k_m4a1"] = "vgui/hud/m9k_m4a1",
		["m9k_m14sp"] = "vgui/hud/m9k_m14sp",
		["m9k_m16a4_acog"] = "vgui/hud/m9k_m16a4_acog",
		["m9k_m416"] = "vgui/hud/m9k_m416",
		["m9k_scar"] = "vgui/hud/m9k_scar",
		["m9k_tar21"] = "vgui/hud/m9k_tar21",
		["m9k_val"] = "vgui/hud/m9k_val",
		["m9k_vikhr"] = "vgui/hud/m9k_vikhr",
		["m9k_winchester73"] = "vgui/hud/m9k_winchester73",
		["m9k_1887winchester"] = "vgui/hud/m9k_1887winchester",
		["m9k_1897winchester"] = "vgui/hud/m9k_1897winchester",
		["m9k_ares_shrike"] = "vgui/hud/m9k_ares_shrike",
		["m9k_aw50"] = "vgui/hud/m9k_aw50",
		["m9k_barret_m82"] = "vgui/hud/m9k_barret_m82",
		["m9k_browningauto5"] = "vgui/hud/m9k_browningauto5",
		["m9k_contender"] = "vgui/hud/m9k_contender",
		["m9k_dbarrel"] = "vgui/hud/m9k_dbarrel",
		["m9k_dragunov"] = "vgui/hud/m9k_dragunov",
		["m9k_fg42"] = "vgui/hud/m9k_fg42",
		["m9k_intervention"] = "vgui/hud/m9k_intervention",
		["m9k_ithacam37"] = "vgui/hud/m9k_ithacam37",
		["m9k_jackhammer"] = "vgui/hud/m9k_jackhammer",
		["m9k_m3"] = "vgui/hud/m9k_m3",
		["m9k_m24"] = "vgui/hud/m9k_m24",
		["m9k_m60"] = "vgui/hud/m9k_m60",
		["m9k_m98b"] = "vgui/hud/m9k_m98b",
		["m9k_m249lmg"] = "vgui/hud/m9k_m249lmg",
		["m9k_m1918bar"] = "vgui/hud/m9k_m1918bar",
		["m9k_minigun"] = "vgui/hud/m9k_minigun",
		["m9k_mossberg590"] = "vgui/hud/m9k_mossberg590",
		["m9k_psg1"] = "vgui/hud/m9k_psg1",
		["m9k_remington870"] = "vgui/hud/m9k_remington870",
		["m9k_remington7615p"] = "vgui/hud/m9k_remington7615p",
		["m9k_sl8"] = "vgui/hud/m9k_sl8",
		["m9k_svu"] = "vgui/hud/m9k_svu",
		["m9k_usas"] = "vgui/hud/m9k_usas",
		["m9k_spas12"] = "vgui/hud/m9k_spas12",
		["m9k_svt40"] = "vgui/hud/m9k_svt40",
		["m9k_striker12"] = "vgui/hud/m9k_striker12",
		["m9k_pkm"] = "vgui/hud/m9k_pkm",
		["m9k_bizonp19"] = "vgui/hud/m9k_bizonp19",
		["m9k_colt1911"] = "vgui/hud/m9k_colt1911",
		["m9k_coltpython"] = "vgui/hud/m9k_coltpython",
		["m9k_deagle"] = "vgui/hud/m9k_deagle",
		["m9k_glock"] = "vgui/hud/m9k_glock",
		["m9k_hk45"] = "vgui/hud/m9k_hk45",
		["m9k_luger"] = "vgui/hud/m9k_luger",
		["m9k_m29satan"] = "vgui/hud/m9k_m29satan",
		["m9k_m92beretta"] = "vgui/hud/m9k_m92beretta",
		["m9k_model3russian"] = "vgui/hud/m9k_model3russian",
		["m9k_mp7"] = "vgui/hud/m9k_mp7",
		["m9k_ragingbull"] = "vgui/hud/m9k_ragingbull",
		["m9k_remington1858"] = "vgui/hud/m9k_remington1858",
		["m9k_sig_p229r"] = "vgui/hud/m9k_sig_p229r",
		["m9k_smgp90"] = "vgui/hud/m9k_smgp90",
		["m9k_sten"] = "vgui/hud/m9k_sten",
		["m9k_thompson"] = "vgui/hud/m9k_thompson",
		["m9k_usp"] = "vgui/hud/m9k_usp",
		["m9k_uzi"] = "vgui/hud/m9k_uzi",
		["m9k_model500"] = "vgui/hud/m9k_model500",
		["m9k_model627"] = "vgui/hud/m9k_model627",
		["m9k_ump45"] = "vgui/hud/m9k_ump45",
		["m9k_mp9"] = "vgui/hud/m9k_mp9",
		["m9k_vector"] = "vgui/hud/m9k_vector",
		["m9k_tec9"] = "vgui/hud/m9k_tec9",
		["m9k_mp5"] = "vgui/hud/m9k_mp5",
		["m9k_kac_pdw"] = "vgui/hud/m9k_kac_pdw",
		["m9k_honeybadger"] = "vgui/hud/m9k_honeybadger",
		["m9k_mp5sd"] = "vgui/hud/m9k_mp5sd",
		["m9k_magpulpdr"] = "vgui/hud/m9k_magpulpdr",
		["m9k_scoped_taurus"] = "vgui/hud/m9k_scoped_taurus",
		["m9k_mp40"] = "vgui/hud/m9k_mp40",
		["m9k_thrown_sticky_grenade"] = "vgui/hud/m9k_sticky_grenade",
		["m9k_thrown_m61"] = "vgui/hud/m9k_m61_frag",
		["m9k_m61_frag"] = "vgui/hud/m9k_m61_frag",
		["m9k_thrown_knife"] = "vgui/hud/m9k_machete",
		["m9k_thrown_harpoon"] = "vgui/hud/m9k_harpoon",
		["m9k_sent_nuke_radiation"] = "vgui/hud/m9k_davy_crockett",
		["m9k_released_poison"] = "vgui/hud/m9k_nerve_gas",
		["m9k_poison_parent"] = "vgui/hud/m9k_nerve_gas",
		["m9k_sent_nuke_radiation"] = "vgui/hud/m9k_davy_crockett",
		["m9k_davy_crockett_explo"] = "vgui/hud/m9k_davy_crockett",
		["m9k_proxy"] = "vgui/hud/m9k_proxy_mine",
		["m9k_milkor_nade"] = "vgui/hud/m9k_milkormgl",
		["m9k_suicide_bomb"] = "vgui/hud/m9k_suicide_bomb",
		["m9k_mad_c4"] = "vgui/hud/m9k_suicide_bomb",
		["m9k_m202_rocket"] = "vgui/hud/m9k_m202",
		["m9k_launched_m79"] = "vgui/hud/m9k_m79gl",
		["m9k_improvised_explosive"] = "vgui/hud/m9k_ied_detonator",
		["m9k_gdcwa_matador_90mm"] = "vgui/hud/m9k_matador",
		["m9k_gdcwa_rpg_heat"] = "vgui/hud/m9k_rpg7",
		["m9k_damascus"] = "vgui/hud/m9k_damascus",
		["m9k_fists"] = "vgui/hud/m9k_fists",
		["m9k_machete"] = "vgui/hud/m9k_machete",
		["m9k_launched_ex41"] = "vgui/hud/m9k_ex41",
		["m9k_oribital_cannon"] = "vgui/hud/m9k_orbital_strike",
		["m9k_knife"] = "vgui/hud/m9k_knife",
		["m9k_thrown_spec_knife"] = "vgui/hud/m9k_knife",
		["m9k_nitro_vapor"] = "vgui/hud/m9k_nitro",

		["m9k_hk45_admin"] = "vgui/hud/m9k_hk45",
		["m9k_l85_admin"] = "vgui/hud/m9k_l85",
		["m9k_amd65_admin"] = "vgui/hud/m9k_amd65",
		["m9k_mossberg590_admin"] = "vgui/hud/m9k_mossberg590"
	}


	local killiconAdd = killicon.Add

	local cCached1 = Color(255,255,255)


	for Key,v in pairs(tData) do
		killiconAdd(Key,v,cCached1)
	end

end

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- --
-- Fonts
-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- --

if CLIENT then

	local surfaceCreateFont = surface.CreateFont
	local ScreenScale = ScreenScale


	local fHook = function()

		surfaceCreateFont("WeaponIcons_m9k",{ -- Hl2 Font
			font = "HalfLife2",
			size = ScreenScale(48),
			weight = 500,
			antialias = true
		})

		surfaceCreateFont("WeaponIconsSelected_m9k",{ -- Hl2 Outline Font
			font = "HalfLife2",
			size = ScreenScale(48),
			weight = 500,
			antialias = true,
			blursize = 10,
			scanlines = 3
		})

		surfaceCreateFont("WeaponIcons_m9k_css",{ -- CSS Font
			font = "csd",
			size = ScreenScale(48),
			weight = 500,
			antialias = true
		})

	end


	hook.Add("OnScreenSizeChanged","MMM_M9k_UpdateFontSize",fHook)
	fHook() -- Make it run on file refresh

end

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- --
-- Ammo
-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- --

if CLIENT then

	local languageAdd = language.Add -- Improve load times by microseconds.


	languageAdd("40mmGrenade_ammo","40mm Grenade")
	languageAdd("ProxMine_ammo","Proximity Mine")
	languageAdd("SniperPenetratedRound_ammo","Sniper Ammo")
	languageAdd("AirboatGun_ammo","Winchester Ammo")
	languageAdd("rzmflaregun_ammo","Flaregun Ammo")
	languageAdd("NerveGas_ammo","Nerve Gas")
	languageAdd("nitroG_ammo","Nitro Glycerine")
	languageAdd("Harpoon_ammo","Harpoon")
	languageAdd("StickyGrenade_ammo","Sticky Grenade")
	languageAdd("IED_Detonators_ammo","IED Detonator")
	languageAdd("M9k_Nuclear_Warhead_ammo","Nuclear Warhead")
	languageAdd("SatCannon_ammo","Orbital Strike Marker Charge")

end


hook.Add("OnGamemodeLoaded",sTag,function()

	hook.Remove("OnGamemodeLoaded",sTag)


	local gameAddAmmoType = game.AddAmmoType -- Improve load times by microseconds.


	gameAddAmmoType({
		name = "m9k_mmm_beer"
	})

	gameAddAmmoType({
		name = "m9k_mmm_decoy"
	})

	gameAddAmmoType({
		name = "m9k_mmm_flaregrenade"
	})

	gameAddAmmoType({
		name = "m9k_mmm_flashbang"
	})

	gameAddAmmoType({
		name = "m9k_mmm_grenade"
	})

	gameAddAmmoType({
		name = "m9k_mmm_incendiary"
	})

	gameAddAmmoType({
		name = "m9k_mmm_molotov"
	})

	gameAddAmmoType({
		name = "m9k_mmm_pipebomb"
	})

	gameAddAmmoType({
		name = "m9k_mmm_rocks"
	})

	gameAddAmmoType({
		name = "m9k_mmm_smokegrenade"
	})

	gameAddAmmoType({
		name = "m9k_mmm_snowball"
	})

end)

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- --