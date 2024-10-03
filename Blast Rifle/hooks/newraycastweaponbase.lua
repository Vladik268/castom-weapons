local use_real_ammo_count = true

Hooks:PostHook(NewRaycastWeaponBase,"_set_parts_enabled","blastrifle_set_parts_visible",function(self,enabled)
	if self._blastrifle_ammocounter then 
		self._blastrifle_ammocounter:set_visible(enabled)
	end
end)

Hooks:PreHook(NewRaycastWeaponBase,"destroy","blastrifle_ondestroyed",function(self,unit)
	managers.player._message_system:unregister(Message.OnEnemyKilled,"blastrifle_onenemykill_" .. tostring(unit:key()))
end)

local orig_blast_has_range_distance_scope = NewRaycastWeaponBase.has_range_distance_scope
function NewRaycastWeaponBase:has_range_distance_scope(...)
	if self._blastrifle_ammocounter then 
		return self._parts and self._assembly_complete and true or false
		--[[
		if self._assembly_complete and self._parts and not result then 
			for partid,part in pairs(self._parts) do 
				local td = tweak_data.weapon.factory.parts[partid]
				if td and td.type == "iwsd" then 
					return true
				end
			end
		end
		--]]
	end
	return orig_blast_has_range_distance_scope(self,...)
end

Hooks:PostHook(NewRaycastWeaponBase,"set_scope_range_distance","blastrifle_set_scope_range_distance",function(self,distance)
	local ammocounter = self._blastrifle_ammocounter
	if ammocounter then 
		ammocounter:set_range_counter(distance)
	end
end)

local function set_ammo_reserve (self,amount)
	local ammocounter = self._blastrifle_ammocounter
	if ammocounter then 
		local ammo_total = self:get_ammo_total()
		if use_real_ammo_count then 
			ammocounter:set_ammo_reserve_count(ammo_total - self:get_ammo_remaining_in_clip())
		else
			ammocounter:set_ammo_reserve_count(ammo_total)
		end
	end
end
Hooks:PostHook(NewRaycastWeaponBase,"on_reload","blastrifle_on_reloaded",set_ammo_reserve)
Hooks:PostHook(NewRaycastWeaponBase,"set_ammo_total","blastrifle_set_ammo_total",set_ammo_reserve)

Hooks:PostHook(NewRaycastWeaponBase,"set_ammo_remaining_in_clip","blastrifle_set_ammo_remaining_in_clip",function(self,amount)
	local ammocounter = self._blastrifle_ammocounter
	if ammocounter then 
		ammocounter:set_magazine_count(amount,self:get_ammo_max_per_clip())
	end
end)
				
Hooks:PostHook(NewRaycastWeaponBase,"clbk_assembly_complete","blastrifle_rcwb_init",function(self,clbk,parts,blueprint)
	if self:get_name_id() == "blast" then 
		local readout = self._parts.wpn_fps_upg_blast_iwsd_readout
		local readout_unit = readout and readout.unit
		if alive(readout_unit) then 
			local ammocounter = readout_unit:blastrifle_ammo_counter()
			self._blastrifle_ammocounter = ammocounter
			if ammocounter then 
				local damage_type_by_ammotype = {
--					wpn_fps_upg_blast_ammo_ap = "bullet",
--					wpn_fps_upg_blast_ammo_syphon = "bullet",
					wpn_fps_upg_blast_ammo_fire = "fire",
					wpn_fps_upg_blast_ammo_poison = "poison",
					wpn_fps_upg_blast_ammo_stun = "tase"
				}
				local ammo_damage_variant= "bullet"
				
				for partid,part in pairs(self._parts) do 
					local td = tweak_data.weapon.factory.parts[partid]
					if td and td.type == "ammo" then 
						ammo_damage_variant = partid and damage_type_by_ammotype[partid] or ammo_damage_variant
						ammocounter:set_ammotype_icon(partid)
						break
					end
				end
				
				
				local pm = managers.player
				if pm then 
					pm._message_system:register(Message.OnEnemyKilled,"blastrifle_onenemykill_" .. tostring(self._unit:key()),function(weapon_unit,variant,killed_unit)
						if ammocounter and weapon_unit == self._unit and variant == "bullet" or variant == ammo_damage_variant then
							ammocounter:add_to_kills_counter(1)
						end
					end)
				end
			end
		
		end
		
	end
end)

SyphonAmmoBase = SyphonAmmoBase or class(InstantBulletBase)

function SyphonAmmoBase:give_impact_damage(col_ray,weapon_unit,user_unit,damage,armor_piercing,shield_knock,knock_down,stagger,variant,...)
	local cd = user_unit.character_damage and user_unit:character_damage() 
	if cd then 
		local hit_unit = col_ray.unit
		if alive(hit_unit) and hit_unit.character_damage and hit_unit:character_damage() then 
			local hit_cd = hit_unit:character_damage()
			if hit_cd.can_kill and hit_cd:can_kill() and not hit_cd:dead() then 
				local weaponbase = weapon_unit and weapon_unit:base()
				if weaponbase and weaponbase._blastrifle_ammocounter then 
					weaponbase._blastrifle_ammocounter:refresh_syphon_spin_timer()
				end
				
				local syphoned_amount = damage / 10
				if cd.change_armor then 
					cd:change_armor(syphoned_amount)
				end
				if cd.change_health then
					if cd.full_health and not cd:full_health() then 
						cd:change_health(syphoned_amount)
					end
				end
			end
		end
	end
	return SyphonAmmoBase.super.give_impact_damage(self,col_ray,weapon_unit,user_unit,damage,armor_piercing,shield_knock,knock_down,stagger,variant,...)
end