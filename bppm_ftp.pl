#!/usr/bin/perl
use strict;
use warnings;
use Net::FTP;
use File::Copy;


my ($ftp, $host, $user, $pass, $dir, $fpath, $file, $logpath, $log, $errlog);

$host="192.168.1.82";
$user="bruce";
$pass="accudata";
$dir="/tmp";
$fpath="E:";
$file="${fpath}/win.txt";
$logpath="E:/log";
$log="${logpath}/bppm_ftp.log";
$errlog="${logpath}/bppm_ftp_err.log";

use File::Copy "cp";
cp("$file","${logpath}");
#cp("$file","${file}.bak");

#use File::Copy "mv";
#mv("${file}.bak","${logpath}");

sub ftp{

	open(FD,">> $log");
	open(STDERR,">> $errlog");

	$ftp = Net::FTP->new($host, Debug => 1) or die "Could not connect to '$host': $@";
	$ftp->login($user,$pass) or die sprintf "Could not login: %s" , $ftp->message;
	$ftp->cwd($dir) or die sprintf "Could not login: %s", $ftp->message;
	$ftp->ls;
	$ftp->binary;
	$ftp->put($file) or die $ftp->message;
	$ftp->quit;

	close(FD);
	close(STDERR);
	return ;
}


sub main{

	&ftp();
	return ;
}

&main;
