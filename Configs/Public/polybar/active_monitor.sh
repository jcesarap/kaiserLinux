#!/bin/bash
xrandr --current | grep " connected" | awk '{print $1}' | head -n 1
