Hooks:PostHook(UpgradesTweakData, "init", "Demo_UpgradesTweakData_init", function(self, tweak_data)
    local GLs_Upgrades = {
        {"arbiter", "wpn_fps_gre_arbiter"},
        {"china", "wpn_fps_gre_china"},
        {"m32", "wpn_fps_gre_m32"},
        {"gre_m79", "wpn_fps_gre_m79"},
        {"slap", "wpn_fps_gre_slap"},
    }

    for _, weapon_upgrade in ipairs(GLs_Upgrades) do
        local weapon_id = weapon_upgrade[1].."_mxakimbo"
        local factory_id = weapon_upgrade[2].."_mxakimbo"
        local newdef = {
            factory_id = factory_id,
            weapon_id = weapon_id,
            category = "weapon"
        }
		self.definitions[weapon_id] = newdef
        table.insert(self.level_tree[0].upgrades, weapon_id)
	end

    log('[Demo_UpgradesTweakData_init]')
end)