#!/usr/bin/env bash

if [ ! -z "$1" ]; then
  echo -e "Searching for \"$1\": \n"
  ps aux | grep "$1" | grep -v grep | grep --color=auto "$1" || echo "\"$1\" is not running!"
else
  echo "You need to enter process name (like firefox, geany etc.)!"
fi
