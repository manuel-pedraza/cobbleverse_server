#!/usr/bin/env bash
export TZ="${TZ:-UTC}"

# Current time (epoch)
now=$(date +%s)
midnight=$(date -d "$(date +%F) +1 day 00:00:00" +%s)
diffSec=$((midnight - now))
diffTime=$(date -u -d "@$diffSec" +"%H:%M:%S")

msg=$(jq -c --arg time "$diffTime" 'map(if type=="object" and .text then .text |= gsub(":time"; $time) else . end)' /server-scripts/messages/server_countdown.json)
/usr/local/bin/rcon-cli tellraw @a "$msg"
# now=$(date -d "@$now" +"%H:%M:%S")
# midnight=$(date -d "@$midnight" +"%H:%M:%S")
# /usr/local/bin/rcon-cli tellraw maxions100 "{\"text\":\"It doesn't work AAAAA - Manu d:$now | m:$midnight\",\"color\":\"red\"}"

