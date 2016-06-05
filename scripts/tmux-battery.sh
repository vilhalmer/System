#!/usr/bin/env bash
# This is a rate-limited battery indicator for the tmux statusline.
#
# Separating the update interval from status-interval allows the clock, etc. 
# to still update in realtime, without hammering on pmset.
#
# TODO: 
#   - Support linux, eventually.
#   - Detect systems with no battery and hide.

update_interval=15 # seconds

now=$(date "+%s")

if [[ $(( $now - ${TMUX_BATTERY_UPDATED:-0} )) -lt $update_interval ]]; then 
    echo "$TMUX_BATTERY"
    exit
fi

tmux set-environment -g TMUX_BATTERY_UPDATED "$now"

segments=5
show_percent=false

battery_status=$(pmset -g batt)
level=$(echo "$battery_status" | sed -n 2p | cut -f 2 | cut -f 1 -d '%')
warning=$((echo "$battery_status" | grep "Warning" 2>&1 > /dev/null) && echo '! ')

segment=$(echo "scale=2;(($level + (100/$segments) - 1) / (100/$segments))" | bc) # Calculate which segment we're in, rounding up.
segment=${segment%.*} # Truncate so bash can understand the number
[[ -z $segment ]] && segment=0 # bc doesn't print leading zeroes.

battery="#[fg=green]"
[[ $level -le 25 ]] && battery="#[fg=yellow]"
[[ $level -le 10 ]] && battery="#[fg=red]"

for (( i=0; i < $segment; i++ )); do
    battery="${battery}▊"
done
battery="${battery}#[fg=white]"
for (( i=$segment; i < $segments; i++ )); do
    battery="${battery}▊"
done
battery="${battery}∎"

charged=$(echo "$battery_status" | head -n 1 | grep -s 'AC')
if [[ -n $charged ]]; then
    echo "$battery_status" | grep 'charged' 2>&1 > /dev/null && charging="#[fg=green,bold]✓ " || charging="#[fg=yellow,bold]⚡ "
fi
detail="$($show_percent && echo " $level")"

tmux set-environment -g TMUX_BATTERY "#[fg=red]$warning$charging#[fg=default,none]$battery#[default,none]$detail#[default,none]"
echo "$TMUX_BATTERY"

