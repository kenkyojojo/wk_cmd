#! /bin/bash

TMPF='/tmp/tmp.$$'
cat dataf6.csv | awk -F, 'BEGIN{OFS=","}{print $1,$4,$3,$2,$5,$6,$7}' > $TMPF
mv -f $TMPF dataf6.csv
