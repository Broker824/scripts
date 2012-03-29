#!/usr/bin/env bash
# wget-list: manage the list of downloaded files
# as seen on http://www.linux.com/archive/feature/59457 (with tweaks)

dl_list="$HOME/tmp/download.txt"
destination_dir="$HOME/downloads/general"
#limit_rate="100k"


download_files () {
if [ ! -e "$dl_list" ]; then
   echo "ERROR: no $dl_list found!
Please, read help for this script with \"$0 -h|--help\""
   exit 2
 fi

while [ "$(find "$dl_list" -size +0)" ]; do
   dl_url="$(head -n1 "$dl_list")"
   wget --limit-rate=$(echo $limit_rate)k -P "$destination_dir" -c "$dl_url" && sed -si 1d "$dl_list"  
 done
}



#set limit rate
if [ ! -z "$1" ]; then
    limit_rate="$1"
 else
    limit_rate="0"
 fi

#only one parameter!
if [ "$#" -gt "1" ]; then
   echo "Usage: $0 limit_rate

limit_rate is your download limit for your connection defined in kbps
Format is \"XXXXk\". Examples:
  $0 100
  $0 256
  $0 1024

If no value, it will be set to 0 (max speed)"
   exit 1
 fi


while true
  do
    download_files
  done

exit 0
