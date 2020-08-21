if CLIENT then
	local Func = function()
		surface.CreateFont("WeaponIcons_m9k",{ -- Hl2 Font
			font = "HalfLife2",
			size = ScreenScale(48),
			weight = 500,
			antialias = true
		})

		surface.CreateFont("WeaponIconsSelected_m9k",{ -- Hl2 Outline Font
			font = "HalfLife2",
			size = ScreenScale(48),
			weight = 500,
			antialias = true,
			blursize = 10,
			scanlines = 3
		})

		surface.CreateFont("WeaponIcons_m9k_css",{ -- CSS Font
			font = "csd",
			size = ScreenScale(48),
			weight = 500,
			antialias = true
		})
	end

	hook.Add("OnScreenSizeChanged","MMM_M9k_UpdateFontSize",Func)
	Func()
end