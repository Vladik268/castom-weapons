Hooks:PostHook(DoctorBagBase, "take", "trent_medic", function(self)
	local is_trent = managers.player:player_unit() and managers.player:player_unit():inventory():equipped_unit():base():get_name_id() == "trent"
	if is_trent then
		managers.player:player_unit():sound():say("trent_health2", nil, nil)
	end
end)