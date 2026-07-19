#!/bin/bash

# Detectar si HDMI1 está conectado
if xrandr | grep "HDMI1 connected"; then
    xrandr --output HDMI1 --auto --left-of eDP1 --output eDP1 --auto
else
    xrandr --output eDP1 --auto --output HDMI1 --off
fi


# Notificar a awesome para que reinicie la decoración de pantallas
sleep 1 && awesome-client "awesome.restart()"
