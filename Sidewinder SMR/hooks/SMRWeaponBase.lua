SMRWeaponBase = SMRWeaponBase or class(ProjectileWeaponBase)

function SMRWeaponBase:init(unit)
	SMRWeaponBase.super.init(self, unit)

	self._bullet_slotmask = managers.slot:get_mask("arrow_impact_targets")
	self._extra_projectile_distance = 70
end

local mvec_spread_direction = Vector3()
function SMRWeaponBase:_fire_raycast(user_unit, from_pos, direction, dmg_mul, shoot_player, spread_mul, autohit_mul, suppr_mul, shoot_through_data)
	local spread_x, spread_y = self:_get_spread(user_unit)
	local right = direction:cross(Vector3(0, 0, 1)):normalized()
	local up = direction:cross(right):normalized()
	local theta = math.random() * 360
	local ax = math.sin(theta) * math.random() * spread_x * (spread_mul or 1)
	local ay = math.cos(theta) * math.random() * spread_y * (spread_mul or 1)

	self._dmg_mul = 1

	mvector3.set(mvec_spread_direction, direction)
	mvector3.add(mvec_spread_direction, right * math.rad(ax))
	mvector3.add(mvec_spread_direction, up * math.rad(ay))

	local potential_spawn_position = from_pos + (mvec_spread_direction * self._extra_projectile_distance)
	local extra_forward_ray = World:raycast("ray", from_pos, potential_spawn_position, "slot_mask", self._bullet_slotmask)

	local unit_name = Idstring("units/mods/weapons/wpn_prj_at_sidewinder_explosive/wpn_prj_at_sidewinder_explosive")
	local unit = World:spawn_unit(unit_name, extra_forward_ray and extra_forward_ray.position or potential_spawn_position, Rotation(mvec_spread_direction, math.UP))

	local owner_peer = managers.network:session():local_peer()
	local thrower_unit = owner_peer:unit()
	local weapon_unit = self._unit

	if thrower_unit and alive(thrower_unit) then
		unit:base():set_thrower_unit(thrower_unit)
	end

	if weapon_unit and alive(weapon_unit) then
		unit:base():set_weapon_unit(weapon_unit)
	end

	if unit:base().set_owner_peer_id then
		unit:base():set_owner_peer_id(owner_peer:id())
	end

	if extra_forward_ray and (extra_forward_ray.distance < self._extra_projectile_distance) then
		unit:base():create_sweep_data()
		unit:base():_on_collision(extra_forward_ray)
	else
		unit:base():throw(mvec_spread_direction)
		unit:damage():add_body_collision_callback(callback(unit:base(), unit:base(), "clbk_impact"))
		unit:base():create_sweep_data()
	end

	managers.statistics:shot_fired({
		hit = false,
		weapon_unit = self._unit
	})

	return {}
end

function SMRWeaponBase:clbk_assembly_complete(...)
	SMRWeaponBase.super.clbk_assembly_complete(self, ...)

	local type_part = managers.weapon_factory:get_part_from_weapon_by_type("body", self._parts)

	if type_part and type_part.unit and type_part.unit.digital_gui and type_part.unit:digital_gui() then
		self._smr_digital_gui = type_part.unit:digital_gui()
	end

	if table.contains(self._blueprint, "fps_at_sidewinder_classic_magazine") then
		self._classic_reload = true
	end
end

function SMRWeaponBase:reload_prefix()
	if self._classic_reload then
		return "classic_"
	end
end

function SMRWeaponBase:set_ammo_remaining_in_clip(...)
	SMRWeaponBase.super.set_ammo_remaining_in_clip(self, ...)

	if self._smr_digital_gui then
		local percentage = self:get_ammo_remaining_in_clip() / self:get_ammo_max_per_clip()
		self._smr_digital_gui:set_ammo_percentage(percentage)
	end
end

function SMRWeaponBase:calculate_ammo_max_per_clip(...)
	local ammo = SMRWeaponBase.super.calculate_ammo_max_per_clip(self, ...)

	local clip_adder = 0
	if self._factory_id and self._blueprint then
		local custom_stats = managers.weapon_factory:get_custom_stats_from_weapon(self._factory_id, self._blueprint)
		for part_id, stats in pairs(custom_stats) do
			if stats.clip_adder then
				clip_adder = clip_adder + stats.clip_adder
			end
		end
	end

	return ammo + clip_adder
end