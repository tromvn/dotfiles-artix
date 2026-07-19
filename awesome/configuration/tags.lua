local awful = require("awful")

-- Tags globales: HDMI1 obtiene tags 1-4, eDP1 obtiene tags 5-8
-- Si solo hay una pantalla, obtiene los 8 tags

screen.connect_signal("request::desktop_decoration", function(s)
    local screen_count = screen.count()

    if screen_count == 1 then
        -- Una sola pantalla: todos los tags
        awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8" }, s, awful.layout.layouts[1])
    else
        -- Dos pantallas: detectar cuál es HDMI1 y cuál es eDP1
        -- HDMI1 queda a la izquierda (x=0), eDP1 a la derecha
        if s.geometry.x == 0 and s ~= screen.primary then
            -- HDMI1: tags 1-4
            awful.tag({ "1", "2", "3", "4" }, s, awful.layout.layouts[1])
        else
            -- eDP1: tags 5-8
            awful.tag({ "5", "6", "7", "8" }, s, awful.layout.layouts[1])
        end
    end
end)
