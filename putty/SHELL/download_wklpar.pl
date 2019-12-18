#!/usr/bin/perl
#use strict;
#use warnings;

$PUTTY="D:/putty";
$PGNAME="download_wklpar.pl";
$LOGDIR="${PUTTY}/LOG";
$LOGFILE="${LOGDIR}/download.log";
$USER="seadm";
$PARA="$ARGV[0]";
%LPAR=(
		WKLA => {
			"WKLPAR"=>"10.201.3.154",
			"AREA_SITE"=>"TSEOA",
			"SSH_KEY"=>"wklparA_seadm.ppk"
				},
		WKLB => {
			"WKLPAR"=>"10.202.3.154",
			"AREA_SITE"=>"TSEOB",
			"SSH_KEY"=>"wklparB_seadm.ppk"
				},
);

#{{{ get time 
sub gettime{
$dayago=$_[0];
#($sec,$min,$hour,$mday,$mon,$year)=localtime(time-86400);
($sec,$min,$hour,$mday,$mon,$year)=localtime(time-${dayago});
	$year+=1900;
	#2014 取尾碼2位數 14
	$file_year=sprintf("%02d", $year % 100);
	$mon+=1;

	if (length ($mon) == 1) {$mon = '0'.$mon;}
	if (length ($mday) == 1) {$mday = '0'.$mday;}
	if (length ($hour) == 1) {$hour = '0'.$hour;}
	if (length ($min) == 1) {$min = '0'.$min;}
	if (length ($sec) == 1) {$sec = '0'.$sec;}
	return ($sec,$min,$hour,$mday,$mon,$year,$file_year);
}
#}}}

#{{{ download nmon file from WKLPAR. 
sub download_nmon{

my $TARGETDIR="/home/se/safechk/selog/itm";
my $DIR="D:\\NMON";
open (LOG,">>${LOGFILE}") || die "Can't open the ${LOGFILE}:$!";
print LOG '#'; print LOG '='x70; print LOG '#',"\n";
my ($sec,$min,$hour,$mday,$mon,$year,$file_year) = &gettime();
print LOG "Time:${year}/${mon}/${mday} ${hour}:${min}:${sec}","\n";
print LOG "Start to running $PGNAME","\n";

	my @TYP=qw(WKLA WKLB);
	foreach ( @TYP ) {
	my ($sec,$min,$hour,$mday,$mon,$year,$file_year) = &gettime(86400);
	$filename="$LPAR{$_}{AREA_SITE}*${file_year}${mon}${mday}.tar.gz";
	$FILECOUNT=`$PUTTY/PLINK.exe -P 2222 -i $PUTTY/ssh-keys/$LPAR{$_}{SSH_KEY} $USER\@$LPAR{$_}{WKLPAR} "ls -l $TARGETDIR/$filename|wc -l"`;
				if ( $FILECOUNT >= 1 ){
				print LOG "Start to download $LPAR{$_}{AREA_SITE} $TARGETDIR directory $filename FILES","\n";
				if ( ! -d "$DIR\\$LPAR{$_}{AREA_SITE}\\$year") {
					print LOG "mkdir $DIR\\$LPAR{$_}{AREA_SITE}\\$year","\n";
					`mkdir "$DIR\\$LPAR{$_}{AREA_SITE}\\$year"`;
				}
				`$PUTTY/PSCP.exe -scp -unsafe -P 2222 -i $PUTTY/ssh-keys/$LPAR{$_}{SSH_KEY} $USER\@$LPAR{$_}{WKLPAR}:$TARGETDIR/$filename $DIR\\$LPAR{$_}{AREA_SITE}\\$year`;
				print LOG "download $LPAR{$_}{AREA_SITE} $TARGETDIR directory finished","\n";
		}else{
			print LOG "Please to check the $filename file on $LPAR{$_}{AREA_SITE} WKLPAR","\n";
		}
	print LOG "Running $PGNAME Finished","\n";
	}
close(LOG);
}
#}}}

#{{{ download daily report file from WKLPAR. 
sub download_daily_report{

my $DIR="D:\\CHK";
my $TARGETDIR="/home/se/chk/report";

open (LOG,">>${LOGFILE}") || die "Can't open the ${LOGFILE}:$!";
print LOG '#'; print LOG '='x70; print LOG '#',"\n";
my ($sec,$min,$hour,$mday,$mon,$year,$file_year) = &gettime();
print LOG "Time:${year}/${mon}/${mday} ${hour}:${min}:${sec}","\n";
print LOG "Start to running $PGNAME","\n";

	my @TYP=qw(WKLA WKLB);
	foreach ( @TYP ) {
	my ($sec,$min,$hour,$mday,$mon,$year,$file_year) = &gettime();
	$filename="merge.report.${file_year}${mon}${mday}${hour}";
	$FILECOUNT=`$PUTTY/PLINK.exe -P 2222 -i $PUTTY/ssh-keys/$LPAR{$_}{SSH_KEY} $USER\@$LPAR{$_}{WKLPAR} "ls -l $TARGETDIR/$filename|wc -l"`;
				if ( $FILECOUNT >= 1 ){
				print LOG "Start to download $LPAR{$_}{AREA_SITE} $TARGETDIR directory $filename FILES","\n";
				if ( ! -d "$DIR\\$LPAR{$_}{AREA_SITE}\\$year") {
					print LOG "mkdir $DIR\\$LPAR{$_}{AREA_SITE}\\$year","\n";
					`mkdir "$DIR\\$LPAR{$_}{AREA_SITE}\\$year"`;
				}
				`$PUTTY/PSCP.exe -scp -unsafe -P 2222 -i $PUTTY/ssh-keys/$LPAR{$_}{SSH_KEY} $USER\@$LPAR{$_}{WKLPAR}:$TARGETDIR/$filename $DIR\\$LPAR{$_}{AREA_SITE}\\$year`;
				print LOG "download $LPAR{$_}{AREA_SITE} $TARGETDIR directory finished","\n";
		}else{
			print LOG "Please to check the $filename on $LPAR{$_}{AREA_SITE} WKLPAR","\n";
		}
	print LOG "Running $PGNAME Finished","\n";
	}
close(LOG);
}
#}}}

#{{{download lpar fileattr err tar.gz file from WKLPAR
sub download_fileattr_err{

my $TARGETDIR="/home/se/safechk/selog/log";
my $DIR="D:\\fileaudit\\err";

open (LOG,">>${LOGFILE}") || die "Can't open the ${LOGFILE}:$!";
print LOG '#'; print LOG '='x70; print LOG '#',"\n";
my ($sec,$min,$hour,$mday,$mon,$year,$file_year) = &gettime();
print LOG "Time:${year}/${mon}/${mday} ${hour}:${min}:${sec}","\n";
print LOG "Start to running $PGNAME","\n";

	my @TYP=qw(WKLA WKLB);
	foreach ( @TYP ) {
	my ($sec,$min,$hour,$mday,$mon,$year,$file_year) = &gettime();
	$filename="*.fileattr.$year$mon$mday.err.tar.gz";
	$FILECOUNT=`$PUTTY/PLINK.exe -P 2222 -i $PUTTY/ssh-keys/$LPAR{$_}{SSH_KEY} $USER\@$LPAR{$_}{WKLPAR} "ls -l $TARGETDIR/$filename|wc -l"`;
				if ( $FILECOUNT >= 1 ){
				print LOG "Start to download $LPAR{$_}{AREA_SITE} $TARGETDIR directory's $filename FILES","\n";
				if ( ! -d "$DIR\\$LPAR{$_}{AREA_SITE}\\$year") {
					print LOG "mkdir $DIR\\$LPAR{$_}{AREA_SITE}\\$year","\n";
					`mkdir "$DIR\\$LPAR{$_}{AREA_SITE}\\$year"`;
				}
				`$PUTTY/PSCP.exe -scp -unsafe -P 2222 -i $PUTTY/ssh-keys/$LPAR{$_}{SSH_KEY} $USER\@$LPAR{$_}{WKLPAR}:$TARGETDIR/$filename $DIR\\$LPAR{$_}{AREA_SITE}\\$year`;
				print LOG "download $LPAR{$_}{AREA_SITE} $TARGETDIR directory $filename finished","\n";
		}else{
			print LOG "Please to check the $filename file on $LPAR{$_}{AREA_SITE} WKLPAR","\n";
		}
	print LOG "Running $PGNAME Finished","\n";
	}
close(LOG);
}
#}}}

sub main{

	#download nmon every day form WKLPAR
	if ($PARA == 1) {
		&download_nmon;
	#download daily_report every day from WKLPAR
	}elsif ($PARA == 2) { 
		&download_daily_report;
	#download lpar fileattr_err file every day from WKLPAR
	}elsif ($PARA == 3) { 
		&download_fileattr_err;
	}else { 
		print "Need the parameter","\n";
		exit 1;
	}
}

&main("$PARA");
