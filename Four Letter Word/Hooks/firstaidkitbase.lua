Hooks:PostHook(FirstAidKitBase, "take", "trent_fak", function(self)
	local is_trent = managers.player:player_unit() and managers.player:player_unit():inventory():equipped_unit():base():get_name_id() == "trent"
	if is_trent then
		managers.player:player_unit():sound():say("trent_health", nil, nil)
	end
end)