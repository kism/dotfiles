require("mp")

-- mpv has no "active profile" property, so compare current options against
-- the high-quality profile's own definition.
local function check()
    for _, p in ipairs(mp.get_property_native("profile-list")) do
        if p.name == "high-quality" then
            for _, o in ipairs(p.options) do
                if o.key ~= "profile" then
                    local cur = mp.get_property("options/" .. o.key)
                    local a, b = tonumber(cur), tonumber(o.value)
                    if cur ~= nil and cur ~= o.value and not (a and b and math.abs(a - b) < 1e-6) then
                        mp.osd_message("high-quality profile not active (" .. o.key .. "=" .. cur .. ")", 1)
                        return
                    end
                end
            end
        end
    end
end

mp.register_event("file-loaded", check)
