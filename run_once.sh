#!/bin/bash
#
# There are 3 ways to do it:
# 1. ps -C "$1"| grep "$1"
# 2. ps -A or ps -C (thanks c00kiemon5ter for tip)
# 3. ps -C "$1" || "$@" (thanks c00kiemon5ter for tip)
#
# also useful: ps axco pid,command (less output)
#if [ -z "$(ps -C "$1"| grep "$1")" ]; then $@ ;fi
ps -C "$1" || "$@" &
