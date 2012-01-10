#!/usr/bin/env bash
#       This program is free software. It comes without any warranty, to
#       the extent permitted by applicable law. You can redistribute it
#       and/or modify it under the terms of the Do What The Fuck You Want
#       To Public License, Version 2, as published by Sam Hocevar. See
#       http://sam.zoy.org/wtfpl/COPYING for more details.
#
#       abcdefghijklmnopqrstuvwxyz

chip_m="ygqfadbmhzciruejxknovlpstw"
chip_v="YGQFADBMHZCIRUEJXKNOVLPSTW"


crypt () {
cat "$@" | tr "a-z" "$chip_m" | tr "A-Z" "$chip_v"
#| tr " " "^" | tr "(" "%"
}

decrypt () {
cat "$@" | tr "$chip_m" "a-z" | tr "$chip_v" "A-Z"
#| tr "^" " " | tr "%" "("
}

help () {
echo "stenc- supid cipher/encoder
Idea is from rot13 (as seen in Advanced Bash shell scripting guide)
Usage: stenc [option] stdin OR file

Options:
	-c crypt file or input with rot13 alike chiper
	-d decrypt file or input with rot13 alike chiper

If no file then reads stdin! Terminate with CTRL+D :)
"
}

case $@ in
  -c ) crypt	;;
  -d ) decrypt	;;
	  * ) help	;;
esac

exit 0
