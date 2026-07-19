#!/bin/bash

# Detectar si HDMI1 está conectado
if xrandr | grep "HDMI1 connected"; then
  xrandr --output HDMI-1 --auto --pos 0x0 --output eDP-1 --auto --pos 0x1080
else
  xrandr --output eDP1 --auto --output HDMI1 --off
fi

# Notificar a awesome para que reinicie la decoración de pantallas
sleep 1 && awesome-client "awesome.restart()"
