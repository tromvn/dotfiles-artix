#!/bin/sh
setxkbmap latam
pipewire &
pipewire-pulse &
wireplumber &
nm-applet &
exec awesome
