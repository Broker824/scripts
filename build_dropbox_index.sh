#!/usr/bin/env bash
DATE_OF_CHANGING="$(date +"%d%m%Y @%H:%M")"
TITLE="Đurin javni dropbox direktorijum <br><h4>poslednja izmena/ažuriranje $(echo $DATE_OF_CHANGING)</h4>"
OUTPUT_FILE="index.html"
OUTPUT_FILE2="index2.html"
IGNORED_FILES="index.html|build_dropbox_index.sh|build_startpage.sh|bookmarks.html|stil.css"

tree -FDCh -H . -T "$TITLE" --charset UTF-8 -o $OUTPUT_FILE -I "$IGNORED_FILES" || echo 'Error!'

#sed -i '/<!--/,/-->/d' $OUTPUT_FILE
#sed -i '/<\/style>/d' $OUTPUT_FILE
#sed -i "s/<style type=\"text\/css\">/<link rel=\"stylesheet\" href=\"stil.css\" type=\"text\/css\" media=\"all\" \/>/g" $OUTPUT_FILE
#sed -i "s/DIR/istaknuto/g" $OUTPUT_FILE
#sed -i "s/VERSION/dno/g" $OUTPUT_FILE
#sed -i "s/<\/a>\//<br><\/a>/g" $OUTPUT_FILE
#sed -i "s/<a class=\"NORM\"/<br><br><a class=\"NORM\"/g" $OUTPUT_FILE
#sed -i "s/<a class=\"istaknuto\"/<br><br><br><br><a class=\"istaknuto\"/g" $OUTPUT_FILE

#cat $OUTPUT_FILE | tr -s "├" "--" | tr -s "─"  "--" | tr -s "│" "--" | tr -s "└" "--" >> $OUTPUT_FILE2
#cat $OUTPUT_FILE | tr -d "├─│└" >> $OUTPUT_FILE2
#mv -f $OUTPUT_FILE2 $OUTPUT_FILE

exit 0
