#!/usr/bin/env bash
# simple password generator

if [ $# -gt 0 ]
then
  length="$(echo $1)"
else
  length="15"
fi

#define password complexity
if [ -z "$2" ]; then
  characters="a-zA-Z0-9"
else
  characters="a-zA-Z0-9-_+?%()/#&$-"
fi

cat /dev/urandom | tr -dc "$characters" | head -c$length && echo
