#!/bin/bash
PATH_AC="/sys/class/power_supply/AC"
PATH_BATTERY_0="/sys/class/power_supply/BAT0"
PATH_BATTERY_1="/sys/class/power_supply/BAT1"
envy_output=$(envycontrol -q)
power_output=$(powerprofilesctl get)

function battery_print {
    if [ -f "$PATH_AC/online" ]; then
        ac=$(cat "$PATH_AC/online")
    else
        ac=0
    fi

    if [ -f "$PATH_BATTERY_0/energy_now" ]; then
        battery_level_0=$(cat "$PATH_BATTERY_0/energy_now")
    else
        battery_level_0=0
    fi

    if [ -f "$PATH_BATTERY_0/energy_full" ]; then
        battery_max_0=$(cat "$PATH_BATTERY_0/energy_full")
    else
        battery_max_0=0
    fi

    if [ -f "$PATH_BATTERY_1/energy_now" ]; then
        battery_level_1=$(cat "$PATH_BATTERY_1/energy_now")
    else
        battery_level_1=0
    fi

    if [ -f "$PATH_BATTERY_1/energy_full" ]; then
        battery_max_1=$(cat "$PATH_BATTERY_1/energy_full")
    else
        battery_max_1=0
    fi

    battery_level=$((battery_level_0 + battery_level_1))
    battery_max=$((battery_max_0 + battery_max_1))

    if [ "$battery_max" -ne 0 ]; then
        battery_percent=$((battery_level * 100 / battery_max))
    else
        battery_percent=0
    fi

    if [ "$ac" -eq 1 ]; then
        icon="#1"
        if [ "$battery_percent" -gt 97 ]; then
            echo "$icon"
        else
            echo "$icon $battery_percent %"
        fi
    else
        if [ "$battery_percent" -gt 85 ]; then
            icon="#21"
        elif [ "$battery_percent" -gt 60 ]; then
            icon="#22"
        elif [ "$battery_percent" -gt 35 ]; then
            icon="#23"
        elif [ "$battery_percent" -gt 10 ]; then
            icon="#24"
        else
            icon="#25"
        fi
        echo " ${power_output}    ${envy_output}   Bateria: $battery_percent %"
        
    fi
}

path_pid="/tmp/polybar-battery-combined-udev.pid"

case "$1" in
--update)
    if [ -f "$path_pid" ]; then
        pid=$(cat "$path_pid")
        if [ -n "$pid" ]; then
            kill -10 "$pid"
        fi
    fi
    ;;
*)
    echo $$ > "$path_pid"

    trap exit INT
    trap "echo" USR1

    while true; do
        battery_print
        sleep 30
    done
    ;;
esac
