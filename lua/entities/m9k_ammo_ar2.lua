AddCSLuaFile()

ENT.Base = "m9kr_base_ammo"
ENT.Category = "M9kR: Ammunition"
ENT.PrintName = "[B] Rifle Ammo"
ENT.Spawnable = true

ENT.AmmoClass		= "ar2"
ENT.AmmoModel		= "models/items/boxmrounds.mdl"
ENT.AmmoCount		= 30
ENT.ImpactSound		= "Default.ImpactSoft"

ENT.bDrawText		= true

ENT.Text 			= "Rifle Ammo"
ENT.TextPos			= Vector(90,90,90)
ENT.TextColor		= Color(230,45,45)
ENT.TextScale		= 0.125

ENT.OffsetUp		= 13.5
ENT.OffsetRight		= 0
ENT.OffsetForward	= -0.25

if CLIENT then
	language.Add("AR2_ammo","Rifle Ammo")
end