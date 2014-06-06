#!/usr/bin/perl

open (File,"$ARGV[0]") or die "open file error\n";

while (<File>){

	chomp $_ ;
#              $1     $2    $3    $4    $5    $6    7     8      9    10   11     12      13
       if (/(^.+?),(.+?),(.+?),(.+?),(.+?),(.+?),(.+?),(.+?),(.+?),(.+?),(.+?),"(.+?)","(.+)"/) {
	   print "###########################Start################################\n";
	   print "lpar_name: $1\n";
	   print "Min_mem: $2\n";
	   print "Desired_men: $3\n";
	   print "Max_men: $4\n";
	   print "Proc_mode: $5\n";
	   print "Min_proc_unit: $6\n";
	   print "Desired_proc_unit: $7\n";
	   print "Max_proc_units: $8\n";
	   print "Min_procs_VP: $9\n";
	   print  "Desired_procs_VP: $10\n";
	   print  "Max_procs_VP: $11\n";

	   @list=split(/,/,$12);
	   foreach (@list) {
           print "Virtual_eth_adapters: $_\n";
	   }

	   @list=split(/,/,$13);
	   foreach (@list) {
	      print  "Virtual_fc_adapters: $_\n";
	   }


	   print  "###########################END##################################\n";
	   print  "\n\n";
	  }	
	
}	
close File;
