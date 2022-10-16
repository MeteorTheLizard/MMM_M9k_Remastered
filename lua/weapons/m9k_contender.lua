SWEP.Base = "bobs_scoped_base"
SWEP.Category = "M9kR: Sniper Rifles"
SWEP.PrintName = "Thompson Contender G2"

SWEP.DynamicLightScale = 1 -- Set to Default

SWEP.HoldType = "pistol"
SWEP.Spawnable = true

SWEP.ViewModelFOV = 65
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_contender2.mdl"
SWEP.WorldModel = "models/weapons/w_g2_contender.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/g2contender/open_chamber.mp3",
		iDelay = 0.50
	},
	{
		sSound = "weapons/g2contender/Bullet_out.mp3",
		iDelay = 0.50 + 0.10
	},
	{
		sSound = "weapons/g2contender/Bullet_in.mp3",
		iDelay = 0.50 + 0.10 + 0.75
	},
	{
		sSound = "weapons/g2contender/close_chamber.mp3",
		iDelay = 0.50 + 0.10 + 0.75 + 0.75
	}
}

SWEP.tDrawSoundSequence = {
	{
		sSound = "weapons/g2contender/Draw.mp3",
		iDelay = 0.10
	},
	{
		sSound = "weapons/g2contender/Cock-1.mp3",
		iDelay = 0.10 + 0.35
	}
}

SWEP.Primary.Sound = "weapons/g2contender/scout-1.wav"

SWEP.Primary.RPM = 45
SWEP.Primary.ClipSize = 1
SWEP.Primary.KickUp = 4
SWEP.Primary.KickDown = 3
SWEP.Primary.KickHorizontal = 5
SWEP.Primary.Automatic = false
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 75
SWEP.Primary.Spread = .30
SWEP.Primary.Ammo = "SniperPenetratedRound"

SWEP.Primary.SpreadBefore = SWEP.Primary.Spread

SWEP.ScopeType = "gdcw_scopesight"
SWEP.ScopeStages = 3
SWEP.ScopeScale = 0.7
SWEP.ReticleScale = 0.6

SWEP.LegacyBalance = {
	Primary = {
		RPM = 35,
		ClipSize = 1,
		KickUp = 1,
		KickDown = 1,
		KickHorizontal = 1,
		Automatic = false,
		NumShots = 1,
		Damage = 85,
		Spread = .01
	}
}

sound.Add({ -- Overlapping sounds are not supported so we keep this.
	name = "contender_g2.Shell",
	channel = CHAN_USER_BASE + 2,
	volumel = 1.0,
	sound = {"weapons/g2contender/pl_shell1.mp3","weapons/g2contender/pl_shell2.mp3","weapons/g2contender/pl_shell3.mp3","weapons/g2contender/pl_shell4.mp3"}
})


if SERVER then -- We override the reload animation that is baked into the PrimaryAttack animation. What were they thinking??

	function SWEP:PrimaryAttackHooked()

		timer.Simple(0.1,function() -- Needs to be delayed so that the bullet still fires accurately while scoped in as well as thirdperson animations to play correctly.
			if not IsValid(self) or not IsValid(self.Owner) or self.Owner:GetActiveWeapon() ~= self then return end

			if self.IsScoping then
				self:ResetInternalVarsHooked() -- Make sure it works with scopes
			end

			self:Reload()
		end)
	end
end