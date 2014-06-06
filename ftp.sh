#!/usr/bin/ksh
IP=localhost
USER=bruce
PASS=accudata

download () {
ftp -i -n  $IP << HANDOFF
	user $USER $PASS
	bin
	put /tmp/m.sh /tmp/ftp/
	quit
HANDOFF
}

upload () {

ftp -i -n  $IP << HANDOFF
	user $USER $PASS
	bin
	lcd /tmp
	cd /tmp/ftp
	put m.sh 
	quit
HANDOFF

}
main () {
#download
	upload
}

main
