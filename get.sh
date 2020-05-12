#!/bin/bash
#this script downloads html versions of books you have access to on cambridge core
#it will create a single html file of it and an epub if you have pandoc
#the point is that cambridge core only lets you download pdfs, not the html and there is no epub
#the url should be to the table of contents e.g. https://www.cambridge.org/core/books/cambridge-companion-to-heideggers-being-and-time/36E496653771E4774A6D43AD211930C8
#you need to have a cookies.txt
#we need pup installed to parse the html nicely
#uses pandoc to convert html to epub
#not all books you have access to have HTML versions. some just have pdfs.

if ! [ -x "$(command -v pup)" ]; then
  echo 'Error: pup is not installed. Get it here: https://github.com/ericchiang/pup' >&2
  exit 1
fi

if [ "${1:0:37}" = "https://www.cambridge.org/core/books/" ] ;
then
	dir=$(echo "${1}" | cut -d"/" -f"6")
else
	echo "${1} isn't the kind of URL I was expecting. Exiting"
	exit
fi

pwd=$(pwd)
mkdir -p "${dir}/assets"
cd "${dir}/assets"

#does cookies.txt exist where we expect?
if ! test -f  "${pwd}/cookies.txt"; then
    echo " ${pwd}/cookies.txt does not exist. Exiting"
    exit
fi

#get the contents page
wget --load-cookies "${pwd}/cookies.txt" "${1}" -O index.html

if grep -q -e "Unfortunately you do not have access to this title"  -e "Check if you have access" index.html; then
    echo "You don't have access to this title. Exiting"
    exit
fi

if ! grep -q -e "View HTML full" -e "Online view" index.html; then
    echo "There is no HTML version of this title. Deleting what was downloaded and exiting."
    cd ../../
    rm -rf "${dir}"
    exit
fi

if grep -q "Online view" index.html; then
    append="online-view"
fi

if grep -q "View HTML full" index.html; then
    append="core-reader"
fi

#use pup to get the title of the book
title=$(cat index.html | pup -p '.book-wrapper h1.title text{}' | tr -d '\n')


#use pup to get the table of contents urls
#note that the urls don't link directly to the html - you need to append /core-reader or /online-view
cat index.html | pup ".results-listing a.part-link attr{href}"  > toc.txt

count=0
while IFS= read -r line
do
  count=$(( $count + 1 ))
  order=$(printf %03d $count)
  id=$(echo "${line}" | rev | cut -d"/" -f2 | rev)
  wget  --load-cookies "${pwd}/cookies.txt" "https://www.cambridge.org$line/$append" -O "${order}-${id}.html"
done < "toc.txt"

#create the html from the pages
echo "<html><head><title>${title}</title></head><body>" > "../${title}.html"
cat *.html | pup article >> "../${title}.html"
echo "</body></html>"  >> "../${title}.html"

if  [ -x "$(command -v pandoc)" ]; then
  echo 'Creating epub using pandoc...'
  pandoc -f html -t epub3 -o "../${title}.epub" "../${title}.html"
  echo "Pandoc's epubs seem much slower than those created manually in Calibre from the HTML. Maybe try that instead?"
fi


cd "${pwd}"
