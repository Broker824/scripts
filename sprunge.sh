#!/usr/bin/env bash
# api from http://sprunge.us/
curl_parameters='-s'

# if we pass argument, it will be used as file extension
if [ -z "$1" ]; then unset file_type; else file_type="?$1"; fi
#command for uploading using api
url="$(curl $curl_parameters -sF 'sprunge=<-' http://sprunge.us)"

# print result and apppend syntax highlighting (if any)
echo "$(date +%d%m%Y_%H%M):$url$file_type" >> /tmp/saved.urls
#copy to clipboard
xclip -i <<< "$url$file_type" && xclip -o

