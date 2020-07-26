hook.Add("PreGamemodeLoaded","MMM_M9k_IsBaseInstalled",function()
	MMM_M9k_IsBaseInstalled = true -- Absolutely avoid global variables like this whenever possible and if there is no way around it, make it as unique as possible.
end) -- This is needed for M9k Remastered weapon packs to tell them that the base is installed and loaded.