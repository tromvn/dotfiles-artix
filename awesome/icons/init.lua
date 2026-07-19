--- Icons directory
local gfs = require("gears.filesystem")
local dir = gfs.get_configuration_dir() .. "icons/"

return {
    --- layouts
    floating = dir .. "layouts/floating.png",
    max = dir .. "layouts/max.png",
    tile = dir .. "layouts/tile.png",
    dwindle = dir .. "layouts/dwindle.png",
    centered = dir .. "layouts/centered.png",
    mstab = dir .. "layouts/mstab.png",
    equalarea = dir .. "layouts/equalarea.png",
    machi = dir .. "layouts/machi.png",

    --- notifications
    notification = dir .. "notification.svg",
    notification_bell = dir .. "notification_bell.svg",

    --- system UI
    volume = dir .. "volume.svg",
    brightness = dir .. "brightness.svg",
    ram = dir .. "ram.svg",
    cpu = dir .. "cpu.svg",
    temp = dir .. "temp.svg",
    disk = dir .. "disk.svg",
    battery_1 = dir .. "battery_1_bar.svg",
    battery_2 = dir .. "battery_2_bar.svg",
    battery_3 = dir .. "battery_3_bar.svg",
    battery_4 = dir .. "battery_4_bar.svg",
    battery_5 = dir .. "battery_5_bar.svg",
    charging_20 = dir .. "battery_charging_20.svg",
    charging_50 = dir .. "battery_charging_50.svg",
    charging_60 = dir .. "battery_charging_60.svg",
    charging_80 = dir .. "battery_charging_80.svg",
    battery_full = dir .. "battery_full.svg",
    battery_low = dir .. "battery_alert.svg",
    battery = dir .. "battery_3_bar.svg",
    charging = dir .. "battery_charging_80.svg",
    web_browser = dir .. "firefox.svg",
    awesome_logo = dir .. "awesome-logo.svg",
}
