--Partially based on Dr. Newbie's code, thanks!
local protect1 = false
local protect2 = false
Hooks:PostHook(HUDManager, "set_teammate_custom_radial", "trent_swan", function(self, i, data)
	local peer = managers.network and managers.network:session():peer(i) or nil
	local has_swan = managers.player:has_category_upgrade("temporary", "berserker_damage_multiplier")
	local swan_aced = has_swan and managers.player:upgrade_value("temporary", "berserker_damage_multiplier")[2] == 6
	local is_trent = managers.player:player_unit() and managers.player:player_unit():inventory():equipped_unit():base():get_name_id() == "trent"
	if has_swan then
		if (peer and peer == managers.network:session():local_peer()) or Global.game_settings.single_player then
			local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN_PD2)
			if hud and hud.panel then
				if data and data.current and data.total then
					if data.current/data.total >= 0.95 and swan_aced then
						if is_trent and not protect1 then
							managers.player:player_unit():sound():say("trent_protect", nil, nil)
							protect1 = true
						end
					end
					if (data.current/data.total <= 0.5 and data.current/data.total >= 0.45 and swan_aced) or (data.current/data.total > 0 and not swan_aced) then
						if is_trent and not protect2 then
							managers.player:player_unit():sound():say("trent_protect2", nil, nil)
							protect2 = true
						end
					end
					if data.current == 0 then
						protect1 = false
						protect2 = false
					end
				end
			end
		end
	end
end)

local sound1 = false
local sound2 = false
Hooks:PostHook(HUDManager, "set_teammate_ability_radial", "trent_chico", function(self, i, data)
	local peer = managers.network and managers.network:session():peer(i) or nil
	local is_chico = managers.blackmarket:equipped_projectile() == "chico_injector"
	local is_trent = managers.player:player_unit() and managers.player:player_unit():inventory():equipped_unit():base():get_name_id() == "trent"
	if (peer and peer == managers.network:session():local_peer()) or Global.game_settings.single_player then
		local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN_PD2)
		if hud and hud.panel then
			if data and data.current and data.total then
				if data.current/data.total >= 0.95 then
					if is_trent and is_chico and not sound1 then
						managers.player:player_unit():sound():say("trent_protect", nil, nil)
						sound1 = true
					end
				end
				if data.current/data.total <= 0.5 and data.current/data.total >= 0.45 then
					if is_trent and is_chico and not sound2 then
						managers.player:player_unit():sound():say("trent_protect2", nil, nil)
						sound2 = true
					end
				end
				if data.current == 0 then
					sound1 = false
					sound2 = false
				end
			end
		end
	end
end)



