#!/bin/sh

# backup_to_winfolder.sh - 將檔案備份到Windows的共享資料夾中

BACKUP_ORG="$HOME"     # 執行tar時的目前資料夾(current directory)
BACKUP_TGT=bin         # 用tar來做archive的資料夾
LOCAL_FILE=my_bin.tar.gz

WIN_SERVICE="//sango/shared"
AUTH_FILE="$HOME/sango-shared.smbaccess"

cd "$BACKUP_ORG"
tar cf - "$BACKUP_TGT" | gzip -c > "$LOCAL_FILE"

smbclient "$WIN_SERVICE" -A "$AUTH_FILE" -c "put '$LOCAL_FILE'"

rm "$LOCAL_FILE"
