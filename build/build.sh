#!/bin/bash
links() {
  mkdir -p _site/links

  # HTML
  while IFS= read -r line; do
    echo "$line" >/tmp/line
    case "$line" in
    "##"*)
      echo "</ul>"
      echo -e "$line</h2>" | sed 's/## /<h2>/g'
      echo "<ul>"
      ;;
    "#"*) echo -e "<main>\n$line</h1>" | sed 's/# /<h1>/g' ;; # h1 is used at the beginning of a markdown file (<main> section)
    "["*)
      echo -n -e '\t<li><a href="'
      echo -n $(awk -F"(" '{print $2}' /tmp/line | sed 's/.$//')
      echo -n '">'
      echo -n $(awk -F"[" '{print $2}' /tmp/line | sed 's/].*//')
      echo '</a></li>'
      ;;
    *) echo "$line" ;;
    esac
  done <markdown/links.md >/tmp/index.html
  echo -e "</ul>\n</main>\n</body>" >>/tmp/index.html
  sed "0,/<\/ul>/s/<\/ul>//" /tmp/index.html >_site/links/index.html

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
  done <markdown/links.md >_site/links/index.gmi
}

links
