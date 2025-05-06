#!/bin/bash

# --- --- Battery --- ---
# --- Power
power=$(upower -d | grep -v "ignored" | grep "percentage:" | head -n 1 | awk '{print $2}' | tr -d '%') # Get power percentage, remove the '%' sign, and convert to an integer
power=$(echo "$power" | xargs)  # Trim any whitespace

# --- --- Load --- ---
cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print int(100 - $1)}')
memory_used=$(free -m | awk 'NR==2{printf "%.2f", $3}')  # Get used memory in MB

# --- --- Temp --- ---
cpu_temp=$(sensors 2>/dev/null | grep "Core 0:" | awk '{print int($3)}' | tr -d '+°C')
gpu_temp=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits)


#
# --- --- Base Values --- ---
battery_threshold=25 # With high-cpu usage being notified, you're warned of being careful with power
temperature_threshold=75
load_cpu_threshold=60
load_ram_threshold=7000
#
# --- --- Battery --- ---
#
if [ "$power" -lt "$battery_threshold" ]; then
	dunstify -u critical -t 1500 "Bateria em $power%"
else
	printf " "
fi
#
# --- --- Temperature --- ---
#
if [[ "$cpu_temp" -gt "$temperature_threshold" || "$gpu_temp" -gt "$temperature_threshold" ]]; then
    dunstify -t 2000 -u critical "Altas temperaturas: $cpu_temp°C / GPU: $gpu_temp°C"
else
	printf " "
fi
#
# --- --- Load --- ---
#
if (( $(echo "$cpu_usage > $load_cpu_threshold" | bc -l) )); then
	dunstify -t 2000 -u critical "Alto uso de CPU ($cpu_usage)"
fi
if (( $(echo "$memory_used > $load_ram_threshold" | bc -l) )); then
	dunstify -t 2000 -u critical "Alto uso de RAM ($memory_used)"
fi
