local gears = require("gears")
local awful = require("awful")

local function update()
    awful.spawn.easy_async_with_shell("brightnessctl get", function(val)
        val = val:gsub("%s+", "")
        awful.spawn.easy_async_with_shell("brightnessctl max", function(max)
            max = max:gsub("%s+", "")
            if tonumber(val) ~= nil and tonumber(max) ~= nil then
                awesome.emit_signal("bright::value", tonumber(val), tonumber(max))
            end
        end)
    end)
end



-- Actualizar al inicio
gears.timer.start_new(1, function()
    update()
    return false
end)


-- Actualizar cuando se presiona una tecla de brillo
awesome.connect_signal("widget::brightness", function()
    update()
end)
