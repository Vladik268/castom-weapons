WeaponDescription._tsw_get_mods_stats = WeaponDescription._tsw_get_mods_stats or WeaponDescription._get_mods_stats
function WeaponDescription._get_mods_stats(name, base_stats, equipped_mods, bonus_stats)
	local mods_stats = WeaponDescription._tsw_get_mods_stats(name, base_stats, equipped_mods, bonus_stats)

	if equipped_mods then
		local factory_id = managers.weapon_factory:get_factory_id_by_weapon_id(name)
		local default_blueprint = managers.weapon_factory:get_default_blueprint_by_factory_id(factory_id)
		local part_data = nil

		local clip_adder = 0
		for _, mod in ipairs(equipped_mods) do
			part_data = managers.weapon_factory:get_part_data_by_part_id_from_weapon(mod, factory_id, default_blueprint)

			if part_data and part_data.custom_stats then
				if part_data.custom_stats.clip_adder then
					clip_adder = clip_adder + part_data.custom_stats.clip_adder
				end
			end
		end

		mods_stats.magazine.value = mods_stats.magazine.value + math.ceil(clip_adder)
	end

	return mods_stats
end

WeaponDescription._tsw_get_weapon_mod_stats = WeaponDescription._tsw_get_weapon_mod_stats or WeaponDescription._get_weapon_mod_stats
function WeaponDescription._get_weapon_mod_stats(mod_name, weapon_name, base_stats, mods_stats, equipped_mods)
	local mod_stats = WeaponDescription._tsw_get_weapon_mod_stats(mod_name, weapon_name, base_stats, mods_stats, equipped_mods)

	local factory_id = managers.weapon_factory:get_factory_id_by_weapon_id(weapon_name)
	local default_blueprint = managers.weapon_factory:get_default_blueprint_by_factory_id(factory_id)
	local part_data = nil

	for _, mod in pairs(mod_stats) do
		part_data = nil

		if mod.name then
			part_data = managers.weapon_factory:get_part_data_by_part_id_from_weapon(mod.name, factory_id, default_blueprint)
		end

		local clip_adder = 0
		if part_data and part_data.custom_stats then
			if part_data.custom_stats.clip_adder then
				clip_adder = clip_adder + part_data.custom_stats.clip_adder
			end
		end

		mod.magazine = mod.magazine + math.ceil(clip_adder)
	end

	return mod_stats
end