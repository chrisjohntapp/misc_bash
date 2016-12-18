find . -type d -name '*.cjt' -print0 | while read -d $'\0' f; do mv "$f" "${f%.cjt}"; done
