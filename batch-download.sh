#!/usr/bin/env bash
# wget-list: manage the list of downloaded files
# as seen on http://www.linux.com/archive/feature/59457 (with tweaks)

dl_list="$HOME/downloads/download_list.txt"
destination_dir="$HOME/downloads/general"
dl_app="1"
# 1 = wget, 2 = curl


#set limit rate and check if input is number
if [ ! -z "$1" ]; then
   if [[ "$1" == "${1//[^0-9]/}" ]]; then limit_rate="$1"; else limit_rate="0"; fi
  else
   limit_rate="0"
 fi


#check if there is file and then download
download_files () {
if [ ! -e "$dl_list" ]; then
   echo "ERROR: no $dl_list found!
Please, read help for this script with \"$0 -h|--help\""
   exit 2
 fi

#determine app for download
if [ "$dl_app" = "1" ]; then
    #use wget
    while [ "$(find "$dl_list" -size +0)" ]; do
       dl_url="$(head -n1 "$dl_list")"
       wget --limit-rate=$(echo $limit_rate)k -P "$destination_dir" -c "$dl_url" && sed -si 1d "$dl_list"
     done
  else
    #use curl
    while [ "$(find "$dl_list" -size +0)" ]; do
       dl_url="$(head -n1 "$dl_list")"
       cd "$destination_dir"
       curl --progress-bar --limit-rate $(echo $limit_rate)k -C - -L -O "$dl_url" && sed -si 1d "$dl_list"
     done
 fi
}


#help
if [ "$#" -gt "1" ]; then
   echo "Usage: $0 [limit_rate]
Script will use your download manager of choice (check \$dl_app) for
downloads.

limit_rate is your download limit for your connection defined in kbps
Format is \"XXX\". Examples:
  $0 100
  $0 256
  $0 1024

Default unit is \"k\" (kilobits). If there is bad/no value, it will be
set to 0 (max speed) for download.
"
   exit 1
 fi


#exec main function
download_files
exit 0
