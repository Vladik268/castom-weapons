--Terrible code + crash prone with mods
--Intended to play quad sound on fire. Perhaps someone more competent could do it.
local last_shot = -1.1
local overkill_cont = false
Hooks:PostHook(RaycastWeaponBase, "fire", "trent_overkill_fire", function(self)
	local is_trent = managers.player:player_unit():inventory():equipped_unit():base():get_name_id() == "trent" and self._setup.user_unit == managers.player:player_unit()
	local overkill_active = managers.player:has_activate_temporary_upgrade("temporary", "overkill_damage_multiplier")
	local overkill_time = managers.player:get_activate_temporary_expire_time("temporary", "overkill_damage_multiplier") - Application:time()
	local overkill_value = managers.player:upgrade_value("temporary", "overkill_damage_multiplier")[2]
	if not overkill_active or overkill_time <= 0 then	
		last_shot = -1.1
		overkill_cont = false
	end
	if is_trent and overkill_active then
		if (overkill_time <= overkill_value - 2.1 or overkill_cont) and overkill_time > 3 then 
			if last_shot + 1.1 < Application:time() then 
				last_shot = Application:time()
				overkill_cont = true
				managers.player:player_unit():sound():say("trent_damage2", nil, nil)
			end
		end
	end
end)
