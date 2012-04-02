#!/usr/bin/env bash

if [ $# -gt 0 ]
then
  for directory in ./* ; do ( cd "$directory" && $@ ) || echo "There was error!" ; done
else
 echo "$0 - Version Control System updater for multiple dirs
Usage: $0 [command]

Examples:
 $0 git pull
 $0 git stash
 $0 bzr pull" >&2
fi
