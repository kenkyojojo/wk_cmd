#!/bin/sh

# yesno.sh - 用Yes/No詢問使用者

# yesno
#     從標準輸入讀入一行資料，若回答是「yes/YES」的話，則為真(終止碼0)
#     若為「no/NO」的話，則為假(終止碼1)。
yesno() {
    yn_result=""
    while [ -z "$yn_result" ]; do
	read yn_reply
	case "$yn_reply" in
	    [Yy][Ee][Ss])  # yes, YES, Yes 等等...
		yn_result=0;;
	    [Nn][Oo])      # no, NO, No 等等...
		yn_result=1;;
	    *)             # 其它
		echo "Please enter YES or NO.";;
	esac
    done
    return $yn_result
}

## 使用例

echo "Do you love icecream?"
if yesno; then
    echo "Okey, you love icecream." 
else
    echo "So you don't like icecream..."
fi

echo "Are you female?"
if yesno; then
    echo "Hmm, you looks so cute!"
else
    echo "You must be male."
fi
