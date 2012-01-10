#!/usr/bin/env bash
#
#       local.fm.sh
        version="0.0.3a5"
#       Creation date: 12.05.2011 22:48:35
#       2011 Radojičić Đurađ (http://lab21.net)
#       
#       This program is free software. It comes without any warranty, to
#       the extent permitted by applicable law. You can redistribute it
#       and/or modify it under the terms of the Do What The Fuck You Want
#       To Public License, Version 2, as published by Sam Hocevar. See
#       http://sam.zoy.org/wtfpl/COPYING for more details.
#
#important stuff that must not be deleted
stat_file="$HOME/.local.fm_stat"
stat_output="$HOME/tmp/local.fm-stat.html"
#stat_output="$HOME/test_$(date +%d%m%Y_%H%m%S).html" #alternative

#-----------------------------------------------------------------------
#user config
#monitor_start_date='08-06-2011'
monitor_start_date='Wen, 12 Oct 2011 16:33:17 +0100'
number_of_songs_in_list='300'
number_of_songs_in_taglist='75'
search_provider="https://duckduckgo.com/?q="
display_songlist="1" # 1 = on , 0 = off
display_tagcloud="1" # 1 = on , 0 = off
font_changing_cycle="10"
font_min_size="12"
font_max_size="50"
#after how much s will script collect info about playing song
collect_timeout="20"


#var for translations                            #transaltion examples (EN)
html_header='| local.fm statistika'              #My local.fm stat
html_monitor_start_date='Datum kreiranja baze'   #Database was created on:
date_of_page_update='Osveženo'                   #Updated:
number_of_played_songs='Preslušano pesama'       #Songs listened:
fav_songs_tagcloud='Oblačak popularnih pesama'   #Favourite songs tagcloud:
list_of_song_names='Lista pesama'                #Song list:
number_of_plays='preslušano'                     #played:

#HTML styles
html_bg_color='#fff'
html_body_font_color='#444'
html_h1_header='#555'
html_h2_header='#555'
html_times_played_color='#080'
html_times_played_color2='#999'
html_song_title_color='#444'
html_links_color='#04c'
html_visited_links_color='#90c'
#since bash uses $RANDOM in a very weird way, you can use 3 hex colors
#that way, you will trully get $RANDOM colors in playlists
#example:
#       02c 888 999
#should be:
#       02c 888 999 02c 888 999 02c 888 999 02c 888 999 02c 888 999
html_tagcloud_colors='408340 9D4A4A aaa 666' #hex values without "#" on start
#end of user config
#----------------------------------------------------------------------


generate_stats () {
echo " generating $stat_output in progress..."
#SONG_TITLE_QUERRY="SongTitle:"
#cut -c "$(echo "$SONG_TITLE_QUERRY" | wc -m)-" | \
#grep "$SONG_TITLE_QUERRY" |
#head -n 1 | awk '{ print $1 }

all_songs="$(cat "$stat_file" | sort | uniq -c | sort -nr)"
displayed_songs="$(echo "$all_songs" | head -n "$number_of_songs_in_list")"
displayed_songs_tags="$(echo "$all_songs" | head -n "$number_of_songs_in_taglist")"
played_songs="$(cat "$stat_file" | sort | wc -l)"

#remove this when you finish
rm -f $stat_output

#if $monitor_start_date is empty, we shall create no info about it
if [ ! -z "$monitor_start_date" ]
 then
  when_was_monitoring_started="<strong>$html_monitor_start_date</strong>: <acronym title=\"$html_monitor_start_date\">$monitor_start_date</acronym> <br/>"
 fi

echo "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\"
	\"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">
<html xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"en\" lang=\"en\">
<head>
	<title>$html_header</title>
	<meta http-equiv=\"content-type\" content=\"text/html;charset=utf-8\" />
 <meta name=\"generator\" content=\"$0 $version\" />
 <style type=\"text/css\"><!--
 body{padding:3% 5% 3% 5%;margin:0 auto;background:#e9e9e9;font:normal 1em 'Liberation Sans','Arial','Verdana',sans-serif;color:#444;word-spacing:0.1em;line-height:1.6em;}
 #nosac{padding:2%;background:#fff;text-align:left;border:thin solid #ccc;-border-radius:0.25em;-moz-border-radius:0.25em;-webkit-border-radius:0.25em;-o-border-radius:0.25em;-ms-border-radius:0.25em;padding:5%;background-color:#fff;border-radius:0.25em;}
 h1{color:$html_h1_header;}
 h2{color:$html_h2_header;}
 .taglist{text-align:center;margin-bottom:4em;}
 .times_played{font-weight:700;color:$html_times_played_color;}
 .times_played2{font:smaller;vertical-align:center;color:$html_times_played_color2;}
 .song_title{color:$html_song_title_color;}
 acronym{border-bottom:thin dotted;text-decoration:none;}
 a{text-decoration:none;color:$html_links_color;}
 a:hover{text-decoration:underline;}
 a:visited{text-decoration:none;color:$html_visited_links_color;}
 a:visited:hover{text-decoration:underline;color:$html_links_color;}
 --></style>
</head>
<body>
<div id=\"nosac\">
<h1>$html_header</h1>
$when_was_monitoring_started
<strong>$date_of_page_update</strong>: <acronym title=\"$date_of_page_update\">$(date -R)</acronym><br/>
<strong>$number_of_played_songs</strong>: <acronym title=\"$number_of_played_songs\">$played_songs</acronym><br/><br/><br/>" >> $stat_output


style_querry_count="0"

#our font size
if [ "$number_of_songs_in_taglist" -gt "$font_max_size" ]; then
 font_size="$font_max_size"
else
 font_size="$number_of_songs_in_taglist"
fi
#colours (array)
font_color=($html_tagcloud_colors)
#font querry
style_querry="$number_of_songs_in_taglist"


if [ $display_tagcloud = 1 ]; then
#start listing songs in TAG cloud
echo "<h2>$fav_songs_tagcloud</h2>" >> $stat_output
echo '<div class="taglist">' >> $stat_output
#
echo "$displayed_songs_tags" | while read listed_song
do
 
  if [ "$font_changing_cycle" -ge "$style_querry_count" ]; then
  
    #if font is smaller than $font_min_size, we shall use $font_min_size only
    if [ "$font_size" -eq "$font_min_size" ]; then
     font_size="$font_min_size"
    else
     let font_size-="1"
    fi
    
   style_querry_count="0"
   
  else
   
   let style_querry_count+="1"
  
  fi
 
 #array for random colors
 H_SELECTED_COLOR=${font_color[RANDOM%${#font_color[@]}]}
 
 #implement all crap into this crap to make the crapiest crap :o)
 DIV_STYLE_S="<span style=\"font-size:$(echo "$font_size px" | tr -d " ");color:#$H_SELECTED_COLOR;\">"
 DIV_STYLE_E="</span>"
 
 #songs with links
 echo "$DIV_STYLE_S$(echo "$listed_song" | awk '{ $1=""; print; }')$DIV_STYLE_E" >> $stat_output.temp
 let style_querry_count-=1
done


#sort tags by random
cat $stat_output.temp | awk '
        BEGIN { srand() }
        { print rand() "\t" $0 }
    ' | sort -n | cut -f2- >> $stat_output

#remove junk
rm -f $stat_output.temp

#close tags
echo '</div><!-- tagcloud -->' >> $stat_output
fi #tagcloud if


#start listing songs
if [ $display_songlist = 1 ]; then
echo "<h2>$list_of_song_names</h2>" >> $stat_output
#
echo "$displayed_songs" | while read listed_song
do
 #if we enabled web search and linking, filename will be querry for web search
 search_querry="$(echo "$listed_song" | awk '{ $1=""; print; }' | cut -c2- | sed 's/&/and/g')"
 
 #if search querry is empty then we shall leave no links
 if [ -z "$search_provider" ]
  then
   song_web_search_ss='<span class="song_title">'
   song_web_search_es='</span>'
  else
   song_web_search_ss="<a href=\"$search_provider$search_querry\">"
   song_web_search_es="</a>"
  fi
  
 #songs with links
 echo "- $song_web_search_ss $(echo "$listed_song" | awk '{ $1=""; print; }') $song_web_search_es \
 <span class=\"times_played2\">($number_of_plays <span class=\"times_played\">$(echo "$listed_song" | awk '{ print $1 }')</span>x)</span><br/>" >> $stat_output
done
#close tags

#close other html tags
echo '</div><!-- nosac--></body></html>' >> $stat_output
fi #songlist if

}


collect_info () {
#timeout for collecting data
sleep $collect_timeout

#MOC - music on console
artist_info="$(mocp --info | grep "Artist:" | cut -c9-)"
track_info="$(mocp --info | grep "SongTitle:" | cut -c12-)"

echo "$artist_info - $track_info" >> "$stat_file"

#we must break script just in case :)
exit 0
}


clean_db(){
echo "Fixing database:"

echo "  * doing backup of base (saved to $stat_file.bak)"
cp -f "$stat_file" "$stat_file.bak"

#searching for bad names
# usually " - *"
echo "  * removing invalid entires"

cat "$stat_file" | grep -v "^ - *" > $stat_file.2
cat "$stat_file.2" | grep -v ". - $" > $stat_file.3

#echo "$(grep -v "^ - $" $stat_file)" | while read line
#do
#  sed -i "/$line/d" $stat_file
#  echo $line
#done
#
#echo "$(grep "^ - *" $stat_file)" | while read line
#do
#  sed -i "/$line/d" $stat_file
#  echo $line
#done

#remove blank lines from file
echo "  * removing blank lines from database"
sed -i '/^$/d' $stat_file.3

mv -f $stat_file.3 $stat_file
rm -f $stat_file.2

}


help () {
echo "$0 (v$version)
Usage: $0 [options]

Options:
 collect        - collect info from audio player (only MOC atm) where
                  [player] is desired audio player (like: mocp, ncmcpp...)
 generate       - generate HTML stats in $stat_output
 cleanup        - cleaning up database
"
}


case $@ in
 generate ) generate_stats ;;
 collect ) collect_info ;;
 cleanup ) clean_db ;;
 * ) help		;;
esac

exit 0
