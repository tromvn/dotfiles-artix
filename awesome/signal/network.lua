local lgi = require("lgi")
local Gio = lgi.require("Gio")
local GLib = lgi.require("GLib")
local gears = require("gears")
local bus = Gio.bus_get_sync(Gio.BusType.SYSTEM, nil)

local function update()
    local state = bus:call_sync(
        "org.freedesktop.NetworkManager",
        "/org/freedesktop/NetworkManager",
        "org.freedesktop.DBus.Properties",
        "Get",
        GLib.Variant("(ss)", { "org.freedesktop.NetworkManager", "State" }),
        nil,
        Gio.DBusCallFlags.NONE,
        -1,
        nil
    )
    if state then
        local val = state.value[1].value
        if val >= 60 then
            awesome.emit_signal("net::value", "up", "up")
        else
            awesome.emit_signal("net::value", "down", "down")
        end
    end
end

gears.timer.start_new(1, function()
    update()
    return false
end)


bus:signal_subscribe(
    "org.freedesktop.NetworkManager",
    "org.freedesktop.NetworkManager",
    "StateChanged",
    "/org/freedesktop/NetworkManager",
    nil,
    Gio.DBusSignalFlags.NONE,
    function(conn, sender, path, iface, signal, params)
        local state = params.value[1]
        if state >= 60 then
            awesome.emit_signal("net::value", "up", "up")
        else
            awesome.emit_signal("net::value", "down", "down")
        end
    end
)
