#!/bin/sh

# yesno_dlg.sh - 用純文字對話盒來詢問Yes/No

dialog --yesno "Are you sure?" 8 70
result=$?
if [ $result -eq 0 ]; then
    echo "Your answer was YES."
elif [ $result -eq 1 ]; then
    echo "Your answer was NO."
else
    echo "Action was cancelled."
fi
