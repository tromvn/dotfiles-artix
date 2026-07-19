local icons = require("icons")
local M = {}

-- =====================
-- SLIDERS
-- =====================

-- Volume
M.vol = wibox.widget {
    bar_shape = help.rrect(beautiful.br),
    bar_height = dpi(24),
    handle_width = dpi(12),
    bar_color = '#00000000',
    handle_color = beautiful.pri,
    handle_shape = help.rrect(beautiful.br),
    forced_height = dpi(24),
    forced_width = dpi(360),
    widget = wibox.widget.slider,
}

-- Brightness
M.bright_slider = wibox.widget {
    bar_shape = help.rrect(beautiful.br),
    bar_height = dpi(24),
    handle_width = dpi(12),
    bar_color = '#00000000',
    handle_color = beautiful.pri,
    handle_shape = help.rrect(beautiful.br),
    forced_height = dpi(24),
    forced_width = dpi(360),
    maximum = 96000,
    widget = wibox.widget.slider,
}

-- Mic
M.mic_slider = wibox.widget {
    bar_shape = help.rrect(beautiful.br),
    bar_height = dpi(24),
    handle_width = dpi(12),
    bar_color = '#00000000',
    handle_color = beautiful.pri,
    handle_shape = help.rrect(beautiful.br),
    forced_height = dpi(24),
    forced_width = dpi(360),
    widget = wibox.widget.slider,
}


-- =====================
-- PROGRESSBARS
-- =====================

-- Volume
M.snd = wibox.widget {
    {
        id = 'prg',
        max_value = 100,
        value = M.vol.value,
        forced_height = dpi(24),
        shape = help.rrect(beautiful.br),
        color = beautiful.pri,
        background_color = beautiful.bg3,
        forced_width = dpi(360),
        widget = wibox.widget.progressbar,
    },
    M.vol,
    layout = wibox.layout.stack,
}

-- Brightness
M.bright = wibox.widget {
    {
        id = 'prg',
        max_value = 96000,
        value = 0,
        forced_height = dpi(24),
        shape = help.rrect(beautiful.br),
        color = beautiful.pri,
        background_color = beautiful.bg3,
        forced_width = dpi(360),
        widget = wibox.widget.progressbar,
    },
    M.bright_slider,
    layout = wibox.layout.stack,
}

-- Mic
M.mic_bar = wibox.widget {
    {
        id = 'prg',
        max_value = 100,
        value = 0,
        forced_height = dpi(24),
        shape = help.rrect(beautiful.br),
        color = beautiful.pri,
        background_color = beautiful.bg3,
        forced_width = dpi(360),
        widget = wibox.widget.progressbar,
    },
    M.mic_slider,
    layout = wibox.layout.stack,
}


-- =====================
-- SLIDERS: CONNECT_SIGNAL
-- =====================

-- Volume
M.vol:connect_signal('property::value', function(val)
    sig.set_vol(val.value)
    M.snd:get_children_by_id('prg')[1].value = val.value
end)

-- Brightness
M.bright_slider:connect_signal('property::value', function(self)
    awful.spawn('brightnessctl set ' .. tostring(self.value) .. ' -q', false)
    M.bright:get_children_by_id('prg')[1].value = self.value
end)

-- Mic
M.mic_slider:connect_signal('property::value', function(self)
    awful.spawn('pactl set-source-volume @DEFAULT_SOURCE@ ' .. tostring(self.value) .. '%', false)
    M.mic_bar:get_children_by_id('prg')[1].value = self.value
end)


-- =====================
-- SYSTEM SIGNALS
-- =====================

-- Volume (button)
awesome.connect_signal('vol::value', function(mut, val)
    if mut == 0 then
        M.vol.handle_color = beautiful.pri
        M.snd:get_children_by_id('prg')[1].color = beautiful.pri
    else
        M.vol.handle_color = beautiful.fg2
        M.snd:get_children_by_id('prg')[1].color = beautiful.fg2
    end
    M.vol.value = val
    M.snd:get_children_by_id('prg')[1].value = val
end)

-- Brightness
awesome.connect_signal('bright::value', function(val, max)
    M.bright_slider.value = val
    M.bright:get_children_by_id('prg')[1].value = val
end)

-- Mic
awesome.connect_signal('mic::value', function(mut, val)
    M.mic_slider.value = val or 0
    M.mic_bar:get_children_by_id('prg')[1].value = val or 0
    if mut == 0 then
        M.mic_bar:get_children_by_id('prg')[1].color = beautiful.pri
    else
        M.mic_bar:get_children_by_id('prg')[1].color = beautiful.fg2
    end
end)


-- =====================
-- INDICADORES
-- =====================

-- Memory
M.mem = wibox.widget {
    text = '0 / 0 GB',
    font = beautiful.font,
    widget = wibox.widget.textbox,
}

-- Temperature
M.temp = wibox.widget {
    text = '0°C',
    font = beautiful.font,
    widget = wibox.widget.textbox,
}

-- Battery icon
M.bat_icon = wibox.widget {
    image = icons.battery_5,
    resize = true,
    forced_width = dpi(20),
    forced_height = dpi(14),
    widget = wibox.widget.imagebox,
}

-- Battery text
M.bat_text = wibox.widget {
    text = "0%",
    font = beautiful.font,
    widget = wibox.widget.textbox,
}

-- Battery export
M.bat = M.bat_text


-- =====================
-- INDICADORES: CONNECT_SIGNAL
-- =====================

-- Memory
awesome.connect_signal('mem::value', function(val, max)
    M.mem.text = val .. ' / ' .. max .. ' MB'
end)

-- Temperature
awesome.connect_signal('temp::value', function(val)
    M.temp.text = math.floor(val / 1000) .. '°C'
end)

-- Battery
require("signal.battery"):connect_signal("update", function(_, percentage, state)
    M.bat_text.text = math.floor(percentage) .. "%"
    if state == 1 or state == 4 then
        if percentage > 80 then
            M.bat_icon.image = gears.color.recolor_image(icons.battery_full, beautiful.fg2)
        elseif percentage > 60 then
            M.bat_icon.image = gears.color.recolor_image(icons.charging_80, beautiful.fg2)
        elseif percentage > 40 then
            M.bat_icon.image = gears.color.recolor_image(icons.charging_60, beautiful.fg2)
        elseif percentage > 20 then
            M.bat_icon.image = gears.color.recolor_image(icons.charging_50, beautiful.fg2)
        else
            M.bat_icon.image = gears.color.recolor_image(icons.charging_20, beautiful.fg2)
        end
    else
        if percentage <= 10 then
            M.bat_icon.image = gears.color.recolor_image(icons.battery_low, beautiful.fg2)
        elseif percentage <= 20 then
            M.bat_icon.image = gears.color.recolor_image(icons.battery_1, beautiful.fg2)
        elseif percentage <= 40 then
            M.bat_icon.image = gears.color.recolor_image(icons.battery_2, beautiful.fg2)
        elseif percentage <= 60 then
            M.bat_icon.image = gears.color.recolor_image(icons.battery_3, beautiful.fg2)
        elseif percentage <= 80 then
            M.bat_icon.image = gears.color.recolor_image(icons.battery_4, beautiful.fg2)
        else
            M.bat_icon.image = gears.color.recolor_image(icons.battery_5, beautiful.fg2)
        end
    end
end)

return M
