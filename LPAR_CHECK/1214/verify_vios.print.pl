#!/usr/bin/perl

#VIOS1,4096,8192,16384,shared,0.6,1.0,2.0,1,2,4,"901/0/2//1/0/ETHERNET0//all/none,902/0/12//2/0/ETHERNET0//all/none,903/0/4//1/0/ETHERNET0//all/none,904/0/5//1/0/ETHERNET0//all/none,905/0/6//1/0/ETHERNET0//all/none,906/0/101//1/0/ETHERNET0//all/none,907/0/111//2/0/ETHERNET0//all/none,908/0/1002//0/0/ETHERNET0//all/none,909/0/1012//0/0/ETHERNET0//all/none,910/0/1004//0/0/ETHERNET0//all/none,911/0/1005//0/0/ETHERNET0//all/none,912/0/1006//0/0/ETHERNET0//all/none,913/0/1101//0/0/ETHERNET0//all/none,914/0/1111//0/0/ETHERNET0//all/none","2/server/3/MDS1/6//1,3/server/4/MDS2/6//1,4/server/5/LOG1/7//1,5/server/6/LOG2/7//1,6/server/7/DAR1-1/6//1,7/server/8/DAR1-2/6//1,8/server/9/DAR1-3/6//1,9/server/10/DAR1-4/6//1,10/server/11/DAR2-1/6//1,11/server/12/DAR2-2/6//1,12/server/13/DAR2-3/6//1,13/server/14/DAR2-4/6//1,14/server/15/DAP1-1/6//1,15/server/16/DAP1-2/6//1,16/server/17/DAP1-3/6//1,17/server/18/DAP1-4/6//1,18/server/19/DAP1-5/6//1,19/server/20/DAP1-6/6//1,20/server/21/DAP1-7/6//1,21/server/22/DAP1-8/6//1,22/server/23/DAP1-9/6//1,23/server/24/DAP1-10/6//1,24/server/25/DAP1-11/6//1,25/server/26/DAP1-12/6//1,26/server/27/DAP1-13/6//1,27/server/28/DAP1-14/6//1,28/server/29/DAP1-15/6//1,29/server/30/DAP1-16/6//1,30/server/31/DAP1-17/6//1,31/server/32/DAP1-18/6//1,32/server/33/DAP1-19/6//1,33/server/34/DAP1-20/6//1,34/server/35/DAP1-21/6//1,35/server/36/DAP1-22/6//1,36/server/37/DAP1-23/6//1,37/server/38/DAP1-24/6//1,38/server/39/DAP1-25/6//1,39/server/40/DAP1-26/6//1,40/server/41/DAP1-27/6//1,41/server/42/DAP1-28/6//1,42/server/43/DAP1-29/6//1,43/server/44/DAP1-30/6//1,44/server/45/DAP1-31/6//1,45/server/46/DAP1-32/6//1,46/server/47/DAP1-33/6//1,47/server/48/DAP1-34/6//1,48/server/49/DAP1-35/6//1,49/server/50/DAP1-36/6//1,50/server/51/DAP1-37/6//1,51/server/52/DAP1-38/6//1,52/server/53/DAP1-39/6//1,53/server/54/DAP1-40/6//1,54/server/55/DAP2-1/6//1,55/server/56/DAP2-2/6//1,56/server/57/DAP2-3/6//1,57/server/58/DAP2-4/6//1,58/server/59/DAP2-5/6//1,59/server/60/DAP2-6/6//1,60/server/61/DAP2-7/6//1,61/server/62/DAP2-8/6//1,62/server/63/DAP2-9/6//1,63/server/64/DAP2-10/6//1,64/server/65/DAP2-11/6//1,65/server/66/DAP2-12/6//1,66/server/67/DAP2-13/6//1,67/server/68/DAP2-14/6//1,68/server/69/DAP2-15/6//1,69/server/70/DAP2-16/6//1,70/server/71/DAP2-17/6//1,71/server/72/DAP2-18/6//1,72/server/73/DAP2-19/6//1,73/server/74/DAP2-20/6//1,74/server/75/DAP2-21/6//1,75/server/76/DAP2-22/6//1,76/server/77/DAP2-23/6//1,77/server/78/DAP2-24/6//1,78/server/79/DAP2-25/6//1,79/server/80/DAP2-26/6//1,80/server/81/DAP2-27/6//1,81/server/82/DAP2-28/6//1,82/server/83/DAP2-29/6//1,83/server/84/DAP2-30/6//1,84/server/85/DAP2-31/6//1,85/server/86/DAP2-32/6//1,86/server/87/DAP2-33/6//1,87/server/88/DAP2-34/6//1,88/server/89/DAP2-35/6//1,89/server/90/DAP2-36/6//1,90/server/91/DAP2-37/6//1,91/server/92/DAP2-38/6//1,92/server/93/DAP2-39/6//1,93/server/94/DAP2-40/6//1,94/server/95/NIM_SERVER/4//1,95/server/96/WORKING_LPAR/4//1"
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
