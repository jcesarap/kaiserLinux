#!/bin/sh
CURRENT=$(xrandr --current | grep " connected" | awk '{print $1}' | head -n 1)
xrandr --output HDMI-1-0 --off --output $CURRENT --mode 1920x1080 --pos 0x0 --rotate normal
xrandr --dpi 96
