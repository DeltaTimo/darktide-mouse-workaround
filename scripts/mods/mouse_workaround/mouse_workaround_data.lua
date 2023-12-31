local mod = get_mod("mouse_workaround")

return {
	name = mod:localize("mod_name"),
	description = mod:localize("mod_description"),
	is_togglable = true,
	options = {
		widgets = {
      {
        setting_id = "release_delay",
        type = "numeric",
        default_value = 20,
        range = {0, 200},
        unit_text = "millis",
        decimals_number = 0,
      },
      {
        setting_id = "enable_left_mouse",
        type = "checkbox",
        default_value = true,
      },
      {
        setting_id = "enable_right_mouse",
        type = "checkbox",
        default_value = true,
      },
      {
        setting_id = "enable_other_mouse",
        type = "checkbox",
        default_value = true,
      },
      {
        setting_id = "hold_required_help",
        type = "group",
        sub_widgets = {
          {
            setting_id = "hold_required",
            type = "numeric",
            default_value = 0,
            range = {0, 200},
            unit_text = "millis",
            decimals_number = 0,
          },
        },
      },
		},
	},
}
