#!/usr/bin/perl
$SITE="TSEOT1";
$HOST=substr($HOSTNAME,0,3);
chomp ($num=`ps -ef | wc -l`);
chomp ($HOSTNAME=`hostname | cut -c1-3`);

print "$num","\n";
print "$HOST","\n";
print "$HOSTNAME","\n";
print "$SITE","\n";
exit 1;
#$LOG="wei.pl.log";

sub tlog () {
  ($MSG,$LOG) = @_;
  chomp ($dt=`date +"%y/%m/%d %H:%M:%S"`);
  open (LOG, ">>$LOG") or die "Cannot open $LOG for writing \n";
  print LOG "$SITE [$dt] $MSG","\n";
#  printf LOG "%s [%s] %s\n",$SITE,$dt,$MSG;
  close (LOG);
}

&tlog("Pppppp222222222222222222222222222222222","wei.pppp.log");

#sub main () {
#	print "$0n";
#	return 1;
#}
#
#&main && print "0\n" || print "1\n";
