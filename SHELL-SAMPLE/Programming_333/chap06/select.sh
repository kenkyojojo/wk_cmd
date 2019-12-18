#!/bin/bash

# select.sh - select的範例

PS3="Which fruits do you like? "
select fruit in apples oranges bananas "I'm full!"; do
    case "$fruit" in
	"I'm full!")
	    break;;
	"")
	    echo "Pardon me?";;
	*)
	    echo "Okey, I will give you some $fruit.";;
    esac
done

echo "Good bye."
