Hooks:PostHook(ChatManager, "_receive_message", "trent_message", function(self)
	local is_trent = managers.player:player_unit() and managers.player:player_unit():inventory():equipped_unit():base():get_name_id() == "trent"
	if is_trent then
		managers.player:player_unit():sound():say("trent_talk", nil, nil)
	end
end)