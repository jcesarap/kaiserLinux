#!/bin/bash
# --- Choose timer
echo "--- TIMER ---"
read -p "Defina o timer (em minutos): " time_period_minutes
time_period=$(($time_period_minutes * 60))
echo "Timer configurado para $time_period_minutes minuto(s) ($time_period segundos). "
read -p "Quer que o computador suspenda depois do timer? (y/n) " timer_boolean
# --- Count
# For each second, -1 from $time period
while [ $time_period_minutes -gt 0 ]; do
    # Runtime
    echo "Tempo acabou: $time_period_minutes minuto(s)"
    # Counter
    ((time_period_minutes--)) # (()) used for arithmetic operations
    sleep 60 # wait 60 seconds before next iteration
done
notify-send "Acabou o tempo" 
if [[ $timer_boolean == "y" ]]; then
    systemctl suspend
else 
    exit 0
fi
while true; do
	ffplay -autoexit -nodisp -volume 80 ~/Dropbox/Kaiser-Linux/Assets/DE/Notification-tone.mp3 > /dev/null 2>&1
	sleep 5
done
printf "   \n"
read -p "Aperte [Enter] para fechar o timer"
