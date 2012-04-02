#!/usr/bin/env bash

if [ $# -gt 1 ]; then
  directory="$(echo $1)"
  query="$(echo $2)"

  #echo search results
  echo "Files found: " && find "$directory" -iname "$query"
  #sanity check
  echo "Are you sure that you want to delete these files? (Y/n)"; read answer
  if [ "$answer" = "[Y|y]" ]; then
    rm -f $(find $DIR -iname "$FILE")
  fi

else

  #"help"
  echo "$0 - delete all files from defined directory and all sub directories in it
Usage: $0 [directory] [file search query]

Examples:
  $0 . bad_file.txt
  $0 /home/foo/temp_dir IMG_0457.JPEG" >&2
fi
