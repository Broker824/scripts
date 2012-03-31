#!/usr/bin/env bash
initial_directory="win32_packages_for_burning"
packages_destination="zapakovani_programi"
working_directory="kalab453"

#pravljenje neophodnog direktorijuma u kojem će se sve zapakovati
mkdir $initial_directory
#premeštanje svih exe i msi paketa
mv *.exe $working_directory
mv *.msi $working_directory
#prebacivanje u radni direktorijum
cd $working_directory

#petlja za pravljenje, nekompresovane, tar arhive
for datoteka in *
  do
    #uklanjanje "loših" karaktera iz imena datoteka
    mv "$f" "`echo "$f" | tr -s " " "_" | tr "A-Z" "a-z"`" 2>/dev/null &
    tar cf $datoteka.tar $FAJL
  done

#prebacivanje svih tar arhiva u zaseban direktorijum
mkdir $packages_destination
mv *.tar $packages_destination
