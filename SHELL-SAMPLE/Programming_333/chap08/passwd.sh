#!/bin/bash
 
die () {
		    echo &gt;&amp;2 "$@"
					    exit 1
}
 
[ "$#" -eq 2 ] || die "2 arguments required, $# provided"
 
username=$1;
newpass=$2;
export HISTIGNORE="expect*";
 
expect -c "
        spawn passwd $username
        expect "?assword:"
        send \"$newpass\r\"
        expect "?assword:"
        send \"$newpass\r\"
        expect eof"
										 
export HISTIGNORE="";
