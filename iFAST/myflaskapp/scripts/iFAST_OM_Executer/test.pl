#!/usr/bin/perl

#use strict;
#use warnings;

BEGIN {
use File::Spec::Functions qw(rel2abs);
use File::Basename qw(dirname basename);
my  $fullPath       = rel2abs($0);
our $installDir     = dirname($fullPath);
our $basename       = basename($fullPath);
}

my $dateTime="21_2_06-05-2024_112529";
print "file=$installDir/Logs/$dateTime\_execution.csv";
open(FH, "<", "$installDir/Logs/$dateTime\_execution.csv");

my $count = 0;

while (<FH>) {
  $count = $.;
}



print "count=$count\n\n";
if($count > 1){
    print "Matches Found\n Output_file: $installDir/Logs/$dateTime\_execution.csv\n";
}else{
    print (CANDIDATES "There were no matches found\n");
    print "No matches Found\n";
}
close FH;
