#!/usr/bin/env bash

#pravljenje neophodnog direktorijuma u kojem će se sve zapakovati
mkdir ./exe32
mv ./*.exe ./exe32/
mv ./*.msi ./exe32/

cd ./exe32

#petlja za pravljenje tar arhive (nekompresovane)
for FAJL in *
  do
    tar cf $FAJL.tar $FAJL
  done

#prebacivanje svih tar arhiva u zaseban direktorijum
mkdir ./tar
mv ./*.tar ./tar/
