if CLIENT then
	local Func = function()
		surface.CreateFont("WeaponIcons_m9k",{
			font = "HalfLife2",
			size = ScreenScale(48),
			weight = 500,
			antialias = true
		})

		surface.CreateFont("WeaponIconsSelected_m9k",{
			font = "HalfLife2",
			size = ScreenScale(48),
			weight = 500,
			antialias = true,
			blursize = 10,
			scanlines = 3
		})
	end

	hook.Add("OnScreenSizeChanged","MMM_M9k_UpdateFontSize",Func)
	Func()
end