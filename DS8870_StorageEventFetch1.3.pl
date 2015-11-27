#!C:\Perl\bin\perl.exe
use strict;
use Net::Ping;
##############################################################################
## Target:																	## 
## Collect DS8870 da, hba, ddm, stgencl, server and ioport	status			##
## then insert into TPCDB table												##
## lsda -> DS8870B1deviceadapter table                                      ##
##                                                                          ##
##																		    ##
## Date:   2014/10/11														##
## Ver:    1.0
## Ver:    1.1 add moduler calculation mechanism						    ##
## Author: Win-Way															##
##############################################################################
my $StorageDir = 'C:\Perl\Storage\DS8870\script';
my $LogDir = 'C:\Perl\Storage\DS8870\log';
my @Array1 = ('lsda','lshba','lsserver','lsstgencl','lsddm','lsioport');
my $Length1 = @Array1;
my $ChkTime = &GetTime;



#my $ip = "192.168.128.193";
# TEST IP = 10.1.223.129 !!
my $ip = "10.1.223.129";
my $p = Net::Ping->new('icmp');

# Check OK -> $result ->1;Check Fail $result -> 0
# set timeout is 5 sec

##############################################################
## Pre-Check Process Count & Env
##############################################################

open(ERR, ">> $LogDir\\err.log") || die "$!\n";
if (!-d "$StorageDir")
{
	print ERR "[ERROR]$ChkTime: $StorageDir Directory is not found!\n";
	exit 1;
}
if (!-d "$LogDir")
{
	print ERR "[ERROR]$ChkTime: $LogDir Directory is not found!\n";
	exit 1;
}
if (!-e "$StorageDir\\AutoInsert.sql")
{
	print ERR "[ERROR]$ChkTime: $StorageDir\\AutoInsert.sql Directory is not found!\n";
	exit 1;
}
close(ERR);

##############################################################
## Fetch Critical Event Message From Storage
##############################################################
my $result=$p->ping($ip,5);

 if ($result == 1)
	{
	#`dscli.exe -user admin -passwd passw0rd lsda -l IBM.2107-75BGW21 > $StorageDir\\lsda.log`;
	#`dscli.exe -user admin -passwd passw0rd lshba -l IBM.2107-75BGW21 > $StorageDir\\lshba.log`;
	#`dscli.exe -user admin -passwd passw0rd lsddm -l IBM.2107-75BGW21 > $StorageDir\\lsddm.log`;
	#`dscli.exe -user admin -passwd passw0rd lsstgencl -l IBM.2107-75BGW21 > $StorageDir\\lsstgencl.log`;
	#`dscli.exe -user admin -passwd passw0rd lsserver -l > $StorageDir\\lsserver.log`;
	#`dscli.exe -user admin -passwd passw0rd lsioport -l > $StorageDir\\lsioport.log`;
	`dscli.exe -user admin -passwd p\@ssw0rd lsda -l IBM.2107-75XC331 > $StorageDir\\lsda.log`;
	`dscli.exe -user admin -passwd p\@ssw0rd lshba -l IBM.2107-75XC331 > $StorageDir\\lshba.log`;
	`dscli.exe -user admin -passwd p\@ssw0rd lsddm -l IBM.2107-75XC331 > $StorageDir\\lsddm.log`;
	`dscli.exe -user admin -passwd p\@ssw0rd lsstgencl -l IBM.2107-75XC331 > $StorageDir\\lsstgencl.log`;
	`dscli.exe -user admin -passwd p\@ssw0rd lsserver -l > $StorageDir\\lsserver.log`;
	`dscli.exe -user admin -passwd p\@ssw0rd lsioport -l > $StorageDir\\lsioport.log`;
	}
else
	{
	open(HISTORY, ">> $LogDir\\err.log") || die "$!\n";
	print HISTORY "[ERROR]$ChkTime: DS8870, PING FAIL\n";
	close(HISTORY);
	}
	
##############################################################
#clear report file
##############################################################

if (-e "$StorageDir\\Summary.log") 
{
	unlink "$StorageDir\\Summary.log";
}
if (-e "$StorageDir\\DeviceAdapter.log")
{
	unlink "$StorageDir\\DeviceAdapter.log";
}
if (-e "$StorageDir\\HostAdapter.log")
{
	unlink "$StorageDir\\HostAdapter.log";
}
if (-e "$StorageDir\\Server.log")
{
	unlink "$StorageDir\\Server.log";
}
if (-e "$StorageDir\\StorageEnclosure.log")
{
	unlink "$StorageDir\\StorageEnclosure.log";
}
if (-e "$StorageDir\\DDMs.log")
{
	unlink "$StorageDir\\DDMs.log";
}
if (-e "$StorageDir\\Port.log")
{
	unlink "$StorageDir\\Port.log";
}



=cut
if (-e "$StorageDir\\ITM_Summary.log") 
{
	unlink "$StorageDir\\ITM_Summary.log";
}
if (-e "$StorageDir\\ITM_DeviceAdapter.log")
{
	unlink "$StorageDir\\ITM_DeviceAdapter.log";
}
if (-e "$StorageDir\\ITM_HostAdapter.log")
{
	unlink "$StorageDir\\ITM_HostAdapter.log";
}
if (-e "$StorageDir\\ITM_Server.log")
{
	unlink "$StorageDir\\ITM_Server.log";
}
if (-e "$StorageDir\\ITM_StorageEnclosure.log")
{
	unlink "$StorageDir\\ITM_StorageEnclosure.log";
}
if (-e "$StorageDir\\ITM_DDMs.log")
{
	unlink "$StorageDir\\ITM_DDMs.log";
}
if (-e "$StorageDir\\ITM_Port.log")
{
	unlink "$StorageDir\\ITM_Port.log";
}
=cut
open (my $NULL,">","$StorageDir\\ITM_Summary.log") or die "cannot open > $StorageDir\\ITM_Summary.log: $!";
open (my $NULL,">","$StorageDir\\ITM_DeviceAdapter.log") or die "cannot open > $StorageDir\\ITM_DeviceAdapter.log: $!";
open (my $NULL,">","$StorageDir\\ITM_HostAdapter.log") or die "cannot open > $StorageDir\\ITM_HostAdapter.log: $!";
open (my $NULL,">","$StorageDir\\ITM_Server.log") or die "cannot open > $StorageDir\\ITM_Server.log: $!";
open (my $NULL,">","$StorageDir\\ITM_StorageEnclosure.log") or die "cannot open > $StorageDir\\ITM_StorageEnclosure.log: $!";
open (my $NULL,">","$StorageDir\\ITM_DDMs.log") or die "cannot open > $StorageDir\\ITM_DDMs.log: $!";
open (my $NULL,">","$StorageDir\\ITM_Port.log") or die "cannot open > $StorageDir\\ITM_Port.log: $!";

=cut
##############################################################
## Write Self-check message every 0,10,20,30,40,50 min
##############################################################
$ChkTime =~ /^.+\-\d+.?(\d+)/;
my $min = $1;
my $mod = $min % 10;

if ($mod == 0)
{
   open(CHKFILE2, ">>$StorageDir\\ITM_Summary.log") or die "$!";
   print CHKFILE2 "$ChkTime;DS8870;\TSEOB-Storage;OK\n";
   close(CHKFILE2);
}
=cut
	
for (my $i=0;$i<=$Length1-1;$i++)
{
	open (FILE,"$StorageDir\\$Array1[$i].log") or die "could not open lscommand file for Reading: $! \n";
	my @file = <FILE>;
	close (FILE);
	my $Length2 = @file;
	open (LOG1,">>$StorageDir\\Summary.log") or die "could not open $StorageDir\\Summary.log for Writing: $!\n";
	
	for (my $j=3;$j<=$Length2-1; $j++)
	{
		if ($Array1[$i] =~ 'lsda')
		{
			open (LOG2,">>$StorageDir\\DeviceAdapter.log") or die "could not open $StorageDir\\DeviceAdapter.log for Writing: $!\n";
			chomp($file[$j]);
			$file[$j] =~ /(^.+?)\s+(Online|Offline|Coming online|Going offline|Failed|Offline Loop \d |Failed|Offline Loop \d\/\d |Taking down Loop \d|Taking down Loop \d\/\d |Bring up all loops?)\s+\w\d+\.(\d\w\d?)\.\w+\d+\-\w\d\-(\w\d?)\s+\-\s+(\d+?)\s+(\d+?)\s/;
			print LOG1 "\"$ChkTime\",";
			print LOG1 "\"Device Adapter\",";
			print LOG2 "\"$ChkTime\",";
			print LOG1 "\"$1\",";
			print LOG1 "\"$2\"\n";
			print LOG2 "\"$1\",";
			print LOG2 "\"$2\",";
			print LOG2 "\"$3\",";
			print LOG2 "\"$4\",";
			print LOG2 "\"$5\",";
			print LOG2 "\"$6\"\n";
		}
		elsif ($Array1[$i] =~ 'lshba')
		{
			open (LOG2,">>$StorageDir\\HostAdapter.log") or die "could not open $StorageDir\\HostAdapter.log for Writing: $!\n";
			chomp($file[$j]);
			$file[$j] =~ /(^.+?)\s+(Online|Offline|Coming online|Going offline|Failed|Offline Loop \d |Failed|Offline Loop \d\/\d |Taking down Loop \d|Taking down Loop \d\/\d |Bring up all loops?)\s+\w\d+\.(\d\w\d?)\.\w+\d+\-\w\d\-(\w\d?)\s+/;
			print LOG1 "\"$ChkTime\",";
			print LOG1 "\"Host Adapter\",";
			print LOG1 "\"$1\",";
			print LOG1 "\"$2\"\n";
			print LOG2 "\"$ChkTime\",";
			print LOG2 "\"$1\",";
			print LOG2 "\"$2\",";
			print LOG2 "\"$3\",";
			print LOG2 "\"$4\"\n";
		}
		elsif ($Array1[$i] =~ 'lsserver')
		{
			open (LOG2,">>$StorageDir\\Server.log") or die "could not open $StorageDir\\Server.log for Writing: $!\n";
			chomp($file[$j]);
			my ($server1,$server2,$server3,$server4,$server5,$server6,$server7,$server8) = split(/\s+/, $file[$j]);
			print LOG1 "\"$ChkTime\",";
			print LOG1 "\"Server\",";
			print LOG1 "\"$server3\",";
			print LOG1 "\"$server5\"\n";
			print LOG2 "\"$ChkTime\",";
			print LOG2 "\"$server1\",";
			print LOG2 "\"$server2\",";
			print LOG2 "\"$server3\",";
			print LOG2 "\"$server4\",";
			print LOG2 "\"$server5\",";
			print LOG2 "\"$server6\"\n";
		}
		elsif ($Array1[$i] =~ 'lsstgencl')
		{
			open (LOG2,">>$StorageDir\\StorageEnclosure.log") or die "could not open $StorageDir\\StorageEnclosure.log for Writing: $!\n";
			chomp($file[$j]);
			$file[$j] =~ /(^.+?)\s+(\w+\d+?)\s+(\w+\d+?)\s+(\w.+?)\s.+\s\s\s\s\s(\d+?)\s+(\d+?)\s+(\d+\.\d+)\s+(\d+?)\s+(\w+)/;
			print LOG1 "\"$ChkTime\",";
			print LOG1 "\"Storage Enclosure\",";
			print LOG1 "\"$1\",";
			print LOG1 "\"$9\"\n";
			print LOG2 "\"$ChkTime\",";
			print LOG2 "\"$1\",";
			print LOG2 "\"$2\",";
			print LOG2 "\"$3\",";
			print LOG2 "\"$4\",";
			print LOG2 "\"$5\",";
			print LOG2 "\"$6\",";
			print LOG2 "\"$7\",";
			print LOG2 "\"$8\",";
			print LOG2 "\"$9\"\n";
		}
		elsif ($Array1[$i] =~ 'lsddm')
		{
			open (LOG2,">>$StorageDir\\DDMs.log") or die "could not open $StorageDir\\DDMs.log for Writing: $!\n";
			chomp($file[$j]);
			$file[$j] =~ /(^.+?)\s+(\w.+?)\d\d\d.+\s+\w(\d.+?)\-\w\d\-(\w\d+?)\s+(\w\d+?)\s+(\d+?)\s+(\d+?)\s+(\d.+?)\s+(\d+?)\s+\w+\s+(\d.+?)\s+(spare required|Unassigned|Spare not required|array member|unconfigured?)\s+(\w.+?)\s+(\d+?)\s+(Normal|New|Installing|Verifying|Formatting|Initializing|Certifying|Rebuilding|Migration Target|Migration Source|Failed|Failed - Deferred Service|Removed|Inappropriate|Inter failed|PFSed?)\s+(\w+?)\s+/;
			print LOG1 "\"$ChkTime\",";
			print LOG1 "\"DDMs\",";
			print LOG1 "\"$1\",";
			print LOG1 "\"$14\"\n";
			print LOG2 "\"$ChkTime\",";
			print LOG2 "\"$1\",";
			print LOG2 "\"$2\",";
			print LOG2 "\"$3\",";
			print LOG2 "\"$4\",";
			print LOG2 "\"$5\",";
			print LOG2 "\"$6\",";
			print LOG2 "\"$7\",";
			print LOG2 "\"$8\",";
			print LOG2 "\"$9\",";
			print LOG2 "\"$10\",";
			print LOG2 "\"$11\",";
			print LOG2 "\"$12\",";
			print LOG2 "\"$13\",";
			print LOG2 "\"$14\",";
			print LOG2 "\"$15\"\n";
		}
		elsif ($Array1[$i] =~ 'lsioport')
		{
			open (LOG2,">>$StorageDir\\Port.log") or die "could not open $StorageDir\\Port.log for Writing: $!\n";
			chomp($file[$j]);
			$file[$j] =~ /(\w\d)(\d)(\d)(\d?)\s.+\s+(\w+?)\s+(Fibre Channel-\w+?)\s+(-|SCSI-FCP)?\s+(\d+)?\s+(\d+\s+Gb\/s)/;
			print LOG1 "\"$ChkTime\",";
			print LOG1 "\"Port\",";
			print LOG1 "\"$1$2$3$4\",";
			print LOG1 "\"$5\"\n";
			print LOG2 "\"$ChkTime\",";
			print LOG2 "\"$1$2$3$4\",";
			print LOG2 "\"$2\",";
			print LOG2 "\"$3\",";
			print LOG2 "\"$4\",";
			print LOG2 "\"$5\",";
			print LOG2 "\"$6\",";
			print LOG2 "\"$7\",";
			print LOG2 "\"$8\",";
			print LOG2 "\"$9\"\n";
		} 
	}
		
}
close(LOG1);
close(LOG2);

##############################################################
#copy StorageEvent.log to ChkDir
##############################################################

#my @Array3 = ('DeviceAdapter','Port','Summary','HostAdapter','Server','StorageEnclosure','DDMs');
my @Array3 = ('DeviceAdapter','Port','Summary','HostAdapter','StorageEnclosure','DDMs','Server');
my $Length3 = @Array3;

for (my $k=0;$k<=$Length3-1;$k++)
{
	open(FILE2,"$StorageDir\\$Array3[$k].log") or die "could not open logfile for Reading: $! \n";
	my @FILE2 = <FILE2>;
	close (FILE2);
	my $length4 = @FILE2;
	for (my $l=0;$l<=$length4-1;$l++)
	{
		open(CHKFILE1,">>$StorageDir\\ITM_$Array3[$k].log") or die "could not open ITMfile for Writing: $! \n";
		chomp($FILE2[$l]);
		my $RegLine = &TranslateSign($FILE2[$l]);
		print CHKFILE1 "$RegLine\n";
	}
	close(CHKFILE1);
}



=cut
{
	open(TMP, "$StorageDir\\$Array3[$k].log") or die "$!";
		open(CHKFILE1, ">>$StorageDir\\ITM_$Array3[$k].log") or die "$!";

		while(my $line = <TMP>)
		{
			chomp($line);
			my $RegLine = &TranslateSign($line);
			print CHKFILE1 "$RegLine\n";
		}
	
   close(CHKFILE1);
close(TMP);
}
=cut


##############################################################
## Write Self-check message every 0,10,20,30,40,50 min
##############################################################
$ChkTime =~ /^.+\-\d+.?(\d+)/;
my $min = $1;
my $mod = $min % 10;

if ($mod == 0)
{
   open(CHKFILE2, ">>$StorageDir\\ITM_Summary.log") or die "$!";
   print CHKFILE2 "$ChkTime;DS8870;\TSEOB-Storage;OK\n";
   close(CHKFILE2);
}



sub GetTime
{
	my ($sec,$min,$hour,$day,$mon,$year)=localtime(time);
	$mon++;
	if (length ($mon) == 1) {$mon = '0'.$mon;}
	if (length ($day) == 1) {$day = '0'.$day;}
	if (length ($hour) == 1) {$hour = '0'.$hour;}
	if (length ($min) == 1) {$min = '0'.$min;}
	if (length ($sec) == 1) {$sec = '0'.$sec;}
	$year+=1900;
	my $time="$year\-$mon\-$day\-$hour\.$min\.$sec";
	return($time);   
}
##############################################################
## Insert Event Message To StorageEvent Table
##############################################################

#`db2cmd.exe -c db2 -tvf C:\\perl\\Storage\\DS8870\\script\\AutoInsert.sql`;

##############################################################
## receved: "DS3512-A1","2014-05-08-15.07.11"
## return: "DS3512-A1";"2014-05-08-15.07.11"
##############################################################

sub TranslateSign
{
   my $Raw = $_[0];
   $Raw =~ s/","/";"/g;
   $Raw =~ s/"//g;
   #print"4\n";
   return($Raw);   
}
