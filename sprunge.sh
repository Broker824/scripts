#!/usr/bin/env bash
# api from http://sprunge.us/
curl_parameters='-s'

if [ -z "$2" ]; then paste_type="$1";else paste_type="$2"; fi
if [ -z "$paste_type" ]; then unset separator; else separator="?"; fi

[[ -t 0 ]]  && url="$(curl $curl_parameters -sF 'sprunge=<-' http://sprunge.us <"$1")" \
            || url="$(curl $curl_parameters -sF 'sprunge=<-' http://sprunge.us)"

printf "txt:%s %s\n" "$url$separator$paste_type" "$*" >> /tmp/saved.urls
xclip -i <<< "$url$separator$paste_type" && xclip -o

