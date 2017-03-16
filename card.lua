local card = {}
card.__profiles_pattern = '^\t*Profiles:$'
card.__aprofile_pattern = '^\t*Active Profile:'
card.__card_pattern = '^Card #(%d+)$'
card.__profile_pattern = '\t*(.*): (.*) %('

card.__get_profile_cmd = "export LC_ALL=C; pactl list cards"
card.__set_profile_cmd = 'pactl set-card-profile'

card.__max_volume = 150

card.menu = {}
card.cards = {}



local state = {
	iterator = nil,
	timer = nil,
	cid = nil
}

function card:switchCard()
   	-- Stop any previous timer
   	if state.timer then
      	state.timer:stop()
      	state.timer = nil
   	end

   	-- Build the list of choices
   	if not state.iterator then
     	state.iterator = awful.util.table.iterate(card.menu, function() return true end)
   	end

   	-- Select one and display the appropriate notification
   	local next  = state.iterator()
   	local label, action, icon
   	if not next then
      	label = "Keep the current configuration"
      	cmd = nil
      	state.iterator = nil
   	else
      	label,cmd = unpack(next)
   	end
   	
	couth.notifier:notify(label)
  
   	state.timer = timer { timeout = couth.CONFIG.NOTIFIER_TIMEOUT }
   	state.timer:connect_signal(
   		"timeout",
		function()
			state.timer:stop()
			state.timer = nil
			state.iterator = nil
			if cmd then awful.util.spawn_with_shell(cmd) end
		end
	)
   state.timer:start()
end

return card