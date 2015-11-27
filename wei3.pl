#!/usr/bin/perl
 
# ------------------------------------------------------------
# fixnag.pl
# ------------------------------------------------------------
# a script to take nagios.log records as input, and then
# output them with the date field converted to something
# human-readable
# ------------------------------------------------------------
 
sub epochtime
{
	my $epoch_time = shift;
	($sec,$min,$hour,$day,$month,$year) = localtime($epoch_time);
		 
	# correct the date and month for humans
	$year = 1900 + $year;
	$month++;
				 
	return sprintf("%02d/%02d/%02d %02d:%02d:%02d", $year, $month, $day, $hour, $min, $sec);
}
 
while (<>)
{
		my $epoch = substr $_, 1, 10;
		my $remainder = substr $_, 13;
		my $human_date = &epochtime($epoch);
		printf("[%s] %s", $human_date, $remainder);
}
 
exit;
