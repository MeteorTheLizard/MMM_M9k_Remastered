if CLIENT then
	language.Add("40mmGrenade_ammo","40mm Grenade")
	language.Add("ProxMine_ammo","Proximity Mine")
end

game.AddAmmoType({
	name = "40mmGrenade",
	dmgtype = DMG_BULLET
})

game.AddAmmoType({
	name = "ProxMine",
	dmgtype = DMG_BULLET
})

sound.Add({
	name = "EX41.Pump",
	channel = CHAN_ITEM,
	volume = 1.0,
	sound = "weapons/ex41/m3_pump.mp3"
})

sound.Add({
	name = "EX41.Insertshell",
	channel = CHAN_ITEM,
	volume = 1.0,
	sound = "weapons/ex41/m3_insertshell.mp3"
})

sound.Add({
	name = "EX41.Draw",
	channel = CHAN_ITEM,
	volume = 1.0,
	sound = "weapons/ex41/draw.mp3"
})

sound.Add({
	name = "RPGF.single",
	channel = CHAN_USER_BASE + 10,
	volume = 1.0,
	soundlevel = 155,
	sound = "GDC/Rockets/RPGF.wav"
})

sound.Add({
	name = "M202F.single",
	channel = CHAN_USER_BASE + 10,
	volume = 1.0,
	soundlevel = 155,
	sound = {"GDC/Rockets/M202F.wav","gdc/rockets/m202f2.wav"}
})

sound.Add({
	name = "MATADORF.single",
	channel = CHAN_USER_BASE + 10,
	volume = 1.0,
	soundlevel = 155,
	sound = "GDC/Rockets/MATADORF.wav"
})

sound.Add({
	name = "sb.click",
	channel = CHAN_USER_BASE + 10,
	volume = "1",
	sound = "weapons/suicidebomb/c4_click.mp3"
})

sound.Add({
	name = "M79_launcher.close",
	channel = CHAN_ITEM,
	volume = 1.0,
	sound = "weapons/M79/m79_close.mp3"
})

sound.Add({
	name = "M79_glauncher.barrelup",
	channel = CHAN_ITEM,
	volume = 1.0,
	sound = "weapons/M79/barrelup.mp3"
})

sound.Add({
	name = "M79_glauncher.InsertShell",
	channel = CHAN_ITEM,
	volume = 1.0,
	sound = "weapons/M79/xm_insert.mp3"
})

sound.Add({
	name = "M79_launcher.draw",
	channel = CHAN_ITEM,
	volume = 1.0,
	sound = "weapons/M79/m79_close.mp3"
})

sound.Add({
	name = "40mmGrenade.Single",
	channel = CHAN_USER_BASE + 10,
	volume = 1.0,
	sound = "weapons/M79/40mmthump.wav"
})