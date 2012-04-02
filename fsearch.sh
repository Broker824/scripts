#!/usr/bin/env bash

if [ $# -gt 1 ]
then
 parameter="$(echo $1)"
 search_query="$(echo $2)"
 
 #directory search
 if [ "$1" = "-d" ]; then
  echo "Searching for \"$search_query\" directory in \"$(pwd)\"..." && echo
  find . -type d -iname "$search_query" || echo "$0 was unable to complete search"
 fi
 #file search
 if [ "$1" = "-f" ]; then
  echo "Searching for \"$search_query\" file(s) in \"$(pwd)\"..." && echo
  find . -iname "$search_query" || echo "$0 was unable to complete search"
 fi

else
 echo "$0 - small wrapper script for find application.
It can search for files/directories in currently working dir.

Usage: $0 -d|-f [search querry]" >&2
fi
