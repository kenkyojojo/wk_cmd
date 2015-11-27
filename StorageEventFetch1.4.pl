#!C:\Perl\bin\perl
use strict;
use File::Copy "cp";
use Net::Ping;

##################################################################################
## Target:																		## 
## extract & filter DS3512/DS5100 storage event(warning/critical) message		##
## then insert into TPCDB STORAGE_HW_EVENT table								##
##																				##
## Date:	2014/09/20															##
## Ver:		1.1																	##
## Ver:		1.2 add self-check mechanism										##
## Ver:		1.3 indicate the latest event										##
## Ver:		1.4 modify self-check inteval										##
## Author:	Win-Way																##
##################################################################################
#print"1\n";
my $StorageEnvDir = 'C:\Program Files (x86)\IBM_DS\client';
my $ScriptEnvDir = 'C:\Perl\Storage\script';
my $SystemCMDDir = 'C:\Windows\System32';
my $LogDir = 'C:\Perl\Storage\log';
my $BaseDir = 'C:\Perl\Storage\Base';
my $ChkDir = 'C:\Perl\Storage\Check';
my $RepDir = 'C:\Perl\Storage\Report';

## Storage IP Configuration
my %Storage = 
(
	#"DS5100-A1" => "10.201.3.176",
	#"DS5100-A2" => "10.201.3.178",
	#"DS3512-A1" => "10.201.3.197",
	"DS5100-TSEOT1" => "10.199.130.175",
	"DS5100-TSEOT2" => "10.199.170.175",
);



##############################################################
## Pre-Check Process Count & Env
##############################################################
my @Process = `$SystemCMDDir\\tasklist.exe`;
my $ChkTime = &GetTime;
my $Count=0;
open(ERR, ">> $LogDir\\err.log") || die "$!\n";
foreach (@Process) 
{
   chomp;
   $Count++ if(/^perl.exe/) 
}
if ($Count > 2)
{
   print ERR "[ERROR]$ChkTime: Running Perl Process > 2 !!\n"; 
   exit 1;
}
if (!-d "$StorageEnvDir") 
{
   print ERR "[ERROR]$ChkTime: $StorageEnvDir Directory is not found!\n"; 
   exit 1;
}
if (!-e "$ScriptEnvDir\\AutoInsert.sql") 
{
   print ERR "[ERROR]$ChkTime: $ScriptEnvDir\\AutoInsert.sql file is not found!\n"; 
   exit 1;
}
if (!-d "$BaseDir") 
{
   print ERR "[ERROR]$ChkTime: $BaseDir Directory is not found!\n"; 
   exit 1;
}
if (!-d "$ChkDir") 
{
   print ERR "[ERROR]$ChkTime: $ChkDir Directory is not found!\n"; 
   exit 1;
}
if (!-d "$RepDir") 
{
   print ERR "[ERROR]$ChkTime: $RepDir Directory is not found!\n"; 
   exit 1;
}
close(ERR);

##############################################################
## Fetch Critical Event Message From Storage
##############################################################

my $p = Net::Ping->new('icmp');
my $LogPath = "C:\\Perl\\Storage";

# Check OK -> $result ->1;Check Fail $result -> 0
# set timeout is 5 sec




while (my ($StorageName, $StorageIP) = each (%Storage))
{
	my $result=$p->ping($StorageIP,5);
	if ($result == 1)
	{
		my $FetchCMD = "smcli.exe $StorageIP -S -c \"save storagesubsystem criticalevents file=\\\"$LogDir\\$StorageName.log\\\" count=2000\;\"";
		#print"$FetchCMD\n";
		`$FetchCMD`;  
	}
	else
	{
		open(HISTORY, ">> $LogDir\\err.log") || die "$!\n";
		print HISTORY "[ERROR]$ChkTime: $StorageName,$StorageIP,PING FAIL\n";
		close(HISTORY);
	}

}

##############################################################
## Filter Event Message
## StorageName Date SequenceNumber EventType EventCategory Priority Description EventSpecificCodes ComponentType ComponentLocation LoggedBy
##      1        2         3           4          5           6         7              8                9              10             11  
##############################################################

open (LOG, ">$LogDir\\StorageEvent.log") or die "$!\n";
while (my ($StorageName, $StorageIP) = each (%Storage))
{
   open (FHD, "$LogDir\\$StorageName.log") or die "Could not open file: $! \n";  
   while(my $line = <FHD>)
   {
      chomp($line);
	  next if $line eq /^\s+/;
	  next if $line =~ /^\d+/;
	  next if $line =~ /^Raw/;	  
	  
	  my($EventClass, $EventMsg) = split(/\:\s/, $line);	  
	  if ($EventClass =~ /^Date/) 
	  {
	     print LOG "\"$StorageName\",";
	     print "\"$StorageName\",";
		 
	     my $RegTime = &TranslateTime("$EventMsg");
	     print LOG "\"$RegTime\",";
	  } 
	  elsif ($EventClass =~ /^Sequence number/) 
	  {
	     print LOG "\"$EventMsg\","; 
	  } 
	  elsif ($EventClass =~ /^Event type/) 
	  {
	     print LOG "\"$EventMsg\",";
	  } 
	  elsif ($EventClass =~ /^Event category/) 
	  {
	     print LOG "\"$EventMsg\",";
	  } 
	  elsif ($EventClass =~ /^Priority/) 
	  {
	     print LOG "\"$EventMsg\",";
	  } 
	  elsif ($EventClass =~ /^Description/) 
	  {
	     print LOG "\"$EventMsg\",";
	  } 
	  elsif ($EventClass =~ /^Event specific codes/) 
	  {
	     print LOG "\"$EventMsg\",";
	  } 
          elsif ($EventClass =~ /^Component type/) 
	  {
	     print LOG "\"$EventMsg\",";
	  }
	  elsif ($EventClass =~ /^Component location/) 
	  {
	     print LOG "\"$EventMsg\",";
	  }
	  elsif ($EventClass =~ /^Logged by/) 
	  {
	     print LOG "\"$EventMsg\"\n";
	  }
	  else 
	  {
	     print "\n";
	  }
   }     
   close(FHD);
}
close(LOG);


##############################################################
#clear report file
##############################################################
#print"2\n";
open (my $NULL,">","$RepDir\\err_report.txt") or warn "cannot open > $RepDir\\err_report.txt: $!";
open (my $NULL,">","$ChkDir\\CurrEvent.txt") or warn "cannot open > $ChkDir\\CurrEvent.txt: $!";

##############################################################
#copy StorageEvent.log to ChkDir
##############################################################

open(TMP, "$LogDir\\StorageEvent.log") or die "Cannot open $LogDir\\StorageEvent.log for Reading: $!\n";
   open(CHKFILE, ">>$ChkDir\\CurrEvent.txt") or die "Cannot open $ChkDir\\CurrEvent.txt for writing: $!\n";

   while(my $line = <TMP>)
   {
      chomp($line);
      my $RegLine = &TranslateSign($line);
      print CHKFILE "$RegLine\n";
   }

   close(CHKFILE);
close(TMP);

#print"3\n";

##############################################################
#compare base file and current file 
##############################################################
my %results;
my %current;
open (REPORT, ">>$RepDir\\err_report.txt") or die "Cannot open $RepDir\\err_report.txt for writing: $!\n";

if (-e "$BaseDir\\BaseEvent.txt")
{
   open (FH_BASE, "$BaseDir\\BaseEvent.txt") or die "Could not open $BaseDir\\BaseEvent.txt file: $! \n";
   while(my $line = <FH_BASE>)
   {
      chomp($line);
      $results{$line}=1;
   }
   close(FH_BASE);

   open (FH_CURR, "$ChkDir\\CurrEvent.txt") or die "Could not open $ChkDir\\CurrEvent.txt file: $!\n";
   while(my $line = <FH_CURR>) 
   {
      chomp($line);
      $results{$line}++;
      $current{$line}=1;
   }
   close(FH_CURR);


   foreach my $key (keys %results)
   {
      my $value = $results{$key};
      if ($value == 1)
      {
         if (exists($current{$key}))
	     {
	        print REPORT "$key\n";
	     }
      }
   }   

   cp ("$ChkDir\\CurrEvent.txt","$BaseDir\\BaseEvent.txt");
   
}
else 
{
   #print"5\n";
   
   cp ("$ChkDir\\CurrEvent.txt","$RepDir\\err_report.txt");
   cp ("$ChkDir\\CurrEvent.txt","$BaseDir\\BaseEvent.txt");

}

##############################################################
## Heart beat Check every 00, 10, 20, 30, 40, 50 minute
##############################################################
$ChkTime =~ /^.+\-\d+.?(\d+)/;
my $min = $1;
my $quoter = $min % 10;

if ($quoter == 0)
{
   print REPORT ";$ChkTime;;;;OK;;;;\n";
}


close(REPORT);

##############################################################
## Insert Event Message To StorageEvent Table
##############################################################
#`db2cmd.exe -c db2 -tvf C:\\Perl\\Storage\\script\\AutoInsert.sql`;


sub GetTime{
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

sub TranslateTime{
##############################################################
## received: 5/8/14 3:07:11 PM
## return: 2014-05-08-15.07.11
##############################################################
   my $RawTime = $_[0];
   $RawTime =~ /(\d+)?\/(\d+)?\/(\d+)?\s+(\d+):(\d+):(\d+)\s+(\w+)/;
   my ($mon,$day,$year,$hour,$min,$sec,$format) = ($1,$2,$3,$4,$5,$6,$7);
   $year = '20'.$year;
   if (length ($mon) == 1) {$mon = '0'.$mon;}
   if (length ($day) == 1) {$day = '0'.$day;}
   if ($format eq "PM") {$hour+=12;}  
   if (length ($hour) == 1) {$hour = '0'.$hour;} 
   my $time="$year\-$mon\-$day\-$hour\.$min\.$sec";
   return($time); 
}

sub TranslateSign{
##############################################################
## receved: "DS3512-A1","2014-05-08-15.07.11"
## return: "DS3512-A1";"2014-05-08-15.07.11"
##############################################################
   my $Raw = $_[0];
   $Raw =~ s/","/";"/g;
   $Raw =~ s/"//g;
   #print"4\n";
   return($Raw);   
}