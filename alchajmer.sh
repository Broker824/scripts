#!/usr/bin/env bash
#
#       alchajmer
        verzija="0.1a5"
#       Datum kreiranja ovog dokumenta je 15.06.2009 22:27:34 CEST
#       
#       Ovaj dokument je kreiran uz pomoć Geany 0.16 editora
#       2009 djura-san (http://lab21.net)
#       
#       This program is free software. It comes without any warranty, to
#       the extent permitted by applicable law. You can redistribute it
#       and/or modify it under the terms of the Do What The Fuck You Want
#       To Public License, Version 2, as published by Sam Hocevar. See
#       http://sam.zoy.org/wtfpl/COPYING for more details.
#        

baza_obaveza="${HOME}/.alchajmer"
baza_za_graficki_pregled="$baza_obaveza-graficki-pregled"



provera_baze () {
	#Ako baza nije prisutna na sistemu onda se kreira nova
	#Ova provera_baze se vrsi prilikom pokretanja bilo koje komande
	if [ ! -f "$baza_obaveza" ]; then
		echo "Baza nije kreirana! Pravim novu bazu..."
		touch $baza_obaveza && echo
	fi
}



obicna () {
	provera_baze

	echo "Unesite obavezu (u jednom redu) i pritisnite ENTER kada zavrsite:"
	read unos
	
	#Ako je unos prazan onda ce skripta da vas umara sa novim unosom
	while [ -z "$unos" ]; do
		echo "Odbijam da dodam praznu obavezu u listu obaveza!"
		echo "Unesite obavezu (u jednom redu) i pritisnite ENTER kada zavrsite:"
		read unos
	done

	echo "oOo- $unos" >> $baza_obaveza
	echo "Obaveza je uneta u bazu podataka!"
}




obaveze_sa_definisanim_vremenom () {
provera_baze

	#varovi za varenje :)
	datum="[0-3][0-9]-[0-1][0-9]-[0-9][0-9][0-9][0-9]"
	vreme="[0-2][0-9]:[0-6][0-9]"

	#Input za datum
	echo -n "Unesite datum obaveze (format: DD-MM-YYYY): "; read idatum
	while [ 0 == $(echo "$idatum" | grep "$datum" | wc -l) ]; do
			echo "Datum je neispravan! Unesite datum obaveze (primer: 21-12-2008): "; read idatum
	done

	#unos za vreme
	echo -n "Unesite vreme obaveze (format: HH:MM): "; read itime
	while [ 0 == $(echo "$itime" | grep "$vreme" | wc -l) ]; do
			echo "Vreme je neispravno! Unesite vreme obaveze (primer: 14:17): "; read itime
	done

	#unos za obavezu
	# btw ovde se moze staviti i nesto mnogo zamimljivije
	#poput unosa koji se salje u cat ali bi onda morao da se odradi malo drugaciji
	#sistem pretrazivanja obaveza i ubacivanja istih u bazu
	echo "Unesite obavezu (u jednom redu) i pritisnite ENTER kada zavrsite:"; read opis
	while [ -z "$opis" ]; do
		echo "Necemo valjda da pravimo obavezu koja nema opis? Ajmo da pokusamo jos jednom:"; read opis
	done

	echo "tTt- $idatum u $itime: $opis" >> $baza_obaveza
	echo "Obaveza je uneta u bazu podataka!"
}




pregled () {
provera_baze

		#Crap za definisanje datuma koje zelim da provera_bazevam
		#Obratite paznju na to da grep moze svuda imati opciju -w koja omogucava
		#da grep trazi kompletnu rec ali ovo nekad radi a nekada ne (ko zna zasto)
		#Zbog toga sam stavio da se pored obaveza ubacuju specijalni karakteri
		#btw sigurno postoji laksi nacin za definisanje svega ovoga sto sledi
		#ali morate se sloziti da je ovo prilicno lak nacin da se stvari odrade jel?

		d0=`date +%d-%m-%Y`
		d1=`date --date="1 day" +%d-%m-%Y`
		d2=`date --date="2 day" +%d-%m-%Y`
		me=`date --date="1 month" +%m`
		#
		dan0=`grep "tTt- $d0 u *" $baza_obaveza | cut -c4-`
		dan1=`grep "tTt- $d1 u *" $baza_obaveza | cut -c4-`
		dan2=`grep "tTt- $d2 u *" $baza_obaveza | cut -c4-`
		mesec=`grep "tTt- [0-3][0-9]-$me-[0-9][0-9][0-9][0-9] u *" $baza_obaveza | cut -c4- | sort -n`
		bez_vremenskog_ogranicenja=`grep "oOo- *" $baza_obaveza | cut -c4-`

		#clear
		echo

		if [ -z "$dan0" ]; then echo "Nema obaveza za danas!" && echo
		else
		echo "Obaveze za danas:"
		echo "$dan0" && echo
		fi

		if [ -z "$dan1" ]; then echo "Nema obaveza za sutra!" && echo
		else
		echo && echo "Obaveze za sutra:"
		echo "$dan1" && echo
		fi

		if [ -z "$dan2" ]; then echo "Nema obaveza za prekosutra!" && echo
		else
		echo && echo "Obaveze za prekosutra:"
		echo "$dan2" && echo
		fi
		
		if [ -z "$mesec" ]; then echo "Nema obaveza za naredni mesec!" && echo
		else
		echo && echo "Lista obaveza za sledeci mesec:"
		echo "$mesec" && echo
		fi

		if [ -z "$bez_vremenskog_ogranicenja" ]; then echo "Lista ostalih obaveza je prazna!" && echo
		else
		echo && echo "Ostale obaveze:"
		echo "$bez_vremenskog_ogranicenja" && echo
		fi
}




graficki_pregled () {
provera_baze

	if [ "$DISPLAY" = "" ] ; then
		echo "X server nije pokrenut stoga necu ni da pokrecem graficki prikaz obaveza!"
		else
			#Prvo moramo da upisemo obaveze u jedan eksterni fajl
			echo "`pregled`" > $baza_za_graficki_pregled

			#Zenity
			if [ -f "/usr/bin/zenity" ]; then
				zenity --title="Alchajmer: lista obaveza" --width="700" --height="600" --text-info --filename=$baza_za_graficki_pregled & exit 0
			#Xdialog
			elif [ -f "/usr/bin/xdialog" ]; then
				xdialog --no-cancel --title "Alchajmer: lista obaveza" --textbox $baza_za_graficki_pregled 40 120 & exit 0
			elif [ -f "/usr/bin/Xdialog" ]; then
				Xdialog --no-cancel --title "Alchajmer: lista obaveza" --textbox $baza_za_graficki_pregled 40 120 & exit 0
   else
    echo "GRESKA: na sistemu nije nadjena nijedna podrzana aplikacija za graficki prikaz obaveza!"
			fi
	fi

}




brisanje_obaveza () {
	provera_baze

	echo && echo "Koju vrstu obaveza zelite da brisete:
  1. Obaveze iz prosle godine
  2. Obaveze koje nemaju definisano vreme i datum"
	echo -n "Izbor: "; read vrsta
	echo



	# Vremenski ogranicene obaveze (brise sve iz prosle godine)
	#trazice u arhivi fajlove koji su u formatu "DD-MM-YYYY" gde ce YYYY da smanji za 1
	if [ "$vrsta" = "1" ]; then

	#Ova fija trenutno ne radi pa e da ubije skriptu kada god je izaberete :(
	#echo "Ova funkcija jos ne radi kako treba :("; exit 2
	#

	var=`date +%Y`
	var2="[0-3][0-9]-[0-1][0-9]"
	let var-=1
	kom=`grep "tTt- $var2-$var u *" $baza_obaveza`


		#Ako nema obaveza iz prosle godine onda nista od brisanja ;)
		if [ -z "$kom" ]; then
			echo "Nema starih obaveza za brisanje!"
		else
			
			#Ako ima obaveza onda ce ih prvo ispisati na ekranu i trazice potvrdu od usera za brisanje
			#Za svaki slucaj ce kopija .alchajmer baze biti sacuvana u .alchajmer.bak
			#Oprez: ako ovu opciju ponovo pokrenete i ona izbrise barem jednu stavku iz prosle godine
			#izgubicete stari .alchajmer.bak !
			clear
			echo "Obaveze koje ce biti obrisane:"
			echo "$kom" | cut -c3-
			echo && echo -n "Da li zaista zelite da izbrisete ove obaveze? (y/N): "; read answer

			if [ "$answer" = "y" ]; then
				cp -f "$baza_obaveza" "$baza_obaveza.bak"

				#metoda 1: sed -i "s/$kom//g" $baza_obaveza
				#metoda 2: sed "/$linija/d" $baza_obaveza
				echo "$kom" | while read linija
					do
						sed -i "/$linija/d" $baza_obaveza
					done
				
				#brisanje praznih redova iz fajla
				sed -i '/^$/d' $baza_obaveza
				echo && echo "Gotovo! Stara arhiva je premestena u $baza_obaveza.bak !"
			fi

		fi
		
	fi


	#Brisanje "obicnih" zadatak iz liste
	#ovi zadaci pocinju sa oOo- i tako ih i prepoznajemo ;)
	#kao sto sam gore naveo, grep moze da ima opciju -w ali je ne preporucujem
	#sa druge strane uz "grep -w" bi imali 100% tacnu pretragu ali znajte
	#da mozete umesto "oOo- " dodati nesto malo socnije (tipa: "o%O%o- ")
	#Ako to menjate onda nema potrebe za grep -w (kolika je verovatnoca da u obavezi unesete "o%O%o-" ?)
	if [ "$vrsta" = "2" ]; then
	kom=`cat -n "$baza_obaveza" | grep "oOo- *"`

		if [ -z "$kom" ]; then
			echo "Nema obaveza za brisanje!"
		else
			clear && 	echo "Obaveze koje nisu vremenski ogranicene:"
			cat -n "$baza_obaveza" | grep "oOo- *"
			echo && echo -n "Unesite broj obaveze koju zelite da brisete: "; read num	
				
				if [ -z "$num" ]; then
					echo "Niste izabrali broj obaveze za brisanje!"
					exit 0
				fi

			#ovde je moguce ubaciti i "sed -i /$2/d $baza_obaveza"
			sed -i "$num d" $baza_obaveza

			#brisanje praznih redova iz fajla
			sed -i '/^$/d' $baza_obaveza
			echo "Izbrisano!"
		fi

	fi

}




help () {
echo "Alchajmer v$verzija - alat za pravljenje malih podsetnika za one koji slabo pamte :)
Upotreba: alchajmer [opcija]

Opcije
  -o   kreiranje obaveza koje nemaju vremensko ogranicenje
  -t   kreiranje obaveze sa datim vremenom
  -p   pregled obaveza
  -pg  graficki pregled obaveza
  -c   brisanje obaveza

Graficki pregled obaveza  koristi zenity ili xdialog (zenity je podrazumevani)
Primeri formata vremena i datuma za ulazne informacije:
  datum: DD-MM-YYYY (primer 01-09-2006)
  vreme: HH:MM (primer 14:55)
"
}


case $@ in
	-o ) obicna		;;
	-t ) obaveze_sa_definisanim_vremenom		;;
	-c ) brisanje_obaveza	;;
	-p ) pregled	;;
	-pg ) graficki_pregled	;;
	 * ) help		;;
esac

exit 0
