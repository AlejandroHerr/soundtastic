local read_pipe    = require("lain.helpers").read_pipe

local sink = {}
MAX_VOLUME = 150
GET_CMD = "export LC_ALL=C; pactl list sinks"
SET_CMD = "pactl set-sink-volume"
MUTE_CMD = "pactl set-sink-mute"

function sink:getVolume()
	local out_sink = read_pipe(GET_CMD)
	
	return { 
		sink = out_sink:match("(%d+).*",0),
		mute = out_sink:match("Mute: (%w+)\n"),
		volume = tonumber(out_sink:match("Volume: front%-left: %d+ /% +(%d+)"))
	}
end

function sink:setVolume(volume)
  local sink = sink:getVolume()
  local cmd = ''
  if volume == 'toggle' then
    cmd = MUTE_CMD .. ' ' .. sink.sink .. ' ' .. volume
    sink.mute = (sink.mute == 'yes') and 'no' or 'yes'
  else
    local vol = tonumber(volume:match("^%-(%d+)$") or volume:match("^%+(%d+)$")) or tonumber( volume )
    if (volume:match("^(%-)%d+$")) then
      vol = ((sink.volume - vol) > 0) and (sink.volume - vol) or 0
    elseif (volume:match("^(%+)%d+$")) then
      vol = ((sink.volume + vol) < MAX_VOLUME) and (sink.volume + vol) or MAX_VOLUME
    else
      vol = math.floor((MAX_VOLUME * vol) /100)
    end
    sink.volume = vol
    cmd = SET_CMD .. ' ' .. sink.sink .. ' ' .. sink.volume .. '%'
  end
  awful.util.spawn_with_shell(cmd)

  return sink
end

return sink
