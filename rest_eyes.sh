#!/usr/bin/env bash
#
#       rest_eyes.sh
#       
#       (c) 2011, djura-san <http://www.lab21.net>
#       
#       This program is free software. It comes without any warranty, to
#       the extent permitted by applicable law. You can redistribute it
#       and/or modify it under the terms of the Do What The Fuck You Want
#       To Public License, Version 2, as published by Sam Hocevar. See
#       http://sam.zoy.org/wtfpl/COPYING for more details.
tekst_za_prikaz='Pogled u daljinu, odmah!'

#Zenity
if [ -f "/usr/bin/zenity" ]
  then
    zenity --title="Alchajmer: lista obaveza" --width="700" --height="600" --text-info --filename=$baza_za_graficki_pregled & exit 0
  #Xdialog
  elif [ -f "/usr/bin/xdialog" ]
  then
    xdialog --no-cancel --title "$tekst_za_prikaz" --textbox "$tekst_za_prikaz" 40 120 & exit 0
  elif [ -f "/usr/bin/Xdialog" ]; then
    Xdialog --no-cancel --title "$tekst_za_prikaz" --textbox "$tekst_za_prikaz" 40 120 & exit 0
  fi
