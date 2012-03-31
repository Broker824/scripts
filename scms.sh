#!/usr/bin/env bash
#
#       scms.sh
        verzija="0.1a7"
#       Datum kreiranja ovog dokumenta je 22.07.2011 00:47:18
#       
#       Ovaj dokument je kreiran uz pomoć Geany 0.20 editora
#       2011, djura-san (http://lab21.net)
#       
#       This program is free software. It comes without any warranty, to
#       the extent permitted by applicable law. You can redistribute it
#       and/or modify it under the terms of the Do What The Fuck You Want
#       To Public License, Version 2, as published by Sam Hocevar. See
#       http://sam.zoy.org/wtfpl/COPYING for more details.
#
# TODO
# - colored odd or even years - DONE
# - basic categories support - DONE
# - speed up stuff by writing info to external files (it will use lest cat in realtime) - DONE
#                     (used shared variables instead of writing to disk... it saves disk life)
# - SEO headers to change some relevant info - DONE
# - general tidy action to clean up whole script and make it pretier
# - add full and title only feeds - DONE
#
txt_src_dir='/home/djura-san/projects/web_design/work/lab21/trenutni/sajt/site_src/txt'
template_dir='/home/djura-san/projects/web_design/work/lab21/trenutni/sajt/site_src/sabloni'
output_dir='/home/djura-san/projects/web_design/work/lab21/trenutni'
#
blog_txt_src='/home/djura-san/projects/web_design/work/lab21/trenutni/sajt/blog_src/txt'
blog_template_dir='/home/djura-san/projects/web_design/work/lab21/trenutni/sajt/blog_src/sabloni'
blog_output_dir='/home/djura-san/projects/web_design/work/lab21/trenutni'
blog_archive_dir='tekstovi'
blog_entry_img='/sajt/tekst.png'
blog_entries_on_homepage='6'
blog_social_buttons='0'
#
blog_feed_full='1'
blog_feed_full_entries='3'
blog_feed_short='1'
blog_feed_short_entries='6'
#
blog_index_header='<h1>Đurina laboratorija</h1><br/><br/>Personalni sajt <span class="a2"><a href="/info.html">IT entuzijaste</a></span>, samoproglašenog raketnog fizičara, naučnika i ronina.<br/><br/><br/> <h3>Poslednji unosi:</h3><br/>'
#blog_archives_header='<h1>Arhiva svih tekstova</h1><br/><br/><div class="kutija"><img src="/sajt/info.png" width="22" height="22" alt="[Info]"/> koristite <span class="podebljano"><code>CTRL+F</code></span> ili taster <span class="podebljano"><code>/</code></span> za brzu pretragu.</div><br/>'
# API variables that can be used in html templates etc
author='djura-san'
website_title='Đurina laboratorija'
meta_description='Personalni sajt IT entuzijaste, samoproglašenog raketnog fizičara, naučnika i ronina.'
html_lang='sr'
meta_charset='utf-8'
feed_encoding='utf-8'
me_meta_tag='http://lab21.net/info.html' #can be anything to describe myself
#
website_address="http://www.lab21.net" #root of site where scms.sh files
                                       #will be, without "/" at end
sitemap_locations="pub/
pub/dizajn/
pub/softver/
tekstovi/"


cleaner () {
 #removing crap
 echo && echo ' * brisu se privremeni sadrzaji'

 rm -f "$blog_output_dir/tekstovi_temp.txt"
 rm -f "$blog_output_dir/tekstovi_arhiva.txt"
 rm -Rf "$blog_output_dir/feed-temp/*"
 rm -f "$blog_output_dir/feed_short.txt"
 rm -f "$blog_output_dir/feed_full.txt"
}


create_blog_post () {
 echo
}


make_webpages () {
#echo info about operation
echo 'Kreiram staticne strane za sajt...'
echo "Sadrzaj se generise u $output_dir
$0 obavlja sledece operacije:
"

 #start with sitemap
 echo ' * pravljenje mape sajta (sitemap)'
 if [ -e "$output_dir/sitemap.xml" ]; then rm -f $output_dir/sitemap.xml ;fi
 
 echo '<?xml version="1.0" encoding="UTF-8"?>
<urlset
      xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://www.sitemaps.org/schemas/sitemap/0.9
            http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd">' >> $output_dir/sitemap.xml
 #we shall read for sitemap paths before we start adding new stuff
 echo "$sitemap_locations" | while read location
  do
   echo "<url><loc>$website_address/$location</loc></url>" >> $output_dir/sitemap.xml
  done
 
 echo ' * pravljenje individualnih strana'
 for webpage in $(ls $txt_src_dir/)
  do
   echo "   - $webpage"
   #if there is file already, we shall erase it
   if [ -e "$output_dir/$webpage.html" ]; then rm -f "$output_dir/$webpage.html"; fi
   #adding var for page title
   page_title="$(echo "$webpage" | tr -s "_" " " )"
   #echo header+content+footer for every web page
   echo "<!DOCTYPE HTML>
<html lang=\"$html_lang\">
<head>
  <meta charset=\"$meta_charset\">
  <title>$page_title :: $website_title</title>
  <meta name=\"description\" content=\"$meta_description\" />
  <meta name=\"author\" content=\"$author\" />
  <meta name=\"robots\" content=\"index, follow\" />
  <link rel=\"me\" type=\"text/html\" href=\"$me_meta_tag\"/>
  <link rel=\"shortcut icon\" type=\"image/x-icon\" href=\"/sajt/slike/favicon.ico\" />
  <link rel=\"stylesheet\" href=\"/sajt/glavni_stil.css\" type=\"text/css\" media=\"screen, projection\" />
  <link rel=\"stylesheet\" href=\"/sajt/stampa.css\" type=\"text/css\" media=\"print\" />
  <script type=\"text/javascript\" src=\"/sajt/smoothscroll.js\"></script>
</head>

<body id=\"vrh_strane\">&nbsp;
<div id=\"sadrzaj\">
<div class=\"vrh\">
   <a href=\"/\">&larr;</a> 
   <a href=\"/tekstovi/arhiva.html\">Tekstovi</a> 
   <a href=\"/projekti.html\">Projekti</a> 
   <a href=\"/info.html\">Autor</a>
</div><!--vrh--><br/><br/>"  >> "$output_dir/$webpage.html"
   #echo $(cat "$template_dir/header.html") >> "$output_dir/$webpage.html"
   #   
   cat "$txt_src_dir/$webpage" >> "$output_dir/$webpage.html"
   echo '<br/><br/><div class="a2"><a href="#vrh_strane">vrh strane &uarr;</a></div>' >> "$output_dir/$webpage.html"
   echo $(cat "$template_dir/footer.html") >> "$output_dir/$webpage.html"
   
   #make sitemap for site
   echo "<url><loc>$website_address/$webpage.html</loc></url>" >> $output_dir/sitemap.xml
  done
 
 #finish sitemap
 echo '</urlset>' >> $output_dir/sitemap.xml
}


blog_feeds () {
  if [ "$blog_feed_full" = "1" ]; then
  echo "<link href=\"/tekstovi/dovod.xml\" type=\"application/atom+xml\" rel=\"alternate\" title=\"Kompletni tekstovi\" />" >> "$blog_output_dir/$blog_archive_dir/$post.html"
  fi
  if [ "$blog_feed_short" = "1" ]; then
  echo "<link href=\"/tekstovi/dovod-kratki.xml\" type=\"application/atom+xml\" rel=\"alternate\" title=\"Kratki naslovi sa kategorijama\" />" >> "$blog_output_dir/$blog_archive_dir/$post.html"
  fi
}


blog_generator () {
#echo info about operation
echo 'Kreiram blog staticnog sadrzaja...'
echo "Blog se generise u $blog_output_dir
$0 obavlja sledece operacije:
"

#if no $blog_output dir, we shall create one
if [ ! -e "$blog_output_dir" ]; then mkdir -p $blog_output_dir ;fi
if [ ! -e "$blog_output_dir/$blog_archive_dir" ]; then mkdir -p $blog_output_dir/$blog_archive_dir ;fi


echo ' * generisanje individualnih datoteka:'
count="0"
for post in $(ls $blog_txt_src/)
 do
  
    #echo info about operation
    echo "   - $post"
    
    #defining stuff in files
    blog_text_title="$(cat $blog_txt_src/$post | sed q | sed 's/\*/\&#42;/g')"
    blog_text_categories="$(cat "$blog_txt_src/$post" | sed '2q;d' | sed 's/\*/\&#42;/g')"
    blog_text_date="$(cat "$blog_txt_src/$post" | sed '3q;d' | sed 's/\*/\&#42;/g')"
    better_date="$(echo "$blog_text_date" | tr -s "/" "-")"

    #if there is file already, we shall erase it
    if [ -e "$blog_output_dir/$blog_archive_dir/$post.html" ]; then rm -f "$blog_output_dir/$blog_archive_dir/$post.html"; fi
    
    ##social buttons
    blog_social_buttons_source="<br/><img src=\"/sajt/slike/deljenje.png\" width=\"16\" height=\"16\" alt=\"[deljenje]\" /> Deljenje: <a href=\"https://identi.ca/index.php?action=newnotice&status_textarea=$blog_text_title @ $website_address/$blog_archive_dir/$post.html\">Identi.ca</a> - <a href=\"http://www.reddit.com/submit\" onclick=\"window.location = 'http://www.reddit.com/submit?url=' + encodeURIComponent(window.location); return false\">reddit</a> - <!--<a href=\"https://twitter.com/share\" class=\"twitter-share-button\" data-count=\"vertical\">Twitter</a><script type=\"text/javascript\" src=\"//platform.twitter.com/widgets.js\"></script>--><!--<a href=\"http://twitter.com/home/?status=$(echo "$blog_text_title" | tr -s " " "+")+@+$website_address/$blog_archive_dir/$post.html\">Twitter</a><script type=\"text/javascript\" src=\"//platform.twitter.com/widgets.js\"></script>--> - <a href=\"http://www.stumbleupon.com/submit?url=$website_address/$blog_archive_dir/$post.html&title=$(echo "$blog_text_title" | tr -s " " "+")\">StumbleUpon</a>"
    if [ "$blog_social_buttons" = "1" ]; then blog_social_buttons_html="$blog_social_buttons_source"; fi
    
    #Make individual posts
    #echo $(cat "$blog_template_dir/header.html") >> "$blog_output_dir/$blog_archive_dir/$post.html"
    #  <meta name=\"DC.Title\" content=\"$blog_text_title :: $website_title\" />
    #  <meta name=\"DC.Creator\" content=\"$author\" />
    #  <meta name=\"DC.Description\" content=\"$blog_text_title\" />
    #  <meta name=\"DCTERMS.Created\" content=\"$better_date\" />
    #  <meta name=\"DC.Language\" content=\"$html_lang\" />
    echo "<!DOCTYPE HTML>
<html lang=\"$html_lang\">
<head>
  <meta charset=\"$meta_charset\">
  <title>$blog_text_title :: $website_title</title>
  <meta name=\"description\" content=\"$blog_text_title\" />
  <meta name=\"author\" content=\"$author\" />
  <meta name=\"robots\" content=\"index, follow\" />
  <link rel=\"me\" type=\"text/html\" href=\"$me_meta_tag\"/>
  <link rel=\"shortcut icon\" type=\"image/x-icon\" href=\"/sajt/slike/favicon.ico\" />
  <link rel=\"stylesheet\" href=\"/sajt/glavni_stil.css\" type=\"text/css\" media=\"screen, projection\" />
  <link rel=\"stylesheet\" href=\"/sajt/stampa.css\" type=\"text/css\" media=\"print\" />"  >> "$blog_output_dir/$blog_archive_dir/$post.html"
  $(blog_feeds)
  echo "<script type=\"text/javascript\" src=\"/sajt/smoothscroll.js\"></script>
  
</head>

<body id=\"vrh_strane\">&nbsp;
<div id=\"sadrzaj\">
<div class=\"vrh\">
   <a href=\"/\">&larr;</a> 
   <a href=\"/tekstovi/arhiva.html\">Tekstovi</a> 
   <a href=\"/projekti.html\">Projekti</a> 
   <a href=\"/info.html\">Autor</a>
</div><!--vrh--><br/><br/>" >> "$blog_output_dir/$blog_archive_dir/$post.html"
    # <a href=\"/$blog_archive_dir/$post.html\">$blog_text_date</a>
    echo "<h1>$blog_text_title</h1><br/>
    <img src=\"/sajt/slike/datum.png\" width=\"16\" height=\"16\" alt=\"[datum]\" /> <span class=\"a2\">$better_date</span>
    <br/><br/>" >> "$blog_output_dir/$blog_archive_dir/$post.html"
    #sed -n '3,${p;}' ili sed '1,3d'
    #<img src=\"/sajt/slike/datum.png\" width=\"16\" height=\"16\" alt=\"[datum]\" /> Datum pisanja: <span class=\"iskoseno\">$blog_text_date</span>
    cat "$blog_txt_src/$post" | sed '1,4d' >> "$blog_output_dir/$blog_archive_dir/$post.html"
    echo "<br/><span class=\"a2\">$blog_social_buttons_html</span>
    <br/><br/><div class=\"a2\"><a href=\"#vrh_strane\">vrh strane &uarr;</a></div>" >> "$blog_output_dir/$blog_archive_dir/$post.html"
    echo $(cat "$blog_template_dir/footer.html") >> "$blog_output_dir/$blog_archive_dir/$post.html"
    
    #from http://bash.cyberciti.biz/decision-making/find-whether-number-is-odd-even/
    #determine if number is odd or even
    determine_number="$(echo "$blog_text_date" | tr -s "/" " " | awk '{ print $1 }')"
    if [ "$(($determine_number % 2))" -eq "0" ]; then
     #if it is even
     archive_hilight_start=""
     archive_hilight_end=""
    else
     #if it is odd
     archive_hilight_start="<span class=\"istaknuto\">"
     archive_hilight_end="</span>"
    fi
    
    #Archives links
    echo "<!-- $blog_text_date --><span class=\"fensi\">$archive_hilight_start<span class=\"iskoseno\">$better_date</span>$archive_hilight_end &mdash;</span> <a href=\"$post.html\">$blog_text_title</a> <span class=\"fensi\"><span class=\"superscript\">$blog_text_categories</span></span><br/>" >> "$blog_output_dir/tekstovi_arhiva.txt"
    
    #Index N articles
    #echo "<!-- $blog_text_date --><img src=\"$blog_entry_img\" title=\"\" alt=\"\" /> <span class=\"podebljano\">$blog_text_title</span> <a href=\"/$blog_archive_dir/$post.html\">[nastavite čitanje...]</a> <br /><span class=\"a2\">&raquo; Oznake: <abbr title=\"oznake/tagovi\">$blog_text_categories</abbr> &mdash; Datum pisanja: <span class=\"iskoseno\">$blog_text_date</span></span><br/><br/>" >> "$blog_output_dir/tekstovi_temp.txt"
    echo "<!-- $blog_text_date --><span class=\"fensi\"><span class=\"iskoseno\">$better_date</span> &mdash;</span> <a href=\"$blog_archive_dir/$post.html\">$blog_text_title</a> <span class=\"fensi\"><span class=\"superscript\">$blog_text_categories</span></span><br/>" >> "$blog_output_dir/tekstovi_temp.txt"
    
    #feed generator
    #  | tr -s "\n" "<br/> " | tr -s "<" "&lt;" | tr -s ">" "&gt;" | tr -s "&" "&amp;"
    if [ "$blog_feed_full" = "1" ]; then
        blog_feed_text="$(cat "$blog_txt_src/$post" | sed '1,4d' | sed 's/$/<br\/>/g' | sed 's/\*/\&#42;/g' | tr -d "\n")"
        atom_data_type=' type="html"'
        echo "<!-- $blog_text_date --><entry><title$atom_data_type>$blog_text_title</title><link href=\"$website_address/$blog_archive_dir/$post.html\"/><id>$website_address/$blog_archive_dir/$post.html</id><updated>$(echo "$blog_text_date" | tr -s "/" "-")T05:17:00Z</updated><summary$atom_data_type><![CDATA[  $blog_text_title (oznake: $blog_text_categories) <br/><br/> $blog_feed_text  ]]></summary></entry>" >> "$blog_output_dir/feed_full.txt"
        #"$blog_output_dir/feed-temp/feed_full_$count.txt"
        #let count+=1
    fi
    
    if [ "$blog_feed_short" = "1" ]; then
        atom_data_type=' type="html"'
        echo "<!-- $blog_text_date --><entry><title$atom_data_type>$blog_text_title</title><link href=\"$website_address/$blog_archive_dir/$post.html\"/><id>$website_address/$blog_archive_dir/$post.html</id><updated>$(echo "$blog_text_date" | tr -s "/" "-")T05:17:00Z</updated><summary$atom_data_type><![CDATA[  $blog_text_title (oznake: $blog_text_categories) ]]></summary></entry>" >> "$blog_output_dir/feed_short.txt"
    fi

 done

 #making archives
 echo ' * pravljenje arhiva'
 
 #Making index page
 echo '   - indeks strana'
 if [ -e "$blog_output_dir/index.html" ]; then rm -f "$blog_output_dir/index.html"; fi
 #echo $(cat "$blog_template_dir/header.html") >> "$blog_output_dir/index.html"
 echo "<!DOCTYPE HTML>
<html lang=\"$html_lang\">
<head>
  <meta charset=\"$meta_charset\">
  <title>$website_title</title>
  <meta name=\"description\" content=\"$meta_description\" />
  <meta name=\"author\" content=\"$author\" />
  <meta name=\"robots\" content=\"index, follow\" />
  <link rel=\"me\" type=\"text/html\" href=\"$me_meta_tag\"/>
  <link rel=\"shortcut icon\" type=\"image/x-icon\" href=\"/sajt/slike/favicon.ico\" />
  <link rel=\"stylesheet\" href=\"/sajt/glavni_stil.css\" type=\"text/css\" media=\"screen, projection\" />
  <link rel=\"stylesheet\" href=\"/sajt/stampa.css\" type=\"text/css\" media=\"print\" />"  >> "$blog_output_dir/index.html"
  $(blog_feeds)
  echo "  <script type=\"text/javascript\" src=\"/sajt/smoothscroll.js\"></script>
</head>

<body id=\"vrh_strane\">&nbsp;
<div id=\"sadrzaj\">
<div class=\"vrh\">
   <a href=\"/tekstovi/arhiva.html\">Tekstovi</a> 
   <a href=\"/projekti.html\">Projekti</a> 
   <a href=\"/info.html\">Autor</a>
</div><!--vrh--><br/><br/>"  >> "$blog_output_dir/index.html"
 #
 echo "$blog_index_header" >> "$blog_output_dir/index.html"
 echo $(cat "$blog_output_dir/tekstovi_temp.txt" | sort -r | head -n $blog_entries_on_homepage) >> "$blog_output_dir/index.html"
 echo '<br/>' >> "$blog_output_dir/index.html"
 echo $(cat "$blog_template_dir/index.html") >> "$blog_output_dir/index.html"
 echo '<br/>' >> "$blog_output_dir/index.html"
 echo $(cat "$blog_template_dir/footer.html") >> "$blog_output_dir/index.html"

 #Making whole archive
 echo '   - godisnje'
 if [ -e "$blog_output_dir/$blog_archive_dir/arhiva.html" ]; then rm -f "$blog_output_dir/$blog_archive_dir/arhiva.html"; fi
 #echo $(cat "$blog_template_dir/header.html") >> "$blog_output_dir/$blog_archive_dir/arhiva.html"
  echo "<!DOCTYPE HTML>
<html lang=\"$html_lang\">
<head>
  <meta charset=\"$meta_charset\">
  <title>Arhiva tekstova :: $website_title</title>
  <meta name=\"description\" content=\"Arhiva tekstova\" />
  <meta name=\"author\" content=\"$author\" />
  <meta name=\"robots\" content=\"index, follow\" />
  <link rel=\"me\" type=\"text/html\" href=\"$me_meta_tag\"/>
  <link rel=\"shortcut icon\" type=\"image/x-icon\" href=\"/sajt/slike/favicon.ico\" />
  <link rel=\"stylesheet\" href=\"/sajt/glavni_stil.css\" type=\"text/css\" media=\"screen, projection\" />
  <link rel=\"stylesheet\" href=\"/sajt/stampa.css\" type=\"text/css\" media=\"print\" />"  >> "$blog_output_dir/$blog_archive_dir/arhiva.html"
  $(blog_feeds)
  echo "  <script type=\"text/javascript\" src=\"/sajt/smoothscroll.js\"></script>
  
</head>

<body id=\"vrh_strane\">&nbsp;
<div id=\"sadrzaj\">
<div class=\"vrh\">
   <a href=\"/\">&larr;</a> 
   <a href=\"/tekstovi/arhiva.html\">Tekstovi</a> 
   <a href=\"/projekti.html\">Projekti</a> 
   <a href=\"/info.html\">Autor</a>
</div><!--vrh--><br/><br/>"  >> "$blog_output_dir/$blog_archive_dir/arhiva.html"
 echo "<h1>Arhiva svih tekstova ($(cat "$blog_output_dir/tekstovi_arhiva.txt" | sed '/^$/d' | wc -l))</h1>
 <br/> <div class=\"kutija\"><span class=\"a2\"><img src=\"/sajt/slike/dovod.png\" width=\"16\" height=\"16\" alt=\"[xml]\" /> <a href=\"/tekstovi/dovod-kratki.xml\">Kratki naslovi (+oznake)</a> + <img src=\"/sajt/slike/dovod.png\" width=\"16\" height=\"16\" alt=\"[xml]\" /> <a href=\"/tekstovi/dovod.xml\">Kompletni tekstovi</a></span></div><!--<div class=\"kutija\"><img src=\"/sajt/slike/info.png\" width=\"22\" height=\"22\" alt=\"[Info]\"/> koristite <span class=\"podebljano\"><code>CTRL+F</code></span> ili taster <span class=\"podebljano\"><code>/</code></span> za brzu pretragu.</div>-->
 <br/><span class=\"a2\">" >> "$blog_output_dir/$blog_archive_dir/arhiva.html"
 #echo "$blog_archives_header" >> "$blog_output_dir/$blog_archive_dir/arhiva.html"
 #echo "Ukupan broj tekstova u arhivi: <span class="podebljano">$(cat "$blog_output_dir/tekstovi_arhiva.txt" | sed '/^$/d' | wc -l)</span><br/>" >> "$blog_output_dir/$blog_archive_dir/arhiva.html"
 echo $(cat "$blog_output_dir/tekstovi_arhiva.txt" | sort -r) >> "$blog_output_dir/$blog_archive_dir/arhiva.html"
 echo '</span><br/><div class="a2"><a href="#vrh_strane">vrh strane &uarr;</a></div>' >> "$blog_output_dir/$blog_archive_dir/arhiva.html"
 echo $(cat "$blog_template_dir/footer.html") >> "$blog_output_dir/$blog_archive_dir/arhiva.html"

 #making feed
if [ "$blog_feed_short" = "1" ] ; then
 echo ' * dodavanje tekstova u kratki Atom dovod'
 if [ -e "$blog_output_dir/$blog_archive_dir/dovod-kratki.xml" ]; then rm -f "$blog_output_dir/$blog_archive_dir/dovod-kratki.xml"; fi
 echo "<?xml version=\"1.0\" encoding=\"$feed_encoding\"?>
<feed xmlns=\"http://www.w3.org/2005/Atom\" xml:lang=\"sr\">
<title type=\"html\">$website_title</title>
<link rel=\"alternate\" type=\"text/html\" href=\"$website_address\"/>
<author><name>$author</name><uri>$website_address</uri></author>
<icon>$website_address/sajt/slike/favicon.ico</icon><logo>$website_address/sajt/slike/favicon.ico</logo>
<link rel=\"self\" type=\"application/atom+xml\" href=\"$website_address/$blog_archive_dir/dovod.xml\"/>
<updated>$(cat "$blog_output_dir/tekstovi_arhiva.txt" | sort -r | head -n 1 | awk '{ print $2 }' | tr -s "/" "-")T05:17:00Z</updated>
<id>$website_address/$blog_archive_dir/</id>" >> "$blog_output_dir/$blog_archive_dir/dovod-kratki.xml"
 echo $(cat "$blog_output_dir/feed_short.txt" | sort -r | head -n $blog_feed_short_entries) >> "$blog_output_dir/$blog_archive_dir/dovod-kratki.xml"
 echo "</feed>" >> "$blog_output_dir/$blog_archive_dir/dovod-kratki.xml"
fi

if [ "$blog_feed_full" = "1" ] ; then
 echo ' * dodavanje tekstova u puni Atom dovod'
 if [ -e "$blog_output_dir/$blog_archive_dir/dovod.xml" ]; then rm -f "$blog_output_dir/$blog_archive_dir/dovod.xml"; fi
 echo "<?xml version=\"1.0\" encoding=\"$feed_encoding\"?>
<feed xmlns=\"http://www.w3.org/2005/Atom\" xml:lang=\"sr\">
<title type=\"html\">$website_title</title>
<link rel=\"alternate\" type=\"text/html\" href=\"$website_address\"/>
<author><name>$author</name><uri>$website_address</uri></author>
<icon>$website_address/sajt/slike/favicon.ico</icon><logo>$website_address/sajt/slike/favicon.ico</logo>
<link rel=\"self\" type=\"application/atom+xml\" href=\"$website_address/$blog_archive_dir/dovod.xml\"/>
<updated>$(cat "$blog_output_dir/tekstovi_arhiva.txt" | sort -r | head -n 1 | awk '{ print $2 }' | tr -s "/" "-")T05:17:00Z</updated>
<id>$website_address/$blog_archive_dir/</id>" >> "$blog_output_dir/$blog_archive_dir/dovod.xml"
 echo $(cat "$blog_output_dir/feed_full.txt" | sort -r | head -n $blog_feed_full_entries) >> "$blog_output_dir/$blog_archive_dir/dovod.xml"
 echo "</feed>" >> "$blog_output_dir/$blog_archive_dir/dovod.xml"
fi

 #calling for cleaner function
 cleaner
 

}



help () {
echo "$0 v$verzija - alat za generisanje statičnih sajtova i blogova
Upotreba: $0 [opcija]

Opcije
  blog   kreiranje bloga
  site   kreiranje sajta
"
}



case $@ in
	blog ) blog_generator		;;
	site ) make_webpages		;;
	 * ) help		;;
esac

exit 0



