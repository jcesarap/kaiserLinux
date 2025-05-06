#!/bin/sh

BLANK='#00000000'       # Transparent background
CLEAR='#2e344022'       # Slightly transparent dark blue-gray
DEFAULT='#111184'     # Soft cyan (Nord accent color)
TEXT='#eceff4ee'        # Light gray for text
WRONG='#bf616abb'       # Red for errors
VERIFYING='#5e81acbb'   # Blue for verifying

i3lock \
--insidever-color=$CLEAR     \
--ringver-color=$VERIFYING   \
\
--insidewrong-color=$CLEAR   \
--ringwrong-color=$WRONG     \
\
--inside-color=$BLANK        \
--ring-color=$DEFAULT        \
--line-color=$BLANK          \
--separator-color=$DEFAULT   \
\
--verif-color=$TEXT          \
--wrong-color=$TEXT          \
--time-color=$TEXT           \
--date-color=$TEXT           \
--layout-color=$TEXT         \
--keyhl-color=$WRONG         \
--bshl-color=$WRONG          \
\
--screen 1                   \
--blur 5                     \
--clock                      \
--indicator                  \
--time-str="%H:%M"           \
--date-str="%d-%m-%Y"        \
