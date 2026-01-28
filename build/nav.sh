nav() {
  while IFS= read -r line; do
    case $line in
    "##"*) break ;;
    "#"*) echo -e "$line</header>\n<nav>" | sed 's/# /<header>/g' ;;
    "=>"*)
      echo -e -n "\t" # indent
      echo -n "$line" | sed 's/=> /<a href="/g' | sed 's/\t/">/g'
      echo "</a>"
      ;;
    *) continue ;;
    esac
  done <sources/index.gmi

  echo "</nav>"
}
