require("mp")

local function title()
    local pl_index = mp.get_property("playlist-current-pos")
    local pl_title = mp.get_property("playlist/" .. pl_index .. "/title")

    -- force playlist title if it has one
    if pl_title ~= nil then
        mp.set_property("force-media-title", pl_title)
    end
end

mp.register_event("file-loaded", title)
