#!/bin/sh

# avinfo.sh - 取得聲音、影像檔的資訊

mplayer -identify -ao null -vo null -frames 0 "$1" 2>/dev/null | \
    grep ^ID

