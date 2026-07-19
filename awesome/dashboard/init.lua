local wid = require("dashboard.wid")
local sli = require("dashboard.sli")

local sliders = wibox.widget {
    {
        {
            -- Barras
            {
                layout = wibox.layout.fixed.horizontal,
                spacing = dpi(10),
                {
                    font = beautiful.icofont,
                    text = '',
                    widget = wibox.widget.textbox,
                },
                sli.snd,
            },
            {
                layout = wibox.layout.fixed.horizontal,
                spacing = dpi(10),
                {
                    font = beautiful.icofont,
                    text = '',
                    -- 󰃟
                    widget = wibox.widget.textbox,
                },
                sli.bright,
            },
            {
                layout = wibox.layout.fixed.horizontal,
                spacing = dpi(17),
                {
                    font = beautiful.icofont,
                    text = '󰍬',
                    widget = wibox.widget.textbox,
                },
                sli.mic_bar,
            },
            -- Temperatura y memoria en la misma línea (centrados)
            {
                layout = wibox.layout.align.horizontal,
                expand = "none",
                {
                    layout = wibox.layout.fixed.horizontal,
                    spacing = dpi(0),
                },
                {
                    layout = wibox.layout.fixed.horizontal,
                    spacing = dpi(20),
                    {
                        layout = wibox.layout.fixed.horizontal,
                        spacing = dpi(5),
                        {
                            font = beautiful.icofont,
                            text = '',
                            widget = wibox.widget.textbox,
                        },
                        sli.temp,
                    },
                    {
                        layout = wibox.layout.fixed.horizontal,
                        spacing = dpi(5),
                        {
                            font = beautiful.icofont,
                            text = '',
                            widget = wibox.widget.textbox,
                        },
                        sli.mem,
                    },
                    {
                        layout = wibox.layout.fixed.horizontal,
                        spacing = dpi(5),
                        sli.bat_icon,
                        sli.bat,
                    }
                },
                {
                    layout = wibox.layout.fixed.horizontal,
                    spacing = dpi(0),
                },
            },
            spacing = dpi(10),
            layout = wibox.layout.fixed.vertical,
        },
        widget = wibox.container.margin,
        margins = dpi(20),
    },
    bg = beautiful.bg2,
    shape = help.rrect(beautiful.br),
    widget = wibox.container.background,
}

local buttons = wibox.widget {
    {
        {

            wid.wifi,
            wid.blu,
            wid.nig,
            wid.vol,
            wid.mic,
            spacing = dpi(10),
            layout = wibox.layout.flex.horizontal,

        },
        top = dpi(20),
        bottom = dpi(20),
        right = dpi(15),
        left = dpi(15),
        widget = wibox.container.margin
    },
    shape = help.rrect(beautiful.br),
    widget = wibox.container.background,
    bg = beautiful.bg2,
}

local dashboard = awful.popup {
    widget = {
        {
            {
                require('dashboard.oth').cal,
                layout = wibox.layout.flex.vertical,
                spacing = dpi(20),
            },
            require("dashboard.play"),
            sliders,
            buttons,
            spacing = dpi(20),
            layout = wibox.layout.fixed.vertical,
        },
        margins = dpi(20),
        forced_width = dpi(400),
        widget = wibox.container.margin
    },
    shape = help.rrect(beautiful.br),
    visible = false,
    bg = beautiful.bg,
    ontop = true,
    placement = function(c)
        (awful.placement.bottom_left)(c, { margins = { left = 60, bottom = 10 } })
    end,
}

dashboard.toggle = function()
    dashboard.visible = not dashboard.visible
end

return dashboard
