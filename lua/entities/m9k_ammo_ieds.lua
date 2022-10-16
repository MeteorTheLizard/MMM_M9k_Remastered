AddCSLuaFile()

ENT.Base = "m9kr_base_ammo"
ENT.Category = "M9kR: Ammunition"
ENT.PrintName = "[B] IEDs"
ENT.Spawnable = true

ENT.AmmoClass		= "IED_Detonators"
ENT.AmmoWeapon		= "m9k_ied_detonator"
ENT.AmmoModel		= "models/items/ammocrates/crateieds.mdl"
ENT.AmmoCount		= 8
ENT.ImpactSound		= "Default.ImpactSoft"

ENT.bDrawText		= true
ENT.bExplOnDestroy	= true

ENT.Text 			= "IEDs"
ENT.TextPos			= Vector(0,90,90)
ENT.TextColor		= Color(230,45,45)
ENT.TextScale		= 0.25

ENT.OffsetUp		= 12
ENT.OffsetRight		= 1
ENT.OffsetForward	= 18