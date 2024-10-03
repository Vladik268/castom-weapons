AkimboGrenadeLauncherBase = AkimboGrenadeLauncherBase or class(AkimboWeaponBase)

function AkimboGrenadeLauncherBase:init(...)
    AkimboGrenadeLauncherBase.super.init(self, ...)
    self._projectile_type = self:weapon_tweak_data().projectile_type
    self._client_authoritative = true
    self._shoot_left = false
end

function AkimboGrenadeLauncherBase:setup_default()
    GrenadeLauncherBase.setup_default(self)
end

function AkimboGrenadeLauncherBase:_fire_raycast(user_unit, from_pos, direction, dmg_mul, shoot_player, spread_mul,
    autohit_mul, suppr_mul, shoot_through_data)
    return GrenadeLauncherBase._fire_raycast(self, user_unit, from_pos, direction, dmg_mul, shoot_player, spread_mul,
               autohit_mul, suppr_mul, shoot_through_data)
end

function AkimboGrenadeLauncherBase:get_damage_falloff(damage, col_ray, user_unit)
    return GrenadeLauncherBase.get_damage_falloff(self, damage, col_ray, user_unit)
end

function AkimboGrenadeLauncherBase:run_and_shoot_allowed()
    return GrenadeLauncherBase.run_and_shoot_allowed(self)
end

function AkimboGrenadeLauncherBase:_update_stats_values()
    GrenadeLauncherBase._update_stats_values(self)
end

function AkimboGrenadeLauncherBase:_adjust_throw_z(m_vec)
end

function AkimboGrenadeLauncherBase:projectile_damage_multiplier()
    return self._dmg_mul
end

function AkimboGrenadeLauncherBase:projectile_speed_multiplier()
    return 1
end

function AkimboGrenadeLauncherBase:_get_spawn_offset()
    return 0
end

function AkimboGrenadeLauncherBase:start_reload(...)
	AkimboGrenadeLauncherBase.super.start_reload(self, ...)
end

function AkimboGrenadeLauncherBase:fire(...)
    local result = nil
	if self._fire_second_gun_next then
		if alive(self._second_gun) then
			result = self._second_gun:base().super.fire(self._second_gun:base(), ...)

			if result then
				if self._fire_second_sound then
					self._fire_second_sound = false

					self._second_gun:base():_fire_sound()
				end

				managers.hud:set_ammo_amount(self:selection_index(), self:ammo_info())
				self._second_gun:base():tweak_data_anim_play("fire")
			end
		end

		self._fire_second_gun_next = false
	else
		result = AkimboWeaponBase.super.fire(self, ...)
		self._fire_second_gun_next = true
	end
    return result
end
NPCAkimboGrenadeLauncherBase = NPCAkimboGrenadeLauncherBase or class(NPCAkimboWeaponBase)
