#!/bin/sh
links() {
  mkdir -p links

  # HTML
  while IFS= read -r line; do
    echo "$line" >/tmp/line
    case "$line" in
    "##"*)
      echo "</ul>"
      echo -e "$line</h2>" | sed 's/## /<h2>/g'
      echo "<ul>"
      ;;
    "#"*) echo "$line</h1>" | sed 's/# /<h1>/g' ;;
    "["*)
      echo -n -e '\t<li><a href="'
      echo -n $(awk -F"(" '{print $2}' /tmp/line | sed 's/.$//')
      echo -n '">'
      echo -n $(awk -F"[" '{print $2}' /tmp/line | sed 's/].*//')
      echo '</a></li>'
      ;;
    *) echo "$line" ;;
    esac
  done <src/links.md >/tmp/index.html
  echo "</ul>" >>/tmp/index.html
  sed "0,/<\/ul>/s/<\/ul>//" /tmp/index.html >links/index.html

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
  done <src/links.md >links/index.gmi
}

links
