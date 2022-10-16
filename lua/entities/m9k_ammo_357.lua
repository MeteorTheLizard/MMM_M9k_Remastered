AddCSLuaFile()

ENT.Base = "m9kr_base_ammo"
ENT.Category = "M9kR: Ammunition"
ENT.PrintName = "[B] .357 Ammo"
ENT.Spawnable = true

ENT.AmmoClass		= "357"
ENT.AmmoModel		= "models/items/357ammo.mdl"
ENT.AmmoCount		= 12
ENT.ImpactSound		= "Default.ImpactSoft"

ENT.bDrawText		= true

ENT.Text 			= ".357 Ammo"
ENT.TextPos			= Vector(90,90,180)
ENT.TextColor		= Color(230,45,45)
ENT.TextScale		= 0.06

ENT.OffsetUp		= 2.20
ENT.OffsetRight		= -0.25
ENT.OffsetForward	= 2.95

if CLIENT then
	language.Add("357_ammo",".357 Ammo")
end