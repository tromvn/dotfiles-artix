local lgi = require("lgi")
local Gio = lgi.require("Gio")
local GLib = lgi.require("GLib")

local bus = Gio.bus_get_sync(Gio.BusType.SYSTEM, nil)

bus:signal_subscribe(
    "org.bluez",
    "org.freedesktop.DBus.Properties",
    "PropertiesChanged",
    nil,
    nil,
    Gio.DBusSignalFlags.NONE,
    function(conn, sender, path, iface, signal, params)
        local props = params.value[2]
        if props and props.Powered ~= nil then
            if props.Powered then
                awesome.emit_signal("blu::value", "yes")
            else
                awesome.emit_signal("blu::value", "no")
            end
        end
    end
)
