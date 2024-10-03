Hooks:PostHook(WeaponFactoryTweakData, "init", "Demo_WeaponFactoryTweakData_init", function(self)
    local GLs = {
        "wpn_fps_gre_arbiter",
        "wpn_fps_gre_china",
        "wpn_fps_gre_m32",
        "wpn_fps_gre_m79",
        "wpn_fps_gre_slap",
    }

    for _, weapon_id in ipairs(GLs) do
        self[weapon_id.."_mxakimbo"] = deep_clone(self[weapon_id])
        self[weapon_id.."_mxakimbo"].unit = "akimbo_GLs/"..weapon_id
        self[weapon_id.."_mxakimbo"].custom = true
        self[weapon_id.."_mxakimbo"].based_on = weapon_id
        self[weapon_id.."_mxakimbo_npc"] = deep_clone(self[weapon_id.."_mxakimbo"])
        self[weapon_id.."_mxakimbo_npc"].custom = true
        self[weapon_id.."_mxakimbo_npc"].based_on = weapon_id
    end
end)