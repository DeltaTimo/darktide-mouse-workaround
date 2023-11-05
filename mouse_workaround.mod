return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`mouse_workaround` encountered an error loading the Darktide Mod Framework.")

		new_mod("mouse_workaround", {
			mod_script       = "mouse_workaround/scripts/mods/mouse_workaround/mouse_workaround",
			mod_data         = "mouse_workaround/scripts/mods/mouse_workaround/mouse_workaround_data",
			mod_localization = "mouse_workaround/scripts/mods/mouse_workaround/mouse_workaround_localization",
		})
	end,
	packages = {},
}
