#!/usr/bin/env bash
# api stuff is from http://ix.io/
curl_parameters='-s'

if [ -z "$2" ]; then paste_type="$1";else paste_type="$2"; fi
if [ -z "$paste_type" ]; then unset separator; else separator="/"; fi

[[ -t 0 ]]  && url="$(curl $curl_parameters -n -F 'f:1=<-' http://ix.io <"$1")" \
            || url="$(curl $curl_parameters -n -F 'f:1=<-' http://ix.io)"

printf "txt:%s %s\n" "$url$separator$paste_type" "$*" >> /tmp/saved.urls
xclip -i <<< "$url$separator$paste_type" && xclip -o
