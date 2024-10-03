function Set(list)
    local set = {}
    for _, l in ipairs(list) do
        set[l] = l
    end
    return set
end

Hooks:PostHook(BlackMarketTweakData, "_init_weapon_skins", "AkimboSawWeaponSkinsInit", function(self)
    local GLs = Set {"arbiter", "china", "m32", "gre_m79", "slap"}

    for i, skin in pairs(self.weapon_skins) do
        if GLs[skin.weapon_id] then
            skin.weapon_ids = {skin.weapon_id, GLs[skin.weapon_id] .. "_mxakimbo"}
        end
    end
end)