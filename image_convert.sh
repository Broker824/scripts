#!/usr/bin/env bash

if [ $# -gt 3 ]
then
 directory="$(echo $1)"
 quality="$(echo $2)"
 geometry="$(echo $3)"
 file_format="$(echo $4)"

  cd $directory && echo 'Processing:'
  mkdir -p converted_images/src/
  for f in *
    do
      convert -geometry $geometry "$f" converted_images/src/"$f"
      convert -quality $quality converted_images/src/"$f" converted_images/"${f%%.*}.$file_format"
      echo "- $f"
    done
  rm -Rf converted_images/src/
else
 echo "Usage: $0 [directory] [quality in % (0-100%)] [resolution by X axis (800, 990...)] [image format (jpeg, png...)]

Examples:
  $0 . 85 650 jpeg
  $0 ~/Images 95 1024 png" >&2
fi
