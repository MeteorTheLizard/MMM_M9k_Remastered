SWEP.Base = "bobs_scoped_base"
SWEP.Category = "M9K Sniper Rifles"
SWEP.PrintName = "M24"

SWEP.HoldType = "ar2"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_dmg_m24s.mdl"
SWEP.WorldModel = "models/weapons/w_snip_m24_6.mdl"

SWEP.Primary.Sound = "Dmgfok_M24SN.Single"
SWEP.Primary.RPM = 40
SWEP.Primary.ClipSize = 5

SWEP.Primary.KickUp = 6
SWEP.Primary.KickDown = 2
SWEP.Primary.KickHorizontal = 5
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "SniperPenetratedRound"
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 120
SWEP.Primary.Spread = .15
SWEP.Primary.SpreadBefore = SWEP.Primary.Spread

SWEP.ScopeScale = 0.7
SWEP.ReticleScale = 0.6

function SWEP:PrimaryAttack()
	if self.Owner:WaterLevel() == 3 then -- No weapons may fire underwater
		self:EmitSound("Weapon_Pistol.Empty")
		self:SetNextPrimaryFire(CurTime() + 0.2)
		return
	end

	if self:CanPrimaryAttack() and (self:GetNextPrimaryFire() < CurTime() or game.SinglePlayer()) then
		timer.Remove("m9k_resetscope_" .. self.OurIndex)

		local Spread = self.Primary.Spread

		if self.Owner:GetVelocity():Length() > 100 then
			Spread = self.Primary.Spread * 6
		elseif self.Owner:KeyDown(IN_DUCK) then
			Spread = self.Primary.Spread / 2
		end

		local Scope = self:GetNWInt("ScopeState")
		local OldScopeState = 0
		if Scope > 0 then
			OldScopeState = Scope
			self:SetNWInt("ScopeState",0)
			self.Owner:SetFOV(0,0.1)

			self.ScopeCD = CurTime() + 1.4

			timer.Create("m9k_resetscope_" .. self.OurIndex,1.4,1,function()
				if not IsValid(self) or not IsValid(self.Owner) or not IsValid(self.Owner:GetActiveWeapon()) or self.Owner:GetActiveWeapon():GetClass() ~= self.ClassName then return end

				if (self:GetNWBool("M9kr_OvrZoomStage") and self.Owner:KeyDown(IN_ATTACK2)) or not self:GetNWBool("M9kr_OvrZoomStage") then
					self:SetNWInt("ScopeState",OldScopeState - 1)

					self:SecondaryAttack()  -- Shitty but effective hack
				end
			end)
		end

		self:SetNextPrimaryFire(CurTime() + 1 / (self.Primary.RPM / 60))
		self:TakePrimaryAmmo(1)
		self:ShootBullet((1 * self.Primary.Damage) * math.Rand(.85,1.3),self.Primary.Recoil,self.Primary.NumShots,Spread)
		self:AttackAnimation()
		self:EmitSound(self.Primary.Sound)
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
		self:MuzzleFlash() -- IDK if this is really needed tbh
	end
end

if CLIENT then
	local CachedTextureID1 = surface.GetTextureID("scope/gdcw_scopesight")

	function SWEP:DrawHUD()
		if self.Owner:GetViewEntity() ~= self.Owner then return end

		if self:GetNWInt("ScopeState") > 0 then
			if self.DrawCrosshair then -- Only set the vars once (this is faster)
				self.Owner:DrawViewModel(false)
				self.DrawCrosshair = false
			end

			surface.SetDrawColor(0,0,0,255)
			surface.SetTexture(CachedTextureID1)
			surface.DrawTexturedRect(self.LensTable.x,self.LensTable.y,self.LensTable.w,self.LensTable.h)
		elseif not self.DrawCrosshair then -- Only set the vars once (this is faster)
			self.Owner:DrawViewModel(true)
			self.DrawCrosshair = true
		end
	end
end