-- Credits to DR NEWBIE
local mysplit = function(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

-- local _mod_path = Application:base_path()..'assets/mod_overrides/pd2-akimbo-launchers/'
-- Hooks:PostHook(BlackMarketTweakData, "_init_projectiles", "GenerateUnits_BlackMarketTweakData_init_projectiles", function(self, tweak_data)
--     -- Clean the content of _mod_path..'/Assets/units'
--     os.execute(string.format('RD /S /Q "%s"', Application:nice_path(_mod_path..'/Assets/units')))
--     for key, projectile in pairs(self.projectiles) do
--         local projectile_unit = projectile.unit
--         local weapon_id = projectile.weapon_id -- Is Associated to a weapon
--         if projectile_unit and weapon_id and not projectile.local_unit then -- Exclude if it already has a local
--             local unit_xml = DB:open("unit", projectile_unit):read()
--             local _nus = mysplit(projectile_unit, "/") -- new unit string
--             local _nu_last = _nus[#_nus] -- Get last from split
--             _nus[#_nus] = nil -- Remove last item
--             local _nu_path = string.join('/', _nus) -- Rejoin the string
--             -- Use the NU_Unit path to create the appropriate folder
--             os.execute('mkdir "'.. Application:nice_path(_mod_path..'/Assets/'.. 'local_units', true) ..'"')
--             local pd2_proj_unit_path = 'assets/mod_overrides/pd2-akimbo-launchers/Assets/'.. projectile.local_unit ..'.unit'
--             log(pd2_proj_unit_path)
--             local _unit_file = io.open(pd2_proj_unit_path, "w+")
--             local newXMLContent = unit_xml:gsub('<network sync="spawn" />', '') -- Put the new xml content in the xml, but remove the sync
--             _unit_file:write(newXMLContent)
--             _unit_file:close()
--         end
--     end
-- end)

Hooks:PostHook(BlackMarketTweakData, "_init_projectiles", "ClientProjectiles_BlackMarketTweakData_init_projectiles", function(self, tweak_data)
    for key, projectile in pairs(self.projectiles) do
        local projectile_unit = projectile.unit
        local weapon_id = projectile.weapon_id -- Is Associated to a weapon
        if projectile_unit and weapon_id and not projectile.local_unit then -- Exclude if it already has a local
            -- local unit_xml = DB:open("unit", projectile_unit):read()
            projectile.no_cheat_count = true -- Make it client side
            -- projectile.client_authoritative = true -- Make it client side, but it crashed when somebody shoots it -.-
            projectile.time_cheat = 0 -- Make it client side
            local _nus = mysplit(projectile_unit, "/") -- new unit string
            local _nu_last = _nus[#_nus] -- Get last from split
            projectile.local_unit = 'local_units/'.. _nu_last .. '_local' 
        end
    end
end)

