#!/usr/bin/perl

for (0..10){
	   my $buf = "A" x (1024 * 1024 * 10);
	      print "Allocated " . length($buf) . " byte buffer\n";
}
print "Finished\n";
sleep(1000);
