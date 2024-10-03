Hooks:PostHook(PlayerTweakData, "init", "Demo_PlayerTweakData_init", function(self)
	local GLs = {
        "arbiter",
        "china",
        "m32",
        "gre_m79",
        "slap",
    }

	for _, weapon_id in ipairs(GLs) do
		local new_gun = weapon_id.."_mxakimbo"			
		self.stances[new_gun] = deep_clone(self.stances.x_akmsu)
	end
end) 
