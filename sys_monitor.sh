#!/bin/bash
# Status script
# original: https://bitbucket.org/jasonwryan/eeepc/src/fefeccd4b280/Scripts/dwm-status
# colours: 01:normal 02:green 03:orange 04:red 05:gray 06:blue

keyboard_indicator() {
if [ ! -z "$(setxkbmap -query | grep "layout" | awk '{print $2}' )" ]
  then
    echo -e "\uE014 \x02$(setxkbmap -query | grep "layout" | awk '{print $2}' )\x01"
  else
    echo -e "\uE014 \x01??\x01"
  fi
}

battery_status(){
  ac="$(awk '{ gsub(/%|%,/, "");} NR==1 {print $4}' <(acpi -V))"
  on="$(grep "on-line" <(acpi -V))"
  if [ -z "$on" ] && [ "$ac" -gt "15" ]; then
    echo -e "\uE04F \x02$ac%\x05 |\x01"
  elif [ -z "$on" ] && [ "$ac" -le "15" ]; then
    echo -e "\uE04F \x05off\x05 |\x01"
  else
    echo -e "\uE023 \x02$ac%\x05 |\x01"
  fi
}


free_mem(){
  used_mem="$(awk '/^-/ {print $3}' <(free -m))"
  free_mem="$(awk '/^-/ {print $4}' <(free -m))"
  if [ "$free_mem" -gt "$used_mem" ]
    then
      echo -e "\uE037 \x02$used_mem\x05 MB |\x01"
    else
      echo -e "\uE037 \x06$used_mem\x05 MB |\x01"
    fi
}


# CPU line courtesy Procyon:https://bbs.archlinux.org/viewtopic.php?pid=874333#p874333
cpu_usage(){
  read cpu a b c previdle rest < /proc/stat
  prevtotal=$((a+b+c+previdle))
  sleep 0.5
  read cpu a b c idle rest < /proc/stat
  total=$((a+b+c+idle))
  cpu_usage="$((100*( (total-prevtotal) - (idle-previdle) ) / (total-prevtotal) ))"
  if [ "$cpu_usage" -gt "50" ]; then echo -e "\uE031 \x06$cpu_usage%"; fi
  if [ "$cpu_usage" -le "50" ]; then echo -e "\uE031 \x01$cpu_usage%"; fi
}


cpu_speed() {
  core_speed="$(grep "cpu MHz" /proc/cpuinfo | awk '{ print $4 }' )"
  echo -e "\x05$core_speed |\x01"
}


hdd_space(){
  hdd_space="$(df -P | sort -d | awk '/^\/dev/{s=s (s?" ":"") $5} END {printf "%s", s}')"
  echo -e "\uE008 \x01$hdd_space\x05 |\x01"
}


# original: https://bitbucket.org/jasonwryan/workstation/src/7c79a4574d84/scripts/speed.sh
net_speed () {
  RXB=$(cat /sys/class/net/eth0/statistics/rx_bytes)
  TXB=$(cat /sys/class/net/eth0/statistics/tx_bytes)
  sleep 2 
  RXBN=$(cat /sys/class/net/eth0/statistics/rx_bytes)
  TXBN=$(cat /sys/class/net/eth0/statistics/tx_bytes)
  RXDIF=$(echo -e $((RXBN - RXB)) )
  TXDIF=$(echo -e $((TXBN - TXB)) )
  RXT=$(ifconfig eth0 | awk '/bytes/ {print $2}' | cut -d: -f2)
  TXT=$(ifconfig eth0 | awk '/bytes/ {print $6}' | cut -d: -f2)

  echo -e "\uE03A \x02$((RXDIF / 1024 / 2))\x01 \uE03B \x06$((TXDIF / 1024 / 2))\x05 |\x01"
}


time_and_date(){
  time_and_date="$(date "+%H:%M %d%m%Y")"
  echo -e "$time_and_date"
}


temperature(){
  cpu_temp="$(sensors | grep "temp1" | cut -c16- | head -c 2)"
  mb_temp="$(sensors | grep "temp2" | cut -c16- | head -c 2)"
  echo -e "\uE00A \x02$cpu_temp\uE010 $mb_temp\uE010\x05 |\x01"
}


# Pipe to status bar
# [$(keyboard_indicator)]
output_info="$(net_speed) $(cpu_usage) $(cpu_speed) $(temperature) $(free_mem) $(hdd_space) $(battery_status) $(time_and_date) "

if [ $# -gt 0 ]
  then
    destination="$(echo -e $1)"
  fi

if [ "$destination" = "dwm" ]
  then
    xsetroot -name "$output_info"
  else
    echo -e "$output_info"
  fi
