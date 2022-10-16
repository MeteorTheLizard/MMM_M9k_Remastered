AddCSLuaFile()

ENT.Base = "m9kr_base_ammo"
ENT.Category = "M9kR: Ammunition"
ENT.PrintName = "[B] Pistol Ammo"
ENT.Spawnable = true

ENT.AmmoClass		= "pistol"
ENT.AmmoModel		= "models/items/boxsrounds.mdl"
ENT.AmmoCount		= 32
ENT.ImpactSound		= "Default.ImpactSoft"

ENT.bDrawText		= true

ENT.Text 			= "Pistol Ammo"
ENT.TextPos			= Vector(90,90,90)
ENT.TextColor		= Color(230,45,45)
ENT.TextScale		= 0.11

ENT.OffsetUp		= 11.6
ENT.OffsetRight		= 0.05
ENT.OffsetForward	= 0

if CLIENT then
	language.Add("Pistol_ammo","Pistol Ammo")
end