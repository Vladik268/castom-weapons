Hooks:PostHook(WeaponFactoryTweakData, "init", "painday3_lynx_weapontweakdata_init", function(self)


	self.parts.wpn_fps_snp_pd3_lynx_bolt.animations = {
		reload = "reload"
	}


	self.parts.wpn_fps_snp_pd3_lynx_scope_piggyback.stance_mod.wpn_fps_snp_pd3_lynx = {
			 translation = Vector3(0, -1, -3.3),	 
             rotation = Rotation(0, 0, 0)
             }
				 

	
end)