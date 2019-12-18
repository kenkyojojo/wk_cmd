#!/usr/bin/perl
#use strict;
use warnings;

my $TARGETDIR="/home/se/safechk/selog/csv";
my $PUTTY="D:/putty";
my $PGNAME="download_csv.pl";
my $CSVDIR="D:\\CSV";
my $LOGDIR="${PUTTY}/LOG";
my $USER="useradm";

($sec,$min,$hour,$mday,$mon,$year)=localtime(time);
$year+=1900;
if ($mon == 0) {
	$mon=12;
	$year-=1;
}
# 抓上個月份
if (length ($mon) == 1) {$mon = '0'.$mon;}
if (length ($mday) == 1) {$mday = '0'.$mday;}
if (length ($hour) == 1) {$hour = '0'.$hour;}
if (length ($min) == 1) {$min = '0'.$min;}
if (length ($sec) == 1) {$sec = '0'.$sec;}


#{{{ download user account csv file from WKLPAR. 
sub download_csv{

my %LPAR=(
		WKLA => {
			"WKLPAR"=>"10.201.3.154",
			"AREA_SITE"=>"TSEOA",
			"SSH_KEY"=>"wklparA_useradm.ppk"
				},
		WKLB => {
			"WKLPAR"=>"10.202.3.154",
			"AREA_SITE"=>"TSEOB",
			"SSH_KEY"=>"wklparB_useradm.ppk"
				},
);


open (LOG,">>${LOGDIR}/download_csv.log") || die "Can't open the download_csv.log:$!";

print LOG '#'; print LOG '='x70; print LOG '#',"\n";
print LOG "Time:${year}/${mon}/${mday} ${hour}:${min}:${sec}","\n";
print LOG "Start to running $PGNAME","\n";

	my @TYP=qw(WKLA WKLB);
	foreach ( @TYP ) {
	$FILECOUNT=`$PUTTY/PLINK.exe -P 2222 -i $PUTTY/ssh-keys/$LPAR{$_}{SSH_KEY} $USER\@$LPAR{$_}{WKLPAR} "ls -l $TARGETDIR/${year}${mon}.*.csv|wc -l"`;
				if ( $FILECOUNT >= 1 ){
				print LOG "Start to download $LPAR{$_}{AREA_SITE} $TARGETDIR directory CSV FILES","\n";
				if ( ! -d "$CSVDIR\\$LPAR{$_}{AREA_SITE}\\${year}${mon}") {
					print LOG "mkdir $CSVDIR\\$LPAR{$_}{AREA_SITE}\\${year}${mon}","\n";
					`mkdir "$CSVDIR\\$LPAR{$_}{AREA_SITE}\\${year}${mon}"`;
				}
				`$PUTTY/PSCP.exe -scp -unsafe -P 2222 -i $PUTTY/ssh-keys/$LPAR{$_}{SSH_KEY} $USER\@$LPAR{$_}{WKLPAR}:$TARGETDIR/${year}${mon}.*.csv $CSVDIR\\$LPAR{$_}{AREA_SITE}\\${year}${mon}\\`;
				print LOG "download $LPAR{$_}{AREA_SITE} $TARGETDIR directory finished","\n";
		}else{
			print LOG "Please to check the CSV file on $LPAR{$_}{AREA_SITE} WKLPAR","\n";
		}
	print LOG "Running $PGNAME Finished","\n";
	}
close(LOG);
}
#}}}

sub main{
	&download_csv;
}

&main;
