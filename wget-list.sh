#!/usr/bin/env bash
# wget-list: manage the list of downloaded files
# as seen on http://www.linux.com/archive/feature/59457 (with tweaks)
# possible to include "--quota XXm" for limiting download

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

if [ $# -gt 0 ]
 then
   limit_rate="$(echo $1)"
  else
   limit_rate="0"
 fi

while [ "$(find $dl_list -size +0)" ]
 do
  dl_url="$(head -n1 $dl_list)"
  wget -P "$destination_dir" -c "$dl_url" --limit-rate=$limit_rate && sed -si 1d "$dl_list"  
 done
}


help () {
echo "$0 - download files with wget by reading list with links
File with dowload links is in $dl_list

Usage: $0 limit_rate

limit_rate is your download limit for your connection defined in kbit.
Format is \"XXXXk\". Examples:
   100k
   256k
   1024k
If no value, it will be set to 0 (max speed)
"
}


case $@ in
 -h|--help ) help ;;
 * ) main;;
esac

exit 0
