#!/bin/sh

# getopts.sh - getopts的範例

opt_f="(none)"
opt_g="(none)"
opt_h="NO"

# 「-f」「-g」是後面有引數的選項，而「-h」則無
while getopts f:g:h flag; do
    case $flag in
	f)
	    opt_f="$OPTARG";;
	g)
	    opt_g="$OPTARG";;
	h)
	    opt_h=YES;;
    esac
done

echo "-f $opt_f"
echo "-g $opt_g"
echo "-h $opt_h"

# 做($OPTIND - 1)次的移位(shift)之後，就可以參照到
# 非選項之引數的其它引數
shift `expr $OPTIND - 1`
echo "other args: $*"
