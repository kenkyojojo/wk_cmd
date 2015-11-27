#!/usr/bin/perl
##########################################
# instead rm to erm
#
# Date:2015-03-18 by TDCC SE     Ver:1.0
##########################################
use strict;

my @array = @ARGV;
my @files;
my %relation;

my $logdir = '/tmp';
my $dir_1 = `pwd`;
chomp($dir_1);


if ( -e "$logdir/del_file.lst" )
{
   unlink "$logdir/del_file.lst" or warn "Could not unlink file: $!";
}

#----------------------------------------------------#
# Filter The file name
#----------------------------------------------------#
my $count = '1';
foreach my $file_1 (@array)
{
   next if ($file_1 eq '*' );		#exclude file name is given *
   next if ($file_1 eq '*.*' );		#exclude file name is given *.*

   #-----------------------------
   # input include directory. ex: /dir/file
   #-----------------------------
   if ( $file_1 =~ /(^.+\/*)?\/(.+)/ )
   {
      my $dir_2 = $1;
      my $file_2 = $2;
      print"\$file_2->$file_2\n";
      
      next if ( $file_2 eq '*' );	#exclude file name is given /dir/*
      next if ( $file_2 eq '*.*' );	#exclude file name is given /dir/*

      my @result_2 = &check_file_exist("$dir_2", "$file_2");

      foreach (@result_2)
      {
         $relation{$count} = "$_";
         $count++;
      }
   } 
   #-----------------------------
   # input NOT include directory. ex: file
   #-----------------------------
   else
   {
      print"\$file_1->$file_1\n";
      
      my @result_1 = &check_file_exist("$dir_1", "$file_1");
      
      foreach (@result_1)
      {
         $relation{$count} = "$_";
         $count++;
      }

   }
}

#----------------------------------------------------#
# Uniq The files
#----------------------------------------------------#
my @tmp;
while (my($key, $value) = each %relation)
{
   push(@tmp, $value);
}
my @uniq = do { my %tmp; grep { !$tmp{$_}++ } @tmp };

open(LOG, ">>$logdir/del_file.lst") || die "Error in opening file \n";
foreach (@uniq)
{
   print LOG "$_\n";
}
close(LOG);

#----------------------------------------------------#
# Delete Report
#----------------------------------------------------#
my $num;
my $line;
$= = 50;

format =
  @>>>    @<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  $num,   $line,          
.

format STDOUT_TOP =
  @||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| 
  "---------------------------------------------------------------------------------------" 
  @||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||  Page @<
  "Delete File List",        $%

  number  property        owner    group          size modify time   file name       
  ------  -------------------------------------------------------------------------------
.

open(FILE, "$logdir/del_file.lst") || die "Error in opening file \n";
my @file = <FILE>;
close(FILE);

my $i = '1';
foreach (@file) {
   chomp;
   if (length ($i) == 1) {$i = '0'.$i;}

   my $file = `ls -l $_`;
   next if ( $file =~ /^total/ );     #exclude file name is ^total
 
   ($num, $line) = ($i, $file);
   $i++;
   write();
}

#----------------------------------------------------#
# Delete File
#----------------------------------------------------#
MENU:

my $length = @file;
if ( $length eq '0')
{
   print"The Delete Pattern was not found!!\n";
   exit 0;
}

print "\n\n";
print "        Are Your Sure You Want to Do This? (Y/N):";
my $input = <STDIN>;
chomp($input);

while (1) 
{
   if (( $input eq "Y" ) or ( $input eq "y" )) 
   {
      &del_file(@file);
      exit 0;
   } 
   elsif (( $input eq "N" ) or ( $input eq "n" )) 
   {
      exit 0;
   } 
   else 
   {
      print "-" x 50, "\n";
      print "[Error] Input Format Error!! Please Input 'Y' or 'N'\n";
      print "-" x 50, "\n";
      goto MENU;
   }

}


#----------------------------------------------------#
# Sub1 check_file_exist: Check file exist or not
# recieve:
#    $dir = /dir
#    $file = *.conf
# return:
#    /dir/a.conf /dir/b.conf /dir/c.conf
#----------------------------------------------------#
sub check_file_exist
{
   my ($dir, $file) = @_;
   my @real_files;
   my @tmp_files = glob("$dir/$file");

   foreach (@tmp_files)
   {
      if ( -e $_ )
      {
         push(@real_files, $_);
      }
      else
      {
         print"sub:[NOT Exist] $_\n";
      }
   }
   return(@real_files);
}

#----------------------------------------------------#
# Sub2 del_file: delete file(s)
# recieve:
#    @real_files = /dir/file1 /dir/file2 ... /dir/fileN
# return:
#    1
#----------------------------------------------------#
sub del_file
{
   my @real_files = @_;
   foreach (@real_files)
   {
      #print"$_\n";
      unlink $_ or warn "Could not unlink $_: $!";
   }   
   return(1);
}
