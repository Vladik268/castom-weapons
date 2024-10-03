
Hooks:PostHook(ProjectileWeaponBase, "init", "ClientProjectiles_ProjectileWeaponBase_init", function(self, ...)
	-- code
    self._client_authoritative = true
end)