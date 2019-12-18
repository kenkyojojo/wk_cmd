#!/bin/sh

# var_tmpassign.sh - 暫時性地變更環境變數

echo "LANG=${LANG}"

for lang in ja_JP.eucJP ja_JP.UTF-8 \
    en_US.ISO8859-1 fr_FR.ISO8859-1 de_DE.ISO8859-1; do
  echo -n "$lang - "
  #echo "$lang - \c"  # Solaris的情況
  LANG="$lang" date +'%B %d (%A)'
done

# LANG的值並未改變
echo "LANG=${LANG}"
