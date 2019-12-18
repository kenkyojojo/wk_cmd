#!/bin/sh

# tiny_cgi.sh - 簡單的CGI script

CHARSET="UTF-8"    # 這個script的文字碼
#CHARSET="EUC-JP"

# 輸出HTTP標頭
echo "Content-Type: text/html; charset=$CHARSET"
echo

# 輸出文件內容
cat <<EOF
<html>
<head>
<title>Sample CGI script</title>
</head>
<body>
<h1>Sample CGI script</h1>
<pre>
`env`
</pre>
</body>
</html>
EOF
