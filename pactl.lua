--	Change that to use lain.helpers ??
local function read_pipe(cmd)
   local f = assert(io.popen(cmd))
   local output = f:read("*all")
   f:close()
   return output
end

local Pulse = { card = {}, sink = {} }
Pulse.card = require("lib.soundtastic.card")
Pulse.sink = require("lib.soundtastic.sink")


local function getProfiles()
	local pactl = read_pipe(Pulse.card.__get_profile_cmd)
	local c,card
	local in_profile = 0
	local profiles = {}
	local profile, profile_name
	for line in pactl:gmatch("[^\n]+") do
		_,_,c = line:find(Pulse.card.__card_pattern)
		if c then 
			card=c
			table.insert(Pulse.card.cards,card)
		end
		if (line:find(Pulse.card.__aprofile_pattern)) then
			in_profile = 0
		end
		if in_profile == 1 then
			_,_,profile,profile_name = line:find(Pulse.card.__profile_pattern)
			if profile ~= 'off' then
				profiles[#profiles + 1] = { label = profile_name, profile = profile, card = card}
			end
		end
		if (line:find(Pulse.card.__profiles_pattern)) then
			in_profile = 1
		end
	end

	return profiles
end

local function buildMenu()
	local cmd
	for p,profile in pairs(getProfiles()) do
		cmd = Pulse.card.__set_profile_cmd .. ' ' .. profile.card .. ' ' .. profile.profile
		for c,card in pairs(Pulse.card.cards) do
			if card ~= profile.card then
				cmd = cmd .. ' && ' .. Pulse.card.__set_profile_cmd .. ' ' .. card .. ' off'
			end
		end
		Pulse.card.menu[#Pulse.card.menu + 1] = {profile.label, cmd}
	end
end

buildMenu()


return Pulse