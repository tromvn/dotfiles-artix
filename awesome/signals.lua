local M = {}

local vol = [[ str=$( pulsemixer --get-volume ); printf "$(pulsemixer --get-mute) ${str% *}\n" ]]
local net = [[ printf "$(cat /sys/class/net/w*/operstate)~|~$(nmcli radio wifi)" ]]
local blue = [[ bluetoothctl show | grep "Powered:" ]]
local fs = [[ df -h --output=used,size / | sed 's/G//g' ]]
local temp = [[ cat /sys/class/thermal/thermal_zone4/temp ]]
local mem = [[
  while IFS=':k ' read -r mem1 mem2 _; do
    case "$mem1" in
      MemTotal)
        memt="$(( mem2 / 1024 ))";;
      MemAvailable)
        memu="$(( memt - mem2 / 1024))";;
    esac;
  done < /proc/meminfo;
  printf "%d %d" "$memu" "$memt"; ]]

M.mem = function()
    awful.spawn.easy_async_with_shell(mem, function(out)
        local val = gears.string.split(out, " ")
        awesome.emit_signal('mem::value', tonumber(val[1]), tonumber(val[2]))
    end)
end

M.temp = function()
    awful.spawn.easy_async_with_shell(temp, function(out)
        awesome.emit_signal('temp::value', tonumber(out))
    end)
end

-- M.vol = function()
--     awful.spawn.easy_async_with_shell(vol, function(out)
--         local val = gears.string.split(out, " ")
--         awesome.emit_signal('vol::value', tonumber(val[1]), tonumber(val[2]))
--     end)
-- end

-- M.net = function()
--     awful.spawn.easy_async_with_shell(net, function(out)
--         local val = gears.string.split(out, "~|~")
--         local w = "down"
--         if val[2]:match("enabled") then
--             w = "up"
--         end
--         awesome.emit_signal('net::value', val[1], w)
--     end)
-- end


-- M.blu = function()
--   awful.spawn.easy_async_with_shell(blue, function(out)
--     if out == "" then
--       awesome.emit_signal('blu::value', "no")
--     else
--       local val = gears.string.split(out, " ")
--       awesome.emit_signal('blu::value', val[2])
--     end
--   end)
-- end

local bright = [[ brightnessctl get ]]
local bright_max = [[ brightnessctl max ]]
local mic =
[[ pulsemixer --get-volume-mic 2>/dev/null || pulsemixer --id $(pulsemixer --list-sources | grep Default | grep -o 'source-[0-9]*') --get-volume | awk '{print $1}' ]]

-- M.bright = function()
--     awful.spawn.easy_async_with_shell(bright, function(val)
--         awful.spawn.easy_async_with_shell(bright_max, function(max)
--             -- naughty.notify({title="bright", text="val:"..tostring(val).." max:"..tostring(max)})
--             awesome.emit_signal('bright::value', tonumber(val), tonumber(max))
--         end)
--     end)
-- end

-- M.mic = function()
--     awful.spawn.easy_async_with_shell([[ pulsemixer --list-sources | grep Default ]], function(out)
--         local mute = out:match("Mute: (%d)")
--         local vol = out:match("'(%d+)%%'")
--         awesome.emit_signal('mic::value', tonumber(mute), tonumber(vol))
--     end)
-- end

gears.timer {
    timeout = 5,
    call_now = true,
    autostart = true,
    callback = function()
        -- M.vol()
        -- M.net()
        -- M.blu()
        M.mem()
        M.temp()
        -- M.bright()
        -- M.mic()
        -- M.fs()
    end
}

M.set_vol = function(val)
    awful.spawn('pactl set-sink-volume @DEFAULT_SINK@ ' .. tonumber(val) .. '%', false)
end

M.toggle_mute = function()
    awful.spawn.with_shell('pulsemixer --toggle-mute ')
    -- M.vol()
end


return M
