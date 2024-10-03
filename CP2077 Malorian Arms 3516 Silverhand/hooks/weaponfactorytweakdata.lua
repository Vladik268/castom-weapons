Hooks:PostHook( WeaponFactoryTweakData, "init", "initMalorianSilverhandInspectWeaponParts", function(self)

	self.wpn_fps_pis_malorian_3516.animations = {
        reload = "reload",
		fire = "recoil",
		fire_steelsight = "recoil",
        reload_not_empty = "reload_not_empty",
        equip_id = "equip_malorian_3516",
        recoil_steelsight = true,
        magazine_empty = "last_recoil",
        inspect = "inspect"
    }
	
	self.parts.wpn_fps_pis_malorian_3516_body.animations = {
        reload = "reload",
		fire = "recoil",
		fire_steelsight = "recoil",
        reload_not_empty = "reload_not_empty",
        equip_id = "equip_malorian_3516",
        recoil_steelsight = true,
        magazine_empty = "last_recoil",
        inspect = "inspect"
    }
	
	self.parts.wpn_fps_pis_malorian_3516_magazine.animations = {
        reload = "reload",
        reload_not_empty = "reload_not_empty",
        inspect = "inspect"
    }
end)