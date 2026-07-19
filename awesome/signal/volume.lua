local awful = require("awful")
local gears = require("gears")

local function update_vol()
    awful.spawn.easy_async_with_shell(
        "str=$(pulsemixer --get-volume); printf \"$(pulsemixer --get-mute) ${str% *}\"",
        function(out)
            local val = require("gears").string.split(out, " ")
            if tonumber(val[1]) ~= nil and tonumber(val[2]) ~= nil then
                awesome.emit_signal("vol::value", tonumber(val[1]), tonumber(val[2]))
            end
        end
    )
end

local function update_mic()
    awful.spawn.easy_async_with_shell(
        "pulsemixer --list-sources | grep Default",
        function(out)
            local mute = out:match("Mute: (%d)")
            local vol = out:match("'(%d+)%%'")
            if tonumber(mute) ~= nil and tonumber(vol) ~= nil then
                awesome.emit_signal("mic::value", tonumber(mute), tonumber(vol))
            end
        end
    )
end

gears.timer.start_new(1, function()
    update_vol()
    update_mic()
    return false
end)
