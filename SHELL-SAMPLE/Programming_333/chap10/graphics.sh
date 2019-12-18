#!/bin/sh

# graphics.sh - 用PostScript語言來製作圖像

cat <<EOF | display -
%!
%%BoundingBox: 0 0 640 240
%%EndComments

% 畫出四角形的框
20 20 600 200 4 copy
1.0 0.7 0.7 setrgbcolor
rectfill
1.0 0.5 0.5 setrgbcolor
4 setlinewidth
rectstroke

% 畫圓
0.7 0.7 1.0 setrgbcolor
120 180 50 0 360 arc
4 setlinewidth
stroke
600 40 150 0 360 arc
8 setlinewidth
stroke

% 寫出使用者的登入名稱
/TimesRoman findfont
72 scalefont
setfont
50 100 moveto
0 setgray
(Welcome `whoami`!) show

% 顯示頁面
showpage
%%EOF
EOF
