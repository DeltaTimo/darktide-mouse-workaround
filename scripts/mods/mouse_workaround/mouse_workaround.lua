-- Mouse Workaround
-- Author: Timo Zuccarello
local mod = get_mod("mouse_workaround")

local release_delay = 0

mod:hook("InputDevice", "held", function(func, self, id, ...)
  local ret = func(self, id, ...)

  -- If button is down or it's not a mouse, don't do anything.
  if self.device_type ~= "mouse" or release_delay == 0 then
    return ret
  end

  -- Create map if it doesn't exist.
  if self._button_release_times == nil then
    self._button_release_times = {}
  end

  -- Set button release time to 0. This way, we know when a button was just released.
  if ret then
    self._button_release_times[id] = 0
    return ret
  end

  -- Button was released:

  local release_time = self._button_release_times[id]
  local now = os.clock()

  if release_time == 0 then
    -- Button was just released.
    -- Set release time later.
    self._button_release_times[id] = now
  elseif release_time == nil then
    -- Button was already released after delay.
    return ret
  elseif (now - release_time) > release_delay then
    -- Button was released for longer than the release delay, but wasn't yet reset.
    -- Finally release and unset.
    self._button_release_times[id] = nil
    return false
  end

  -- Button was released, but not for longer than the set release delay.
  -- Keep pressing
  return true
end)

-- Handle settings.
mod.on_setting_changed = function()
  release_delay = mod:get("release_delay") / 1000
end

-- Get and transform the settings to the required format.
mod.on_setting_changed()
