#!/bin/bash
# Requires: imagemagick, id3v2, ffmpeg

if [ $# -gt 1 ]
then

background=/tmp/$RANDOM.gif
#title=`id3v2 -l $1 | grep TIT2 | cut -d: -f 2`
filename=`basename "$1" | tr "_" " "`

convert -size 320x240 xc:black -fill white -draw "gravity Center text 0,0 '$filename'" $background

#if input is not mp3 file, then we shall convert it
if [ -z "$(echo $1 | grep .mp3)" ]
	then
		ffmpeg -i "$1" -ab 131072 "$1.mp3"
		file="$1.mp3"
	else
		file="$1"
	fi

ffmpeg -loop_input -r ntsc -i $background -i "$file" -acodec copy -ab 160 -shortest -qscale 5 $2

rm $background
rm "$1.mp3"

else

	echo "Usage: mp32avi.sh [input.mp3] [output.avi]" >&2

fi
