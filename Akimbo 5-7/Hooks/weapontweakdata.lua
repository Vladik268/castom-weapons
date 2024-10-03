Hooks:PostHook(WeaponTweakData, "init", "akimbofiveseven", function(self)
---- Custom Weapon ---
-- Pistols --
-- 5.7×28mm --
-- Akimbo 5/7
self.x_lemming.CLIP_AMMO_MAX = 30
self.x_lemming.NR_CLIPS_MAX = 2
self.x_lemming.AMMO_MAX = self.x_lemming.CLIP_AMMO_MAX * self.x_lemming.NR_CLIPS_MAX
self.x_lemming.AMMO_PICKUP = deep_clone(self.lemming.AMMO_PICKUP)
self.x_lemming.damage_falloff = deep_clone(self.x_deagle.damage_falloff)
end)