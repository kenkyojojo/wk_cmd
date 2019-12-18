#!/usr/bin/perl
#use strict;
use warnings;

my $WKLPAR="10.199.168.154";
my $TARGETDIR="/home/se/safechk/selog/log";
my $PUTTY="D:/putty/";
my ($sec,$min,$hour,$mday,$mon,$year)=localtime(time);

$year+=1900;
$mon+=1;

if (length ($mon) == 1) {$mon = '0'.$mon;}
if (length ($mday) == 1) {$mday = '0'.$mday;}
if (length ($hour) == 1) {$hour = '0'.$hour;}
if (length ($min) == 1) {$min = '0'.$min;}
if (length ($sec) == 1) {$sec = '0'.$sec;}


#download lpar fileattr err tar.gz file from WKLPAR.
sub download_fileattr_err{
$FILECOUNT=`$PUTTY/PLINK.exe -P 2222 -i $PUTTY/ssh-keys/wklpar.ppk seadm\@$WKLPAR "ls -l $TARGETDIR/*.fileattr.$year$mon$mday.err.tar.gz|wc -l "`;
	open (LOG, ">>D:/putty/LOG/${year}${mon}.download.log") || die "Can't open the download.log:$!";
 		print LOG '#'; print LOG '='x70; print LOG '#',"\n";
		print LOG "Time:$year/$mon/$mday $hour:$min:$sec","\n";
		print LOG "Start to running download.pl\n";
	if ( $FILECOUNT == 1 ){
			print LOG "start to download $TARGETDIR/TSEOA1.fileattr.$year$mon$mday.err.tar.gz\n";
			`$PUTTY/PSCP.exe -scp -unsafe -P 2222 -i "$PUTTY/ssh-keys/wklpar.ppk" "seadm\@$WKLPAR:$TARGETDIR/*.fileattr.$year$mon$mday.err.tar.gz" "D:/fileaudit/err"`;
			print LOG "download finished\n";
	}
		print LOG "download.pl finished\n";
	close(LOG);
}

sub main{
	&download_fileattr_err;
}

&main;
