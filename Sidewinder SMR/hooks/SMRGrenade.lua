SMRGrenade = SMRGrenade or class(ProjectileBase)

function SMRGrenade:init(unit)
	SMRGrenade.super.init(self, unit, true)

	self._slot_mask = managers.slot:get_mask("arrow_impact_targets")

	self._damage = 75
	self._damage_class = CoreSerialize.string_to_classtable("InstantExplosiveBulletBase")
end

function SMRGrenade:set_weapon_unit(weapon_unit)
	SMRGrenade.super.set_weapon_unit(self, weapon_unit)

	self._slot_mask = weapon_unit:base()._bullet_slotmask
	self._damage = weapon_unit:base()._damage
end

function SMRGrenade:throw(dir)
	local velocity = dir
	local launch_speed = 6445

	velocity = velocity * launch_speed
	velocity = Vector3(velocity.x, velocity.y, velocity.z)
	local mass_look_up_modifier = self._mass_look_up_modifier or 2
	local mass = math.max(mass_look_up_modifier * (1 + math.min(0, dir.z)), 1)

	if self._simulated then
		self._unit:push_at(mass, velocity, self._unit:body(0):center_of_mass())
	else
		self._velocity = velocity
	end
end

function SMRGrenade:_on_collision(col_ray)
	if alive(col_ray.unit) then
		self._damage_class:on_collision(col_ray, self._weapon_unit or self._unit, self._thrower_unit, self._damage, false, false)
	end

	self._unit:set_slot(0)
end