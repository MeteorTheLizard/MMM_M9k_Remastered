AddCSLuaFile()

if CLIENT then
	language.Add("40mmGrenade_ammo","40mm Grenade")
	language.Add("ProxMine_ammo","Proximity Mine")
	language.Add("SniperPenetratedRound_ammo","Sniper Ammo")
	language.Add("AirboatGun_ammo","Winchester Ammo")
	language.Add("rzmflaregun_ammo","Flaregun Ammo")
	language.Add("NerveGas_ammo","Nerve Gas")
	language.Add("nitroG_ammo","Nitro Glycerine")
	language.Add("Harpoon_ammo","Harpoon")
	language.Add("StickyGrenade_ammo","Sticky Grenade")
end

hook.Add("Initialize","M9k_Ammo_Init",function()
	game.AddAmmoType({
		name = "40mmGrenade",
		dmgtype = DMG_BULLET
	})

	game.AddAmmoType({
		name = "ProxMine",
		dmgtype = DMG_BULLET
	})

	game.AddAmmoType({
		name = "rzmflaregun",
		dmgtype = DMG_BULLET
	})

	game.AddAmmoType({
		name = "NerveGas"
	})

	game.AddAmmoType({
		name = "StickyGrenade"
	})

	game.AddAmmoType({
		name = "nitroG"
	})

	game.AddAmmoType({
		name = "Harpoon"
	})
end)