Hooks:PostHook(WeaponTweakData, "init", "AkimboGLs_WeaponTweakData_init", function(self)	
	local GLs = {
        "arbiter",
        "china",
        "m32",
        "gre_m79",
        "slap",
    }

	for _, weapon_id in ipairs(GLs) do
		local new_weapon_id = weapon_id.."_mxakimbo"			
		local new_weapon = deep_clone(self[weapon_id])
        local original_weapon = self[weapon_id]
        new_weapon.name_id = new_weapon.name_id..'_mxakimbo'        
        new_weapon.unlock_func = false

        -- beardlib sync without spending 20 minutes of your life writing an xml
        -- now you can use those 20 minutes to do something else
        new_weapon.custom = true
        new_weapon.based_on = weapon_id
        
        new_weapon.categories = {
            "akimbo_special",
			"grenade_launcher"
		}

        new_weapon.texture_bundle_folder = "mx_mods"

        new_weapon.CLIP_AMMO_MAX = original_weapon.CLIP_AMMO_MAX * 2
        new_weapon.NR_CLIPS_MAX = original_weapon.NR_CLIPS_MAX * 2
        new_weapon.AMMO_MAX = original_weapon.AMMO_MAX * 2
        
        new_weapon.weapon_hold = "x_akmsu"
        new_weapon.animations = {
            equip_id = "equip_x_akmsu",
            reload_name_id = not new_weapon.timers.shotgun_reload_shell and "x_akmsu" or new_weapon.animations.reload_name_id,
            fire = "recoil",
            reload = "reload",
            reload_not_empty = "reload_not_empty",
            recoil_steelsight = true,
        }

        if original_weapon.CLIP_AMMO_MAX == 1 then 
            new_weapon.fire_mode_data.fire_rate = 0.3
            new_weapon.single.fire_rate = 0.3
        else
            new_weapon.fire_mode_data.fire_rate = new_weapon.fire_mode_data.fire_rate * 0.8 
            new_weapon.single.fire_rate = new_weapon.single.fire_rate * 0.8
        end

        local akimbo_debuff = 0.30
        if original_weapon.stats then			
            new_weapon.stats.concealment = math.round((original_weapon.stats.concealment or 0) * akimbo_debuff)
            new_weapon.stats.spread = math.round((original_weapon.stats.spread or 0) * akimbo_debuff)
            new_weapon.stats.spread_moving = math.round((original_weapon.stats.spread_moving or 0) * akimbo_debuff)
            new_weapon.stats.recoil  = math.round((original_weapon.stats.recoil  or 0) * akimbo_debuff)
        end
       
        if not new_weapon.timers.shotgun_reload_shell then
            local MIN_RELOAD_SPEED = 3.5 -- Reload speed empty Krinkov matched the animation
            local RELOAD_SPEED_MULTIPLIER = 0.75 -- % slower than default
            -- Calculate percentage diff
            local difference_perc = (new_weapon.timers.reload_empty - MIN_RELOAD_SPEED) / MIN_RELOAD_SPEED
            -- Make the reload speed match the Krinkov
            local new_reload_speed = MIN_RELOAD_SPEED     
            if new_weapon.timers.reload_empty <= MIN_RELOAD_SPEED then  
                new_weapon.timers.reload_not_empty = new_reload_speed
                new_weapon.timers.reload_empty = new_reload_speed
                -- Nerf the reload speed using Krinkov reference
                new_weapon.stats.reload  = math.round((new_weapon.stats.reload  or 0) * RELOAD_SPEED_MULTIPLIER)
            elseif difference_perc < 1 then
                new_weapon.timers.reload_not_empty = new_reload_speed
                new_weapon.timers.reload_empty = new_reload_speed
                -- Nerf the reload speed using Krinkov reference
                new_weapon.stats.reload  = math.round((new_weapon.stats.reload  or 0) * (RELOAD_SPEED_MULTIPLIER))
                -- Apply nerf based on difference betweer krinkov rel speed VS current weapon rel speed
                -- Multiplicative way
                new_weapon.stats.reload  = math.round((new_weapon.stats.reload  or 0) * (difference_perc))
            else  
                log("Difference is HUGE Use another animation"..difference_perc)
            end
        end
        self[new_weapon_id] = new_weapon
	end
end)