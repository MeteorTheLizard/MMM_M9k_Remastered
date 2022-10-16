AddCSLuaFile()

ENT.Base = "m9kr_base_ammo"
ENT.Category = "M9kR: Ammunition"
ENT.PrintName = "[B] SMG Ammo"
ENT.Spawnable = true

ENT.AmmoClass		= "smg1"
ENT.AmmoModel		= "models/items/boxsrounds.mdl"
ENT.AmmoCount		= 30
ENT.ImpactSound		= "Default.ImpactSoft"

ENT.bDrawText		= true

ENT.Text 			= "SMG Ammo"
ENT.TextPos			= Vector(90,90,90)
ENT.TextColor		= Color(230,45,45)
ENT.TextScale		= 0.11

ENT.OffsetUp		= 11.6
ENT.OffsetRight		= 0.05
ENT.OffsetForward	= 0

if CLIENT then
	language.Add("SMG1_ammo","SMG Ammo")
end