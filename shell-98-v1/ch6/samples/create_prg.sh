#! /bin/bash

echo "正在產生 hello.c ...."
echo
cat <<'EOF' > hello.c
#include <stdio.h>

int main() {
    printf("Hello world!\n");
    return 0;
}
EOF

echo "編譯 hello.c ...."
echo
# 編譯 hello.c，產生執行檔
gcc -o hello hello.c

# 若編譯成功，就執行。
if [ $? -eq 0 ]; then
   echo "執行 hello ...."
   echo
   ./hello
else
   echo 'Compile ERROR: hello.c'
fi
