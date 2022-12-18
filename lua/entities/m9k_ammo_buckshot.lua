AddCSLuaFile()

ENT.Base = "m9kr_base_ammo"
ENT.Category = "M9kR: Ammunition"
ENT.PrintName = "[B] Shotgun Ammo"
ENT.Spawnable = true

ENT.AmmoClass		= "buckshot"
ENT.AmmoModel		= "models/items/boxbuckshot.mdl"
ENT.AmmoCount		= 30
ENT.ImpactSound		= "Default.ImpactSoft"

ENT.bDrawText		= true

ENT.Text 			= "Shotgun Ammo"
ENT.TextPos			= Vector(0,90,90)
ENT.TextColor		= Color(230,45,45)
ENT.TextScale		= 0.04

ENT.OffsetUp		= 2.85
ENT.OffsetRight		= -0.35
ENT.OffsetForward	= 3.75

if CLIENT then
	language.Add("Buckshot_ammo","Shotgun Ammo")
end