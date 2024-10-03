KuroGrenade = KuroGrenade or class(ProjectileBase)
local trail = "effects/kuro_trail"

function KuroGrenade:init(unit)
	KuroGrenade.super.init(self, unit, true)

	self._slot_mask = managers.slot:get_mask("arrow_impact_targets")

	self._damage = 55
	self._damage_class = CoreSerialize.string_to_classtable("InstantBulletBase")
end

function KuroGrenade:set_weapon_unit(weapon_unit)
	KuroGrenade.super.set_weapon_unit(self, weapon_unit)

	self._slot_mask = weapon_unit:base()._bullet_slotmask
	self._damage = weapon_unit:base()._damage
	
	managers.game_play_central:add_projectile_trail(self._unit, self._unit:orientation_object(), trail)
end

function KuroGrenade:throw(dir)
	local velocity = dir
	local launch_speed = 1500

	velocity = velocity * launch_speed
	velocity = Vector3(velocity.x, velocity.y, velocity.z)
	local mass_look_up_modifier = 1
	local mass = math.max(mass_look_up_modifier * (1 + math.min(0, dir.z)), 1)

	if self._simulated then
		self._unit:push_at(mass, velocity, self._unit:body(0):center_of_mass())
		World:play_physic_effect(Idstring("physic_effects/anti_gravitate"), self._unit)
	else
		self._velocity = velocity
	end
end

function KuroGrenade:_on_collision(col_ray)
	if alive(col_ray.unit) then
		self._damage_class:on_collision(col_ray, self._weapon_unit or self._unit, self._thrower_unit, self._damage, false, false)
	end
	
	managers.game_play_central:remove_projectile_trail(self._unit)
	self._unit:set_slot(0)
end



local tmp_vel = Vector3()

function KuroGrenade:update(unit, t, dt)
	local autohit_dir = self:_calculate_autohit_direction()

	if autohit_dir then
		local body = self._unit:body(0)

		mvector3.set(tmp_vel, body:velocity())

		local speed = mvector3.normalize(tmp_vel)

		mvector3.step(tmp_vel, tmp_vel, autohit_dir, dt * 10)
		body:set_velocity(tmp_vel * speed)
	end
	

	KuroGrenade.super.update(self, unit, t, dt)
end

local tmp_vec1 = Vector3()

function KuroGrenade:_calculate_autohit_direction()
	local enemies = managers.enemy:all_enemies()
	local pos = self._unit:position()
	local dir = self._unit:rotation():y()
	local closest_dis, closest_pos = nil

	for u_key, enemy_data in pairs(enemies) do
		local enemy = enemy_data.unit

		if enemy:base():lod_stage() == 1 and not enemy:in_slot(16) then
			local com = enemy:get_object(Idstring("Spine1")):position()

			mvector3.direction(tmp_vec1, pos, com)

			local angle = mvector3.angle(dir, tmp_vec1)

			if angle < 30 then
				local dis = mvector3.distance_sq(pos, com)

				if not closest_dis or dis < closest_dis then
					closest_dis = dis
					closest_pos = com
				end
			end
		end
	end

	if closest_pos then
		mvector3.direction(tmp_vec1, pos, closest_pos)

		return tmp_vec1
	end
end
