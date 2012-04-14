#!/usr/bin/env bash
# adapted work using stuff from http://kde-apps.org/content/show.php?content=148065
# this script requires no json stuff, just sed and awk
# api link: http://bayfiles.com/api
api_url="http://api.bayfiles.com/v1/file/uploadUrl"

if [ ! -z "$1" ]; then

  echo -n "waiting for bayfiles response (download/delete links) ..."
  # when we remove all ":" and "," characters, we can find out that:
  # uploadUrl is $3
  # downloadUrl is $15
  # deleteUrl is $17
  curl -s -F "file=@$1" $(curl -s "$api_url" | sed 's/":"/ /g' | sed 's/","/ /g' | awk '{print $3}' | tr -d '\\' ) | sed 's/":"/ /g' | sed 's/","/ /g' | awk '{print $15}' | tr -d '"}\\'

else

  echo "Usage: $0 [file]" && exit 1

fi

