Hooks:PostHook(PlayerStandard, "_start_action_jump", "trent_jump", function(self)
	if managers.player:player_unit() and managers.player:player_unit():inventory():equipped_unit():base():get_name_id() == "trent" then
		managers.player:player_unit():sound():say("trent_jump", nil, nil)
	end
end)

function PlayerStandard:_find_pickups(t)
	local pickups = World:find_units_quick("sphere", self._unit:movement():m_pos(), self._pickup_area, self._slotmask_pickups)
	local grenade_tweak = tweak_data.blackmarket.projectiles[managers.blackmarket:equipped_grenade()]
	local may_find_grenade = not grenade_tweak.base_cooldown and managers.player:has_category_upgrade("player", "regain_throwable_from_ammo")
	local is_trent = managers.player:player_unit() and managers.player:player_unit():inventory():equipped_unit():base():get_name_id() == "trent"

	for _, pickup in ipairs(pickups) do
		if pickup:pickup() and pickup:pickup():pickup(self._unit) then
			if may_find_grenade then
				local data = managers.player:upgrade_value("player", "regain_throwable_from_ammo", nil)

				if data then
					managers.player:add_coroutine("regain_throwable_from_ammo", PlayerAction.FullyLoaded, managers.player, data.chance, data.chance_inc)
				end
			end
			if is_trent then
				managers.player:player_unit():sound():say("trent_pickup", nil, nil)
			end
			for id, weapon in pairs(self._unit:inventory():available_selections()) do
				managers.hud:set_ammo_amount(id, weapon.unit:base():ammo_info())
			end
		end
	end
end

function PlayerStandard:_update_foley(t, input)
	local is_trent = managers.player:player_unit() and managers.player:player_unit():inventory():equipped_unit():base():get_name_id() == "trent"
	if self._state_data.on_zipline then
		return
	end

	if not self._gnd_ray and not self._state_data.on_ladder then
		if not self._state_data.in_air then
			self._state_data.in_air = true
			self._state_data.enter_air_pos_z = self._pos.z

			self:_interupt_action_running(t)
			self._unit:set_driving("orientation_object")
		end
	elseif self._state_data.in_air then
		self._unit:set_driving("script")

		self._state_data.in_air = false
		local from = self._pos + math.UP * 10
		local to = self._pos - math.UP * 60
		local material_name, pos, norm = World:pick_decal_material(from, to, self._slotmask_bullet_impact_targets)

		self._unit:sound():play_land(material_name)

		if self._unit:character_damage():damage_fall({
			height = self._state_data.enter_air_pos_z - self._pos.z
		}) then
			if is_trent and self._state_data.enter_air_pos_z - self._pos.z < 631 then
				managers.player:player_unit():sound():say("trent_land2", nil, nil)
			end
			self._running_wanted = false

			managers.rumble:play("hard_land")
			self._ext_camera:play_shaker("player_fall_damage")
			self:_start_action_ducking(t)
		elseif input.btn_run_state then
			self._running_wanted = true
		end

		self._jump_t = nil
		self._jump_vel_xy = nil
		if self._state_data.enter_air_pos_z - self._pos.z > 90 and self._state_data.enter_air_pos_z - self._pos.z < 300 and is_trent then
			managers.player:player_unit():sound():say("trent_land", nil, nil)
		end

		self._ext_camera:play_shaker("player_land", 0.5)
		managers.rumble:play("land")
	elseif self._jump_vel_xy and t - self._jump_t > 0.3 then
		self._jump_vel_xy = nil

		if input.btn_run_state then
			self._running_wanted = true
		end
	end

	self:_check_step(t)
end