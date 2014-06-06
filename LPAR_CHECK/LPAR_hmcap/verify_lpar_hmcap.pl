#!/usr/bin/perl
#     1       2         3         4        5          6                 7             8            9             10              11
#lpar_name,min_mem,desired_mem,max_mem,proc_mode,min_proc_units,desired_proc_units,max_proc_units,min_procs,desired_procs,max_procs,\
#       12                    13                   14
#virtual_eth_adapters,virtual_scsi_adapters,virtual_fc_adapters

#DAP1-8,3072,3072,6144,shared,0.25,0.25,1.0,"2/0/2//0/1/ETHERNET0//all/none,4/0/4//0/1/ETHERNET0//all/none,5/0/5//0/1/ETHERNET0//all/none,7/0/7//0/1/ETHERNET0//all/none,8/0/8//0/1/ETHERNET0//all/none,9/0/9//0/1/ETHERNET0//all/none","278/client/2/VIOS2/278/1,78/client/1/VIOS1/78/1",none
#min_procs=1,desired_procs=2,max_procs=4

$hostname="10.199.130.252";
$command = "ssh hscroot\@${hostname} 'lssyscfg  -m `lssyscfg -r sys -F name` -r prof -F lpar_name,min_mem,desired_mem,max_mem,proc_mode,min_proc_units,desired_proc_units,max_proc_units,min_procs,desired_procs,max_procs,virtual_eth_adapters,virtual_fc_adapters ' > lpar_prof.txt";



`$command`;

open (File,"lpar_prof.txt") or "open file error";
open (File2,">sort_lpar_prof_ap.txt") or "open file error";
while (<File>){

	chomp $_ ;
##               $1     $2    $3    $4    $5    $6    7     8     9    10    11     12        13
	     if (/(^.+?),(.+?),(.+?),(.+?),(.+?),(.+?),(.+?),(.+?),(.+?),(.+?),(.+?),"(.+?)","""(.+)"""/) {
###	if (/(^.+?),(.+?),(.+?),(.+?),(.+?),(.+?),(.+?),(.+?),"(.+?)""/) {
	   print File2 "###########################Start################################\n";
	   print File2 "lpar_name: $1\n";
	   print File2 "Min_mem: $2\n";
	   print File2 "Desired_men: $3\n";
	   print File2 "Max_men: $4\n";
	   print File2 "Proc_mode: $5\n";
	   print File2 "Min_proc_unit: $6\n";
	   print File2 "Desired_proc_unit: $7\n";
	   print File2 "Max_proc_units: $8\n";
	   print File2 "Min_procs_VP: $9\n";
	   print File2 "Desired_procs_VP: $10\n";
	   print File2 "Max_procs_VP: $11\n";

	   @list=split(/,/,$12);
	   foreach (@list) {
	      print File2 "Virtual_eth_adapters: $_\n";
	   }

	   @list=split(/"",""/,$13);
	   foreach (@list) {
	      print File2 "Virtual_fc_adapters: $_\n";
	   }

##print File2 "Virtual_scsi_adapters: $10\n\n";
##print File2 "Virtual_fc_adapters: $10\n\n";
#
	   print File2 "###########################END##################################\n";
       print File2 "\n\n";
	  }	
	
}	
close File;
close File2;
##
###$command = "ssh hscroot\@hmc-test 'lssyscfg  -m `lssyscfg -r sys -F name` -r prof -F lpar_name,min_mem,desired_mem,max_mem,proc_mode,min_proc_units,desired_proc_units,max_proc_units,min_procs,desired_procs,max_procs,virtual_eth_adapters,virtual_fc_adapters | grep \^VIOS' > lpar_prof.txt";
###$command = "ssh hscroot\@hmc1-test 'lssyscfg  -m `lssyscfg -r sys -F name` -r prof -F lpar_name,min_mem,desired_mem,max_mem,proc_mode,min_proc_units,desired_proc_units,max_proc_units,min_procs,desired_procs,max_procs,virtual_eth_adapters,virtual_fc_adapters | grep \^VIOS' > lpar_prof.txt";
##
##
##
###`$command`;
##
##
open (File,"lpar_prof_vios.txt") or "open file error";
open (File2,">>sort_lpar_prof.txt") or "open file error";
while (<File>){

	chomp $_ ;
#              $1     $2    $3    $4    $5    $6    7     8      9    10   11     12      13
 	    if (/(^.+?),(.+?),(.+?),(.+?),(.+?),(.+?),(.+?),(.+?),(.+?),(.+?),(.+?),"(.+?)","(.+)"/) {
	   print File2 "###########################Start################################\n";
	   print File2 "lpar_name: $1\n";
	   print File2 "Min_mem: $2\n";
	   print File2 "Desired_men: $3\n";
	   print File2 "Max_men: $4\n";
	   print File2 "Proc_mode: $5\n";
	   print File2 "Min_proc_unit: $6\n";
	   print File2 "Desired_proc_unit: $7\n";
	   print File2 "Max_proc_units: $8\n";
	   print File2 "Min_procs_VP: $9\n";
	   print File2 "Desired_procs_VP: $10\n";
	   print File2 "Max_procs_VP: $11\n";
#
	   @list=split(/,/,$12);
	   foreach (@list) {
	      print File2 "Virtual_eth_adapters: $_\n";
	   }
#
	   @list=split(/,/,$13);
	   foreach (@list) {
	      print File2 "Virtual_fc_adapters: $_\n";
	   }
#
#
	   print File2 "###########################END##################################\n";
	   print File2 "\n\n";
	  }	
	
}	
close File;
close File2;
####`mv sort_lpar_prof.txt lpar_prof.txt`;
