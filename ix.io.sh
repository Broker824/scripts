#!/usr/bin/env bash
# api stuff is from http://ix.io/
curl_parameters='-s'

# if we pass argument, it will be used as file extension
if [ -z "$1" ]; then unset file_type; else file_type="/$1"; fi
#command for uploading using api
url="$(curl $curl_parameters -n -F 'f:1=<-' http://ix.io)"

# print result and apppend syntax highlighting (if any)
echo "$(date +%d%m%Y_%H%M): $url$file_type" >> /tmp/saved.urls
#copy to clipboard
xclip -i <<< "$url$file_type" && xclip -o
