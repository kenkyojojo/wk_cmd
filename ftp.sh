#!/usr/bin/ksh
IP=10.199.168.154
USER=root
PASS=root

download () {
ftp -i -n $IP << HANDOFF
	user $USER $PASS
	bin
	cd /TWSE/ITM/
	lcd /tmp/ITM/
	mget *
	quit
HANDOFF
}

upload () {

ftp -i -n $IP << HANDOFF
	user $USER $PASS
	bin
	lcd /tmp
	cd /tmp/ftp
	put m.sh 
	quit
HANDOFF

}
main () {
	download
#	upload
}

main
