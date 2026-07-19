-- Importing libraries
gears = require('gears')
awful = require('awful')
hotkeys_popup = require('awful.hotkeys_popup')
helpers = require('helpers')
wibox = require('wibox')
naughty = require("naughty")
beautiful = require('beautiful')
dpi = beautiful.xresources.apply_dpi
beautiful.init(os.getenv('HOME') .. '/.config/awesome/theme/init.lua')
keys = require('keys')
help = require('help')
sig = require('signals')
require('signal.battery')
require('signal.bluetooth')
require('signal.volume')
require('signal.brightness')
require('signal.network')
require('ui.notifications.battery')
dashboard = require("dashboard")
menu = require('menu')

awesome.connect_signal("debug::error", function(err)
    naughty.notification({ title = "Error", text = tostring(err) })
end)

local req = {
    'notif',
    'bar',
    'rule',
    -- 'titlebar',
    'music',
    'client',
    'awful.autofocus',
}

for _, x in pairs(req) do
    require(x)
end

local function set_wallpaper(s)
    if beautiful.wall then
        local wall = beautiful.wall
        if type(wall) == "function" then
            wall = wall(s)
        end
        gears.wallpaper.maximized(wall, s, true)
    end
end

screen.connect_signal("property::geometry", set_wallpaper)
awful.screen.connect_for_each_screen(set_wallpaper)

-- Layouts
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.floating,
}

-- Virtual desktops/ Tabs
screen.connect_signal("request::desktop_decoration", function(s)
    local screen_count = screen.count()
    if screen_count == 1 then
        awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8" }, s, awful.layout.layouts[1])
    else
        if s.geometry.x == 0 then
            awful.tag({ "1", "2", "3", "4" }, s, awful.layout.layouts[1])
        else
            awful.tag({ "5", "6", "7", "8" }, s, awful.layout.layouts[1])
        end
    end
end)

-- Autostart
awful.spawn.with_shell('redshift -x && redshift -O 4000K')
awful.spawn.with_shell('killall flameshot; flameshot')
awful.spawn.with_shell('killall xsettingsd; xsettingsd &')
awful.spawn.with_shell('killall mpDris2; mpDris2 &')
awful.spawn.with_shell('mpd &')

-- Garbage Collection
collectgarbage('setpause', 110)
collectgarbage('setstepmul', 1000)
