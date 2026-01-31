#!/bin/bash

source build/nav.sh
cp sources/index.gmi _site
cp -r docs _site

links() {
  mkdir -p _site/links

  # HTML
  echo -e "<head>\n\t<title>$(grep '# ' sources/links.md | sed 's/# //')</title>\n<head>"
  echo -e "\t<style>"
  cat sources/style.css | sed 's/^/  /'
  echo -e "\t</style>"
  echo "<body>"

  nav | sed 's/^/  /'
  
  # This while loop converts Markdown to HTML.
  while IFS= read -r line; do
    echo "$line" >/tmp/line
    case "$line" in
    "##"*)
      echo -e "\t\t</ul>"
      echo -e "\t\t$line</h2>" | sed 's/## /<h2>/'
      echo -e "\t\t<ul>"
      ;;
    "#"*) echo -e "\t<main>\n\t\t$line</h1>" | sed 's/# /<h1>/' ;; # h1 is used at the beginning of a markdown file (<main> section)
    "["*)
      echo -n -e '\t\t\t<li><a href="'
      echo -n $(awk -F"(" '{print $2}' /tmp/line | sed 's/.$//')
      echo -n '">'
      echo -n $(awk -F"[" '{print $2}' /tmp/line | sed 's/].*//')
      echo '</a></li>'
      ;;
    *) echo "$line" ;;
    esac
  done < sources/links.md > /tmp/index.html
  echo -e "\t\t</ul>\n\t</main>\n</body>" >> /tmp/index.html
  sed "0,/\t\t<\/ul>/s/\t\t<\/ul>//" /tmp/index.html # remove first </ul>

  # Gemini
  while IFS= read -r line; do
    case "$line" in
    "["*)
      echo "$line" >/tmp/line
      echo -n '=> '
      echo -n $(awk -F"(" '{print $2}' /tmp/line | sed 's/.$//')
      echo -n -e '\t'
      echo $(awk -F"[" '{print $2}' /tmp/line | sed 's/].*//')
      ;;
    *) echo "$line" ;;
    esac
  done < sources/links.md > _site/links/index.gmi
}

links > _site/links/index.html
