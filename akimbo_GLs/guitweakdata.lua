Hooks:PostHook(GuiTweakData, "init", "AkimboGLs_GuiTweakData_init", function(self)
    table.insert(self.buy_weapon_categories.primaries, {"akimbo_special"})
    table.insert(self.buy_weapon_categories.secondaries, {"akimbo_special"})
end)
