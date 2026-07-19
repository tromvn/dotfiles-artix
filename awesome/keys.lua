-- Variables
local keys = {}

local mod = 'Mod4'
local alt = 'Mod1'
local ctrl = 'Control'
local shift = 'Shift'
local tags = 8
keys.tags = tags

-- Keybindings
keys.globalkeys = gears.table.join(

-- Awesome
    awful.key({ mod, ctrl }, 'r', awesome.restart, { description = "reload awesome", group = "WM" }),
    awful.key({ mod, ctrl }, 'q', awesome.quit, { description = "quit awesome", group = "WM" }),
    awful.key({ mod }, 's', hotkeys_popup.show_help, { description = "show help", group = "WM" }),
    awful.key({ mod, alt }, 'l', function() awful.spawn(os.getenv('HOME') .. '/.local/bin/lock.sh') end,
        { description = "lock screen", group = "hotkeys" }),

    -- Ocultar/Mostrar Wibar
    awful.key({ mod, ctrl }, 'b',
        function()
            local screen = awful.screen.focused()
            screen.mywibox.visible = not screen.mywibox.visible
        end,
        { description = "ocultar/mostrar barra", group = "awesome" }),


    -- Dashboard
    awful.key({ mod }, 'd', function() dashboard.toggle() end, { description = "toggle dashboard", group = "app" }),

    -- Applications
    awful.key({ mod }, 'Return', function() awful.util.spawn('kitty') end,
        { description = "open terminal", group = "app" }),
    awful.key({ mod }, 'space', function() awful.util.spawn('rofi -show drun') end,
        { description = "open app launcher", group = "app" }),
    awful.key({ mod }, 'b', function() awful.util.spawn('librewolf') end, { description = "open browser", group = "app" }),
    awful.key({ mod }, 'f', function() awful.util.spawn('thunar') end,
        { description = "open file manager", group = "app" }),
    awful.key({ mod }, 'e', function() awful.util.spawn('mousepad') end,
        { description = "open text editor", group = "app" }),
    awful.key({ mod, shift }, 'e', function() awful.util.spawn(os.getenv('HOME') .. '/.local/bin/zed') end,
        { description = "open code editor", group = "app" }),

    -- Screenshots
    awful.key({}, 'Print', function() awful.spawn.with_shell('maim -s -m 10 -f png | satty --filename=-') end,
        { description = "screenshot", group = "hotkeys" }),

    -- Hardware
    awful.key({}, 'XF86MonBrightnessUp',
        function()
            awful.spawn('brightnessctl set 5%+ -q', false)
            awesome.emit_signal("widget::brightness")
        end, { description = "increase brightness", group = "hotkeys" }),
    awful.key({}, 'XF86MonBrightnessDown',
        function()
            awful.spawn('brightnessctl set 5%- -q', false)
            awesome.emit_signal("widget::brightness")
        end, { description = "decrease brightness", group = "hotkeys" }),
    awful.key({}, 'XF86AudioRaiseVolume', function() awful.spawn('amixer sset Master 5%+', false) end,
        { description = "increase volume", group = "hotkeys" }),
    awful.key({}, 'XF86AudioLowerVolume', function() awful.spawn('amixer sset Master 5%-', false) end,
        { description = "decrease volume", group = "hotkeys" }),
    awful.key({}, 'XF86AudioMute', function() awful.spawn('amixer sset Master toggle', false) end,
        { description = "mute volume", group = "hotkeys" }),

    -- Focus by direction
    awful.key({ mod }, 'Up', function() awful.client.focus.bydirection('up') end,
        { description = "focus up", group = "client" }),
    awful.key({ mod }, 'Down', function() awful.client.focus.bydirection('down') end,
        { description = "focus down", group = "client" }),
    awful.key({ mod }, 'Left', function() awful.client.focus.bydirection('left') end,
        { description = "focus left", group = "client" }),
    awful.key({ mod }, 'Right', function() awful.client.focus.bydirection('right') end,
        { description = "focus right", group = "client" }),

    -- Resize client
    awful.key({ mod, ctrl }, 'Up', function() helpers.client.resize_client(client.focus, 'up') end,
        { description = "resize up", group = "client" }),
    awful.key({ mod, ctrl }, 'Down', function() helpers.client.resize_client(client.focus, 'down') end,
        { description = "resize down", group = "client" }),
    awful.key({ mod, ctrl }, 'Left', function() helpers.client.resize_client(client.focus, 'left') end,
        { description = "resize left", group = "client" }),
    awful.key({ mod, ctrl }, 'Right', function() helpers.client.resize_client(client.focus, 'right') end,
        { description = "resize right", group = "client" }),

    -- Resize master area
    awful.key({ mod, shift, alt }, 'Right', function() awful.tag.incmwfact(0.025) end,
        { description = "increase master width", group = "layout" }),
    awful.key({ mod, shift, alt }, 'Left', function() awful.tag.incmwfact(-0.025) end,
        { description = "decrease master width", group = "layout" }),
    awful.key({ mod, shift, alt }, 'Up', function() awful.client.incwfact(0.05) end,
        { description = "increase client height", group = "layout" }),
    awful.key({ mod, shift, alt }, 'Down', function() awful.client.incwfact(-0.05) end,
        { description = "decrease client height", group = "layout" }),

    -- Screen focus
    awful.key({ mod, ctrl }, 'Tab', function() awful.screen.focus_relative(1) end,
        { description = "focus next screen", group = "screen" }),

    -- Tags navigation
    awful.key({ mod, alt }, 'Left', awful.tag.viewprev, { description = "view previous tag", group = "tags" }),
    awful.key({ mod, alt }, 'Right', awful.tag.viewnext, { description = "view next tag", group = "tags" }),

    -- Power
    awful.key({ mod, ctrl, shift }, 'p', function() awful.spawn('sudo poweroff') end,
        { description = "poweroff", group = "WM" }),
    awful.key({ mod, ctrl, shift }, 's', function() awful.spawn('loginctl suspend') end,
        { description = "suspend", group = "WM" }),
    awful.key({ mod, ctrl, shift }, 'b', function() awful.spawn('sudo reboot') end,
        { description = "reboot", group = "WM" })
)

-- Client keybindings
keys.clientkeys = gears.table.join(
    awful.key({ mod }, 'q', function(c) c:kill() end, { description = "close", group = "client" }),
    awful.key({ mod }, 'n', function(c) c.minimized = true end, { description = "minimize", group = "client" }),
    awful.key({ mod, ctrl }, 'n', function()
        local c = awful.client.restore()
        if c then c:activate({ raise = true, context = 'key.unminimize' }) end
    end, { description = "restore minimized", group = "client" }),
    awful.key({ mod }, 'm', function(c) c.maximized = not c.maximized end,
        { description = "toggle maximize", group = "client" }),
    awful.key({ mod, shift }, 'f', function(c)
        c.fullscreen = not c.fullscreen; c:raise()
    end, { description = "toggle fullscreen", group = "client" }),
    awful.key({ mod }, 'Tab', function() awful.client.floating.toggle() end,
        { description = "toggle floating", group = "client" }),
    awful.key({ mod }, 'c', function(c) awful.placement.centered(c, { honor_workarea = true, honor_padding = true }) end,
        { description = "center window", group = "client" }),
    awful.key({ mod }, 'p', function(c) c.ontop = not c.ontop end, { description = "toggle ontop", group = "client" }),
    awful.key({ mod, shift }, 'p', function(c) c.sticky = not c.sticky end,
        { description = "toggle sticky", group = "client" }),
    awful.key({ mod, shift }, 'Up', function(c) helpers.client.move_client(c, 'up') end),
    awful.key({ mod, shift }, 'Down', function(c) helpers.client.move_client(c, 'down') end),
    awful.key({ mod, shift }, 'Left', function(c) helpers.client.move_client(c, 'left') end),
    awful.key({ mod, shift }, 'Right', function(c) helpers.client.move_client(c, 'right') end)
)

-- Mouse controls
keys.clientbuttons = gears.table.join(
    awful.button({}, 1, function(c) client.focus = c end),
    awful.button({ mod }, 1, function() awful.mouse.client.move() end),
    awful.button({ mod }, 2, function(c) c:kill() end),
    awful.button({ mod }, 3, function() awful.mouse.client.resize() end)
)

-- Tags globales 1-8
for i = 1, tags do
    keys.globalkeys = gears.table.join(keys.globalkeys,
        awful.key({ mod }, '#' .. i + 9,
            function()
                local tag_name = tostring(i)
                for s in screen do
                    local tag = awful.tag.find_by_name(s, tag_name)
                    if tag then
                        awful.screen.focus(s)
                        tag:view_only()
                        return
                    end
                end
            end, { description = "view tag " .. i, group = "tags" }),
        awful.key({ mod, shift }, '#' .. i + 9,
            function()
                if client.focus then
                    local tag_name = tostring(i)
                    for s in screen do
                        local tag = awful.tag.find_by_name(s, tag_name)
                        if tag then
                            client.focus:move_to_tag(tag)
                            return
                        end
                    end
                end
            end, { description = "move to tag " .. i, group = "tags" }))
end

-- Set globalkeys
root.keys(keys.globalkeys)

return keys
