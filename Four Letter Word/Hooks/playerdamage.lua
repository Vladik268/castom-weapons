Hooks:PostHook(PlayerDamage, "damage_fire", "trent_burn", function(self)
	local is_trent = managers.player:player_unit() and managers.player:player_unit():inventory():equipped_unit():base():get_name_id() == "trent" and self._unit == managers.player:player_unit()
	if is_trent then
		if math.random(0, 1) == 0 then
			managers.player:player_unit():sound():say("trent_burn", nil, nil)
		else
			managers.player:player_unit():sound():say("trent_burn2", nil, nil)
		end
	end
end)

local quad_start = false
local quad_expire = false
Hooks:PostHook(PlayerDamage, "update", "trent_quad", function(self, unit, t, dt)
	local is_trent = managers.player:player_unit() and managers.player:player_unit():inventory():equipped_unit():base():get_name_id() == "trent" and self._unit == managers.player:player_unit()
	local overkill_active = managers.player:has_activate_temporary_upgrade("temporary", "overkill_damage_multiplier")
	local overkill_time = managers.player:get_activate_temporary_expire_time("temporary", "overkill_damage_multiplier") - t
	if overkill_active and overkill_time >= 19.95 and not quad_start then
		quad_start = true
		if is_trent then 
			managers.player:player_unit():sound():say("trent_damage", nil, nil)
		end
	end
	if is_trent and overkill_active and (overkill_time <= 3 and overkill_time >= 2.95) and not quad_expire then
		managers.player:player_unit():sound():say("trent_damage3", nil, nil)
		quad_expire = true
	end
	if overkill_time <= 0 then
		quad_start = false
		quad_expire = false
	end
end)