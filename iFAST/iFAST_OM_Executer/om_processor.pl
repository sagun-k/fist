#!/usr/bin/perl

#use strict;
#use warnings;
#use Text::CSV;

BEGIN {
use File::Spec::Functions qw(rel2abs);
use File::Basename qw(dirname basename);
my  $fullPath       = rel2abs($0);
our $installDir     = dirname($fullPath);
our $basename       = basename($fullPath);
}
use Data::Dumper;

my $siteLists=shift;
#my @omfiles=shift;
my $om_file=shift;
my $cmd_cnf_path=shift; chomp $cmd_cnf_path;
# my $om_counter_mapping=shift; chomp $om_counter_mapping;
my $dateTime=shift;chomp $dateTime;
my $scriptLog=shift;chomp $scriptLog;
my $cst_prev_Hour=shift;chomp $cst_prev_Hour;
my $COUNTERINFO=shift;chomp $COUNTERINFO;

my @siteList=split(',',$siteLists);

#C:\Users\p.venkata\Downloads\New_query_2024_08_11

#print "processing OM files\n";
#print "@siteList\n";
#print "$om_file\n";
#print "cmd_cnf_path=$cmd_cnf_path\n";
#print "counterMapping=$om_counter_mapping\n";
#print "dateTime=$dateTime\n";
#print "scriptLog=$scriptLog\n";

#Commands Conf
#RachPreambleAPerBeam+RachPreambleACFRAPerBeam,=,0
#NumMSG3PerBeam+NumMSG3CFRAPerBeam,=,0
#CauseInternalRandomAccessProblem,!=,0
#All true/Any true


    if (-e "$om_file"){
    #if (-e "Logs/NR_PRACH_BEAM_pidXXX_06-02-2024_161230.csv"){
        open (OM, "<$om_file");
        #open (NRPRACH, "<Logs/NR_PRACH_BEAM_pidXXX_06-02-2024_161230.csv");
        while(<OM>) {
            if ($_ !~ /VZ_/ ) { next; }
            my($hour,$gNB_ID,$NE_ID,$cell_id,$S5NR_DLMACLayerDataVolume_MB,$S5NR_ULMACLayerDataVolume_MB,$S5NR_ULMACcellAggregateTput_Mbps_Num,$S5NR_DLTTIUtilization_Pct_Num) = (split(',', $_))[2,3,4,5,22,23,37,39];
            # if ($enb_id_noDup eq "$given_NE"){
		#print "$NE_ID\n";
                # my ($cell_id,$locId) = (split('/',$cellLocation))[0,1];
                my($loc_code,$NE_ID) = (split('_', $NE_ID))[0,1];
                # my($NE_ID, $loc_id) = (split('_', $NE_NAME))[0,1];
                # my ($first_num_D) = $cell_id =~ /(\d+)/;#for cbrs
                 if(($hour == $cst_prev_Hour) && ( grep( /^$NE_ID$/, @siteList) )){
			#print "inside\n";
                    $status_hash_noDup{$NE_ID}{$cell_id}{S5NR_DLMACLayerDataVolume_MB} += $S5NR_DLMACLayerDataVolume_MB;
                    $status_hash_noDup{$NE_ID}{$cell_id}{S5NR_ULMACLayerDataVolume_MB} += $S5NR_ULMACLayerDataVolume_MB;
                    $status_hash_noDup{$NE_ID}{$cell_id}{S5NR_ULMACcellAggregateTput_Mbps_Num} += $S5NR_ULMACcellAggregateTput_Mbps_Num;
                    $status_hash_noDup{$NE_ID}{$cell_id}{S5NR_DLTTIUtilization_Pct_Num} += $S5NR_DLTTIUtilization_Pct_Num;
                 }
            # }
        }
        close(OM);
    }
    #print Dumper \%status_hash_noDup;

    open (CANDIDATES, ">>$installDir/Logs/$dateTime\_execution.csv") or die "Can't open file : $installDir/Logs/$dateTime\_execution.csv\n";
    open (LOG, ">>$scriptLog") or die "Can't open file : $scriptLog\n";
    print (CANDIDATES "NE_ID,CELL_ID,STATUS\n");
    print (LOG Dumper( \%status_hash_noDup));
    print (LOG "NE_ID,CELL_ID,CONDITION,PROCESSED_VALUE,OPERATOR,COMPARE_VALUE\n");

    #formulas
    foreach my $NE_ID (keys %status_hash_noDup) {
        #print "$NE_ID\n";
        my $status="FAIL";
        my @boolArr=();
        foreach my $cell_id ( keys %{$status_hash_noDup{$NE_ID}}) {
            #print "$cell_id\n";
            open (FILE_D, "<$cmd_cnf_path");
            while(<FILE_D>) {
                chomp;
                if ($_ =~ /^#/) { next; }
                my($condLine, $operator, $value) = (split(',', $_))[0,1,2];
                chomp $condLine;
                chomp $operator;
                chomp $value;
                my @cond_arr = split /[\+\-\*\s\/]+/, $condLine;
                if((index($condLine,"+")!= -1)&& (scalar(@cond_arr)==2)){
                    # $cond=$cond_arr[0]+$cond_arr[1];
                    $cond=($status_hash_noDup{$NE_ID}{$cell_id}{$cond_arr[0]} + $status_hash_noDup{$NE_ID}{$cell_id}{$cond_arr[1]});
                }elsif((index($condLine,"-")!= -1)&& (scalar(@cond_arr)==2)){
                    # $cond=$cond_arr[0]-$cond_arr[1];
                    $cond=($status_hash_noDup{$NE_ID}{$cell_id}{$cond_arr[0]} - $status_hash_noDup{$NE_ID}{$cell_id}{$cond_arr[1]});
                }
                if((scalar(@cond_arr)==1)){
                    $cond=$status_hash_noDup{$NE_ID}{$cell_id}{$cond_arr[0]};
                }

                #only 1 operand?
                #print "NE_ID=$NE_ID,cell_id=$cell_id,condLine=$condLine,processedValue=$cond,operator=$operator,CompareValue=$value\n";
                print (LOG "$NE_ID,$cell_id,$condLine,$cond,$operator,$value\n");
                if($operator eq "="){
                    if($cond == $value){
                        push(@boolArr,1);
                        #print "pass\n";
                        $status="PASS";
                    }else{
                        push(@boolArr,0);
                        #print "fail\n";
                        $status="FAIL";
                    }
                }
                if($operator eq ">"){
                    if($cond > $value){
                        push(@boolArr,1);
                        #print "pass\n";
                        $status="PASS";
                    }else{
                        push(@boolArr,0);
                        #print "fail\n";
                        $status="FAIL";
                    }
                }
                if($operator eq "<"){
                    if($cond < $value){
                        push(@boolArr,1);
                        #print "pass\n";
                        $status="PASS";
                    }else{
                        push(@boolArr,0);
                        #print "fail\n";
                        $status="FAIL";
                    }
                }
                if(($operator eq "!=")&&($value ne "")){

                    if(($cond != $value)){
                        push(@boolArr,1);
                        #print "pass\n";
                        $status="PASS";
                    #}
                    #elsif(($value eq "")&&($cond ne $value)){
                    #    push(@boolArr,1);
                        #print "pass\n";
                    #    $status="PASS";
                    }else{
                        push(@boolArr,0);
                        #print "fail\n";
                        $status="FAIL";
                    }
                }

            }
            close(FILE_D);
            if (@boolArr == grep { $_ eq "1" } @boolArr) {
                # all equal
                #print "$NE_ID,$cell_id,PASS\n";
                print (CANDIDATES "$NE_ID,$cell_id,PASS\n");
                # print (VALIDATION "$NE_ID,$status\n");
            }else{
                #print (FAILS "$NE_ID,$cell_id,FAIL\n");
                #print "Condition not matched for $NE_ID,$cell_id\n";
            }
        }
    }
close(CANDIDATES);
#print "fileAb=$installDir/Logs/$dateTime\_execution.csv\n";
#print "file=$installDir/Logs/$dateTime\_execution.csv\n";
open(FH, "<", "$installDir/Logs/$dateTime\_execution.csv");

my $count = 0;

while (<FH>) {
  $count = $.;
}

#print "count=$count\n";


if($count > 1){
    print "\nMatches Found\nOutput_file: $installDir/Logs/$dateTime\_execution.csv\n";
}else{
    print (CANDIDATES "There were no matches found\n");
    print "No matches Found\n";
}
close FH;

#print "Script log can be found at $scriptLog\n";
