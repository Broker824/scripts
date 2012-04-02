#!/usr/bin/env bash

if [ $# -gt 0 ]
then
 dir="$(echo $1)"
 cd $dir

  for f in *; do
    mv "$f" "$(echo "$f" | tr -s " " "_" | tr "A-Z" "a-z")" 2>/dev/null &
  done

else
 echo "$0 - renamer that removes spaces and upper case letters from files
Usage: $0 [directory]" >&2
fi
