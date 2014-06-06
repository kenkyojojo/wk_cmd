#! /bin/bash

read yname
case $yname in
    Jack | John | Joe) 
        echo 'Well...'
        echo "Long time no see."
        echo "How do you do ?"
        ;;
    (Mary| May)  echo 'Nice to meet you.';;
    C*) echo 'Long time no see.';;
    *) echo 'Hi!';;
esac
