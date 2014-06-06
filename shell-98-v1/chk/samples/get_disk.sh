#! /bin/bash

# 變數要先宣告後才能使用
shopt -s -o nounset

while read x x x m
do
    case "$m" in
      hd?)
        Media=$(cat /proc/ide/$m/media)
        if [ "$Media" = "disk" ] ; then
          echo "磁碟機: $m, 型號: $(cat /proc/ide/$m/model)"
        fi
        ;;
      sd?)
        M=$(scsi_info /dev/$m | grep MODEL)
        M=${M#*\"}
        M=${M%\"*}
        echo "磁碟機: $m, 型號: $M"
        ;;
      *) 
        ;;
    esac
done < /proc/partitions
