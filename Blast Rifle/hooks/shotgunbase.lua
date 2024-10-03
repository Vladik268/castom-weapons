--Allows instantelectricbulletbase to deal damage (instead of being forced to 0)

InstantElectricBulletBase = InstantElectricBulletBase or class(InstantBulletBase)

function InstantElectricBulletBase:give_impact_damage(col_ray, weapon_unit, user_unit, damage, armor_piercing)
	local hit_unit = col_ray.unit
	local action_data = {
		damage = damage,
		weapon_unit = weapon_unit,
		attacker_unit = user_unit,
		col_ray = col_ray,
		armor_piercing = armor_piercing,
		attacker_unit = user_unit,
		attack_dir = col_ray.ray,
		variant = weapon_unit:base() and weapon_unit:base().get_tase_strength and weapon_unit:base():get_tase_strength() or "light"
	}
	local defense_data = hit_unit and hit_unit:character_damage().damage_tase and hit_unit:character_damage():damage_tase(action_data)

	return defense_data
end