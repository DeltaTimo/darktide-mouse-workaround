-- Mouse Workaround
-- Author: Timo Zuccarello
local mod = get_mod("mouse_workaround")

local release_delay = 0
local enable_left_mouse = true
local enable_right_mouse = true
local enable_other_mouse = true
local hold_required = 0

mod:hook("InputDevice", "held", function(func, self, id, ...)
  local ret = func(self, id, ...)

  -- If it's not a mouse, delay is disabled/0, don't do anything.
  if self.device_type ~= "mouse" or release_delay == 0 then
    return ret
  end

  -- Don't do anything if not enabled for this mouse button.
  if (id == 0 and not enable_left_mouse)
    or (id == 1 and not enable_right_mouse)
    or (id ~= 0 and id ~= 1 and not enable_other_mouse) then
    return ret
  end

  -- Create maps if they doesn't exist.
  if self._button_release_times == nil then
    self._button_release_times = {}
  end

  if self._button_press_times == nil then
    self._button_press_times = {}
  end

  local now = os.clock()

  if ret then
    -- We have different cases here:
    --   * The button was just depressed.
    --   * The button is still pressed for less than `hold_required`.
    -- and importantly:
    --   * The button was just depressed BUT was never actually released because of this workaround.

    if self._button_press_times[id] == nil and self._button_release_times[id] == nil then
      -- Just depressed and was already finally released or never before pressed in the first place.
      self._button_press_times[id] = now
    end

    -- Return early if we're pressing the button. Nothing to do beyond this point.
    return ret
  end

  -- Button was released:

  local press_time = self._button_press_times[id]
  local release_time = self._button_release_times[id]

  -- Multiple different cases here as well:
  --   * The button was never pressed or was already released by us.
  --   * The button was pressed before and just got released.
  --  and the following cases MAY overlap with the former:
  --   * The button was released and wasn't pressed for longer than required. => Don't apply the workaround.
  --   * The button was released more than the release delay ago, but wasn't yet reset.

  if press_time == nil then
    -- Button was either never pressed or was already finally released.
    return false
  elseif release_time == nil then
    -- Button was just released.
    -- Set release time to now for later calls.
    self._button_release_times[id] = now
    release_time = now
  end

  if ((now - release_time) > release_delay)
    or ((now - press_time) <= hold_required) then
    -- Button was released for longer than the release delay, but wasn't yet reset.
    --  OR
    -- Button was released but wasn't pressed for longer than the required hold time.

    -- Finally release and unset.
    self._button_release_times[id] = nil
    self._button_press_times[id] = nil
    return false
  end

  -- Button was released after being held for longer than the required hold time, but not for longer than the set release delay.
  -- Keep pressing
  return true
end)

-- Handle settings.
mod.on_setting_changed = function()
  release_delay = mod:get("release_delay") / 1000
  enable_left_mouse = mod:get("enable_left_mouse")
  enable_right_mouse = mod:get("enable_right_mouse")
  enable_other_mouse = mod:get("enable_other_mouse")
  hold_required = mod:get("hold_required") / 1000
end

-- Get and transform the settings to the required format.
mod.on_setting_changed()
