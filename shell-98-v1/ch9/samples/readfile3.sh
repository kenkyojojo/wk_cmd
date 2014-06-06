#! /bin/bash

IFS=':'

cat /etc/passwd | {

while read f1 f2 f3 f4 f5 f6 f7
do
   echo "±b¸¹: $f1¡Alogin shell ¬O: $f7"
done 

}
