Hooks:PostHook(WeaponFactoryTweakData, "create_bonuses", "VSSModInit", function(self)
	if self.parts.wpn_fps_snp_vss_pso and self.parts.wpn_fps_upg_vss_irons and self.parts.wpn_fps_upg_vss_irons_il then
		table.list_append(self.parts.wpn_fps_snp_vss_pso.forbids, {"wpn_fps_upg_o_45iron"})
		table.list_append(self.parts.wpn_fps_upg_vss_irons.forbids, {"wpn_fps_upg_o_45iron"})
		table.list_append(self.parts.wpn_fps_upg_vss_irons_il.forbids, {"wpn_fps_upg_o_45iron"})
	end
	local custom_wpn_id = "wpn_fps_snp_vss"
	local stance_wpn_id = "wpn_fps_snp_tti"
	for _, part_id in pairs(self[custom_wpn_id].uses_parts) do
		if self.parts[part_id] then
			if self.parts[part_id].type == "sight" or self.parts[part_id].a_obj == "a_o" then
				if self.parts[part_id].stance_mod and self.parts[part_id].stance_mod[stance_wpn_id] then
					self.parts[part_id].stance_mod[custom_wpn_id] = deep_clone(self.parts[part_id].stance_mod[stance_wpn_id])
				end
			end
		end
	end
end)