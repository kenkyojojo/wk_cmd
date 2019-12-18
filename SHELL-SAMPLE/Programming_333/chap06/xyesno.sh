#!/bin/sh

# xyesno.sh - 在GUI中詢問Yes/No

if Xdialog --yesno "Are you sure?" 8 70; then
    echo "Your answer was YES."
else
    echo "Your answer was NO."
fi
