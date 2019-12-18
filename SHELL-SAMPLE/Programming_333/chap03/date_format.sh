#!/bin/sh

# date_format.sh - 指定格式的日期時間

date +'%Y/%m/%d %H:%M:%S'  # yyyy/mm/dd HH:MM:SS
date +'%c'                 # 依對應locale(語言環境)的格式
date +'Timezone: %Z'       # 顯示現在的時區
