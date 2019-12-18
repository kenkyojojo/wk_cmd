#!/bin/bash
alarm() {
		  perl -e '
			  eval {
					$SIG{ALRM} = sub { die };
				    alarm shift;
				    system(@ARGV);
			    	};
		      if ($@) { exit 1 }
			    ' "$@";
}

for port in {1..65535}; do
    alarm 1 "echo >/dev/tcp/google.com/$port" &&
    echo "port $port is open" ||
    echo "port $port is closed"
done

#for port in {1..65535}; do
#  echo >/dev/tcp/google.com/$port &&
#  echo "port $port is open" ||
#  echo "port $port is closed"
#done
#
