local wibox = require("wibox")
local beautiful = require("beautiful")
local battery_signal = require("signal.battery")
local gears = require("gears")

local M = {}

-- Función para cargar un ícono SVG desde awesome/icons/
local function load_svg_icon(path)
    return wibox.widget {
        image = path,
        resize = true,
        widget = wibox.widget.imagebox,
    }
end

-- Cargar íconos de batería desde awesome/icons/
local battery_full = load_svg_icon("/home/tromvn/.config/awesome/icons/battery.svg")
local battery_low = load_svg_icon("/home/tromvn/.config/awesome/icons/battery-low.svg")
local battery_charging = load_svg_icon("/home/tromvn/.config/awesome/icons/charging.svg")

-- Widget para mostrar el porcentaje
M.bat_text = wibox.widget {
    text = "0%",
    font = beautiful.font,
    widget = wibox.widget.textbox,
}

-- Función para simular niveles intermedios
local function create_battery_level(percent)
    local container = wibox.widget {
        {
            battery_full,
            widget = wibox.widget.imagebox,
        },
        widget = wibox.container.background,
        bg = beautiful.bg,
    }

    local mask = wibox.widget {
        {
            widget = wibox.widget.textbox,
            text = string.rep(" ", 10),
        },
        {
            widget = wibox.widget.textbox,
            text = string.rep("■", math.floor(percent / 4)),
            color = beautiful.fg,
            font = "Terminus 10",
        },
        layout = wibox.layout.fixed.horizontal,
    }

    mask:set_max_size(battery_full.image:get_width(), battery_full.image:get_height())

    local battery_level = wibox.widget {
        {
            container,
            mask,
            layout = wibox.layout.stack,
        },
        widget = wibox.container.place,
    }

    return battery_level
end

-- Inicializar M.battery_widget con un valor por defecto
M.battery_widget = wibox.widget {
    {
        battery_full,
        M.bat_text,
        spacing = dpi(5),
        layout = wibox.layout.fixed.horizontal,
    },
    layout = wibox.layout.fixed.horizontal,
}

-- Función para actualizar el ícono y el texto según el estado y porcentaje
M.update_battery = function(percent, state)
    percent = percent or 0
    M.bat_text.text = percent .. "%"

    -- Cambiar ícono según el estado
    if state == "Charging" then
        battery_full.image = battery_charging.image
    else
        battery_full.image = beautiful.icons.battery and beautiful.icons.battery.image or battery_full.image
    end

    -- Simular niveles visuales
    if percent >= 75 then
        -- Nivel alto (usamos el ícono completo)
        M.battery_widget = wibox.widget {
            {
                battery_full,
                M.bat_text,
                spacing = dpi(5),
                layout = wibox.layout.fixed.horizontal,
            },
            layout = wibox.layout.fixed.horizontal,
        }
    elseif percent >= 50 then
        -- Nivel medio (simulamos 75% de carga)
        local battery_75 = create_battery_level(75)
        M.battery_widget = wibox.widget {
            {
                battery_75,
                M.bat_text,
                spacing = dpi(5),
                layout = wibox.layout.fixed.horizontal,
            },
            layout = wibox.layout.fixed.horizontal,
        }
    elseif percent >= 25 then
        -- Nivel medio-bajo (simulamos 50% de carga)
        local battery_50 = create_battery_level(50)
        M.battery_widget = wibox.widget {
            {
                battery_50,
                M.bat_text,
                spacing = dpi(5),
                layout = wibox.layout.fixed.horizontal,
            },
            layout = wibox.layout.fixed.horizontal,
        }
    else
        -- Nivel bajo (usamos el ícono de batería baja)
        battery_full.image = battery_low.image
        M.battery_widget = wibox.widget {
            {
                battery_full,
                M.bat_text,
                spacing = dpi(5),
                layout = wibox.layout.fixed.horizontal,
            },
            layout = wibox.layout.fixed.horizontal,
        }
    end
end

-- Conectar señales de batería
if battery_signal then
    battery_signal:connect_signal("update", function(percent, state, _, _)
        print("Señal de batería recibida: " .. percent .. "% (" .. state .. ")") -- Depuración
        M.update_battery(percent, state)
    end)
end

-- Inicializar con un valor dummy
M.update_battery(85, "Discharging")

return M
