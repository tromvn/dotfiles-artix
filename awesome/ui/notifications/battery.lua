local gears = require("gears")
local beautiful = require("beautiful")
local naughty = require("naughty")
local icons = require("icons")

local notified_charging = false
local notified_discharging = false
local notified_20 = false
local notified_10 = false

require("signal.battery"):connect_signal("update", function(_, percentage, state, _, _, _)
    -- state 1 = cargando, state 2 = descargando

    if (state == 1 or state == 4) and not notified_charging then
        naughty.notification({
            title = "Batería",
            text = "Cargando — " .. math.floor(percentage) .. "%",
            app_name = "AwesomeWM",
            image = gears.color.recolor_image(icons.charging, beautiful.ok),
        })
        notified_charging = true
        notified_discharging = false
    end

    if state == 2 and not notified_discharging then
        naughty.notification({
            title = "Batería",
            text = "Usando batería — " .. math.floor(percentage) .. "%",
            app_name = "AwesomeWM",
            image = gears.color.recolor_image(icons.battery, beautiful.ok),
        })
        notified_discharging = true
        notified_charging = false
        -- Resetear alertas de nivel al desconectar cargador
        notified_20 = false
        notified_10 = false
    end

    if state == 2 and percentage <= 20 and not notified_20 then
        naughty.notification({
            title = "Batería baja",
            text = "Batería al " .. math.floor(percentage) .. "%",
            app_name = "AwesomeWM",
            image = gears.color.recolor_image(icons.battery_low, beautiful.pri),
        })
        notified_20 = true
    end

    if state == 2 and percentage <= 10 and not notified_10 then
        naughty.notification({
            title = "Batería crítica",
            text = "Batería al " .. math.floor(percentage) .. "% — conecta el cargador",
            app_name = "AwesomeWM",
            image = gears.color.recolor_image(icons.battery_low, beautiful.err),
        })
        notified_10 = true
    end
end)
