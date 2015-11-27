#!/usr/bin/perl
sub gettime{
#my ($sec, $min, $hour, $day, $mon, $year) = localtime(time);
#$onedayago=@_[0];
$onedayago=@_[0];
	($sec,$min,$hour,$day,$mon,$year)=localtime(time-${onedayago});
	$now_date=join("-",($year+1900,$mon+1,$day));
	$now_time=join(":",($hour,$min,$sec));
	return ($now_date, $now_time);
	return ($sec,$min,$hour,$day,$mon,$year);
}

my ($now_date,$now_time) = &gettime(86400);
print "$now_date $now_time","\n";
my ($now_date,$now_time) = &gettime();
print "$now_date $now_time","\n";
