Hooks:PostHook(WeaponFactoryTweakData, "init", "akimbofiveseven_part", function(self)

self.wpn_fps_pis_x_lemming.override = self.wpn_fps_pis_x_lemming.override or {}

-- 5/7 AP --
-- Extended Magazine --
self.wpn_fps_pis_x_lemming.override.wpn_fps_pis_lemming_m_ext = self.wpn_fps_pis_x_lemming.override.wpn_fps_pis_lemming_m_ext or {}

self.wpn_fps_pis_x_lemming.override.wpn_fps_pis_lemming_m_ext.stats = {
	extra_ammo = 4
}
end)
