Hooks:PreHook( PlayerStandard, "_check_action_cash_inspect", "_check_action_cash_inspect_malorian", function(self, t, input)

	if not input.btn_cash_inspect_press then
		return
	end

	local pain = self:_interacting() or self:is_deploying() or self:_changing_weapon() or self:_is_throwing_projectile() or self:_is_meleeing() or self:_on_zipline() or self:running() or self:_is_reloading() or self:in_steelsight() or self:is_equipping() or self:shooting() or self:_is_cash_inspecting(t)

	if pain then
		return
	end
	
	self._equipped_unit:base():tweak_data_anim_play("inspect")

end)

Hooks:PostHook( PlayerStandard, "_interupt_action_cash_inspect", "_interupt_action_cash_inspect_malorian", function(self, t)

	if self:_is_cash_inspecting() then
		self._ext_camera:play_redirect(Idstring("idle"))
	end
	
	self._equipped_unit:base():tweak_data_anim_stop("inspect")

end)

Hooks:PostHook( PlayerStandard, "_check_action_cash_inspect", "_check_action_cash_inspect_malorian_2", function(self, t)

	local pain = self:_is_cash_inspecting(t)

	if pain then
		return
	end
	
	self._equipped_unit:base():tweak_data_anim_stop("inspect")

end)





--fire melee effect below this line
local mvec3_dis_sq = mvector3.distance_sq
local mvec3_set = mvector3.set
local mvec3_set_z = mvector3.set_z
local mvec3_sub = mvector3.subtract
local mvec3_add = mvector3.add
local mvec3_mul = mvector3.multiply
local mvec3_norm = mvector3.normalize

local temp_vec1 = Vector3()

local tmp_ground_from_vec = Vector3()
local tmp_ground_to_vec = Vector3()
local up_offset_vec = math.UP * 30
local down_offset_vec = math.UP * -40

local fwd_ray_to = Vector3()
local win32 = SystemInfo:platform() == Idstring("WIN32")

local mvec_pos_new = Vector3()
local mvec_achieved_walk_vel = Vector3()
local mvec_move_dir_normalized = Vector3()

local melee_vars = {
	"player_melee",
	"player_melee_var2"
}

local debug_draw = false

Hooks:PostHook(PlayerStandard,"_start_action_melee","_start_action_melee_malorian",function(self,t,input,instant)
	local equipped_weapon = self:get_equipped_weapon()
	local weapon_name = equipped_weapon and equipped_weapon:get_name_id()
	local melee_entry = managers.blackmarket:equipped_melee_weapon()
	local wtd = weapon_name and tweak_data.weapon[weapon_name]
	if not (wtd and wtd.has_cp_fire_melee and melee_entry == "weapon") then
		return
	end
	
	local range = wtd.fire_melee_range or 400
	local radius = wtd.fire_melee_radius or 66
	local damage = (wtd.fire_melee_damage or 10) * managers.player:get_melee_dmg_multiplier()
	
	local from = self._unit:movement():m_head_pos()
	local rotation = self._unit:movement():m_head_rot()
	local base_direction = rotation:y()
	
	local yaw = rotation:yaw()
	local pitch = rotation:pitch()
	local roll = rotation:roll()
	
	local player_can_shield_knock = managers.player:has_category_upgrade("player", "shield_knock")
	
	local function do_melee_damage(hit_unit,col_ray)
		local can_shield_knock
		local character_unit = hit_unit
		if player_can_shield_knock and hit_unit:in_slot(8) and alive(hit_unit:parent()) and not hit_unit:parent():character_damage():is_immune_to_shield_knockback() then
			can_shield_knock = true
			character_unit = hit_unit:parent() or character_unit
		end
		
		local dmg_ext = character_unit:character_damage()
		if dmg_ext and dmg_ext.damage_melee then
			
			--below is largely vanilla (various melee dmg mul code)
			--why it's not inside its own melee mul func, i don't know
			local dmg_multiplier = 1

			if not managers.enemy:is_civilian(character_unit) and not managers.groupai:state():is_enemy_special(character_unit) then
				dmg_multiplier = dmg_multiplier * managers.player:upgrade_value("player", "non_special_melee_multiplier", 1)
			else
				dmg_multiplier = dmg_multiplier * managers.player:upgrade_value("player", "melee_damage_multiplier", 1)
			end

			dmg_multiplier = dmg_multiplier * managers.player:upgrade_value("player", "melee_" .. tostring(tweak_data.blackmarket.melee_weapons[melee_entry].stats.weapon_type) .. "_damage_multiplier", 1)

			if managers.player:has_category_upgrade("melee", "stacking_hit_damage_multiplier") then
				self._state_data.stacking_dmg_mul = self._state_data.stacking_dmg_mul or {}
				self._state_data.stacking_dmg_mul.melee = self._state_data.stacking_dmg_mul.melee or {
					nil,
					0
				}
				local stack = self._state_data.stacking_dmg_mul.melee

				if stack[1] and t < stack[1] then
					dmg_multiplier = dmg_multiplier * (1 + managers.player:upgrade_value("melee", "stacking_hit_damage_multiplier", 0) * stack[2])
				else
					stack[2] = 0
				end
			end

			local health_ratio = self._ext_damage:health_ratio()
			local damage_health_ratio = managers.player:get_damage_health_ratio(health_ratio, "melee")

			if damage_health_ratio > 0 then
				local damage_ratio = damage_health_ratio
				dmg_multiplier = dmg_multiplier * (1 + managers.player:upgrade_value("player", "melee_damage_health_ratio_multiplier", 0) * damage_ratio)
			end

			dmg_multiplier = dmg_multiplier * managers.player:temporary_upgrade_value("temporary", "berserker_damage_multiplier", 1)
			local target_dead = character_unit:character_damage().dead and not character_unit:character_damage():dead()
			local target_hostile = managers.enemy:is_enemy(character_unit) and not tweak_data.character[character_unit:base()._tweak_table].is_escort and character_unit:brain():is_hostile()
			local life_leach_available = managers.player:has_category_upgrade("temporary", "melee_life_leech") and not managers.player:has_activate_temporary_upgrade("temporary", "melee_life_leech")

			if target_dead and target_hostile and life_leach_available then
				managers.player:activate_temporary_upgrade("temporary", "melee_life_leech")
				self._unit:character_damage():restore_health(managers.player:temporary_upgrade_value("temporary", "melee_life_leech", 1))
			end
			--end vanilla section
			
			dmg_ext:damage_melee({
				variant = "melee",
				damage = damage,
				damage_effect = nil,
				attacker_unit = self._unit,
				col_ray = col_ray,
				shield_knock = can_shield_knock,
				name_id = melee_entry,
				charge_lerp_value = 0
			})
		end
	end
	
	local function do_fireball_cast(angle,unique_hits)
		local new_rotation = Rotation(yaw+angle,pitch,roll)
		local direction = new_rotation:y()
		local to = from + direction * range
		
		local effect_name = "effects/payday2/particles/explosions/flamethrower"
			
		if debug_draw then
			Draw:brush(Color.red:with_alpha(0.2),5):line(from,to)
			Draw:brush(Color.green:with_alpha(0.2),5):sphere(to,radius)
		end
		
		local col_ray = self._unit:raycast("ray", from, to, "slot_mask", self._slotmask_bullet_impact_targets, "sphere_cast_radius", radius, "ray_type", "body melee")
		if col_ray then
			local hit_unit = col_ray.unit
			if hit_unit and alive(hit_unit) then
		
				local u_key = hit_unit:key()
				if unique_hits[u_key] then
					--log("already hit")
				else
					--register hit so the unit isn't double-hit
					unique_hits[u_key] = hit_unit
					do_melee_damage(hit_unit,col_ray)
					asdf = col_ray
				end
		
			end
			
			World:effect_manager():spawn({
				effect = Idstring(effect_name),
				position = col_ray.position,
				rotation = Rotation()
			})
		else
			--aoe (can hit multiple units)
			local sphere_hits = World:find_units_quick("sphere",to,radius,"slot_mask",self._slotmask_bullet_impact_targets)
			for _,hit_unit in pairs(sphere_hits) do 
				--don't check unique_hits for aoes; allow hitting same enemy multiple times from this type of hit
				
				--do_melee_damage(hit_unit,{})
			end
			--sphere cast
			World:effect_manager():spawn({
				effect = Idstring(effect_name),
				position = to,
				rotation = Rotation()
			})
		end
	end
	
	local num_casts = 5
	local is_even = num_casts % 2 == 0
	local half_casts = math.floor(num_casts / 2)
	local angle_interval = 10
	
	local unique_hits = {} --don't hit the same unit multiple times
	if num_casts > 1 then
		for i = 1,half_casts,1 do 
			local left_angle = i * angle_interval
			local right_angle = -left_angle
			do_fireball_cast(left_angle,unique_hits)
			do_fireball_cast(right_angle,unique_hits)
		end
	end
	if not is_even then
		--do cast straight ahead
		do_fireball_cast(0,unique_hits)
	end
	--[[
	for _,data in pairs(unique_hits) do 
		local unit = data.unit
		local raycast = data.raycast
		local dmg_ext = unit:character_damage()
		if dmg_ext and dmg_ext.damage_fire then
		
			local hits,hit_enemy = equipped_weapon:_collect_hits(from,to)
			if hit_enemy then
				asdf = hits
				
				dmg_ext:damage_melee({
					variant = "melee",
					damage = damage,
					damage_effect = nil,
					attacker_unit = self._unit,
					col_ray = hits,
					shield_knock = false,
					name_id = melee_entry,
					charge_lerp_value = 0
				})
			end
			
		end
		
		
	end
	--]]
	
end)

--[[
			
	local fire_dot_data = wtd.melee_fire_dot_data or {
		dot_trigger_chance = 75,
		dot_damage = 30,
		dot_length = 1.6,
		dot_trigger_max_distance = 3000,
		dot_tick_period = 0.5
	}
	
			dmg_ext:damage_fire({
				variant = "fire",
				damage = damage,
				weapon_unit = equipped_weapon._unit,
				attacker_unit = self._unit,
				col_ray = {
					ray = raycast,
					body = raycast.body,
					hit_position = to,
				},
				armor_piercing = false,
				shield_knock = false,
				knock_down = nil,
				stagger = nil,
				fire_dot_data = fire_dot_data
			})
--]]
			
--[[


--based on FlamethrowerEffectExtension
CoolFireEffect = {
debug_draw = false,
	flame_effects_list = {}
}

function CoolFireEffect:update(t,dt)
	Console:SetTracker(t,1)
	for i=#self.flame_effects_list,1,-1 do 
		local kill_effect = false
		
		local flame_effect_data = self.flame_effects_list[i]
		if World:effect_manager():alive(flame_effect_data.id) then
			flame_effect_data.duration = flame_effect_data.duration - dt
			if flame_effect_data.duration < 0 then
				--timeout
				Log("timeout")
				kill_effect = true
			else
				--calculate next position
				mvec3_set(temp_vec1,flame_effect_data.last_position)
				mvec3_add(temp_vec1,flame_effect_data.direction * flame_effect_data.range * dt)
				
				local raycast = World:raycast(flame_effect_data.last_position,temp_vec1)
				if raycast ~= nil then
					--hit object; kill effect
					Log("collision")
					kill_effect = true

					--may as well move the last position of the flame effect to the point of impact
					temp_vec1 = raycast.position or temp_vec1
				end
				World:effect_manager():move(flame_effect_data.id, temp_vec1)
				flame_effect_data.last_position = temp_vec1
			end
		elseif flame_effect_data.was_alive == false then
			flame_effect_data.was_alive = true 
			--one frame of grace for effects that weren't previously extant
		else
			Log("dead effect")
--			kill_effect = true
		end
		
		if kill_effect then
			World:effect_manager():kill(flame_effect_data.id)
			table.remove(self.flame_effects_list,i)
		end
	end
end

function CoolFireEffect:spawn_fire_effect(effect_name,from_pos,range,direction,duration)
	local rotation = Rotation(direction, math.UP)
	local effect_id = World:effect_manager():spawn({
		effect = Idstring(effect_name),
		position = from_pos,
		rotation = rotation
	})
	if effect_id ~= -1 then
		local data = {
			id = effect_id,
			was_alive = false,
			last_position = from_pos,
			direction = direction,
			range = range,
			duration = duration
		}
		table.insert(self.flame_effects_list,data)
	end
end

if BeardLib then
	BeardLib:AddUpdater("malorian_update_fire_effect",callback(CoolFireEffect,CoolFireEffect,"update"))
end


local orig_do_melee = PlayerStandard._start_action_melee

function PlayerStandard:_start_action_melee(t, input, instant,...)
	local equipped_weapon = self:get_equipped_weapon()
	
	if not (alive(equipped_weapon) and equipped_weapon.has_cp_fire_melee) then
		return orig_do_melee(self,t,input,instant,...)
	end
	
	self._equipped_unit:base():tweak_data_anim_stop("fire")
	self:_interupt_action_reload(t)
	self:_interupt_action_steelsight(t)
	self:_interupt_action_running(t)
	self:_interupt_action_charging_weapon(t)

	self._state_data.melee_charge_wanted = nil
	self._state_data.meleeing = true
	self._state_data.melee_start_t = nil
	local melee_entry = managers.blackmarket:equipped_melee_weapon()
	local primary = managers.blackmarket:equipped_primary()
	local primary_id = primary.weapon_id
	local bayonet_id = managers.blackmarket:equipped_bayonet(primary_id)
	local bayonet_melee = false

	if bayonet_id and melee_entry == "weapon" and self._equipped_unit:base():selection_index() == 2 then
		bayonet_melee = true
	end

	if instant then
		self:_do_action_melee(t, input)

		return
	end

	self:_stance_entered()

	if self._state_data.melee_global_value then
		self._camera_unit:anim_state_machine():set_global(self._state_data.melee_global_value, 0)
	end

	local melee_entry = managers.blackmarket:equipped_melee_weapon()
	self._state_data.melee_global_value = tweak_data.blackmarket.melee_weapons[melee_entry].anim_global_param

	self._camera_unit:anim_state_machine():set_global(self._state_data.melee_global_value, 1)

	local current_state_name = self._camera_unit:anim_state_machine():segment_state(self:get_animation("base"))
	local attack_allowed_expire_t = tweak_data.blackmarket.melee_weapons[melee_entry].attack_allowed_expire_t or 0.15
	self._state_data.melee_attack_allowed_t = t + (current_state_name ~= self:get_animation("melee_attack_state") and attack_allowed_expire_t or 0)
	local instant_hit = tweak_data.blackmarket.melee_weapons[melee_entry].instant

	if not instant_hit then
		self._ext_network:send("sync_melee_start", 0)
	end

	if current_state_name == self:get_animation("melee_attack_state") then
		self._ext_camera:play_redirect(self:get_animation("melee_charge"))

		return
	end

	local offset = nil

	if current_state_name == self:get_animation("melee_exit_state") then
		local segment_relative_time = self._camera_unit:anim_state_machine():segment_relative_time(self:get_animation("base"))
		offset = (1 - segment_relative_time) * 0.9
	end

	offset = math.max(offset or 0, attack_allowed_expire_t)

	self._ext_camera:play_redirect(self:get_animation("melee_enter"), nil, offset)
end

--]]