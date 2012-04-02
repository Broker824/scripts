#!/usr/bin/env bash

if [ $# -gt 1 ]
then
 parameter="$(echo $1)"
 search_query="$(echo $2)"
 
 #directory search
 if [ "$1" = "-d" ]; then
  echo -e "Results of searching \"$search_query\" directory in \"$(pwd)\": \n"
  # alternative: 2>1 | grep -v 'Permission denied'
  find . -type d -iname "$search_query" 2>/dev/null | grep --color=auto "$search_query"
 fi
 #file search
 if [ "$1" = "-f" ]; then
  echo -e "Results of searching for \"$search_query\" file(s) in \"$(pwd)\": \n"
  # alternative: 2>1 | grep -v 'Permission denied'
  find . -iname "$search_query" 2>/dev/null | grep --color=auto "$search_query"
 fi

else
 echo "$0 - small wrapper script for find application.
It can search for files/directories in currently working dir.

Usage: $0 -d|-f [search querry]" >&2
fi
