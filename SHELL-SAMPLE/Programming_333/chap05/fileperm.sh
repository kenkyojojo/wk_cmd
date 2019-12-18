#!/bin/sh

# fileperm.sh - 調查檔案的存取權

[ -r "$1" ] && rp="readable" || rp="not readable"
[ -w "$1" ] && wp="writable" || wp="not writable"
[ -x "$1" ] && xp="executable" || xp="not executable"

echo "$1 is $rp, $wp and $xp."
