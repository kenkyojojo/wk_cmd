#!/bin/sh

# heredoc.sh - here document的例子

# 將地名一覽表排序過後再顯示
sort <<EOF
Sapporo
Tokyo
Nagoya
Osaka
Fukuoka
EOF
# ↑「EOF」的前面不可以有其它東西

echo

# 將訊息顯示在畫面上
# (若想顯示較長的訊息時，有時會使用這種寫法
# 由於有指定「-」，所以行頭的縮排字元會被忽略。
cat <<-ENDOFFILE
	Acquaintance, n.: A person whom we know well enough to borrow from,
	but not well enough to lend to.
	    - Ambrose Bierce, The Devil's Dictionary
	ENDOFFILE
# ↑這不是空白字元，而是縮排


#
# 「<<EOF」與「<<'EOF'」的不同
#

#若是使用「<<EOF」的話，因為變數展開是有變的，所以「$PATH」會被展開(與"..."時相同)
echo
cat <<EOF
[cat <<EOF]
$PATH
EOF

# 若是使用「<<'EOF'」的話，變數展開是無效的(與'...'時相同)
echo
cat <<'EOF'    # $PATH未被展開
[cat <<'EOF']
$PATH
EOF
