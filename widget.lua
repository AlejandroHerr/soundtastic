local newtimer     = require("lain.helpers").newtimer
local wibox        = require("wibox")
local setmetatable = setmetatable
local Pulse      = require("lib.soundtastic.pactl")

-- Basic template for custom widgets
-- lain.widgets.brightness

local sound = {}


local function worker(args)
    local args     = args or {}
    local timeout  = args.timeout or 1
    local settings = args.settings or function() end
    local sound_prev = {
      sink = '',
      mute = '',
      volume = ''
    }
    sound.widget = wibox.widget.textbox("")--tostring(Pulse.sink:getVolume().volume))


    function sound.widget.update()
        sound_now = Pulse.sink:getVolume()
        widget = sound.widget
        if sound_prev.sink ~= sound_now.sink
          or sound_prev.volume ~= sound_now.volume
          or sound_prev.mute ~= sound_now.mute then
          settings()
          sound_prev = sound_now
        end

    end

    newtimer(cmd, timeout, sound.widget.update)

    return sound.widget
end

return setmetatable(sound, { __call = function(_, ...) return worker(...) end })