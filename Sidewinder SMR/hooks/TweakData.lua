Hooks:PostHook(TweakData, "_setup_scene_pose_items", "TF2Sidewinder_ScenePoseItems", function(self)
	self.scene_pose_items.husk_sidewinder = {
		"primary"
	}
end)

Hooks:PostHook(TweakData, "_setup_scene_poses", "TF2Sidewinder_ScenePoses", function(self)
	self.scene_poses.weapon.sidewinder = {
		"husk_sidewinder",
		required_pose = true
	}
end)