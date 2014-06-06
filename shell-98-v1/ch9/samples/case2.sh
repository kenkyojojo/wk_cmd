#! /bin/bash

shopt -s extglob
read yname
case $yname in
    j@(ac|xy|pq)k|john|joe) echo 'Long time no see.';;
    *) echo 'Hi!';;
esac
