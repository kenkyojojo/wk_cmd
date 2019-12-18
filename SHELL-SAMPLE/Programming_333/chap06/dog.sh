#!/bin/sh

# animal.sh - 顯示指定的動物叫聲

# 若沒有指定選項的話，則會從自身的script名稱去掉副檔名(.sh)者
# 做為選項來執行
# 例:cat.sh → animal.sh --cat
#     dog.sh → animal.sh --dog

# 若沒有指定選項的話，從script名稱去掉副檔名(.sh)
# 做為選項來使用。
# 若有指定選項的話，則使用之。
if [ -z "$1" ]; then
    opt=--`basename "$0" .sh`
else
    opt="$1"
fi

# 依據選項來顯示叫聲
case "$opt" in
    --dog)
	bow="Bowwow, bowwow";;
    --cat)
	bow="Meow, meow";;
    --cow)
	bow="Moo, moo";;
    --pig)
	bow="Oink, Oink";;
    *)
	bow="!?X, !?X"
esac
echo $bow
