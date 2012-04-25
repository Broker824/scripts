#!/usr/bin/env bash
# as seen on: https://github.com/w0ng/bin/blob/master/bulkrename
# replace spaces with underscores, delete puncutation, 
# change upper to lower case, remove extra underscores

if [ ! -z "$1" ]; then
  find "$1" -depth | while read line; do
  dir="$(dirname "$line")"
  old="$(basename "$line")"
  new="$(echo $old | tr ' ' '_' \
      | tr -d '[]{},?!' | tr -d "'" \
      | tr '[[:upper:]]' '[[:lower:]]' \
      | sed 's/__/_/g' | sed 's/_-_/-/g' )"
  [[ "$old" != "$new" ]] && mv -iv "$dir/$old" "$dir/$new"
  done
else
  echo 'Usage: bulkrename.sh directory'
 fi
