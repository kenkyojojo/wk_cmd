#!/bin/sh

# trash.sh - 將指定的檔案移到垃圾桶($HOME/.Trash)

# 若欲刪除的檔案不存在的話，則顯示使用方法之後，結束程式
if [ $# -eq 0 ]; then
    echo "usage: trash files_to_trash..."
    exit 1
fi

# 若內建的「test -e」不能使用的話，則使用外部指令
if /bin/sh -c 'test -e "$0"' 2>/dev/null; then
    command=""
else
    command="command"    # Solaris的情況
fi

# 若$HOME/.Trash不存在的話，則自行製作
$command [ -e "$HOME/.Trash" ] || mkdir "$HOME/.Trash" || {
    echo "Could not create ~/.Trash"
    exit 1
}

# 做刪除處理
error=""
for path do  # 對所有的引數做同樣的動作

    # 確認刪除對象檔案是否存在
    if $command [ -e "$path" ]; then

	# 若檔案存在的話，則檢查垃圾桶內是否
	# 已存在同名的檔案
	fname=`basename "$path"`
	in_trash="$HOME/.Trash/$fname"
	suffix=0
	while $command [ -e $in_trash ]; do
	    # 若存在著同名檔案的話，則在後面加上數字
	    # 若還是重複的話，則依順增加數字
	    in_trash="$HOME/.Trash/${fname}.${suffix}"
	    suffix=`expr $suffix + 1`
	done

	# 將檔案移到垃圾桶
	if mv "$path" "$in_trash"; then
            # 成功的話，則什麼都不做
	    :  
	else
	    # 移動失敗
	    echo "$path: could not move to Trash" >&2
	    error="YES"
	fi

    else
	# 若檔案不存在的話，則顯示錯誤訊息
	echo "$path: not exist" >&2
	error="YES"
    fi
done

[ -n "$ERROR" ] && exit 1  # 做在途中發生錯誤的話，則將終止碼設為1
exit 0
