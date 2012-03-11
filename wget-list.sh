#!/usr/bin/env bash
# wget-list: manage the list of downloaded files
# as seen on http://www.linux.com/archive/feature/59457 (with tweaks)

dl_list="$HOME/tmp/download.txt"
destination_dir="$HOME/downloads/general"
#limit_rate="100k"

main () {
if [ ! -e "$dl_list" ]
 then
  echo "ERROR: no $dl_list found!
Please, read help for this script with \"$0 -h|--help\""
  exit 2
 fi

if [ $# -gt 1 ]
 then
   limit_rate="$(echo $2)"
  else
   limit_rate="90k"
 fi

while [ "$(find "$dl_list" -size +0)" ]
 do
  dl_url="$(head -n1 "$dl_list")"
  wget --limit-rate=$limit_rate -P "$destination_dir" -c "$dl_url" && sed -si 1d "$dl_list"  
 done
}


help () {
echo "$0 - download files with wget by reading list with links
File with dowload links is in $dl_list

Usage: $0 limit_rate

limit_rate is your download limit for your connection defined in kbps
Format is \"XXXXk\". Examples:
   $0 100k
   $0 256k
   $0 1024k
If no value, it will be set to 0 (max speed)
"
}


case $@ in
 -h|--help     ) help ;;
 -d|--download ) main ;;
esac

exit 0
