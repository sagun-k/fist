#!/usr/bin/perl
#use strict;
use warnings;

BEGIN {
use File::Spec::Functions qw(rel2abs);
use File::Basename qw(dirname basename);
my  $fullPath       = rel2abs($0);
our $installDir     = dirname($fullPath);
our $basename       = basename($fullPath);
}

#chdir $installDir;
#use lib $installDir;
use Data::Dumper;

print "installDir=$installDir\n";

#NEType, NE_ID
my $lteOrNr = shift; chomp $lteOrNr;
my $given_NE = shift; chomp $given_NE;

#date timestamp from bash
my $dateTimeKpi = shift; chomp $dateTimeKpi;
my $TempPath = shift; chomp $TempPath;
my $TempPathDays = shift; chomp $TempPathDays;
my $cstPrevHour = shift; chomp $cstPrevHour;
my $given_gNBId = shift; chomp $given_gNBId;
my $given_AUID = shift; chomp $given_AUID;

#4G files
my $rrcConnEstMsgFile = shift; chomp $rrcConnEstMsgFile;#RRC_conn_est_msg.csv
my $s1ContSetupFile = shift; chomp $s1ContSetupFile;#s1_cont_setup.csv
my $rlfDetectNumpercell = shift; chomp $rlfDetectNumpercell;#rlf_detect_numpercell.csv
my $rrcEstFile = shift; chomp $rrcEstFile;#rrc_conn_est.csv
my $contRelMmeEnbCell = shift; chomp $contRelMmeEnbCell;#cont_rel_mmeEnbCell.csv
my $rrcNumberFIle = shift; chomp $rrcNumberFIle;#rrc_conn_num.csv
my $airrlcpk = shift; chomp $airrlcpk;#air_rlc_pk.csv
my $airMacPacket4gFIle = shift; chomp $airMacPacket4gFIle;#air_mac_pk.csv
my $dlHarqTransBler = shift; chomp $dlHarqTransBler;#dl_harq_transBler.csv
my $dlHarqTransBler256 = shift; chomp $dlHarqTransBler256;#dl_harq_transBler_256.csv
my $ulHarqTransBler = shift; chomp $ulHarqTransBler;#ul_harq_transBler.csv
my $x2OutHoWoFail = shift; chomp $x2OutHoWoFail;#x2_outHo_woFail.csv

#ENDC files
my $endc_addInfo = shift; chomp $endc_addInfo;#endc_addInfo.csv
my $endc_relInfo = shift; chomp $endc_relInfo;#endc_relInfo.csv
my $endc_capUE = shift; chomp $endc_capUE;#endc_capUE.csv

#4G additional kpi's
my $cellAvailability = shift; chomp $cellAvailability;#cellAvailability.csv
my $packetLossRate = shift; chomp $packetLossRate;#packetLossRate.csv
my $emtcRrcConnEst = shift; chomp $emtcRrcConnEst;#emtcRrcConnEst.csv
my $emtcCallDrop = shift; chomp $emtcCallDrop;#emtcCallDrop.csv
my $emtcUeS1ConnEst = shift; chomp $emtcUeS1ConnEst;#emtcUeS1ConnEst.csv
my $nbiotRrcConnEst = shift; chomp $nbiotRrcConnEst;#nbiotRrcConnEst.csv
my $nbiotCallDrop = shift; chomp $nbiotCallDrop;#nbiotCallDrop.csv
my $nbiotUeS1ConnEst = shift; chomp $nbiotUeS1ConnEst;#x2_outHo_woFail.csv

#5G files
my $SgNBAddition_5gFile = shift; chomp $SgNBAddition_5gFile; #SgNBAddition_perDU_pergNB_5g.csv
my $cucpCslHexa_5gFile = shift; chomp $cucpCslHexa_5gFile;#cucpCslHexa_5g.csv
my $intraSnPscell_5gFile = shift; chomp $intraSnPscell_5gFile;#intraSnPscell_5g.csv
my $interSnPcell_5gFile = shift; chomp $interSnPcell_5gFile;#interSnPcell_5g.csv
my $air_macpk_5gFile = shift; chomp $air_macpk_5gFile;#air_mcsvacpk_5g.csv
my $dl_ueThroughput_5gFile = shift; chomp $dl_ueThroughput_5gFile;#dl_ueThroughput_5g.csv
my $ul_UeThroughput_5gFile = shift; chomp $ul_UeThroughput_5gFile;#ul_UeThroughput_5g.csv
my $dl_harq_transBler_5gFile = shift; chomp $dl_harq_transBler_5gFile;#dl_harq_transBler_5g.csv
my $ul_harq_transBler_5gFile = shift; chomp $ul_harq_transBler_5gFile;#ul_harq_transBler_5g.csv
my $prach_nrBeam_5gFile = shift; chomp $prach_nrBeam_5gFile;#prach_nrBeam_5g.csv
my $prach_nr_5gFile = shift; chomp $prach_nr_5gFile;#prach_nr_5g.csv
my $cellUnavailableTime_5gFile = shift; chomp $cellUnavailableTime_5gFile;#cellUnavailableTime_5g.csv
my $ue_connNumPerGnb_5gFile = shift; chomp $ue_connNumPerGnb_5gFile; #ue_connNumPerGnb_5g.csv
my $kpiListFile = "$installDir/Conf/kpi_list.conf";

my @dateCst=split('_',$dateTimeKpi);
print "$dateCst[0]\n";

#thresholds/avg
my $rrcThresh=`grep "RRC_Connection_Establishment_Message" $kpiListFile | cut -d"," -f3 | grep -v "#"`; chomp $rrcThresh;
my $s1ContThresh=`grep -r 'S1_Context_Setup' $kpiListFile | cut -d"," -f3 | grep -v "#"`; chomp $s1ContThresh;
my $rlfDetThresh=`grep 'RLF_Detection_Number_per_Cell' $kpiListFile | cut -d"," -f3 | grep -v "#"`;chomp $rlfDetThresh;
my $contRelThresh=`grep 'Context_Release_by_MME_and_eNB_per_cell' $kpiListFile | cut -d"," -f3 | grep -v "#"`; chomp $contRelThresh;
my $rrcNumThresh=`grep 'RRC_Connection_Number' $kpiListFile | cut -d"," -f3 | grep -v "#"`; chomp $rrcNumThresh;
my $airRLCThresh=`grep 'Air_RLC_Packet' $kpiListFile | cut -d"," -f3 | grep -v "#"`; chomp $airRLCThresh;
my $airMac4gThresh=`grep 'AirMAC_Packet' $kpiListFile | cut -d"," -f3 | grep -v "#"`; chomp $airMac4gThresh;
my $DLHarqThresh=`grep 'DownlinkHARQ_Transmission_BLER' $kpiListFile | cut -d"," -f3 | grep -v "#"`; chomp $DLHarqThresh;
my $DLHarq256Thresh=`grep 'Downlink_HARQ_Transmission_BLER_in_256_QAM_Support' $kpiListFile | cut -d"," -f3 | grep -v "#"`; chomp $DLHarq256Thresh;
my $ULHarqThresh=`grep 'Uplink_HARQ_Transmission_BLER' $kpiListFile | cut -d"," -f3 | grep -v "#"`; chomp $ULHarqThresh;
my $x2HoThresh=`grep 'X2_Out_Handover' $kpiListFile | cut -d"," -f3 | grep -v "#"`; chomp $x2HoThresh;
my $CellAvailabilityThresh=`grep 'Cell_Availability' $kpiListFile | cut -d"," -f3 | grep -v "#"`; chomp $CellAvailabilityThresh;
my $packetLossThresh=`grep 'VOLTE_UL_PDCP_Packet_Loss_Rate' $kpiListFile | cut -d"," -f3 | grep -v "#"`; chomp $packetLossThresh;
my $emtcRRCThresh=`grep 'EMTC_RRC_Setup_Failure' $kpiListFile | cut -d"," -f3 | grep -v "#"`; chomp $emtcRRCThresh;
my $emtcContDropThresh=`grep 'EMTC_Context_Drop_Rate' $kpiListFile | cut -d"," -f3 | grep -v "#"`; chomp $emtcContDropThresh;
my $nbiotRrcSetupThresh=`grep 'NBIOT_RRC_Setup_Failure' $kpiListFile | cut -d"," -f3 | grep -v "#"`; chomp $nbiotRrcSetupThresh;
my $nbiotContDropThresh=`grep 'NBIOT_Context_Drop_Rate' $kpiListFile | cut -d"," -f3 | grep -v "#"`; chomp $nbiotContDropThresh;
my $endcAddThresh=`grep 'EN-DC_Addition_Information' $kpiListFile | cut -d"," -f3 | grep -v "#"`;chomp $endcAddThresh;
my $endcRelThresh=`grep 'EN-DC_Release_Information' $kpiListFile | cut -d"," -f3 | grep -v "#"`;chomp $endcRelThresh;
my $endcCapThresh=`grep 'RRC_Connection_Release_of_EN-DC_Capable_UE' $kpiListFile | cut -d"," -f3 | grep -v "#"`; chomp $endcCapThresh;
my $sgNBAdd5gThresh=`grep 'SgNB_Addition_per_gNB' $kpiListFile | cut -d"," -f3 | grep -v "#"`; chomp $sgNBAdd5gThresh;
my $cucp5gThresh=`grep 'CU_CP_CSL_Hexa_per_gNB' $kpiListFile | cut -d"," -f3 | grep -v "#"`; chomp $cucp5gThresh;
my $intra5gThresh=`grep 'Intra_SN_Pscell_Change_per_gNB' $kpiListFile | cut -d"," -f3 | grep -v "#"`; chomp $intra5gThresh;
my $inter5gThresh=`grep 'Inter_SN_Pscell_Change_per_gNB' $kpiListFile | cut -d"," -f3 | grep -v "#"`; chomp $inter5gThresh;
my $airMac5gThresh=`grep 'NR_Air_MAC_Packet' $kpiListFile | cut -d"," -f3 | grep -v "#"`; chomp $airMac5gThresh;
my $dlUeThru5gThresh=`grep 'Downlink_UE_Throughput' $kpiListFile | cut -d"," -f3 | grep -v "#"`; chomp $dlUeThru5gThresh;
my $ulUeThru5gThresh=`grep 'Uplink_UE_Throughput' $kpiListFile | cut -d"," -f3 | grep -v "#"`; chomp $ulUeThru5gThresh;
my $dlHarq5gThresh=`grep 'DL_HARQ_TRANSMISSION_count_and_BLER' $kpiListFile | cut -d"," -f3 | grep -v "#"`; chomp $dlHarq5gThresh;
my $ulHarq5gThresh=`grep 'UL_HARQ_TRANSMISSION_count_and_BLER' $kpiListFile | cut -d"," -f3 | grep -v "#"`; chomp $ulHarq5gThresh;
my $prachBeam5gThresh=`grep 'Physical_Random_Access_Channel_in_NR_for_beam' $kpiListFile | cut -d"," -f3 | grep -v "#"`; chomp $prachBeam5gThresh;
my $prachNr5gThresh=`grep 'Physical_Random_Access_Channel_in_NR' $kpiListFile | cut -d"," -f3 | grep -v "#"`; chomp $prachNr5gThresh;
my $cellUnavail5gThresh=`grep 'NR_Cell_Unavailable_Time' $kpiListFile | cut -d"," -f3 | grep -v "#"`; chomp $cellUnavail5gThresh;
my $ueConn5gThresh=`grep 'UE_Connection_Number_per_gNB_DU' $kpiListFile | cut -d"," -f3 | grep -v "#"`; chomp $ueConn5gThresh;


my($type, $ID) = (split('_', $given_NE))[0,1];
$type=$type."_";
print "$type\n";
print "$lteOrNr\n";

my $du_id=$given_AUID;
print "du_id=$du_id\n";
#Check NE Type 4G or 5G
if ($lteOrNr eq "LTE"){
	print "inside 4g";
	kpi_calc_4G();
	kpi_calc_noDup_4G();
}
if($lteOrNr eq "NR"){
	print "inside 5g";
	# airPack_5g();
	# rach_thruput();
	EndcDrop_5g();
	Sgnb_5g();
	interIntra();
}

sub kpi_calc_noDup_4G {
	#Context Setup Failure
	if (-e "$TempPath/$s1ContSetupFile"){
		open (S1CONTSETUP, "<$TempPath/$s1ContSetupFile");
		while(<S1CONTSETUP>) {
			if ($_ !~ /^eNB/ ) { next; }
			my($enb_id_noDup, $cellLocation, $conn_rxSetupRequest, $conn_txSetupFail, $conn_s1SetupFail) = (split(',', $_))[0,6,7,9,10];
			if ($enb_id_noDup eq "$given_NE"){
				my $cell_id_noDup = $cellLocation;#has no duplicate cellId's
				my ($first_num) = $cell_id_noDup =~ /(\d+)/;#for cbrs
				if($first_num < 100){
					$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{conn_rxSetupRequest} += $conn_rxSetupRequest;
					$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{conn_txSetupFail} += $conn_txSetupFail;
					$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{conn_s1SetupFail} += $conn_s1SetupFail;
				}
			}
		}
		close(S1CONTSETUP);
	}
	if (-e "$TempPathDays/$s1ContSetupFile"){
		open (S1CONTSETUP_D, "<$TempPathDays/$s1ContSetupFile");
		while(<S1CONTSETUP_D>) {
			if ($_ !~ /^eNB/ ) { next; }
			my($enb_id_noDup, $cellLocation_D, $conn_rxSetupRequestD, $conn_txSetupFailD, $conn_s1SetupFailD) = (split(',', $_))[0,6,7,9,10];
			if ($enb_id_noDup eq "$given_NE"){
				my $cell_id_noDup = $cellLocation_D;#has no duplicate cellId's
				my ($first_num_D) = $cell_id_noDup =~ /(\d+)/;#for cbrs
				if($first_num_D < 100){
					$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{conn_rxSetupRequestD} += $conn_rxSetupRequestD;
					$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{conn_txSetupFailD} += $conn_txSetupFailD;
					$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{conn_s1SetupFailD} += $conn_s1SetupFailD;
				}
			}
		}
		close(S1CONTSETUP_D);
	}

	#RRC ConnectionDropRate #nr
	if (-e "$TempPath/$rlfDetectNumpercell"){
		open (RLFDET, "<$TempPath/$rlfDetectNumpercell");
		while(<RLFDET>) {
			if ($_ !~ /^eNB/ ) { next; }
			my($enb_id_noDup, $cellLocation, $radio_linkFail, $arq_maxReTrans) = (split(',', $_))[0,6,7,8];
			if ($enb_id_noDup eq "$given_NE"){
				my $cell_id_noDup = $cellLocation;#has no duplicate cellId's
				my ($first_num) = $cell_id_noDup =~ /(\d+)/;#for cbrs
				if($first_num < 100){
					$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{radio_linkFail} += $radio_linkFail;
					$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{arq_maxReTrans} += $arq_maxReTrans;
				}
			}
		}
		close(RLFDET);
	}

	if (-e "$TempPathDays/$rlfDetectNumpercell"){
		open (RLFDET_D, "<$TempPathDays/$rlfDetectNumpercell");
		while(<RLFDET_D>) {
			if ($_ !~ /^eNB/ ) { next; }
			my($enb_id_noDup, $cellLocationD, $radio_linkFailD, $arq_maxReTransD) = (split(',', $_))[0,6,7,8];
			if ($enb_id_noDup eq "$given_NE"){
				my $cell_id_noDup = $cellLocationD;#has no duplicate cellId's
				my ($first_num_D) = $cell_id_noDup =~ /(\d+)/;#for cbrs
				if($first_num_D < 100){
					$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{radio_linkFailD} += $radio_linkFailD;
					$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{arq_maxReTransD} += $arq_maxReTransD;
				}
			}
		}
		close(RLFDET_D);
	}

	#RRC ConnectionDropRate #dr
	if (-e "$TempPath/$rrcEstFile"){
		open (RRCEST, "<$TempPath/$rrcEstFile");
		while(<RRCEST>) {
			if ($_ !~ /^eNB/ ) { next; }
			my($enb_id_noDup, $cellLocation, $ConnEstabSucc) = (split(',', $_))[0,6,8];
			if ($enb_id_noDup eq "$given_NE"){
				my($cell_id_noDup, $loc_id) = (split('/', $cellLocation))[0,1];#has duplicate cellId's
				my ($first_num) = $cell_id_noDup =~ /(\d+)/;#for cbrs
				if($first_num < 100){
					$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{ConnEstabSucc} += $ConnEstabSucc;
				}
			}
		}
		close(RRCEST);
	}

	if (-e "$TempPathDays/$rrcEstFile"){
		open (RRCEST_D, "<$TempPathDays/$rrcEstFile");
		while(<RRCEST_D>) {
			if ($_ !~ /^eNB/ ) { next; }
			my($enb_id_noDup, $cellLocationD, $ConnEstabSuccD) = (split(',', $_))[0,6,8];
			if ($enb_id_noDup eq "$given_NE"){
				my($cell_id_noDup, $loc_id) = (split('/', $cellLocationD))[0,1];#has duplicate cellId's
				my ($first_num_D) = $cell_id_noDup =~ /(\d+)/;#for cbrs
				if($first_num_D < 100){
					$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{ConnEstabSuccD} += $ConnEstabSuccD;
				}
			}
		}
		close(RRCEST_D);
	}

	#ContextDropRate
	if (-e "$TempPath/$contRelMmeEnbCell"){
		open (CONTRELMMEENB, "<$TempPath/$contRelMmeEnbCell");
		while(<CONTRELMMEENB>) {
			if ($_ !~ /^eNB/ ) { next; }
			my($enb_id_noDup, $cellLocation, $RelNormalByMme,$RelAbnormalByMme,$RelAbnormalByMmeAct,$RelNormalByEnb,$RelAbnormalByEnb) = (split(',', $_))[0,6,7,9,10,11,13];
			if ($enb_id_noDup eq "$given_NE"){
				my $cell_id_noDup = $cellLocation;#has no duplicate cellId's
				my ($first_num) = $cell_id_noDup =~ /(\d+)/;#for cbrs
				if($first_num < 100){
					$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{RelNormalByMme} += $RelNormalByMme;#h
					$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{RelAbnormalByMme} += $RelAbnormalByMme;#j
					$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{RelAbnormalByMmeAct} += $RelAbnormalByMmeAct;#k
					$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{RelNormalByEnb} += $RelNormalByEnb;#l
					$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{RelAbnormalByEnb} += $RelAbnormalByEnb;#n
				}
			}
		}
		close(CONTRELMMEENB);
	}

	if (-e "$TempPathDays/$contRelMmeEnbCell"){
		open (CONTRELMMEENB_D, "<$TempPathDays/$contRelMmeEnbCell");
		while(<CONTRELMMEENB_D>) {
			if ($_ !~ /^eNB/ ) { next; }
			my($enb_id_noDup, $cellLocationD, $RelNormalByMmeD,$RelAbnormalByMmeD,$RelAbnormalByMmeActD,$RelNormalByEnbD,$RelAbnormalByEnbD) = (split(',', $_))[0,6,7,9,10,11,13];
			if ($enb_id_noDup eq "$given_NE"){
				my $cell_id_noDup = $cellLocationD;#has no duplicate cellId's
				my ($first_num) = $cell_id_noDup =~ /(\d+)/;#for cbrs
				if($first_num < 100){
					$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{RelNormalByMmeD} += $RelNormalByMmeD;#h
					$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{RelAbnormalByMmeD} += $RelAbnormalByMmeD;#j
					$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{RelAbnormalByMmeActD} += $RelAbnormalByMmeActD;#k
					$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{RelNormalByEnbD} += $RelNormalByEnbD;#l
					$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{RelAbnormalByEnbD} += $RelAbnormalByEnbD;#n
				}
			}
		}
		close(CONTRELMMEENB_D);
	}

	#AvgRRCconnectedUserspercell
	if (-e "$TempPath/$rrcNumberFIle"){
		open (RRCCONNUM, "<$TempPath/$rrcNumberFIle");
		while(<RRCCONNUM>) {
			if ($_ !~ /^eNB/ ) { next; }
			my($enb_id_noDup, $cellLocation, $ConnNoTot,$ConnNoCnt) = (split(',', $_))[0,6,9,10];
			if ($enb_id_noDup eq "$given_NE"){
				my $cell_id_noDup = $cellLocation;#has no duplicate cellId's
				my ($first_num) = $cell_id_noDup =~ /(\d+)/;#for cbrs
				if($first_num < 100){
					$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{ConnNoTot} += $ConnNoTot;
					$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{ConnNoCnt} += $ConnNoCnt;
				}
			}
		}
		close(RRCCONNUM);
	}

	if (-e "$TempPathDays/$rrcNumberFIle"){
		open (RRCCONNUM_D, "<$TempPathDays/$rrcNumberFIle");
		while(<RRCCONNUM_D>) {
			if ($_ !~ /^eNB/ ) { next; }
			my($enb_id_noDup, $cellLocationD, $ConnNoTotD,$ConnNoCntD) = (split(',', $_))[0,6,9,10];
			if ($enb_id_noDup eq "$given_NE"){
				my $cell_id_noDup = $cellLocationD;#has no duplicate cellId's
				my ($first_num_D) = $cell_id_noDup =~ /(\d+)/;#for cbrs
				if($first_num_D < 100){
					$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{ConnNoTotD} += $ConnNoTotD;
					$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{ConnNoCntD} += $ConnNoCntD;
				}
			}
		}
		close(RRCCONNUM_D);
	}
	
	#UL UPT,DL MAC Volume
	if (-e "$TempPath/$airMacPacket4gFIle"){
		open (AIRMACPK, "<$TempPath/$airMacPacket4gFIle");
		while(<AIRMACPK>) {
			if ($_ !~ /^eNB/ ) { next; }
			my($enb_id_noDup, $cellLocation, $AirMacDLByte,$ULIpThruVol,$ULIpThruTime) = (split(',', $_))[0,6,12,23,24];
			if ($enb_id_noDup eq "$given_NE"){
				my $cell_id_noDup = $cellLocation;#has no duplicate cellId's
				my ($first_num) = $cell_id_noDup =~ /(\d+)/;#for cbrs
				if($first_num < 100){
					$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{AirMacDLByte} += $AirMacDLByte;
					$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{ULIpThruVol}  += $ULIpThruVol;
					$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{ULIpThruTime} += $ULIpThruTime;
				}
			}
		}
		close(AIRMACPK);
	}

		if (-e "$TempPathDays/$airMacPacket4gFIle"){
			open (AIRMACPK_D, "<$TempPathDays/$airMacPacket4gFIle");
			while(<AIRMACPK_D>) {
				if ($_ !~ /^eNB/ ) { next; }
				my($enb_id_noDup, $cellLocationD, $AirMacDLByteD,$ULIpThruVolD,$ULIpThruTimeD) = (split(',', $_))[0,6,12,23,24];
				if ($enb_id_noDup eq "$given_NE"){
					my $cell_id_noDup = $cellLocationD;#has no duplicate cellId's
					my ($first_num_D) = $cell_id_noDup =~ /(\d+)/;#for cbrs
					if($first_num_D < 100){
						$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{AirMacDLByteD} += $AirMacDLByteD;
						$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{ULIpThruVolD}  += $ULIpThruVolD;
						$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{ULIpThruTimeD} += $ULIpThruTimeD;
					}
				}
			}
			close(AIRMACPK_D);
        }
        #DL Init BLER,DL Residual BLER
        if (-e "$TempPath/$dlHarqTransBler"){
			open (DLHARQ, "<$TempPath/$dlHarqTransBler");
			while(<DLHARQ>) {
				if ($_ !~ /^eNB/ ) { next; }
				my($enb_id_noDup, $cellLocation, $DLTransmissionRetrans0,$DLTransmissionRetrans1,$DLTransmissionNackedRetrans) = (split(',', $_))[0,6,18,19,25];
				if ($enb_id_noDup eq "$given_NE"){
					my $cell_id_noDup = $cellLocation;#has no duplicate cellId's
					my ($first_num) = $cell_id_noDup =~ /(\d+)/;#for cbrs
					if($first_num < 100){
						$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{DLTransmissionRetrans0} += $DLTransmissionRetrans0;#s
						$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{DLTransmissionRetrans1}  += $DLTransmissionRetrans1;#t
						$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{DLTransmissionNackedRetrans} += $DLTransmissionNackedRetrans;#z
					}
				}
			}
			close(DLHARQ);
        }

        if (-e "$TempPathDays/$dlHarqTransBler"){
			open (DLHARQ_D, "<$TempPathDays/$dlHarqTransBler");
			while(<DLHARQ_D>) {
				if ($_ !~ /^eNB/ ) { next; }
				my($enb_id_noDup, $cellLocationD, $DLTransmissionRetrans0D,$DLTransmissionRetrans1D,$DLTransmissionNackedRetransD) = (split(',', $_))[0,6,18,19,25];
				if ($enb_id_noDup eq "$given_NE"){
					my $cell_id_noDup = $cellLocationD;#has no duplicate cellId's
					my ($first_num_D) = $cell_id_noDup =~ /(\d+)/;#for cbrs
					if($first_num_D < 100){
						$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{DLTransmissionRetrans0D} += $DLTransmissionRetrans0D;#s
						$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{DLTransmissionRetrans1D}  += $DLTransmissionRetrans1D;#t
						$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{DLTransmissionNackedRetransD} += $DLTransmissionNackedRetransD;#z
					}
				}
			}
			close(DLHARQ_D);
        }

        #DL Init BLER,DL Residual BLER
        if (-e "$TempPath/$dlHarqTransBler256"){
			open (DLHARQ256, "<$TempPath/$dlHarqTransBler256");
			while(<DLHARQ256>) {
				if ($_ !~ /^eNB/ ) { next; }
				my($enb_id_noDup, $cellLocation, $DLTransmissionRetrans0_256Q,$DLTransmissionRetrans1_256Q,$DLTransmissionNackedRetrans_256Q) = (split(',', $_))[0,6,18,19,25];
				if ($enb_id_noDup eq "$given_NE"){
					my $cell_id_noDup = $cellLocation;#has no duplicate cellId's
					my ($first_num) = $cell_id_noDup =~ /(\d+)/;#for cbrs
					if($first_num < 100){
						$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{DLTransmissionRetrans0_256Q} += $DLTransmissionRetrans0_256Q;#s
						$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{DLTransmissionRetrans1_256Q} += $DLTransmissionRetrans1_256Q;#t
						$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{DLTransmissionNackedRetrans_256Q}  += $DLTransmissionNackedRetrans_256Q;#z
					}
				}
			}
			close(DLHARQ256);
        }

        if (-e "$TempPathDays/$dlHarqTransBler256"){
			open (DLHARQ256_D, "<$TempPathDays/$dlHarqTransBler256");
			while(<DLHARQ256_D>) {
				if ($_ !~ /^eNB/ ) { next; }
				my($enb_id_noDup, $cellLocationD, $DLTransmissionRetrans0_256QD,$DLTransmissionRetrans1_256QD,$DLTransmissionNackedRetrans_256QD) = (split(',', $_))[0,6,18,19,25];
				if ($enb_id_noDup eq "$given_NE"){
					my $cell_id_noDup = $cellLocationD;#has no duplicate cellId's
					my ($first_num_D) = $cell_id_noDup =~ /(\d+)/;#for cbrs
					if($first_num_D < 100){
						$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{DLTransmissionRetrans0_256QD} += $DLTransmissionRetrans0_256QD;#s
						$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{DLTransmissionRetrans1_256QD} += $DLTransmissionRetrans1_256QD;#t
						$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{DLTransmissionNackedRetrans_256QD}  += $DLTransmissionNackedRetrans_256QD;#z
					}
				}
			}
			close(DLHARQ256_D);
        }

		#UL Init BLER, UL Residual BLER
		if (-e "$TempPath/$ulHarqTransBler"){
			open (ULHARQ, "<$TempPath/$ulHarqTransBler");
			while(<ULHARQ>) {
				if ($_ !~ /^eNB/ ) { next; }
				my($enb_id_noDup, $cellLocation, $ULTransmissionRetrans0,$ULTransmissionRetrans1,$ULTransmissionNackedRetrans) = (split(',', $_))[0,6,39,40,67];
				if ($enb_id_noDup eq "$given_NE"){
					my $cell_id_noDup = $cellLocation;#has no duplicate cellId's
					my ($first_num) = $cell_id_noDup =~ /(\d+)/;#for cbrs
					if($first_num < 100){
						$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{ULTransmissionRetrans0} += $ULTransmissionRetrans0;#AN
						$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{ULTransmissionRetrans1}  += $ULTransmissionRetrans1;#AO
						$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{ULTransmissionNackedRetrans}  += $ULTransmissionNackedRetrans;#BP
					}
				}
			}
			close(ULHARQ);
		}

		if (-e "$TempPathDays/$ulHarqTransBler"){
			open (ULHARQ_D, "<$TempPathDays/$ulHarqTransBler");
			while(<ULHARQ_D>) {
				if ($_ !~ /^eNB/ ) { next; }
				my($enb_id_noDup, $cellLocationD, $ULTransmissionRetrans0D,$ULTransmissionRetrans1D,$ULTransmissionNackedRetransD) = (split(',', $_))[0,6,39,40,67];
				if ($enb_id_noDup eq "$given_NE"){
					my $cell_id_noDup = $cellLocationD;#has no duplicate cellId's
					my ($first_num_D) = $cell_id_noDup =~ /(\d+)/;#for cbrs
					if($first_num_D < 100){
						$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{ULTransmissionRetrans0D} += $ULTransmissionRetrans0D;#AN
						$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{ULTransmissionRetrans1D}  += $ULTransmissionRetrans1D;#AO
						$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{ULTransmissionNackedRetransD}  += $ULTransmissionNackedRetransD;#BP
					}
				}
			}
			close(ULHARQ_D);
		}

	#SEA_ENDC_CapUE_RRC_Drop
	if (-e "$TempPath/$endc_capUE"){
		open (ENDCCAP, "<$TempPath/$endc_capUE");
		while(<ENDCCAP>) {
		if ($_ !~ /^eNB/ ) { next; }
		my($enb_id_noDup, $cellLocation, $EnDc_CpCcNormal,$EnDc_CpCcTo,$EnDc_CpCcFail,$EnDc_UpGtpFail,$EnDc_UpMacFail,$EnDc_UpMacUEInact,$EnDc_UpPdcpFail,$EnDc_UpRlcFail,$EnDc_RrcHcTo,$EnDc_RrcSigFail,$EnDc_RrcSigTo,$EnDc_CpBhCacFail,$EnDc_CpCapaCacFail,$EnDc_CpQosCacFail,$EnDc_S1apCuFail,$EnDc_S1apLinkFail,$EnDc_S1apRoTo,$EnDc_S1apSigFail,$EnDc_S1apSigTo,$EnDc_X2apCuFail,$EnDc_X2apLinkFail,$EnDc_X2apRoTo,$EnDc_X2apSigFail,$EnDc_CpPreemption,$EnDc_MmeOverload) = (split(',', $_))[0,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31];
			if ($enb_id_noDup eq "$given_NE"){
				my $cell_id_noDup= $cellLocation;#has no duplicate cellId's
				my ($first_num) = $cell_id_noDup =~ /(\d+)/;#for cbrs
				if($first_num < 100){
				$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_CpCcNormal} += $EnDc_CpCcNormal;
				$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_CpCcTo} +=  $EnDc_CpCcTo;
				$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_CpCcFail} += $EnDc_CpCcFail;
				$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_UpGtpFail} += $EnDc_UpGtpFail;
				$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_UpMacFail} += $EnDc_UpMacFail;
				$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_UpMacUEInact} += $EnDc_UpMacUEInact;
				$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_UpPdcpFail} += $EnDc_UpPdcpFail;
				$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_UpRlcFail} +=  $EnDc_UpRlcFail;
				$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_RrcHcTo} +=  $EnDc_RrcHcTo;
				$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_RrcSigFail} += $EnDc_RrcSigFail;
				$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_RrcSigTo} += $EnDc_RrcSigTo;
				$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_CpBhCacFail} += $EnDc_CpBhCacFail;
				$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_CpCapaCacFail} += $EnDc_CpCapaCacFail;
				$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_CpQosCacFail} += $EnDc_CpQosCacFail;
				$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_S1apCuFail} += $EnDc_S1apCuFail;
				$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_S1apLinkFail} += $EnDc_S1apLinkFail;
				$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_S1apRoTo} += $EnDc_S1apRoTo;
				$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_S1apSigFail} += $EnDc_S1apSigFail;
				$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_S1apSigTo} += $EnDc_S1apSigTo;
				$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_X2apCuFail} += $EnDc_X2apCuFail;
				$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_X2apLinkFail} += $EnDc_X2apLinkFail;
				$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_X2apRoTo} += $EnDc_X2apRoTo;
				$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_X2apSigFail} += $EnDc_X2apSigFail;
				$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_CpPreemption} += $EnDc_CpPreemption;
				$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_MmeOverload} += $EnDc_MmeOverload;
				}
			}
		}
		close(ENDCCAP);
	}
	if (-e "$TempPathDays/$endc_capUE"){
		open (ENDCCAP_D, "<$TempPathDays/$endc_capUE");
		while(<ENDCCAP_D>) {
			if ($_ !~ /^eNB/ ) { next; }
			my($enb_id_noDup, $cellLocationD, $EnDc_CpCcNormalD,$EnDc_CpCcToD,$EnDc_CpCcFailD,$EnDc_UpGtpFailD,$EnDc_UpMacFailD,$EnDc_UpMacUEInactD,$EnDc_UpPdcpFailD,$EnDc_UpRlcFailD,$EnDc_RrcHcToD,$EnDc_RrcSigFailD,$EnDc_RrcSigToD,$EnDc_CpBhCacFailD,$EnDc_CpCapaCacFailD,$EnDc_CpQosCacFailD,$EnDc_S1apCuFailD,$EnDc_S1apLinkFailD,$EnDc_S1apSigFailD,$EnDc_S1apRoToD,$EnDc_S1apSigToD,$EnDc_X2apCuFailD,$EnDc_X2apLinkFailD,$EnDc_X2apRoToD,$EnDc_X2apSigFailD,$EnDc_CpPreemptionD,$EnDc_MmeOverloadD) = (split(',', $_))[0,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31];
			if ($enb_id_noDup eq "$given_NE"){
				my $cell_id_noDup= $cellLocationD;#has no duplicate cellId's
				my ($first_num_D) = $cell_id_noDup =~ /(\d+)/;#for cbrs
				if($first_num_D < 100){
					$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_CpCcNormalD} += $EnDc_CpCcNormalD;
					$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_CpCcToD} +=  $EnDc_CpCcToD;
					$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_CpCcFailD} += $EnDc_CpCcFailD;
					$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_UpGtpFailD} += $EnDc_UpGtpFailD;
					$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_UpMacFailD} += $EnDc_UpMacFailD;
					$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_UpMacUEInactD} += $EnDc_UpMacUEInactD;
					$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_UpPdcpFailD} += $EnDc_UpPdcpFailD;
					$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_UpRlcFailD} +=  $EnDc_UpRlcFailD;
					$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_RrcHcToD} +=  $EnDc_RrcHcToD;
					$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_RrcSigFailD} += $EnDc_RrcSigFailD;
					$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_RrcSigToD} += $EnDc_RrcSigToD;
					$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_CpBhCacFailD} += $EnDc_CpBhCacFailD;
					$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_CpCapaCacFailD} += $EnDc_CpCapaCacFailD;
					$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_CpQosCacFailD} += $EnDc_CpQosCacFailD;
					$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_S1apCuFailD} += $EnDc_S1apCuFailD;
					$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_S1apLinkFailD} += $EnDc_S1apLinkFailD;
					$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_S1apSigFailD} += $EnDc_S1apSigFailD;
					$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_S1apRoToD} += $EnDc_S1apRoToD;
					$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_S1apSigToD} += $EnDc_S1apSigToD;
					$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_X2apCuFailD} += $EnDc_X2apCuFailD;
					$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_X2apLinkFailD} += $EnDc_X2apLinkFailD;
					$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_X2apRoToD} += $EnDc_X2apRoToD;
					$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_X2apSigFailD} += $EnDc_X2apSigFailD;
					$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_CpPreemptionD} += $EnDc_CpPreemptionD;
					$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_MmeOverloadD} += $EnDc_MmeOverloadD;
				}
			}
		}
		close(ENDCCAP_D);
	}

	#Cell Availability
	if (-e "$TempPath/$cellAvailability"){
		open (AVAIL, "<$TempPath/$cellAvailability");
		while(<AVAIL>) {
			if ($_ !~ /^eNB/ ) { next; }
			my($enb_id_noDup, $cellLocation, $ReadCellUnavailableTime, $CellAvailPmPeriodTime) = (split(',', $_))[0,6,8,9];
			if ($enb_id_noDup eq "$given_NE"){
				my($cell_id_noDup) = $cellLocation;#has no duplicate cellid's
				my ($first_num) = $cell_id_noDup =~ /(\d+)/;#for cbrs
				if($first_num < 100){
					$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{ReadCellUnavailableTime} +=  $ReadCellUnavailableTime;
					$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{CellAvailPmPeriodTime} += $CellAvailPmPeriodTime;
				}
			}
		}
		close(AVAIL);
	}

	if (-e "$TempPathDays/$cellAvailability"){
		open (AVAIL_D, "<$TempPathDays/$cellAvailability");
		while(<AVAIL_D>) {
			if ($_ !~ /^eNB/ ) { next; }
			my($enb_id_noDup, $cellLocation_D, $ReadCellUnavailableTimeD, $CellAvailPmPeriodTimeD) = (split(',', $_))[0,6,8,9];
			if ($enb_id_noDup eq "$given_NE"){
				my($cell_id_noDup) = $cellLocation_D;#has no duplicate cellid's
				my ($first_num_D) = $cell_id_noDup =~ /(\d+)/;#for cbrs
				if($first_num_D < 100){
					$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{ReadCellUnavailableTimeD} +=  $ReadCellUnavailableTimeD;
					$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{CellAvailPmPeriodTimeD} += $CellAvailPmPeriodTimeD;
				}
			}
		}
		close(AVAIL_D);
	}

	print Dumper \%status_hash_noDup;
	open (CANDIDATES, ">>$installDir/Logs/candidates_$dateTimeKpi.csv") or die "Can't open file : $installDir/Logs/candidates_$dateTimeKpi.csv\n";
	foreach my $enb_id_noDup (keys %status_hash_noDup) {
		foreach my $cell_id_noDup ( keys %{$status_hash_noDup{$enb_id_noDup}}) {
			##Context Setup Failure
			$nm_contSetupFail = ($status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{conn_txSetupFail} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{conn_s1SetupFail});
			$dr_contSetupFail = $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{conn_rxSetupRequest};
			if($dr_contSetupFail != 0){
				$contSetupFail_rate =($nm_contSetupFail / $dr_contSetupFail ) * 100;
				#baseline avg
				$nm_contSetupFailD = ($status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{conn_txSetupFailD} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{conn_s1SetupFailD});
				$dr_contSetupFailD = ($status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{conn_rxSetupRequestD});
				if($dr_contSetupFailD != 0){
					my $contSetupFail_rateD =($nm_contSetupFailD / $dr_contSetupFailD ) * 100;
					if($contSetupFail_rateD != 0){
						#final comparison
						my $finalContSetupFail = (($contSetupFail_rate - $contSetupFail_rateD)/$contSetupFail_rateD)*100;
						$finalContSetupFail = sprintf("%.3f", $finalContSetupFail); 
						$contSetupFail_rateD = sprintf("%.3f", $contSetupFail_rateD); 
						$contSetupFail_rate = sprintf("%.3f", $contSetupFail_rate); 
						print "finalContSetupFail=$finalContSetupFail\n";
						if ($finalContSetupFail > $s1ContThresh) {
							print (CANDIDATES "$dateCst[0],$cstPrevHour,Context Setup Failure,$enb_id_noDup,$cell_id_noDup,$contSetupFail_rateD,$contSetupFail_rate,$finalContSetupFail\n");
						}
					}
				}
			}

			##RRC ConnectionDropRate #nr
			my $nm_rrcConnDr = ($status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{radio_linkFail} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{arq_maxReTrans});
			my $dr_rrcConnDr = $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{ConnEstabSucc};
			if($dr_rrcConnDr != 0){
				my $rrcConnDr_rate =($nm_rrcConnDr / $dr_rrcConnDr ) * 100;
				#baseline avg
				my $nm_rrcConnDrD = ($status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{radio_linkFailD} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{arq_maxReTransD});
				my $dr_rrcConnDrD = ($status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{ConnEstabSuccD});
				if($dr_rrcConnDrD != 0){
					my $rrcConnDr_rateD =($nm_rrcConnDrD / $dr_rrcConnDrD ) * 100;
					if($rrcConnDr_rateD != 0){
						#final comparison
						my $finalRrcConnDrFail = (($rrcConnDr_rate - $rrcConnDr_rateD)/$rrcConnDr_rateD)*100;
						$finalRrcConnDrFail = sprintf("%.3f", $finalRrcConnDrFail); 
						$rrcConnDr_rateD = sprintf("%.3f", $rrcConnDr_rateD); 
						$rrcConnDr_rate = sprintf("%.3f", $rrcConnDr_rate); 
						print "finalRrcConnDrFail=$finalRrcConnDrFail\n";
						if ($finalRrcConnDrFail > $rlfDetThresh) {
							print (CANDIDATES "$dateCst[0],$cstPrevHour,RRC ConnectionDropRate,$enb_id_noDup,$cell_id_noDup,$rrcConnDr_rateD,$rrcConnDr_rate,$finalRrcConnDrFail\n");
						}
					}
				}
			}

			##ContextDropRate
			my $nm_contDr = ($status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{RelAbnormalByEnb} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{RelAbnormalByMmeAct});
			my $dr_contDr = ($status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{RelAbnormalByEnb} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{RelNormalByEnb} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{RelAbnormalByMme} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{RelNormalByMme});
			if($dr_contDr != 0){
				my $contDr_rate =($nm_contDr / $dr_contDr ) * 100;
				#baseline avg
				my $nm_contDrD = ($status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{RelAbnormalByEnbD} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{RelAbnormalByMmeActD});
				my $dr_contDrD = ($status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{RelAbnormalByEnbD} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{RelNormalByEnbD} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{RelAbnormalByMmeD} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{RelNormalByMmeD});
				if( $dr_contDrD != 0){
					my $contDr_rateD =($nm_contDrD / $dr_contDrD ) * 100;
					if($contDr_rateD != 0){
						#final comparison
						my $finalContDrFail = (($contDr_rate - $contDr_rateD)/$contDr_rateD)*100;
						$finalContDrFail = sprintf("%.3f", $finalContDrFail); 
						$contDr_rateD = sprintf("%.3f", $contDr_rateD); 
						$contDr_rate = sprintf("%.3f", $contDr_rate); 
						print "finalContDrFail=$finalContDrFail\n";
						if ($finalContDrFail > $contRelThresh) {
							print (CANDIDATES "$dateCst[0],$cstPrevHour,Context Drop Rate,$enb_id_noDup,$cell_id_noDup,$contDr_rateD,$contDr_rate,$finalContDrFail\n");
						}
					}
				}
			}

			##AvgRRCconnectedUserspercell
			my $nm_avgRrc = ($status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{ConnNoTot});
			my $dr_avgRrc = ($status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{ConnNoCnt});
			if($dr_avgRrc != 0){
				my $avgRrc_rate =($nm_avgRrc / $dr_avgRrc ) * 100;
				#baseline avg
				my $nm_avgRrcD = ($status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{ConnNoTotD});
				my $dr_avgRrcD = ($status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{ConnNoCntD});
				if($dr_avgRrcD != 0){
					my $avgRrc_rateD =($nm_avgRrcD / $dr_avgRrcD ) * 100;
					if($avgRrc_rateD != 0){
						#final comparison
						my $finalAvgRrcFail = (($avgRrc_rate - $avgRrc_rateD)/$avgRrc_rateD)*100;
						$finalAvgRrcFail = sprintf("%.3f", $finalAvgRrcFail); 
						$avgRrc_rateD = sprintf("%.3f", $avgRrc_rateD); 
						$avgRrc_rate = sprintf("%.3f", $avgRrc_rate); 
						print "finalAvgRrcFail=$finalAvgRrcFail\n";
						if ($finalAvgRrcFail > $rrcNumThresh) {
							print (CANDIDATES "$dateCst[0],$cstPrevHour,Avg RRC connected UsersPerCell,$enb_id_noDup,$cell_id_noDup,$avgRrc_rateD,$avgRrc_rate,$finalAvgRrcFail\n");
						}
					}
				}
			}
			
			##UL UPT
			my $nm_ulUpt = (($status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{ULIpThruVol}) * 8)/1000;
			my $dr_ulUpt = ($status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{ULIpThruTime})/1000;
			if($dr_ulUpt != 0){
				my $ulUptFail_rate =($nm_ulUpt / $dr_ulUpt ) * 100;
				#baseline avg
				my $nm_ulUptD = ((($status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{ULIpThruVolD}) * 8)/1000);
				my $dr_ulUptD = (($status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{ULIpThruTimeD})/1000);
				if( $dr_ulUptD != 0){
					my $ulUptFail_rateD =($nm_ulUptD / $dr_ulUptD ) * 100;
					if($ulUptFail_rateD != 0){
						#final comparison
						my $finalUlUptFail = (($ulUptFail_rate - $ulUptFail_rateD)/$ulUptFail_rateD)*100;
						$finalUlUptFail = sprintf("%.3f", $finalUlUptFail); 
						$ulUptFail_rateD = sprintf("%.3f", $ulUptFail_rateD); 
						$ulUptFail_rate = sprintf("%.3f", $ulUptFail_rate); 
						print "finalUlUptFail=$finalUlUptFail\n";
						if ($finalUlUptFail < $airMac4gThresh) {
							print (CANDIDATES "$dateCst[0],$cstPrevHour,UL UPT,$enb_id_noDup,$cell_id_noDup,$ulUptFail_rateD,$ulUptFail_rate,$finalUlUptFail\n");
						}
					}
				}
			}

			##DL MAC Volume
			my $nr_dlmacVol = ($status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{AirMacDLByte})/1000;
			#baseline avg
			my $nr_dlmacVolD = (($status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{AirMacDLByteD})/1000);
			if($nr_dlmacVolD != 0){
				#final comparison
				my $finaldlmacVolDFail = (($nr_dlmacVol - $nr_dlmacVolD)/$nr_dlmacVolD)*100;
				$finaldlmacVolDFail = sprintf("%.3f", $finaldlmacVolDFail); 
				$nr_dlmacVolD = sprintf("%.3f", $nr_dlmacVolD); 
				$nr_dlmacVol = sprintf("%.3f", $nr_dlmacVol); 
				print "finaldlmacVolDFail=$finaldlmacVolDFail\n";
				if ($finaldlmacVolDFail < $airMac4gThresh) {
					print (CANDIDATES "$dateCst[0],$cstPrevHour,DL MAC Volume,$enb_id_noDup,$cell_id_noDup,$nr_dlmacVolD,$nr_dlmacVol,$finaldlmacVolDFail\n");
				}
			}

			##DL Init BLER
			my $nm_dlInit = ($status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{DLTransmissionRetrans1} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{DLTransmissionRetrans1_256Q});
			my $dr_dlInit = ($status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{DLTransmissionRetrans0} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{DLTransmissionRetrans0_256Q});
			if($dr_dlInit != 0){
				my $dlInitFail_rate =($nm_dlInit / $dr_dlInit ) * 100;
				#baseline avg
				my $nm_dlInitD = ($status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{DLTransmissionRetrans1D} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{DLTransmissionRetrans1_256QD});
				my $dr_dlInitD = ($status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{DLTransmissionRetrans0D} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{DLTransmissionRetrans0_256QD});
				if($dr_dlInitD != 0){
					my $dlInitFail_rateD =($nm_dlInitD / $dr_dlInitD ) * 100;
					if($dlInitFail_rateD != 0){
						#final comparison
						my $finalDlInitFail = (($dlInitFail_rate - $dlInitFail_rateD)/$dlInitFail_rateD)*100;
						$finalDlInitFail = sprintf("%.3f", $finalDlInitFail); 
						$dlInitFail_rateD = sprintf("%.3f", $dlInitFail_rateD); 
						$dlInitFail_rate = sprintf("%.3f", $dlInitFail_rate); 
						print "finalDlInitFail=$finalDlInitFail\n";
						if ($finalDlInitFail > $DLHarqThresh) {
							print (CANDIDATES "$dateCst[0],$cstPrevHour,DL Init BLER,$enb_id_noDup,$cell_id_noDup,$dlInitFail_rateD,$dlInitFail_rate,$finalDlInitFail\n");
						}
					}
				}	
			}

			#DL Residual BLER
			my $nm_dlBler = ($status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{DLTransmissionNackedRetrans} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{DLTransmissionNackedRetrans_256Q});
			my $dr_dlBler = ($status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{DLTransmissionRetrans0} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{DLTransmissionRetrans0_256Q});
			if($dr_dlBler != 0){
				my $dlBlerFail_rate =($nm_dlBler / $dr_dlBler ) * 100;
				#baseline avg
				my $nm_dlBlerD = ($status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{DLTransmissionNackedRetransD} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{DLTransmissionNackedRetrans_256QD});
				my $dr_dlBlerD = ($status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{DLTransmissionRetrans0D} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{DLTransmissionRetrans0_256QD});
				if($dr_dlBlerD != 0){
					my $dlBlerFail_rateD =($nm_dlBlerD / $dr_dlBlerD ) * 100;
					if($dlBlerFail_rateD != 0){
						#final comparison
						my $finaldlBlerFail = (($dlBlerFail_rate - $dlBlerFail_rateD)/$dlBlerFail_rateD)*100;
						$finaldlBlerFail = sprintf("%.3f", $finaldlBlerFail); 
						$dlBlerFail_rateD = sprintf("%.3f", $dlBlerFail_rateD); 
						$dlBlerFail_rate = sprintf("%.3f", $dlBlerFail_rate); 
						print "finaldlBlerFail=$finaldlBlerFail\n";
						if ($finaldlBlerFail > $DLHarqThresh) {
							print (CANDIDATES "$dateCst[0],$cstPrevHour,DL Residual BLER,$enb_id_noDup,$cell_id_noDup,$dlBlerFail_rateD,$dlBlerFail_rate,$finaldlBlerFail\n");
						}
					}
				}
			}

			#UL Init BLER
			my $nm_ulInit = ($status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{ULTransmissionRetrans1});
			my $dr_ulInit = ($status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{ULTransmissionRetrans0});
			if($dr_ulInit != 0){
				my $ulInitFail_rate =($nm_ulInit / $dr_ulInit ) * 100;
				#baseline avg
				my $nm_ulInitD = ($status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{ULTransmissionRetrans1D});
				my $dr_ulInitD = ($status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{ULTransmissionRetrans0D});
				if($dr_ulInitD != 0){
					my $ulInitFail_rateD =($nm_ulInitD / $dr_ulInitD ) * 100;
					if($ulInitFail_rateD != 0){
						#final comparison
						my $finalUlInitFail = (($ulInitFail_rate - $ulInitFail_rateD)/$ulInitFail_rateD)*100;
						$finalUlInitFail = sprintf("%.3f", $finalUlInitFail); 
						$ulInitFail_rateD = sprintf("%.3f", $ulInitFail_rateD); 
						$ulInitFail_rate = sprintf("%.3f", $ulInitFail_rate);
						print "finalUlInitFail=$finalUlInitFail\n";
						if ($finalUlInitFail > $ULHarqThresh) {
							print (CANDIDATES "$dateCst[0],$cstPrevHour,UL Init BLER,$enb_id_noDup,$cell_id_noDup,$ulInitFail_rateD,$ulInitFail_rate,$finalUlInitFail\n");
						}
					}
				}
			}

			#UL Residual BLER
			my $nm_ulBler = ($status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{ULTransmissionNackedRetrans});
			my $dr_ulBler = ($status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{ULTransmissionRetrans0});
			if($dr_ulBler != 0){
				my $ulBlerFail_rate =($nm_ulBler / $dr_ulBler ) * 100;
				#baseline avg
				my $nm_ulBlerD = ($status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{ULTransmissionNackedRetransD});
				my $dr_ulBlerD = ($status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{ULTransmissionRetrans0D});
				if($dr_ulBlerD != 0){
					my $ulBlerFail_rateD =($nm_ulBlerD / $dr_ulBlerD ) * 100;
					if($ulBlerFail_rateD != 0){
						#final comparison
						my $finalUlBlerFail = (($ulBlerFail_rate - $ulBlerFail_rateD)/$ulBlerFail_rateD)*100;
						$finalUlBlerFail = sprintf("%.3f", $finalUlBlerFail); 
						$ulBlerFail_rateD = sprintf("%.3f", $ulBlerFail_rateD); 
						$ulBlerFail_rate = sprintf("%.3f", $ulBlerFail_rate);
						print "finalUlBlerFail=$finalUlBlerFail\n";
						if ($finalUlBlerFail > $ULHarqThresh) {
							print (CANDIDATES "$dateCst[0],$cstPrevHour,UL Residual BLER,$enb_id_noDup,$cell_id_noDup,$ulBlerFail_rateD,$ulBlerFail_rate,$finalUlBlerFail\n");
						}
					}
				}
			}
			
			#SEA_ENDC_CapUE_RRC_Drop
			my $nm_endcCapUe = ($status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_CpCcTo} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_CpCcFail} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_UpGtpFail} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_UpMacFail} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_UpPdcpFail} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_UpRlcFail} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_RrcHcTo} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_RrcSigFail} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_RrcSigTo} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_CpBhCacFail} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_CpCapaCacFail} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_CpQosCacFail} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_S1apCuFail} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_S1apLinkFail} +     $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_S1apRoTo} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_S1apSigFail}+ $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_S1apSigTo} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_X2apCuFail} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_X2apLinkFail} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_X2apRoTo} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_X2apSigFail} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_CpPreemption} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_MmeOverload});
			my $dr_endcCapUe = ($status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_CpCcTo} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_CpCcFail} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_UpGtpFail} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_UpMacFail} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_UpPdcpFail} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_UpRlcFail} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_RrcHcTo} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_RrcSigFail} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_RrcSigTo} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_CpBhCacFail} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_CpCapaCacFail} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_CpQosCacFail} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_S1apCuFail} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_S1apLinkFail} +     $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_S1apRoTo} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_S1apSigFail} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_S1apSigTo} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_X2apCuFail} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_X2apLinkFail} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_X2apRoTo} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_X2apSigFail} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_CpPreemption} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_MmeOverload} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_CpCcNormal} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_UpMacUEInact});
			if( $dr_endcCapUe != 0){
				my $capUeFail_rate =($nm_endcCapUe / $dr_endcCapUe ) * 100;
				#baseline avg
				my $nm_endcCapUeD = ($status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_CpCcToD} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_CpCcFailD} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_UpGtpFailD} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_UpMacFailD} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_UpPdcpFailD} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_UpRlcFailD} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_RrcHcToD} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_RrcSigFailD} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_RrcSigToD} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_CpBhCacFailD} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_CpCapaCacFailD} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_CpQosCacFailD} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_S1apCuFailD} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_S1apLinkFailD} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_S1apRoToD} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_S1apSigFailD} +$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_S1apSigToD} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_X2apCuFailD} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_X2apLinkFailD} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_X2apRoToD} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_X2apSigFailD} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_CpPreemptionD} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_MmeOverloadD});
				my $dr_endcCapUeD = ($status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_CpCcToD} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_CpCcFailD} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_UpGtpFailD} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_UpMacFailD} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_UpPdcpFailD} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_UpRlcFailD} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_RrcHcToD} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_RrcSigFailD} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_RrcSigToD} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_CpBhCacFailD} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_CpCapaCacFailD} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_CpQosCacFailD} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_S1apCuFailD} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_S1apLinkFailD} +     $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_S1apRoToD} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_S1apSigFailD} +$status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_S1apSigToD} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_X2apCuFailD} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_X2apLinkFailD} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_X2apRoToD} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_X2apSigFailD} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_CpPreemptionD} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_MmeOverloadD} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_CpCcNormalD} + $status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{EnDc_UpMacUEInactD});
				if($dr_endcCapUeD != 0){
					my $capUeFail_rateD =($nm_endcCapUeD / $dr_endcCapUeD ) * 100;
					if($capUeFail_rateD != 0){
						#final comparison
						my $finalCapUeFail = (($capUeFail_rate - $capUeFail_rateD)/$capUeFail_rateD)*100;
						$finalCapUeFail = sprintf("%.3f", $finalCapUeFail); 
						$capUeFail_rateD = sprintf("%.3f", $capUeFail_rateD); 
						$capUeFail_rate = sprintf("%.3f", $capUeFail_rate);
						print "finalCapUeFail=$finalCapUeFail\n";
						if ($finalCapUeFail > $endcCapThresh) {
							print (CANDIDATES "$dateCst[0],$cstPrevHour,SEA_ENDC_CapUE_RRC_Drop,$enb_id_noDup,$cell_id_noDup,$capUeFail_rateD,$capUeFail_rate,$finalCapUeFail\n");
						}
					}
				}
			}
					
			#Cell Availability
			my $nm_availability = ($status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{CellAvailPmPeriodTime})-($status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{ReadCellUnavailableTime}) ;
			my $dr_availability = ($status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{CellAvailPmPeriodTime});
			if($dr_availability != 0){
				my $availabilityFail_rate =($nm_availability / $dr_availability ) * 100;
				#baseline avg
				my $nm_availabilityD = (($status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{CellAvailPmPeriodTimeD})-($status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{ReadCellUnavailableTimeD})) ;
				my $dr_availabilityD = ($status_hash_noDup{$enb_id_noDup}{$cell_id_noDup}{CellAvailPmPeriodTimeD});
				if($dr_availabilityD != 0){
					my $availabilityFail_rateD =($nm_availabilityD / $dr_availabilityD ) * 100;
					if( $availabilityFail_rateD != 0){
						#final comparison
						my $finalAvailabilityFail = (($availabilityFail_rate - $availabilityFail_rateD)/$availabilityFail_rateD)*100;
						$availabilityFail_rate = sprintf("%.3f", $availabilityFail_rate); 
						$availabilityFail_rateD = sprintf("%.3f", $availabilityFail_rateD); 
						$finalAvailabilityFail = sprintf("%.3f", $finalAvailabilityFail);
						print "finalAvailabilityFail=$finalAvailabilityFail\n";
						if ($finalAvailabilityFail < $CellAvailabilityThresh) {
							print (CANDIDATES "$dateCst[0],$cstPrevHour,Cell Availability,$enb_id_noDup,$cell_id_noDup,$availabilityFail_rateD,$availabilityFail_rate,$finalAvailabilityFail\n");
						}	
					}
				}
			}
	
		}
	}
}
sub kpi_calc_4G {
	#RRC Setup Failure,RRCSetupFailure_DEN
	if (-e "$TempPath/$rrcConnEstMsgFile"){
		open (ESTMSG, "<$TempPath/$rrcConnEstMsgFile");
		while(<ESTMSG>) {
			if ($_ !~ /^eNB/ ) { next; }
			my($enb_id, $cellLocation, $conn_request, $conn_setup) = (split(',', $_))[0,6,7,9];
			if ($enb_id eq "$given_NE"){
				my($cell_id, $loc_id) = (split('/', $cellLocation))[0,1];#has duplicate cellid's
				my ($first_num) = $cell_id =~ /(\d+)/;#for cbrs
				if($first_num < 100){
					$status_hash{$enb_id}{$cell_id}{conn_request} +=  $conn_request;
					$status_hash{$enb_id}{$cell_id}{conn_setup} += $conn_setup;
				}
			}
		}
		close(ESTMSG);
	}

	if (-e "$TempPathDays/$rrcConnEstMsgFile"){
		open (ESTMSG_D, "<$TempPathDays/$rrcConnEstMsgFile");
		while(<ESTMSG_D>) {
			if ($_ !~ /^eNB/ ) { next; }
			my($enb_id, $cellLocation_D, $conn_requestD, $conn_setupD) = (split(',', $_))[0,6,7,9];
			if ($enb_id eq "$given_NE"){
				my($cell_id, $loc_id) = (split('/', $cellLocation_D))[0,1];#has duplicate cellid's
				my ($first_num_D) = $cell_id =~ /(\d+)/;#for cbrs
				if($first_num_D < 100){
					$status_hash{$enb_id}{$cell_id}{conn_requestD} +=  $conn_requestD;
					$status_hash{$enb_id}{$cell_id}{conn_setupD} += $conn_setupD;
				}
			}
		}
		close(ESTMSG_D);
	}


	#DL UPT
	if (-e "$TempPath/$airrlcpk"){
		open (AIRRLCPK, "<$TempPath/$airrlcpk");
		while(<AIRRLCPK>) {
			if ($_ !~ /^eNB/ ) { next; }
			my($enb_id, $cellLocation, $IpThruThpVoDLByte,$IpThruThpDLTime) = (split(',', $_))[0,6,29,30];
			if ($enb_id eq "$given_NE"){
				my($cell_id, $loc_id) = (split('/', $cellLocation))[0,1];#has duplicate cellId's
				my ($first_num) = $cell_id =~ /(\d+)/;#for cbrs
				if($first_num < 100){
					$status_hash{$enb_id}{$cell_id}{IpThruThpVoDLByte} += $IpThruThpVoDLByte;
					$status_hash{$enb_id}{$cell_id}{IpThruThpDLTime} += $IpThruThpDLTime;
				}
			}
		}
		close(AIRRLCPK);
	}

	if (-e "$TempPathDays/$airrlcpk"){
		open (AIRRLCPK_D, "<$TempPathDays/$airrlcpk");
		while(<AIRRLCPK_D>) {
			if ($_ !~ /^eNB/ ) { next; }
			my($enb_id, $cellLocationD, $IpThruThpVoDLByteD,$IpThruThpDLTimeD) = (split(',', $_))[0,6,29,30];
			if ($enb_id eq "$given_NE"){
				my($cell_id, $loc_id) = (split('/', $cellLocationD))[0,1];#has duplicate cellId's
				my ($first_num_D) = $cell_id =~ /(\d+)/;#for cbrs
				if($first_num_D < 100){
					$status_hash{$enb_id}{$cell_id}{IpThruThpVoDLByteD} += $IpThruThpVoDLByteD;
					$status_hash{$enb_id}{$cell_id}{IpThruThpDLTimeD} += $IpThruThpDLTimeD;
				}
			}
		}
		close(AIRRLCPK_D);
	}

        #X2HO FailRate
        if (-e "$TempPath/$x2OutHoWoFail"){
			open (X2HO, "<$TempPath/$x2OutHoWoFail");
			while(<X2HO>) {
				if ($_ !~ /^eNB/ ) { next; }
				if ($_ =~ /RADIO_REASON/) { 
					my($enb_id, $cellLocation, $InterX2OutAtt,$InterX2OutSucc) = (split(',', $_))[0,6,7,9];
					if ($enb_id eq "$given_NE"){
						my($cell_id, $loc_id) = (split('/', $cellLocation))[0,1];#has duplicate cellId's
						my ($first_num) = $cell_id =~ /(\d+)/;#for cbrs
						if($first_num < 100){
							$status_hash{$enb_id}{$cell_id}{InterX2OutAtt} += $InterX2OutAtt;
							$status_hash{$enb_id}{$cell_id}{InterX2OutSucc} += $InterX2OutSucc;
						}
					}
				}
			}
			close(X2HO);
        }

	if (-e "$TempPathDays/$x2OutHoWoFail"){
		open (X2HO_D, "<$TempPathDays/$x2OutHoWoFail");
		while(<X2HO_D>) {
			if ($_ !~ /^eNB/ ) { next; }
			if ($_ =~ /RADIO_REASON/) { #check with zubair
				my($enb_id, $cellLocationD, $InterX2OutAttD,$InterX2OutSuccD) = (split(',', $_))[0,6,7,9];
				if ($enb_id eq "$given_NE"){
					my($cell_id, $loc_id) = (split('/', $cellLocationD))[0,1];#has duplicate cellId's
					my ($first_num_D) = $cell_id =~ /(\d+)/;#for cbrs
					if($first_num_D < 100){
						$status_hash{$enb_id}{$cell_id}{InterX2OutAttD} += $InterX2OutAttD;
						$status_hash{$enb_id}{$cell_id}{InterX2OutSuccD} += $InterX2OutSuccD;
					}
				}
			}
		}
		close(X2HO_D);
	}
	#ENDC Attempts FR1, SEA_ENDC_SCG_Failure-dr
	if (-e "$TempPath/$endc_addInfo"){
		open (ENDCADD, "<$TempPath/$endc_addInfo");
		while(<ENDCADD>) {
			if ($_ !~ /^eNB/ ) { next; }
			my($enb_id, $cellLocation, $EnDc_AddAtt) = (split(',', $_))[0,6,7];
			if ($enb_id eq "$given_NE"){
				my($cell_id, $loc_id) = (split('/', $cellLocation))[0,1];#has duplicate cellId's
				$fr1_2 = substr($loc_id, 8, 1);
				if($fr1_2 == 9){#FR1
					my ($first_num) = $cell_id =~ /(\d+)/;#for cbrs
					if($first_num < 100){
						$status_hash{$enb_id}{$cell_id}{EnDc_AddAtt} += $EnDc_AddAtt;
					}
				}elsif($fr1_2 != 9){#FR2
					my ($first_num) = $cell_id =~ /(\d+)/;#for cbrs
					if($first_num < 100){
						$status_hash{$enb_id}{$cell_id}{EnDc_AddAtt_fr2} += $EnDc_AddAtt;
					}	
				}	
			}
		}
		close(ENDCADD);
	}

	if (-e "$TempPathDays/$endc_addInfo"){
		open (ENDCADD_D, "<$TempPathDays/$endc_addInfo");
		while(<ENDCADD_D>) {
			if ($_ !~ /^eNB/ ) { next; }
			my($enb_id, $cellLocationD, $EnDc_AddAttD) = (split(',', $_))[0,6,7];
			if ($enb_id eq "$given_NE"){
				my($cell_id, $loc_id) = (split('/', $cellLocationD))[0,1];#has duplicate cellId's
				$fr1_2 = substr($loc_id, 8, 1);
				if($fr1_2 == 9){
					my ($first_num_D) = $cell_id =~ /(\d+)/;#for cbrs
					if($first_num_D < 100){
						$status_hash{$enb_id}{$cell_id}{EnDc_AddAttD} += $EnDc_AddAttD;
					}
				}elsif($fr1_2 != 9){#FR2
					my ($first_num_D) = $cell_id =~ /(\d+)/;#for cbrs
					if($first_num_D < 100){
						$status_hash{$enb_id}{$cell_id}{EnDc_AddAttD_fr2} += $EnDc_AddAttD;
					}	
				}
			}
		}
		close(ENDCADD_D);
	}
	#SEA_ENDC_SCG_Failure - nr
	if (-e "$TempPath/$endc_relInfo"){
		open (ENDCREL, "<$TempPath/$endc_relInfo");
		while(<ENDCREL>) {
			if ($_ !~ /^eNB/ ) { next; }
			my($enb_id, $cellLocation, $EnDc_UeContxtRel, $EnDc_InternalResouFail, $EnDc_DcOverallTO, $EnDc_BearerNotSupp, $EnDc_RadioConnection_UeLost, $EnDc_t310_Expiry, $EnDc_SCG, $EnDc_randomAccessProblem, $EnDc_MaxNumRetx, $EnDc_IntegrityFailure, $EnDc_reconfigFailure,$EnDc_UeLost) = (split(',', $_))[0,6,7,9,10,13,14,17,18,19,20,21,22,23,24];
			if ($enb_id eq "$given_NE"){
				my($cell_id, $loc_id) = (split('/', $cellLocation))[0,1];#has duplicate cellId's
				$fr1_2 = substr($loc_id, 8, 1);
				if($fr1_2 == 9){
					my ($first_num) = $cell_id =~ /(\d+)/;#for cbrs
					if($first_num < 100){
						$status_hash{$enb_id}{$cell_id}{EnDc_UeContxtRel} += $EnDc_UeContxtRel;
						$status_hash{$enb_id}{$cell_id}{EnDc_InternalResouFail} += $EnDc_InternalResouFail;
						$status_hash{$enb_id}{$cell_id}{EnDc_DcOverallTO} += $EnDc_DcOverallTO;
						$status_hash{$enb_id}{$cell_id}{EnDc_BearerNotSupp} += $EnDc_BearerNotSupp;
						$status_hash{$enb_id}{$cell_id}{EnDc_RadioConnection_UeLost} += $EnDc_RadioConnection_UeLost;
						$status_hash{$enb_id}{$cell_id}{EnDc_t310_Expiry} += $EnDc_t310_Expiry;
						$status_hash{$enb_id}{$cell_id}{EnDc_SCG} += $EnDc_SCG;
						$status_hash{$enb_id}{$cell_id}{EnDc_randomAccessProblem} +=  $EnDc_randomAccessProblem;
						$status_hash{$enb_id}{$cell_id}{EnDc_MaxNumRetx} += $EnDc_MaxNumRetx;
						$status_hash{$enb_id}{$cell_id}{EnDc_IntegrityFailure} += $EnDc_IntegrityFailure;
						$status_hash{$enb_id}{$cell_id}{EnDc_reconfigFailure} += $EnDc_reconfigFailure;
						$status_hash{$enb_id}{$cell_id}{EnDc_UeLost} += $EnDc_UeLost;
					}
				}elsif($fr1_2 != 9){#FR2
					my ($first_num) = $cell_id =~ /(\d+)/;#for cbrs
					if($first_num < 100){
						$status_hash{$enb_id}{$cell_id}{EnDc_UeContxtRel_fr2} += $EnDc_UeContxtRel;
						$status_hash{$enb_id}{$cell_id}{EnDc_InternalResouFail_fr2} += $EnDc_InternalResouFail;
						$status_hash{$enb_id}{$cell_id}{EnDc_DcOverallTO_fr2} += $EnDc_DcOverallTO;
						$status_hash{$enb_id}{$cell_id}{EnDc_BearerNotSupp_fr2} += $EnDc_BearerNotSupp;
						$status_hash{$enb_id}{$cell_id}{EnDc_RadioConnection_UeLost_fr2} += $EnDc_RadioConnection_UeLost;
						$status_hash{$enb_id}{$cell_id}{EnDc_t310_Expiry_fr2} += $EnDc_t310_Expiry;
						$status_hash{$enb_id}{$cell_id}{EnDc_SCG_fr2} += $EnDc_SCG;
						$status_hash{$enb_id}{$cell_id}{EnDc_randomAccessProblem_fr2} +=  $EnDc_randomAccessProblem;
						$status_hash{$enb_id}{$cell_id}{EnDc_MaxNumRetx_fr2} += $EnDc_MaxNumRetx;
						$status_hash{$enb_id}{$cell_id}{EnDc_IntegrityFailure_fr2} += $EnDc_IntegrityFailure;
						$status_hash{$enb_id}{$cell_id}{EnDc_reconfigFailure_fr2} += $EnDc_reconfigFailure;
						$status_hash{$enb_id}{$cell_id}{EnDc_UeLost_fr2} += $EnDc_UeLost;
					}	
				}
			}
		}
		close(ENDCREL);
	}

	if (-e "$TempPathDays/$endc_relInfo"){
		open (ENDCREL_D, "<$TempPathDays/$endc_relInfo");
		while(<ENDCREL_D>) {
			if ($_ !~ /^eNB/ ) { next; }
			my($enb_id, $cellLocationD, $EnDc_UeContxtRelD, $EnDc_InternalResouFailD, $EnDc_DcOverallTOD, $EnDc_BearerNotSuppD, $EnDc_RadioConnection_UeLostD, $EnDc_t310_ExpiryD, $EnDc_SCGD, $EnDc_randomAccessProblemD, $EnDc_MaxNumRetxD, $EnDc_IntegrityFailureD, $EnDc_reconfigFailureD,$EnDc_UeLostD) = (split(',', $_))[0,6,7,9,10,13,14,17,18,19,20,21,22,23,24];
			if ($enb_id eq "$given_NE"){
				my($cell_id, $loc_id) = (split('/', $cellLocationD))[0,1];#has duplicate cellId's
				$fr1_2 = substr($loc_id, 8, 1);
				if($fr1_2 == 9){
					my ($first_num_D) = $cell_id =~ /(\d+)/;#for cbrs
					if($first_num_D < 100){
						$status_hash{$enb_id}{$cell_id}{EnDc_UeContxtRelD} += $EnDc_UeContxtRelD;
						$status_hash{$enb_id}{$cell_id}{EnDc_InternalResouFailD} += $EnDc_InternalResouFailD;
						$status_hash{$enb_id}{$cell_id}{EnDc_DcOverallTOD} += $EnDc_DcOverallTOD;
						$status_hash{$enb_id}{$cell_id}{EnDc_BearerNotSuppD} += $EnDc_BearerNotSuppD;
						$status_hash{$enb_id}{$cell_id}{EnDc_RadioConnection_UeLostD} += $EnDc_RadioConnection_UeLostD;
						$status_hash{$enb_id}{$cell_id}{EnDc_t310_ExpiryD} += $EnDc_t310_ExpiryD;
						$status_hash{$enb_id}{$cell_id}{EnDc_SCGD} += $EnDc_SCGD;
						$status_hash{$enb_id}{$cell_id}{EnDc_randomAccessProblemD} += $EnDc_randomAccessProblemD;
						$status_hash{$enb_id}{$cell_id}{EnDc_MaxNumRetxD} += $EnDc_MaxNumRetxD;
						$status_hash{$enb_id}{$cell_id}{EnDc_IntegrityFailureD} += $EnDc_IntegrityFailureD;
						$status_hash{$enb_id}{$cell_id}{EnDc_reconfigFailureD} += $EnDc_reconfigFailureD;
						$status_hash{$enb_id}{$cell_id}{EnDc_UeLostD} += $EnDc_UeLostD;
					}
				}elsif($fr1_2 != 9){#FR2
					my ($first_num_D) = $cell_id =~ /(\d+)/;#for cbrs
					if($first_num_D < 100){
						$status_hash{$enb_id}{$cell_id}{EnDc_UeContxtRelD_fr2} += $EnDc_UeContxtRelD;
						$status_hash{$enb_id}{$cell_id}{EnDc_InternalResouFailD_fr2} += $EnDc_InternalResouFailD;
						$status_hash{$enb_id}{$cell_id}{EnDc_DcOverallTOD_fr2} += $EnDc_DcOverallTOD;
						$status_hash{$enb_id}{$cell_id}{EnDc_BearerNotSuppD_fr2} += $EnDc_BearerNotSuppD;
						$status_hash{$enb_id}{$cell_id}{EnDc_RadioConnection_UeLostD_fr2} += $EnDc_RadioConnection_UeLostD;
						$status_hash{$enb_id}{$cell_id}{EnDc_t310_ExpiryD_fr2} += $EnDc_t310_ExpiryD;
						$status_hash{$enb_id}{$cell_id}{EnDc_SCGD_fr2} += $EnDc_SCGD;
						$status_hash{$enb_id}{$cell_id}{EnDc_randomAccessProblemD_fr2} += $EnDc_randomAccessProblemD;
						$status_hash{$enb_id}{$cell_id}{EnDc_MaxNumRetxD_fr2} += $EnDc_MaxNumRetxD;
						$status_hash{$enb_id}{$cell_id}{EnDc_IntegrityFailureD_fr2} += $EnDc_IntegrityFailureD;
						$status_hash{$enb_id}{$cell_id}{EnDc_reconfigFailureD_fr2} += $EnDc_reconfigFailureD;
						$status_hash{$enb_id}{$cell_id}{EnDc_UeLostD_fr2} += $EnDc_UeLostD;
					}	
				}
			}
		}
		close(ENDCREL_D);
	}
	
	#VOLTE UL PDCP Packet Loss Rate
	if (-e "$TempPath/$packetLossRate"){
		open (PACK, "<$TempPath/$packetLossRate");
		while(<PACK>) {
			if ($_ !~ /^eNB/ ) { next; }
			if ($_ =~ /QCI1/) { 
				my($enb_id, $cellLocation, $PdcpSduTotalULNum, $PdcpSduLossULNum) = (split(',', $_))[0,6,13,14];
				if ($enb_id eq "$given_NE"){
					my($cell_id, $loc_id) = (split('/', $cellLocation))[0,1];#has duplicate cellId's
					my ($first_num) = $cell_id =~ /(\d+)/;#for cbrs
					if($first_num < 100){
						$status_hash{$enb_id}{$cell_id}{PdcpSduTotalULNum} +=  $PdcpSduTotalULNum;
						$status_hash{$enb_id}{$cell_id}{PdcpSduLossULNum} += $PdcpSduLossULNum;
					}
				}
			}
		}
		close(PACK);
	}

	if (-e "$TempPathDays/$packetLossRate"){
		open (PACK_D, "<$TempPathDays/$packetLossRate");
		while(<PACK_D>) {
			if ($_ !~ /^eNB/ ) { next; }
			if ($_ =~ /QCI1/) { 
				my($enb_id, $cellLocation_D, $PdcpSduTotalULNumD, $PdcpSduLossULNumD) = (split(',', $_))[0,6,13,14];
				if ($enb_id eq "$given_NE"){
					my($cell_id, $loc_id) = (split('/', $cellLocation_D))[0,1];#has duplicate cellId's
					my ($first_num_D) = $cell_id =~ /(\d+)/;#for cbrs
					if($first_num_D < 100){
						$status_hash{$enb_id}{$cell_id}{PdcpSduTotalULNumD} +=  $PdcpSduTotalULNumD;
						$status_hash{$enb_id}{$cell_id}{PdcpSduLossULNumD} += $PdcpSduLossULNumD;
					}
				}
			}
		}
		close(PACK_D);
	}
	
	#EMTC RRC Setup Failure
	if (-e "$TempPath/$emtcRrcConnEst"){
		open (EMTCRRC, "<$TempPath/$emtcRrcConnEst");
		while(<EMTCRRC>) {
			if ($_ !~ /^eNB/ ) { next; }
			my($enb_id, $cellLocation, $eMTC_ConnEstabAtt, $eMTC_ConnEstabSucc) = (split(',', $_))[0,6,7,8];
			if ($enb_id eq "$given_NE"){
				my($cell_id, $loc_id) = (split('/', $cellLocation))[0,1];#has duplicate cellId's
				my ($first_num) = $cell_id =~ /(\d+)/;#for cbrs
				if($first_num < 100){
					$status_hash{$enb_id}{$cell_id}{eMTC_ConnEstabAtt} +=  $eMTC_ConnEstabAtt;
					$status_hash{$enb_id}{$cell_id}{eMTC_ConnEstabSucc} += $eMTC_ConnEstabSucc;
				}
			}
		}
		close(EMTCRRC);
	}

	if (-e "$TempPathDays/$emtcRrcConnEst"){
		open (EMTCRRC_D, "<$TempPathDays/$emtcRrcConnEst");
		while(<EMTCRRC_D>) {
			if ($_ !~ /^eNB/ ) { next; }
			my($enb_id, $cellLocation_D, $eMTC_ConnEstabAttD, $eMTC_ConnEstabSuccD) = (split(',', $_))[0,6,7,8];
			if ($enb_id eq "$given_NE"){
				my($cell_id, $loc_id) = (split('/', $cellLocation_D))[0,1];#has duplicate cellId's
				my ($first_num_D) = $cell_id =~ /(\d+)/;#for cbrs
				if($first_num_D < 100){
					$status_hash{$enb_id}{$cell_id}{eMTC_ConnEstabAttD} +=  $eMTC_ConnEstabAttD;
					$status_hash{$enb_id}{$cell_id}{eMTC_ConnEstabSuccD} += $eMTC_ConnEstabSuccD;
				}
			}
		}
		close(EMTCRRC_D);
	}
	
	#EMTC Context Drop Rate, NUM
	if (-e "$TempPath/$emtcCallDrop"){
		open (EMTCCALL, "<$TempPath/$emtcCallDrop");
		while(<EMTCCALL>) {
			if ($_ !~ /^eNB/ ) { next; }
			my($enb_id, $cellLocation, $eMTC_CallDrop_EccbDspAuditRlcMacCallRelease,$eMTC_CallDrop_EccbRcvResetRequestFromEcmb,$eMTC_CallDrop_EccbRcvCellReleaseIndFromEcmb,$eMTC_CallDrop_EccbRadioLinkFailure,$eMTC_CallDrop_EccbDspAuditMacCallRelease,$eMTC_CallDrop_EccbArqMaxReTransmission,$eMTC_CallDrop_EccbDspAuditRlcCallRelease,$eMTC_CallDrop_EccbTmoutRrcConnectionReconfig,$eMTC_CallDrop_EccbTmoutRrcConnectionReestablish,$eMTC_CallDrop_EccbS1SctpOutOfService) = (split(',', $_))[0,6,7,8,9,10,11,12,13,14,15,16];
			if ($enb_id eq "$given_NE"){
				my($cell_id, $loc_id) = (split('/', $cellLocation))[0,1];#has duplicate cellId's
				my ($first_num) = $cell_id =~ /(\d+)/;#for cbrs
				if($first_num < 100){
					$status_hash{$enb_id}{$cell_id}{eMTC_CallDrop_EccbDspAuditRlcMacCallRelease} +=  $eMTC_CallDrop_EccbDspAuditRlcMacCallRelease;
					$status_hash{$enb_id}{$cell_id}{eMTC_CallDrop_EccbRcvResetRequestFromEcmb} += $eMTC_CallDrop_EccbRcvResetRequestFromEcmb;
					$status_hash{$enb_id}{$cell_id}{eMTC_CallDrop_EccbRcvCellReleaseIndFromEcmb} += $eMTC_CallDrop_EccbRcvCellReleaseIndFromEcmb;
					$status_hash{$enb_id}{$cell_id}{eMTC_CallDrop_EccbRadioLinkFailure} += $eMTC_CallDrop_EccbRadioLinkFailure;
					$status_hash{$enb_id}{$cell_id}{eMTC_CallDrop_EccbDspAuditMacCallRelease} += $eMTC_CallDrop_EccbDspAuditMacCallRelease;
					$status_hash{$enb_id}{$cell_id}{eMTC_CallDrop_EccbArqMaxReTransmission} += $eMTC_CallDrop_EccbArqMaxReTransmission;
					$status_hash{$enb_id}{$cell_id}{eMTC_CallDrop_EccbDspAuditRlcCallRelease} += $eMTC_CallDrop_EccbDspAuditRlcCallRelease;
					$status_hash{$enb_id}{$cell_id}{eMTC_CallDrop_EccbTmoutRrcConnectionReconfig} += $eMTC_CallDrop_EccbTmoutRrcConnectionReconfig;
					$status_hash{$enb_id}{$cell_id}{eMTC_CallDrop_EccbTmoutRrcConnectionReestablish} += $eMTC_CallDrop_EccbTmoutRrcConnectionReestablish;
					$status_hash{$enb_id}{$cell_id}{eMTC_CallDrop_EccbS1SctpOutOfService} += $eMTC_CallDrop_EccbS1SctpOutOfService;
				}
			}
		}
		close(EMTCCALL);
	}

	if (-e "$TempPathDays/$emtcCallDrop"){
		open (EMTCCALL_D, "<$TempPathDays/$emtcCallDrop");
		while(<EMTCCALL_D>) {
			if ($_ !~ /^eNB/ ) { next; }
			my($enb_id, $cellLocation_D, $eMTC_CallDrop_EccbDspAuditRlcMacCallReleaseD,$eMTC_CallDrop_EccbRcvResetRequestFromEcmbD,$eMTC_CallDrop_EccbRcvCellReleaseIndFromEcmbD,$eMTC_CallDrop_EccbRadioLinkFailureD,$eMTC_CallDrop_EccbDspAuditMacCallReleaseD,$eMTC_CallDrop_EccbArqMaxReTransmissionD,$eMTC_CallDrop_EccbDspAuditRlcCallReleaseD,$eMTC_CallDrop_EccbTmoutRrcConnectionReconfigD,$eMTC_CallDrop_EccbTmoutRrcConnectionReestablishD,$eMTC_CallDrop_EccbS1SctpOutOfServiceD) = (split(',', $_))[0,6,7,8,9,10,11,12,13,14,15,16];
			if ($enb_id eq "$given_NE"){
				my($cell_id, $loc_id) = (split('/', $cellLocation_D))[0,1];#has duplicate cellId's
				my ($first_num_D) = $cell_id =~ /(\d+)/;#for cbrs
				if($first_num_D < 100){
					$status_hash{$enb_id}{$cell_id}{eMTC_CallDrop_EccbDspAuditRlcMacCallReleaseD} +=  $eMTC_CallDrop_EccbDspAuditRlcMacCallReleaseD;
					$status_hash{$enb_id}{$cell_id}{eMTC_CallDrop_EccbRcvResetRequestFromEcmbD} += $eMTC_CallDrop_EccbRcvResetRequestFromEcmbD;
					$status_hash{$enb_id}{$cell_id}{eMTC_CallDrop_EccbRcvCellReleaseIndFromEcmbD} += $eMTC_CallDrop_EccbRcvCellReleaseIndFromEcmbD;
					$status_hash{$enb_id}{$cell_id}{eMTC_CallDrop_EccbRadioLinkFailureD} += $eMTC_CallDrop_EccbRadioLinkFailureD;
					$status_hash{$enb_id}{$cell_id}{eMTC_CallDrop_EccbDspAuditMacCallReleaseD} += $eMTC_CallDrop_EccbDspAuditMacCallReleaseD;
					$status_hash{$enb_id}{$cell_id}{eMTC_CallDrop_EccbArqMaxReTransmissionD} += $eMTC_CallDrop_EccbArqMaxReTransmissionD;
					$status_hash{$enb_id}{$cell_id}{eMTC_CallDrop_EccbDspAuditRlcCallReleaseD} += $eMTC_CallDrop_EccbDspAuditRlcCallReleaseD;
					$status_hash{$enb_id}{$cell_id}{eMTC_CallDrop_EccbTmoutRrcConnectionReconfigD} += $eMTC_CallDrop_EccbTmoutRrcConnectionReconfigD;
					$status_hash{$enb_id}{$cell_id}{eMTC_CallDrop_EccbTmoutRrcConnectionReestablishD} += $eMTC_CallDrop_EccbTmoutRrcConnectionReestablishD;
					$status_hash{$enb_id}{$cell_id}{eMTC_CallDrop_EccbS1SctpOutOfServiceD} += $eMTC_CallDrop_EccbS1SctpOutOfServiceD;
				}
			}
		}
		close(EMTCCALL_D);
	}	
	
	#EMTC Context Drop Rate, DEN
	if (-e "$TempPath/$emtcUeS1ConnEst"){
		open (EMTCUE, "<$TempPath/$emtcUeS1ConnEst");
		while(<EMTCUE>) {
			if ($_ !~ /^eNB/ ) { next; }
			my($enb_id, $cellLocation, $eMTC_S1ConnEstabSucc) = (split(',', $_))[0,6,8];
			if ($enb_id eq "$given_NE"){
				my($cell_id, $loc_id) = (split('/', $cellLocation))[0,1];#has duplicate cellId's
				my ($first_num) = $cell_id =~ /(\d+)/;#for cbrs
				if($first_num < 100){
					$status_hash{$enb_id}{$cell_id}{eMTC_S1ConnEstabSucc} +=  $eMTC_S1ConnEstabSucc;
				}
			}
		}
		close(EMTCUE);
	}

	if (-e "$TempPathDays/$emtcUeS1ConnEst"){
		open (EMTCUE_D, "<$TempPathDays/$emtcUeS1ConnEst");
		while(<EMTCUE_D>) {
			if ($_ !~ /^eNB/ ) { next; }
			my($enb_id, $cellLocation_D, $eMTC_S1ConnEstabSuccD,) = (split(',', $_))[0,6,8];
			if ($enb_id eq "$given_NE"){
				my($cell_id, $loc_id) = (split('/', $cellLocation_D))[0,1];#has duplicate cellId's
				my ($first_num_D) = $cell_id =~ /(\d+)/;#for cbrs
				if($first_num_D < 100){
					$status_hash{$enb_id}{$cell_id}{eMTC_S1ConnEstabSuccD} +=  $eMTC_S1ConnEstabSuccD;
	
				}
			}
		}
		close(EMTCUE_D);
	}	
	#NBIOT RRC Setup Failure
	if (-e "$TempPath/$nbiotRrcConnEst"){
		open (NBIOTRRC, "<$TempPath/$nbiotRrcConnEst");
		while(<NBIOTRRC>) {
			if ($_ !~ /^eNB/ ) { next; }
			my($enb_id, $cellLocation, $NBIoT_ConnEstabAtt,$NBIoT_ConnEstabSucc) = (split(',', $_))[0,6,7,8];
			if ($enb_id eq "$given_NE"){
				my($cell_id, $loc_id) = (split('/', $cellLocation))[0,1];#has duplicate cellId's
				$cell_id =~ s/NBIoT_//g;
				my ($first_num) = $cell_id =~ /(\d+)/;#for cbrs
				if(($first_num < 100) && ($NBIoT_ConnEstabAtt ne "")){
					$status_hash{$enb_id}{$cell_id}{NBIoT_ConnEstabAtt} +=  $NBIoT_ConnEstabAtt;
					$status_hash{$enb_id}{$cell_id}{NBIoT_ConnEstabSucc} +=  $NBIoT_ConnEstabSucc;
				}
			}
		}
		close(NBIOTRRC);
	}

	if (-e "$TempPathDays/$nbiotRrcConnEst"){
		open (NBIOTRRC_D, "<$TempPathDays/$nbiotRrcConnEst");
		while(<NBIOTRRC_D>) {
			if ($_ !~ /^eNB/ ) { next; }
			my($enb_id, $cellLocation_D, $NBIoT_ConnEstabAttD,$NBIoT_ConnEstabSuccD) = (split(',', $_))[0,6,7,8];
			if ($enb_id eq "$given_NE"){
				my($cell_id, $loc_id) = (split('/', $cellLocation_D))[0,1];#has duplicate cellId's
				$cell_id =~ s/NBIoT_//g;
				my ($first_num_D) = $cell_id =~ /(\d+)/;#for cbrs
				if(($first_num_D < 100) && ($NBIoT_ConnEstabAttD ne "")){
					$status_hash{$enb_id}{$cell_id}{NBIoT_ConnEstabAttD} +=  $NBIoT_ConnEstabAttD;
					$status_hash{$enb_id}{$cell_id}{NBIoT_ConnEstabSuccD} +=  $NBIoT_ConnEstabSuccD;
				}
			}
		}
		close(NBIOTRRC_D);
	}	
	
	#NBIOT Context Drop Rate
	if (-e "$TempPath/$nbiotCallDrop"){
		open (NBIOTCALL, "<$TempPath/$nbiotCallDrop");
		while(<NBIOTCALL>) {
			if ($_ !~ /^eNB/ ) { next; }
			my($enb_id, $cellLocation,$NBIoT_CallDrop_NccbDspAuditRlcMacCallRelease,$NBIoT_CallDrop_NccbRcvResetRequestFromNcmb,$NBIoT_CallDrop_NccbRcvCellReleaseIndFromNcmb,$NBIoT_CallDrop_NccbRadioLinkFailure,$NBIoT_CallDrop_NccbDspAuditMacCallRelease,$NBIoT_CallDrop_NccbArqMaxReTransmission,$NBIoT_CallDrop_NccbTmoutRrcConnectionReconfig,$NBIoT_CallDrop_NccbTmoutRrcConnectionReestablish,$NBIoT_CallDrop_NccbS1SctpOutOfService) = (split(',', $_))[0,6,7,8,9,10,11,12,14,15,16];
			if ($enb_id eq "$given_NE"){
				my($cell_id, $loc_id) = (split('/', $cellLocation))[0,1];#has duplicate cellId's
				$cell_id =~ s/NBIoT_//g;
				my ($first_num) = $cell_id =~ /(\d+)/;#for cbrs
				if(($first_num < 100) && ($NBIoT_CallDrop_NccbDspAuditRlcMacCallRelease ne "")){
					$status_hash{$enb_id}{$cell_id}{NBIoT_CallDrop_NccbDspAuditRlcMacCallRelease} +=  $NBIoT_CallDrop_NccbDspAuditRlcMacCallRelease;
					$status_hash{$enb_id}{$cell_id}{NBIoT_CallDrop_NccbRcvResetRequestFromNcmb} += $NBIoT_CallDrop_NccbRcvResetRequestFromNcmb;
					$status_hash{$enb_id}{$cell_id}{NBIoT_CallDrop_NccbRcvCellReleaseIndFromNcmb} += $NBIoT_CallDrop_NccbRcvCellReleaseIndFromNcmb;
					$status_hash{$enb_id}{$cell_id}{NBIoT_CallDrop_NccbRadioLinkFailure} += $NBIoT_CallDrop_NccbRadioLinkFailure;
					$status_hash{$enb_id}{$cell_id}{NBIoT_CallDrop_NccbDspAuditMacCallRelease} += $NBIoT_CallDrop_NccbDspAuditMacCallRelease;
					$status_hash{$enb_id}{$cell_id}{NBIoT_CallDrop_NccbArqMaxReTransmission} += $NBIoT_CallDrop_NccbArqMaxReTransmission;
					$status_hash{$enb_id}{$cell_id}{NBIoT_CallDrop_NccbTmoutRrcConnectionReconfig} += $NBIoT_CallDrop_NccbTmoutRrcConnectionReconfig;
					$status_hash{$enb_id}{$cell_id}{NBIoT_CallDrop_NccbTmoutRrcConnectionReestablish} += $NBIoT_CallDrop_NccbTmoutRrcConnectionReestablish;
					$status_hash{$enb_id}{$cell_id}{NBIoT_CallDrop_NccbS1SctpOutOfService} += $NBIoT_CallDrop_NccbS1SctpOutOfService;
				}
			}
		}
		close(NBIOTCALL);
	}

	if (-e "$TempPathDays/$nbiotCallDrop"){
		open (NBIOTCALL_D, "<$TempPathDays/$nbiotCallDrop");
		while(<NBIOTCALL_D>) {
			if ($_ !~ /^eNB/ ) { next; }
			my($enb_id, $cellLocation_D,$NBIoT_CallDrop_NccbDspAuditRlcMacCallReleaseD,$NBIoT_CallDrop_NccbRcvResetRequestFromNcmbD,$NBIoT_CallDrop_NccbRcvCellReleaseIndFromNcmbD,$NBIoT_CallDrop_NccbRadioLinkFailureD,$NBIoT_CallDrop_NccbDspAuditMacCallReleaseD,$NBIoT_CallDrop_NccbArqMaxReTransmissionD,$NBIoT_CallDrop_NccbTmoutRrcConnectionReconfigD,$NBIoT_CallDrop_NccbTmoutRrcConnectionReestablishD,$NBIoT_CallDrop_NccbS1SctpOutOfServiceD) = (split(',', $_))[0,6,7,8,9,10,11,12,14,15,16];
			if ($enb_id eq "$given_NE"){
				my($cell_id, $loc_id) = (split('/', $cellLocation_D))[0,1];#has duplicate cellId's
				$cell_id =~ s/NBIoT_//g;
				my ($first_num_D) = $cell_id =~ /(\d+)/;#for cbrs
				if(($first_num_D < 100) && ($NBIoT_CallDrop_NccbDspAuditRlcMacCallReleaseD ne "")){
					$status_hash{$enb_id}{$cell_id}{NBIoT_CallDrop_NccbDspAuditRlcMacCallReleaseD} +=  $NBIoT_CallDrop_NccbDspAuditRlcMacCallReleaseD;
					$status_hash{$enb_id}{$cell_id}{NBIoT_CallDrop_NccbRcvResetRequestFromNcmbD} += $NBIoT_CallDrop_NccbRcvResetRequestFromNcmbD;
					$status_hash{$enb_id}{$cell_id}{NBIoT_CallDrop_NccbRcvCellReleaseIndFromNcmbD} += $NBIoT_CallDrop_NccbRcvCellReleaseIndFromNcmbD;
					$status_hash{$enb_id}{$cell_id}{NBIoT_CallDrop_NccbRadioLinkFailureD} += $NBIoT_CallDrop_NccbRadioLinkFailureD;
					$status_hash{$enb_id}{$cell_id}{NBIoT_CallDrop_NccbDspAuditMacCallReleaseD} += $NBIoT_CallDrop_NccbDspAuditMacCallReleaseD;
					$status_hash{$enb_id}{$cell_id}{NBIoT_CallDrop_NccbArqMaxReTransmissionD} += $NBIoT_CallDrop_NccbArqMaxReTransmissionD;
					$status_hash{$enb_id}{$cell_id}{NBIoT_CallDrop_NccbTmoutRrcConnectionReconfigD} += $NBIoT_CallDrop_NccbTmoutRrcConnectionReconfigD;
					$status_hash{$enb_id}{$cell_id}{NBIoT_CallDrop_NccbTmoutRrcConnectionReestablishD} += $NBIoT_CallDrop_NccbTmoutRrcConnectionReestablishD;
					$status_hash{$enb_id}{$cell_id}{NBIoT_CallDrop_NccbS1SctpOutOfServiceD} += $NBIoT_CallDrop_NccbS1SctpOutOfServiceD;
				}
			}
		}
		close(NBIOTCALL_D);
	}	
	
	#NBIOT_Context_Drop_Rate, DEN
	if (-e "$TempPath/$nbiotUeS1ConnEst"){
		open (NBIOTUE, "<$TempPath/$nbiotUeS1ConnEst");
		while(<NBIOTUE>) {
			if ($_ !~ /^eNB/ ) { next; }
			my($enb_id, $cellLocation, $NBIoT_S1ConnEstabSucc) = (split(',', $_))[0,6,8];
			if ($enb_id eq "$given_NE"){
				my($cell_id, $loc_id) = (split('/', $cellLocation))[0,1];#has duplicate cellId's
				$cell_id =~ s/NBIoT_//g;
				my ($first_num) = $cell_id =~ /(\d+)/;#for cbrs
				if(($first_num < 100) && ($NBIoT_S1ConnEstabSucc ne "")){
					$status_hash{$enb_id}{$cell_id}{NBIoT_S1ConnEstabSucc} +=  $NBIoT_S1ConnEstabSucc;
				}
			}
		}
		close(NBIOTUE);		
	}

	if (-e "$TempPathDays/$nbiotUeS1ConnEst"){
		open (NBIOTUE_D, "<$TempPathDays/$nbiotUeS1ConnEst");
		while(<NBIOTUE_D>) {
			if ($_ !~ /^eNB/ ) { next; }
			my($enb_id, $cellLocation_D, $NBIoT_S1ConnEstabSuccD) = (split(',', $_))[0,6,8];
			if ($enb_id eq "$given_NE"){
				my($cell_id, $loc_id) = (split('/', $cellLocation_D))[0,1];#has duplicate cellId's
				$cell_id =~ s/NBIoT_//g;				
				my ($first_num_D) = $cell_id =~ /(\d+)/;#for cbrs
				if(($first_num_D < 100) && ($NBIoT_S1ConnEstabSuccD ne "")){
					$status_hash{$enb_id}{$cell_id}{NBIoT_S1ConnEstabSuccD} +=  $NBIoT_S1ConnEstabSuccD;
	
				}
			}
		}
		close(NBIOTUE_D);	
	}	
	print Dumper \%status_hash;
	open (CANDIDATES, ">>$installDir/Logs/candidates_$dateTimeKpi.csv") or die "Can't open file : $installDir/Logs/candidates_$dateTimeKpi.csv\n";
	foreach my $enb_id (keys %status_hash) {
		foreach my $cell_id ( keys %{$status_hash{$enb_id}}) {
			##RRC Setup Failure
			$nm_rrcSetupFail = ($status_hash{$enb_id}{$cell_id}{conn_request} - $status_hash{$enb_id}{$cell_id}{conn_setup});
			$dn_rrcSetupFail = $status_hash{$enb_id}{$cell_id}{conn_request};
			if($dn_rrcSetupFail != 0){
				$rrcSetupFail_rate =($nm_rrcSetupFail / $dn_rrcSetupFail ) * 100;
				#baseline avg
				$nm_rrcSetupFailD = ($status_hash{$enb_id}{$cell_id}{conn_requestD} - $status_hash{$enb_id}{$cell_id}{conn_setupD});
				$dn_rrcSetupFailD = ($status_hash{$enb_id}{$cell_id}{conn_requestD});
				if($dn_rrcSetupFailD != 0){
					$rrcSetupFail_rateD =($nm_rrcSetupFailD / $dn_rrcSetupFailD ) * 100;
					if($rrcSetupFail_rateD != 0){
						#final comparison
						$finalRrcSetupFail = (($rrcSetupFail_rate - $rrcSetupFail_rateD)/$rrcSetupFail_rateD)*100;
						$finalRrcSetupFail = sprintf("%.3f", $finalRrcSetupFail); 
						$rrcSetupFail_rate = sprintf("%.3f", $rrcSetupFail_rate); 
						$rrcSetupFail_rateD = sprintf("%.3f", $rrcSetupFail_rateD); 
						if ($finalRrcSetupFail > $rrcThresh) {
							print (CANDIDATES "$dateCst[0],$cstPrevHour,RRC Setup Failure,$enb_id,$cell_id,$rrcSetupFail_rateD,$rrcSetupFail_rate,$finalRrcSetupFail\n");
						}
					}
				}
			}

			##RRCSetupFailure_DEN
			my $dr_rrcSetFail = ($status_hash{$enb_id}{$cell_id}{conn_request});
			#baseline avg
			my $dr_rrcSetFailD = ($status_hash{$enb_id}{$cell_id}{conn_requestD});
			if($dr_rrcSetFailD != 0){
				#final comparison
				my $finalRrcSetFail = (($dr_rrcSetFail - $dr_rrcSetFailD)/$dr_rrcSetFailD)*100;
				$finalRrcSetFail = sprintf("%.3f", $finalRrcSetFail); 
				$dr_rrcSetFailD = sprintf("%.3f", $dr_rrcSetFailD); 
				$dr_rrcSetFail = sprintf("%.3f", $dr_rrcSetFail); 
				print "finalRrcSetFail=$finalRrcSetFail\n";
				if ($finalRrcSetFail > $rrcThresh) {
					print (CANDIDATES "$dateCst[0],$cstPrevHour,RRCSetupFailure_DEN,$enb_id,$cell_id,$dr_rrcSetFailD,$dr_rrcSetFail,$finalRrcSetFail\n");
				}
			}

			##DL UPT
			my $nm_dlUpt = (($status_hash{$enb_id}{$cell_id}{IpThruThpVoDLByte}) * 8)/1000;
			my $dr_dlUpt = ($status_hash{$enb_id}{$cell_id}{IpThruThpDLTime})/1000;
			if($dr_dlUpt != 0){
				my $dlUptFail_rate =($nm_dlUpt / $dr_dlUpt ) * 100;
				#baseline avg
				my $nm_dlUptD = ((($status_hash{$enb_id}{$cell_id}{IpThruThpVoDLByteD}) * 8)/1000);
				my $dr_dlUptD = (($status_hash{$enb_id}{$cell_id}{IpThruThpDLTimeD})/1000);
				if($dr_dlUptD != 0){
					my $dlUptFail_rateD =($nm_dlUptD / $dr_dlUptD ) * 100;
					if($dlUptFail_rateD != 0){
						#final comparison
						my $finalDlUptFail = (($dlUptFail_rate - $dlUptFail_rateD)/$dlUptFail_rateD)*100;
						$finalDlUptFail = sprintf("%.3f", $finalDlUptFail); 
						$dlUptFail_rateD = sprintf("%.3f", $dlUptFail_rateD); 
						$dlUptFail_rate = sprintf("%.3f", $dlUptFail_rate); 
						print "finalDlUptFail=$finalDlUptFail\n";
						if ($finalDlUptFail < $airRLCThresh) {
							print (CANDIDATES "$dateCst[0],$cstPrevHour,DL UPT,$enb_id,$cell_id,$dlUptFail_rateD,$dlUptFail_rate,$finalDlUptFail\n");
						}
					}
				}
			}

			#X2HO FailRate
			my $nm_X2HO = ($status_hash{$enb_id}{$cell_id}{InterX2OutAtt})-($status_hash{$enb_id}{$cell_id}{InterX2OutSucc}) ;
			my $dr_X2HO = ($status_hash{$enb_id}{$cell_id}{InterX2OutAtt});
			if($dr_X2HO != 0){
				my $X2HOFail_rate =($nm_X2HO / $dr_X2HO ) * 100;
				#baseline avg
				my $nm_X2HOD = (($status_hash{$enb_id}{$cell_id}{InterX2OutAttD})-($status_hash{$enb_id}{$cell_id}{InterX2OutSuccD})) ;
				my $dr_X2HOD = ($status_hash{$enb_id}{$cell_id}{InterX2OutAttD});
				if($dr_X2HOD != 0){
					my $X2HOFail_rateD =($nm_X2HOD / $dr_X2HOD ) * 100;
					if($X2HOFail_rateD != 0){
						#final comparison
						my $finalX2HOFail = (($X2HOFail_rate - $X2HOFail_rateD)/$X2HOFail_rateD)*100;
						$finalX2HOFail = sprintf("%.3f", $finalX2HOFail); 
						$X2HOFail_rateD = sprintf("%.3f", $X2HOFail_rateD); 
						$X2HOFail_rate = sprintf("%.3f", $X2HOFail_rate);
						print "finalX2HOFail=$finalX2HOFail\n";
						if ($finalX2HOFail > $x2HoThresh) {
							print (CANDIDATES "$dateCst[0],$cstPrevHour,X2HO FailRate,$enb_id,$cell_id,$X2HOFail_rateD,$X2HOFail_rate,$finalX2HOFail\n");
						}
					}
				}
			}
			#ENDC Attempts FR1
			my $nm_endcFr1 = ($status_hash{$enb_id}{$cell_id}{EnDc_AddAtt});
			#baseline avg
			my $nm_endcFr1D = ($status_hash{$enb_id}{$cell_id}{EnDc_AddAttD});
			if($nm_endcFr1D != 0){
				#final comparison
				my $finalendcFr1DFail = (($nm_endcFr1 - $nm_endcFr1D)/$nm_endcFr1D)*100;
				$finalendcFr1DFail = sprintf("%.3f", $finalendcFr1DFail); 
				$nm_endcFr1D = sprintf("%.3f", $nm_endcFr1D); 
				$nm_endcFr1 = sprintf("%.3f", $nm_endcFr1);
				print "finalendcFr1DFail=$finalendcFr1DFail\n";
				# $nth = substr($enb_id, 4, 1);
				if ($finalendcFr1DFail > $endcAddThresh) {
					print (CANDIDATES "$dateCst[0],$cstPrevHour,ENDC Attempts FR1,$enb_id,$cell_id,$nm_endcFr1D,$nm_endcFr1,$finalendcFr1DFail\n");
				}
			}
			
			#ENDC Attempts FR2
			my $nm_endcFr2 = ($status_hash{$enb_id}{$cell_id}{EnDc_AddAtt_fr2});
			#baseline avg
			my $nm_endcFr2D = ($status_hash{$enb_id}{$cell_id}{EnDc_AddAttD_fr2});
			if($nm_endcFr2D != 0){
				#final comparison
				my $finalendcFr2DFail = (($nm_endcFr2 - $nm_endcFr2D)/$nm_endcFr2D)*100;
				$finalendcFr2DFail = sprintf("%.3f", $finalendcFr2DFail); 
				$nm_endcFr2D = sprintf("%.3f", $nm_endcFr2D); 
				$nm_endcFr2 = sprintf("%.3f", $nm_endcFr2);
				print "finalendcFr2DFail=$finalendcFr2DFail\n";
				# $nth = substr($enb_id, 4, 1);
				if ($finalendcFr2DFail > $endcAddThresh) {
					print (CANDIDATES "$dateCst[0],$cstPrevHour,ENDC Attempts FR2,$enb_id,$cell_id,$nm_endcFr2D,$nm_endcFr2,$finalendcFr2DFail\n");
				}
			}

			#SEA_ENDC_SCG_Failure
			my $nm_endcScg = ($status_hash{$enb_id}{$cell_id}{EnDc_InternalResouFail} + $status_hash{$enb_id}{$cell_id}{EnDc_UeContxtRel} + $status_hash{$enb_id}{$cell_id}{EnDc_DcOverallTO} + $status_hash{$enb_id}{$cell_id}{EnDc_BearerNotSupp} + $status_hash{$enb_id}{$cell_id}{EnDc_RadioConnection_UeLost} + $status_hash{$enb_id}{$cell_id}{EnDc_t310_Expiry} + $status_hash{$enb_id}{$cell_id}{EnDc_SCG} + $status_hash{$enb_id}{$cell_id}{EnDc_randomAccessProblem} + $status_hash{$enb_id}{$cell_id}{EnDc_MaxNumRetx} + $status_hash{$enb_id}{$cell_id}{EnDc_IntegrityFailure} + $status_hash{$enb_id}{$cell_id}{EnDc_reconfigFailure} + $status_hash{$enb_id}{$cell_id}{EnDc_UeLost} ) ;
			my $dr_endcScg = ($status_hash{$enb_id}{$cell_id}{EnDc_AddAtt});
			if($dr_endcScg != 0){
				my $scgFail_rate =($nm_endcScg / $dr_endcScg ) * 100;
				#baseline avg
				my $nm_endcScgD = ($status_hash{$enb_id}{$cell_id}{EnDc_InternalResouFailD} + $status_hash{$enb_id}{$cell_id}{EnDc_UeContxtRelD} + $status_hash{$enb_id}{$cell_id}{EnDc_DcOverallTOD} + $status_hash{$enb_id}{$cell_id}{EnDc_BearerNotSuppD} + $status_hash{$enb_id}{$cell_id}{EnDc_RadioConnection_UeLostD} + $status_hash{$enb_id}{$cell_id}{EnDc_t310_ExpiryD} + $status_hash{$enb_id}{$cell_id}{EnDc_SCGD} + $status_hash{$enb_id}{$cell_id}{EnDc_randomAccessProblemD} + $status_hash{$enb_id}{$cell_id}{EnDc_MaxNumRetxD} + $status_hash{$enb_id}{$cell_id}{EnDc_IntegrityFailureD} + $status_hash{$enb_id}{$cell_id}{EnDc_reconfigFailureD} + $status_hash{$enb_id}{$cell_id}{EnDc_UeLostD} ) ;
				my $dr_endcScgD = ($status_hash{$enb_id}{$cell_id}{EnDc_AddAttD});
				if($dr_endcScgD != 0){
					my $scgFail_rateD =($nm_endcScgD / $dr_endcScgD ) * 100;
					if($scgFail_rateD != 0){
						#final comparison
						my $finalendcscgFail = (($scgFail_rate - $scgFail_rateD)/$scgFail_rateD)*100;
						$finalendcscgFail = sprintf("%.3f", $finalendcscgFail); 
						$scgFail_rateD = sprintf("%.3f", $scgFail_rateD); 
						$scgFail_rate = sprintf("%.3f", $scgFail_rate);
						print "finalendcscgFail=$finalendcscgFail\n";
						if ($finalendcscgFail > $endcRelThresh) {
							print (CANDIDATES "$dateCst[0],$cstPrevHour,SEA_ENDC_SCG_Failure_FR1,$enb_id,$cell_id,$scgFail_rateD,$scgFail_rate,$finalendcscgFail\n");
						}
					}
				}
			}
			
			#SEA_ENDC_SCG_Failure_FR2
			my $nm_endcScg_fr2 = ($status_hash{$enb_id}{$cell_id}{EnDc_InternalResouFail_fr2} + $status_hash{$enb_id}{$cell_id}{EnDc_UeContxtRel_fr2} + $status_hash{$enb_id}{$cell_id}{EnDc_DcOverallTO_fr2} + $status_hash{$enb_id}{$cell_id}{EnDc_BearerNotSupp_fr2} + $status_hash{$enb_id}{$cell_id}{EnDc_RadioConnection_UeLost_fr2} + $status_hash{$enb_id}{$cell_id}{EnDc_t310_Expiry_fr2} + $status_hash{$enb_id}{$cell_id}{EnDc_SCG_fr2} + $status_hash{$enb_id}{$cell_id}{EnDc_randomAccessProblem_fr2} + $status_hash{$enb_id}{$cell_id}{EnDc_MaxNumRetx_fr2} + $status_hash{$enb_id}{$cell_id}{EnDc_IntegrityFailure_fr2} + $status_hash{$enb_id}{$cell_id}{EnDc_reconfigFailure_fr2} + $status_hash{$enb_id}{$cell_id}{EnDc_UeLost_fr2} ) ;
			my $dr_endcScg_fr2 = ($status_hash{$enb_id}{$cell_id}{EnDc_AddAtt_fr2});
			if($dr_endcScg_fr2 != 0){
				my $scgFail_rate_fr2 =($nm_endcScg_fr2 / $dr_endcScg_fr2 ) * 100;
				#baseline avg
				my $nm_endcScgD_fr2 = ($status_hash{$enb_id}{$cell_id}{EnDc_InternalResouFailD_fr2} + $status_hash{$enb_id}{$cell_id}{EnDc_UeContxtRelD_fr2} + $status_hash{$enb_id}{$cell_id}{EnDc_DcOverallTOD_fr2} + $status_hash{$enb_id}{$cell_id}{EnDc_BearerNotSuppD_fr2} + $status_hash{$enb_id}{$cell_id}{EnDc_RadioConnection_UeLostD_fr2} + $status_hash{$enb_id}{$cell_id}{EnDc_t310_ExpiryD_fr2} + $status_hash{$enb_id}{$cell_id}{EnDc_SCGD_fr2} + $status_hash{$enb_id}{$cell_id}{EnDc_randomAccessProblemD_fr2} + $status_hash{$enb_id}{$cell_id}{EnDc_MaxNumRetxD_fr2} + $status_hash{$enb_id}{$cell_id}{EnDc_IntegrityFailureD_fr2} + $status_hash{$enb_id}{$cell_id}{EnDc_reconfigFailureD_fr2} + $status_hash{$enb_id}{$cell_id}{EnDc_UeLostD_fr2} ) ;
				my $dr_endcScgD_fr2 = ($status_hash{$enb_id}{$cell_id}{EnDc_AddAttD_fr2});
				if($dr_endcScgD_fr2 != 0){
					my $scgFail_rateD_fr2 =($nm_endcScgD_fr2 / $dr_endcScgD_fr2 ) * 100;
					if($scgFail_rateD_fr2 != 0){
						#final comparison
						my $finalendcscgFail_fr2 = (($scgFail_rate_fr2 - $scgFail_rateD_fr2)/$scgFail_rateD_fr2)*100;
						$finalendcscgFail_fr2 = sprintf("%.3f", $finalendcscgFail_fr2); 
						$scgFail_rateD_fr2 = sprintf("%.3f", $scgFail_rateD_fr2); 
						$scgFail_rate_fr2 = sprintf("%.3f", $scgFail_rate_fr2);
						print "finalendcscgFail_fr2=$finalendcscgFail_fr2\n";
						if ($finalendcscgFail_fr2 > $endcRelThresh) {
							print (CANDIDATES "$dateCst[0],$cstPrevHour,SEA_ENDC_SCG_Failure_FR2,$enb_id,$cell_id,$scgFail_rateD_fr2,$scgFail_rate_fr2,$finalendcscgFail_fr2\n");
						}
					}
				}
			}
			
			#VOLTE UL PDCP Packet Loss Rate
			my $nm_packetLoss = ($status_hash{$enb_id}{$cell_id}{PdcpSduLossULNum});
			my $dr_packetLoss = ($status_hash{$enb_id}{$cell_id}{PdcpSduTotalULNum});
			if($dr_packetLoss != 0){
				my $packetLossFail_rate =($nm_packetLoss / $dr_packetLoss ) * 100;
				#baseline avg
				my $nm_packetLossD = ($status_hash{$enb_id}{$cell_id}{PdcpSduLossULNumD});
				my $dr_packetLossD = ($status_hash{$enb_id}{$cell_id}{PdcpSduTotalULNumD});
				if($dr_packetLossD != 0){
					my $packetLossFail_rateD =($nm_packetLossD / $dr_packetLossD ) * 100;
					if($packetLossFail_rateD != 0){
						#final comparison
						my $finalpacketLossFail = (($packetLossFail_rate - $packetLossFail_rateD)/$packetLossFail_rateD)*100;
						$packetLossFail_rate = sprintf("%.3f", $packetLossFail_rate); 
						$packetLossFail_rateD = sprintf("%.3f", $packetLossFail_rateD); 
						$finalpacketLossFail = sprintf("%.3f", $finalpacketLossFail);
						print "finalpacketLossFail=$finalpacketLossFail\n";
						if ($finalpacketLossFail > $packetLossThresh) {
							print (CANDIDATES "$dateCst[0],$cstPrevHour,Packet Loss Rate,$enb_id,$cell_id,$packetLossFail_rateD,$packetLossFail_rate,$finalpacketLossFail\n");
						}
					}
				}
			}
			
			#EMTC RRC Setup Failure
			if(exists ($status_hash{$enb_id}{$cell_id}{eMTC_ConnEstabAtt}) ne ""){
			my $nm_emtcRrc = ($status_hash{$enb_id}{$cell_id}{eMTC_ConnEstabAtt} - $status_hash{$enb_id}{$cell_id}{eMTC_ConnEstabSucc});
			my $dr_emtcRrc = ($status_hash{$enb_id}{$cell_id}{eMTC_ConnEstabAtt});
			if( $dr_emtcRrc != 0 ){
				my $emtcRrcFail_rate =($nm_emtcRrc / $dr_emtcRrc ) * 100;
				#baseline avg
				my $nm_emtcRrcD = ($status_hash{$enb_id}{$cell_id}{eMTC_ConnEstabAttD} - $status_hash{$enb_id}{$cell_id}{eMTC_ConnEstabSuccD});
				my $dr_emtcRrcD = ($status_hash{$enb_id}{$cell_id}{eMTC_ConnEstabAttD});
				if($dr_emtcRrcD != 0){
					my $emtcRrcFail_rateD =($nm_emtcRrcD / $dr_emtcRrcD ) * 100;
					if($emtcRrcFail_rateD != 0){
						#final comparison
						my $finalemtcRrcFail = (($emtcRrcFail_rate - $emtcRrcFail_rateD)/$emtcRrcFail_rateD)*100;
						$emtcRrcFail_rate = sprintf("%.3f", $emtcRrcFail_rate); 
						$emtcRrcFail_rateD = sprintf("%.3f", $emtcRrcFail_rateD); 
						$finalemtcRrcFail = sprintf("%.3f", $finalemtcRrcFail);
						print "finalemtcRrcFail=$finalemtcRrcFail\n";
						if ($finalemtcRrcFail > $packetLossThresh) {
							print (CANDIDATES "$dateCst[0],$cstPrevHour,EMTC RRC Setup Failure,$enb_id,$cell_id,$emtcRrcFail_rateD,$emtcRrcFail_rate,$finalemtcRrcFail\n");
						}
					}
				}
			}
			}

			#EMTC Context Drop Rate
			if (exists ($status_hash{$enb_id}{$cell_id}{eMTC_CallDrop_EccbDspAuditRlcMacCallRelease}) ne "" ){
			my $nm_emtcContDrop = ($status_hash{$enb_id}{$cell_id}{eMTC_CallDrop_EccbDspAuditRlcMacCallRelease}+ $status_hash{$enb_id}{$cell_id}{eMTC_CallDrop_EccbRcvResetRequestFromEcmb} + $status_hash{$enb_id}{$cell_id}{eMTC_CallDrop_EccbRcvCellReleaseIndFromEcmb} + $status_hash{$enb_id}{$cell_id}{eMTC_CallDrop_EccbRadioLinkFailure} + $status_hash{$enb_id}{$cell_id}{eMTC_CallDrop_EccbDspAuditMacCallRelease} + $status_hash{$enb_id}{$cell_id}{eMTC_CallDrop_EccbArqMaxReTransmission} + $status_hash{$enb_id}{$cell_id}{eMTC_CallDrop_EccbDspAuditRlcCallRelease} + $status_hash{$enb_id}{$cell_id}{eMTC_CallDrop_EccbTmoutRrcConnectionReconfig} + $status_hash{$enb_id}{$cell_id}{eMTC_CallDrop_EccbTmoutRrcConnectionReestablish} + $status_hash{$enb_id}{$cell_id}{eMTC_CallDrop_EccbS1SctpOutOfService});
			my $dr_emtcContDrop = ($status_hash{$enb_id}{$cell_id}{eMTC_S1ConnEstabSucc});
            if($dr_emtcContDrop != 0){
				my $emtcContDropFail_rate =($nm_emtcContDrop / $dr_emtcContDrop ) * 100;
				#baseline avg
				my $nm_emtcContDropD = ($status_hash{$enb_id}{$cell_id}{eMTC_CallDrop_EccbDspAuditRlcMacCallReleaseD}+ $status_hash{$enb_id}{$cell_id}{eMTC_CallDrop_EccbRcvResetRequestFromEcmbD} + $status_hash{$enb_id}{$cell_id}{eMTC_CallDrop_EccbRcvCellReleaseIndFromEcmbD} + $status_hash{$enb_id}{$cell_id}{eMTC_CallDrop_EccbRadioLinkFailureD} + $status_hash{$enb_id}{$cell_id}{eMTC_CallDrop_EccbDspAuditMacCallReleaseD} + $status_hash{$enb_id}{$cell_id}{eMTC_CallDrop_EccbArqMaxReTransmissionD} + $status_hash{$enb_id}{$cell_id}{eMTC_CallDrop_EccbDspAuditRlcCallReleaseD} + $status_hash{$enb_id}{$cell_id}{eMTC_CallDrop_EccbTmoutRrcConnectionReconfigD} + $status_hash{$enb_id}{$cell_id}{eMTC_CallDrop_EccbTmoutRrcConnectionReestablishD} + $status_hash{$enb_id}{$cell_id}{eMTC_CallDrop_EccbS1SctpOutOfServiceD});
				my $dr_emtcContDropD = ($status_hash{$enb_id}{$cell_id}{eMTC_S1ConnEstabSuccD});
				if($dr_emtcContDropD != 0){
					my $emtcContDropFail_rateD =($nm_emtcContDropD / $dr_emtcContDropD ) * 100;
					if($emtcContDropFail_rateD != 0){
						#final comparison
						my $finalemtcContDropFail = (($emtcContDropFail_rate - $emtcContDropFail_rateD)/$emtcContDropFail_rateD)*100;
						$emtcContDropFail_rate = sprintf("%.3f", $emtcContDropFail_rate); 
						$emtcContDropFail_rateD = sprintf("%.3f", $emtcContDropFail_rateD); 
						$finalemtcContDropFail = sprintf("%.3f", $finalemtcContDropFail);
						print "finalemtcContDropFail=$finalemtcContDropFail\n";
						if ($finalemtcContDropFail > $emtcContDropThresh) {
							print (CANDIDATES "$dateCst[0],$cstPrevHour,EMTC Context Drop Rate,$enb_id,$cell_id,$emtcContDropFail_rateD,$emtcContDropFail_rate,$finalemtcContDropFail\n");
						}
					}
				}
			}
			}

			#NBIOT RRC Setup Failure
			if (exists ($status_hash{$enb_id}{$cell_id}{NBIoT_ConnEstabAtt}) ne ""){

			my $nm_nbiotRrc = ($status_hash{$enb_id}{$cell_id}{NBIoT_ConnEstabAtt})-($status_hash{$enb_id}{$cell_id}{NBIoT_ConnEstabSucc});
			my $dr_nbiotRrc = ($status_hash{$enb_id}{$cell_id}{NBIoT_ConnEstabAtt});
			if($dr_nbiotRrc != 0){
				my $nbiotRrcFail_rate =($nm_nbiotRrc / $dr_nbiotRrc ) * 100;
				#baseline avg
				my $nm_nbiotRrcD = ($status_hash{$enb_id}{$cell_id}{NBIoT_ConnEstabAttD})-($status_hash{$enb_id}{$cell_id}{NBIoT_ConnEstabSuccD});
				my $dr_nbiotRrcD = ($status_hash{$enb_id}{$cell_id}{NBIoT_ConnEstabAttD});
				if($dr_nbiotRrcD != 0){
					my $nbiotRrcFail_rateD =($nm_nbiotRrcD / $dr_nbiotRrcD ) * 100;
					if($nbiotRrcFail_rateD != 0){
						#final comparison
						my $finalnbiotRrcFail = (($nbiotRrcFail_rate - $nbiotRrcFail_rateD)/$nbiotRrcFail_rateD)*100;
						$nbiotRrcFail_rate = sprintf("%.3f", $nbiotRrcFail_rate); 
						$nbiotRrcFail_rateD = sprintf("%.3f", $nbiotRrcFail_rateD); 
						$finalnbiotRrcFail = sprintf("%.3f", $finalnbiotRrcFail);
						print "finalnbiotRrcFail=$finalnbiotRrcFail\n";
						if ($finalnbiotRrcFail > $nbiotRrcSetupThresh) {
							print (CANDIDATES "$dateCst[0],$cstPrevHour,NBIOT RRC Setup Failure,$enb_id,$cell_id,$nbiotRrcFail_rateD,$nbiotRrcFail_rate,$finalnbiotRrcFail\n");
						}
					}
				}
			}
			}
			
			#NBIOT Context Drop Rate
			if(exists ($status_hash{$enb_id}{$cell_id}{NBIoT_CallDrop_NccbDspAuditRlcMacCallRelease}) ne ""){
			my $nm_nbiotContDrop = ($status_hash{$enb_id}{$cell_id}{NBIoT_CallDrop_NccbDspAuditRlcMacCallRelease}+ $status_hash{$enb_id}{$cell_id}{NBIoT_CallDrop_NccbRcvResetRequestFromNcmb} + $status_hash{$enb_id}{$cell_id}{NBIoT_CallDrop_NccbRcvCellReleaseIndFromNcmb} + $status_hash{$enb_id}{$cell_id}{NBIoT_CallDrop_NccbRadioLinkFailure} + $status_hash{$enb_id}{$cell_id}{NBIoT_CallDrop_NccbDspAuditMacCallRelease} + $status_hash{$enb_id}{$cell_id}{NBIoT_CallDrop_NccbArqMaxReTransmission} + $status_hash{$enb_id}{$cell_id}{NBIoT_CallDrop_NccbTmoutRrcConnectionReconfig} + $status_hash{$enb_id}{$cell_id}{NBIoT_CallDrop_NccbTmoutRrcConnectionReestablish} + $status_hash{$enb_id}{$cell_id}{NBIoT_CallDrop_NccbS1SctpOutOfService});
			my $dr_nbiotContDrop = ($status_hash{$enb_id}{$cell_id}{NBIoT_S1ConnEstabSucc});
			if($dr_nbiotContDrop != 0){
				my $nbiotContDropFail_rate =($nm_nbiotContDrop / $dr_nbiotContDrop ) * 100;
				#baseline avg
				my $nm_nbiotContDropD = ($status_hash{$enb_id}{$cell_id}{NBIoT_CallDrop_NccbDspAuditRlcMacCallReleaseD}+ $status_hash{$enb_id}{$cell_id}{NBIoT_CallDrop_NccbRcvResetRequestFromNcmbD} + $status_hash{$enb_id}{$cell_id}{NBIoT_CallDrop_NccbRcvCellReleaseIndFromNcmbD} + $status_hash{$enb_id}{$cell_id}{NBIoT_CallDrop_NccbRadioLinkFailureD} + $status_hash{$enb_id}{$cell_id}{NBIoT_CallDrop_NccbDspAuditMacCallReleaseD} + $status_hash{$enb_id}{$cell_id}{NBIoT_CallDrop_NccbArqMaxReTransmissionD} + $status_hash{$enb_id}{$cell_id}{NBIoT_CallDrop_NccbTmoutRrcConnectionReconfigD} + $status_hash{$enb_id}{$cell_id}{NBIoT_CallDrop_NccbTmoutRrcConnectionReestablishD} + $status_hash{$enb_id}{$cell_id}{NBIoT_CallDrop_NccbS1SctpOutOfServiceD});
				my $dr_nbiotContDropD = ($status_hash{$enb_id}{$cell_id}{NBIoT_S1ConnEstabSuccD});
				if($dr_nbiotContDropD != 0){
					my $nbiotContDropFail_rateD =($nm_nbiotContDropD / $dr_nbiotContDropD ) * 100;
					if($nbiotContDropFail_rateD != 0){
						#final comparison
						my $finalnbiotContDropFail = (($nbiotContDropFail_rate - $nbiotContDropFail_rateD)/$nbiotContDropFail_rateD)*100;
						$nbiotContDropFail_rate = sprintf("%.3f", $nbiotContDropFail_rate); 
						$nbiotContDropFail_rateD = sprintf("%.3f", $nbiotContDropFail_rateD); 
						$finalnbiotContDropFail = sprintf("%.3f", $finalnbiotContDropFail);
						print "finalnbiotContDropFail=$finalnbiotContDropFail\n";
						if ($finalnbiotContDropFail > $nbiotContDropThresh) {
							print (CANDIDATES "$dateCst[0],$cstPrevHour,NBIOT Context Drop Rate,$enb_id,$cell_id,$nbiotContDropFail_rateD,$nbiotContDropFail_rate,$finalnbiotContDropFail\n");
						}
					}
				}
			}
			}			
		}
	}

	close(CANDIDATES);
}

sub rach_thruput{
	#S5NR_DLUserPerceivedTput_Mbps
	if (-e "$TempPath/$dl_ueThroughput_5gFile") {
		open (DLUE, "<$TempPath/$dl_ueThroughput_5gFile");
		while(<DLUE>) {
			if ($_ !~ /^$type/ ) { next; }
			my($du_id_rach, $NE_name, $cellLocation, $DLUeThruVol, $DLUeThruTime) = (split(',', $_))[0,2,6,8,9];
			# if ($NE_name eq "$given_NE"){
			if (index($NE_name, $given_NE) != -1) {
				#my $cell_id_rach =~ s/[^0-9]//g;
				my($cell_id_rach, $loc_id) = (split('/', $cellLocation))[0,1];#has duplicate cell ID's
				#print "DLUE=$cell_id_rach\n";
				$status_hashTp5g{$du_id_rach}{$cell_id_rach}{DLUeThruVol} += $DLUeThruVol;
				$status_hashTp5g{$du_id_rach}{$cell_id_rach}{DLUeThruTime} += $DLUeThruTime;
			}
		}
		close(DLUE);
	}

	if (-e "$TempPathDays/$dl_ueThroughput_5gFile") {
		open (DLUE_D, "<$TempPathDays/$dl_ueThroughput_5gFile");
		while(<DLUE_D>) {
			if ($_ !~ /^$type/ ) { next; }
			my($du_id_rach, $NE_nameD, $cellLocationD, $DLUeThruVolD, $DLUeThruTimeD) = (split(',', $_))[0,2,6,8,9];
			# if ($du_id_rach eq "$given_NE"){
			  if (index($NE_nameD, $given_NE) != -1) {
				#my $cell_id_rach =~ s/[^0-9]//g;
				my($cell_id_rach, $loc_id) = (split('/', $cellLocationD))[0,1];#has duplicate cell ID's
				$status_hashTp5g{$du_id_rach}{$cell_id_rach}{DLUeThruVolD} += $DLUeThruVolD;
				$status_hashTp5g{$du_id_rach}{$cell_id_rach}{DLUeThruTimeD} += $DLUeThruTimeD;
			}
		}
		close(DLUE_D);
	}

	#S5NR_ULUserPerceivedTput_Mbps
	if (-e "$TempPath/$ul_UeThroughput_5gFile") {
		open (ULUE, "<$TempPath/$ul_UeThroughput_5gFile");
		while(<ULUE>) {
			if ($_ !~ /^$type/ ) { next; }
			my($du_id_rach, $NE_name, $cellLocation, $ULUeThruVol, $ULUeThruTime) = (split(',', $_))[0,2,6,8,9];
			# if ($du_id_rach eq "$given_NE"){
			if (index($NE_name, $given_NE) != -1) {
				#my $cell_id_rach =~ s/[^0-9]//g;
				my($cell_id_rach, $loc_id) = (split('/', $cellLocation))[0,1];#has duplicate cell ID's
				$status_hashTp5g{$du_id_rach}{$cell_id_rach}{ULUeThruVol} +=  $ULUeThruVol;
				$status_hashTp5g{$du_id_rach}{$cell_id_rach}{ULUeThruTime} += $ULUeThruTime;
			}
		}
		close(ULUE);
	}

	if (-e "$TempPathDays/$ul_UeThroughput_5gFile") {
		open (ULUE_D, "<$TempPathDays/$ul_UeThroughput_5gFile");
		while(<ULUE_D>) {
			if ($_ !~ /^$type/ ) { next; }
			my($du_id_rach, $NE_nameD, $cellLocationD, $ULUeThruVolD, $ULUeThruTimeD) = (split(',', $_))[0,2,6,8,9];
			# if ($du_id_rach eq "$given_NE"){
			if (index($NE_nameD, $given_NE) != -1) {
				#my $cell_id_rach =~ s/[^0-9]//g;
				my($cell_id_rach, $loc_id) = (split('/', $cellLocationD))[0,1];#has duplicate cell ID's
				$status_hashTp5g{$du_id_rach}{$cell_id_rach}{ULUeThruVolD} +=  $ULUeThruVolD;
				$status_hashTp5g{$du_id_rach}{$cell_id_rach}{ULUeThruTimeD} += $ULUeThruTimeD;
			}
		}
		close(ULUE_D);
	}
	
	#S5NR_RACH_SR%
	if (-e "$TempPath/$prach_nrBeam_5gFile") {
		open (PRACHBEAM, "<$TempPath/$prach_nrBeam_5gFile");
		while(<PRACHBEAM>) {
			if ($_ !~ /^$type/ ) { next; }
			my($du_id_rach, $NE_name, $cellLocation, $RachPreambleAPerBeam, $RachPreambleACFRAPerBeam, $NumMSG3CFRAPerBeam, $NumMSG5PerBeam, $RachPreambleBPerBeam) = (split(',', $_))[0,2,6,7,9,12,13,16];
			# if ($du_id_rach eq "$given_NE"){
			if (index($NE_name, $given_NE) != -1) {
				#my $cell_id_rach =~ s/[^0-9]//g;
				my($cell_id_rach, $loc_id) = (split('/', $cellLocation))[0,1];#has duplicate cell ID's
				$status_hashTp5g{$du_id_rach}{$cell_id_rach}{RachPreambleAPerBeam} += $RachPreambleAPerBeam;
				$status_hashTp5g{$du_id_rach}{$cell_id_rach}{RachPreambleACFRAPerBeam} += $RachPreambleACFRAPerBeam;
				$status_hashTp5g{$du_id_rach}{$cell_id_rach}{NumMSG3CFRAPerBeam} += $NumMSG3CFRAPerBeam;
				$status_hashTp5g{$du_id_rach}{$cell_id_rach}{NumMSG5PerBeam} += $NumMSG5PerBeam;
				$status_hashTp5g{$du_id_rach}{$cell_id_rach}{RachPreambleBPerBeam} += $RachPreambleBPerBeam;
			}
		}
		close(PRACHBEAM);
	}


	if (-e "$TempPathDays/$prach_nrBeam_5gFile") {
		open (PRACHBEAM_D, "<$TempPathDays/$prach_nrBeam_5gFile");
		while(<PRACHBEAM_D>) {
			if ($_ !~ /^$type/ ) { next; }
			my($du_id_rach, $NE_nameD,$cellLocationD, $RachPreambleAPerBeamD, $RachPreambleACFRAPerBeamD, $NumMSG3CFRAPerBeamD, $NumMSG5PerBeamD, $RachPreambleBPerBeamD) = (split(',', $_))[0,2,6,7,9,12,13,16];
			# if ($du_id_rach eq "$given_NE"){
			if (index($NE_nameD, $given_NE) != -1) {
				#my $cell_id_rach =~ s/[^0-9]//g;
				my($cell_id_rach, $loc_id) = (split('/', $cellLocationD))[0,1];#has duplicate cell ID's
				$status_hashTp5g{$du_id_rach}{$cell_id_rach}{RachPreambleAPerBeamD} += $RachPreambleAPerBeamD;
				$status_hashTp5g{$du_id_rach}{$cell_id_rach}{RachPreambleACFRAPerBeamD} += $RachPreambleACFRAPerBeamD;
				$status_hashTp5g{$du_id_rach}{$cell_id_rach}{NumMSG3CFRAPerBeamD} += $NumMSG3CFRAPerBeamD;
				$status_hashTp5g{$du_id_rach}{$cell_id_rach}{NumMSG5PerBeamD} += $NumMSG5PerBeamD;
				$status_hashTp5g{$du_id_rach}{$cell_id_rach}{RachPreambleBPerBeamD} += $RachPreambleBPerBeamD;
			}
		}
		close(PRACHBEAM_D);
	}
	print Dumper \%status_hashTp5g;
	open (CANDIDATES, ">>$installDir/Logs/candidates_$dateTimeKpi.csv") or die "Can't open file : $installDir/Logs/candidates_$dateTimeKpi.csv\n";
	foreach my $du_id_rach (keys %status_hashTp5g) {
		foreach my $cell_id_rach ( keys %{$status_hashTp5g{$du_id_rach}}) {	
			#S5NR_DLUserPerceivedTput_Mbps
			my $nm_dlueThru = ((8 * $status_hashTp5g{$du_id_rach}{$cell_id_rach}{DLUeThruVol})/1000);
			my $dr_dlueThru = (($status_hashTp5g{$du_id_rach}{$cell_id_rach}{DLUeThruTime}) / 1000000);
			if($dr_dlueThru != 0){
				my $DLUser_failrate  = $nm_dlueThru/$dr_dlueThru;
				#baseline avg
				my $nm_dlueThruD = ((8 * $status_hashTp5g{$du_id_rach}{$cell_id_rach}{DLUeThruVolD})/1000);
				my $dr_dlueThruD = (($status_hashTp5g{$du_id_rach}{$cell_id_rach}{DLUeThruTimeD}) / 1000000);
				if($dr_dlueThruD != 0){
					my $DLUser_failrateD  = $nm_dlueThruD/$dr_dlueThruD;
					if($DLUser_failrateD != 0){
						#final_comparison
						my $finalDLUserFail = (($DLUser_failrate - $DLUser_failrateD)/$DLUser_failrateD)*100;
						$finalDLUserFail = sprintf("%.3f", $finalDLUserFail); 
						$DLUser_failrateD = sprintf("%.3f", $DLUser_failrateD); 
						$DLUser_failrate = sprintf("%.3f", $DLUser_failrate);
						if ($finalDLUserFail < $dlUeThru5gThresh) {
							print (CANDIDATES "$dateCst[0],$cstPrevHour,S5NR_DLUserPerceivedTput_Mbps,$du_id_rach,$cell_id_rach,$DLUser_failrateD,$DLUser_failrate,$finalDLUserFail\n");
						}
					}
				}
			}

			#S5NR_ULUserPerceivedTput_Mbps
			my $nm_ulueThru = ((8 * $status_hashTp5g{$du_id_rach}{$cell_id_rach}{ULUeThruVol})/1000);
			my $dr_ulueThru = (($status_hashTp5g{$du_id_rach}{$cell_id_rach}{ULUeThruTime}) / 8000);
            if($dr_ulueThru != 0){
				my $ULUser_failrate  = $nm_ulueThru/$dr_ulueThru;
				#baseline_avg
				my $nm_ulueThruD = ((8 * $status_hashTp5g{$du_id_rach}{$cell_id_rach}{ULUeThruVolD})/1000);
				my $dr_ulueThruD = (($status_hashTp5g{$du_id_rach}{$cell_id_rach}{ULUeThruTimeD}) / 8000);
				if($dr_ulueThruD != 0){
					my $ULUser_failrateD  = $nm_ulueThruD/$dr_ulueThruD;
					if($ULUser_failrateD != 0){
						#final_comparison
						my $finalULUserFail = (($ULUser_failrate - $ULUser_failrateD)/$ULUser_failrateD)*100;
						$finalULUserFail = sprintf("%.3f", $finalULUserFail); 
						$ULUser_failrateD = sprintf("%.3f", $ULUser_failrateD); 
						$ULUser_failrate = sprintf("%.3f", $ULUser_failrate);
						if ($finalULUserFail < $ulUeThru5gThresh) {
							print (CANDIDATES "$dateCst[0],$cstPrevHour,S5NR_ULUserPerceivedTput_Mbps,$du_id_rach,$cell_id_rach,$ULUser_failrateD,$ULUser_failrate,$finalULUserFail\n");
						}
					}
				}
			}

			#S5NR_RACH_SR%
			my $nm_rach = ($status_hashTp5g{$du_id_rach}{$cell_id_rach}{NumMSG5PerBeam} + $status_hashTp5g{$du_id_rach}{$cell_id_rach}{NumMSG3CFRA} + $status_hashTp5g{$du_id_rach}{$cell_id_rach}{NumMSG3CFRAPerBeam} + $status_hashTp5g{$du_id_rach}{$cell_id_rach}{NumMSG3});
			my $dr_rach = ($status_hashTp5g{$du_id_rach}{$cell_id_rach}{RachPreambleAPerBeam} + $status_hashTp5g{$du_id_rach}{$cell_id_rach}{RachPreambleBPerBeam} + $status_hashTp5g{$du_id_rach}{$cell_id_rach}{RachPreambleA} + $status_hashTp5g{$du_id_rach}{$cell_id_rach}{RachPreambleACFRAPerBeam} + $status_hashTp5g{$du_id_rach}{$cell_id_rach}{RachPreambleACFRA});
            if($dr_rach != 0){
				my $rachSr_failrate  = 100 * ($nm_rach/$dr_rach);
				#baseline_avg
				my $nm_rachD = ($status_hashTp5g{$du_id_rach}{$cell_id_rach}{NumMSG5PerBeamD} + $status_hashTp5g{$du_id_rach}{$cell_id_rach}{NumMSG3CFRAD} + $status_hashTp5g{$du_id_rach}{$cell_id_rach}{NumMSG3CFRAPerBeamD} + $status_hashTp5g{$du_id_rach}{$cell_id_rach}{NumMSG3D});
				my $dr_rachD = ($status_hashTp5g{$du_id_rach}{$cell_id_rach}{RachPreambleAPerBeamD} + $status_hashTp5g{$du_id_rach}{$cell_id_rach}{RachPreambleBPerBeamD} + $status_hashTp5g{$du_id_rach}{$cell_id_rach}{RachPreambleAD} + $status_hashTp5g{$du_id_rach}{$cell_id_rach}{RachPreambleACFRAPerBeamD} + $status_hashTp5g{$du_id_rach}{$cell_id_rach}{RachPreambleACFRAD});
				if($dr_rachD != 0){
					my $rachSr_failrateD  = 100 * ($nm_rachD/$dr_rachD);
					#final_comparison
					if($rachSr_failrateD != 0){
						my $finalRachSrFail = (($rachSr_failrate - $rachSr_failrateD)/$rachSr_failrateD)*100;
						$finalRachSrFail = sprintf("%.3f", $finalRachSrFail); 
						$rachSr_failrateD = sprintf("%.3f", $rachSr_failrateD); 
						$rachSr_failrate = sprintf("%.3f", $rachSr_failrate);
						if ($finalRachSrFail > $prachBeam5gThresh) {
							print (CANDIDATES "$dateCst[0],$cstPrevHour,S5NR_RACH_SR,$du_id_rach,$cell_id_rach,$rachSr_failrateD,$rachSr_failrate,$finalRachSrFail\n");
						}
					}
				}
			}
		}
	}
	close(CANDIDATES);
}


sub airPack_5g{
	#S5NR_DLMACLayerDataVolume_MB
	print "NE=$given_NE\n";
	print "$TempPath/$air_macpk_5gFile\n";

	if (-e "$TempPath/$air_macpk_5gFile") {
		open (AIR5G, "<$TempPath/$air_macpk_5gFile");
		while(<AIR5G>) {
			#if ($_ !~ /^$type/ ) { next; }
			my($du_id, $NE_name,$cellLocation, $AirMacDLByte_nr) = (split(',', $_))[0,2,6,10];
			#print "du_id=$du_id\n";
			# if ($du_id eq "$given_NE"){
			if (index($NE_name, $given_NE) != -1) {
				print "inside match of NE to file\n\n\n";
				#my $cell_id =~ s/[^0-9]//g;
				my $cell_id=$cellLocation;
				$status_hashAir5g{$given_NE}{$cell_id}{AirMacDLByte_nr} += $AirMacDLByte_nr;
			}
		}
		close(AIR5G);
	}

	if (-e "$TempPathDays/$air_macpk_5gFile") {
		open (AIR5G_D, "<$TempPathDays/$air_macpk_5gFile");
		while(<AIR5G_D>) {
			#if ($_ !~ /^$type/ ) { next; }
			my($du_id, $NE_nameD, $cellLocationD, $AirMacDLByte_nrD) = (split(',', $_))[0,2,6,10];
			# if ($du_id eq "$given_NE"){
			if (index($NE_nameD, $given_NE) != -1) {
				#my $cell_id =~ s/[^0-9]//g;
				my $cell_id=$cellLocationD;
				$status_hashAir5g{$given_NE}{$cell_id}{AirMacDLByte_nrD} += $AirMacDLByte_nrD;
			}
		}
		close(AIR5G_D);
	}

	#S5NR_DLInitBLER_%
	if (-e "$TempPath/$dl_harq_transBler_5gFile") {
		open (DLHARQ, "<$TempPath/$dl_harq_transBler_5gFile");
		while(<DLHARQ>) {
			#if ($_ !~ /^$type/ ) { next; }
			my($du_id, $NE_name, $cellLocation, $Nrof1stTxTrial_DL, $Nrof2ndTxTrial_DL, $NrofResidualError_DL) = (split(',', $_))[0,2,6,7,8,15];
			# if ($du_id eq "$given_NE"){
			if (index($NE_name, $given_NE) != -1) {
				#my $cell_id =~ s/[^0-9]//g;
				my $cell_id=$cellLocation;
				$status_hashAir5g{$given_NE}{$cell_id}{Nrof1stTxTrial_DL} += $Nrof1stTxTrial_DL;
				$status_hashAir5g{$given_NE}{$cell_id}{Nrof2ndTxTrial_DL} += $Nrof2ndTxTrial_DL;
				$status_hashAir5g{$given_NE}{$cell_id}{NrofResidualError_DL} += $NrofResidualError_DL;
			}
		}
		close(DLHARQ);
	}

	if (-e "$TempPathDays/$dl_harq_transBler_5gFile") {
		open (DLHARQ_D, "<$TempPathDays/$dl_harq_transBler_5gFile");
		while(<DLHARQ_D>) {
			#if ($_ !~ /^$type/ ) { next; }
			my($du_id, $NE_nameD, $cellLocationD, $Nrof1stTxTrial_DLD, $Nrof2ndTxTrial_DLD, $NrofResidualError_DLD) = (split(',', $_))[0,2,6,7,8,15];
			# if ($du_id eq "$given_NE"){
			if (index($NE_nameD, $given_NE) != -1) {
				#my $cell_id =~ s/[^0-9]//g;
				my $cell_id=$cellLocationD;
				$status_hashAir5g{$given_NE}{$cell_id}{Nrof1stTxTrial_DLD} += $Nrof1stTxTrial_DLD;
				$status_hashAir5g{$given_NE}{$cell_id}{Nrof2ndTxTrial_DLD} += $Nrof2ndTxTrial_DLD;
				$status_hashAir5g{$given_NE}{$cell_id}{NrofResidualError_DLD} += $NrofResidualError_DLD;
			}
		}
		close(DLHARQ_D);
	}
	#S5NR_ULInitBLER_%
	if (-e "$TempPath/$ul_harq_transBler_5gFile") {
		open (ULHARQ, "<$TempPath/$ul_harq_transBler_5gFile");
		while(<ULHARQ>) {
			#if ($_ !~ /^$type/ ) { next; }
			my($du_id, $NE_name, $cellLocation, $Nrof1stTxTrial_UL, $Nrof2ndTxTrial_UL, $NrofResidualError_UL) = (split(',', $_))[0,2,6,7,8,15];
			# if ($du_id eq "$given_NE"){
			if (index($NE_name, $given_NE) != -1) {
				#my $cell_id =~ s/[^0-9]//g;
				my $cell_id=$cellLocation;
				$status_hashAir5g{$given_NE}{$cell_id}{Nrof1stTxTrial_UL} += $Nrof1stTxTrial_UL;
				$status_hashAir5g{$given_NE}{$cell_id}{Nrof2ndTxTrial_UL} += $Nrof2ndTxTrial_UL;
				$status_hashAir5g{$given_NE}{$cell_id}{NrofResidualError_UL} += $NrofResidualError_UL;
			}
		}
		close(ULHARQ);
	}

	if (-e "$TempPathDays/$ul_harq_transBler_5gFile") {
		open (ULHARQ_D, "<$TempPathDays/$ul_harq_transBler_5gFile");
		while(<ULHARQ_D>) {
			#if ($_ !~ /^$type/ ) { next; }
			my($du_id, $NE_nameD, $cellLocationD, $Nrof1stTxTrial_ULD, $Nrof2ndTxTrial_ULD, $NrofResidualError_ULD) = (split(',', $_))[0,2,6,7,8,15];
			# if ($du_id eq "$given_NE"){
			if (index($NE_nameD, $given_NE) != -1) {
				#my $cell_id =~ s/[^0-9]//g;
				my $cell_id=$cellLocationD;
				$status_hashAir5g{$given_NE}{$cell_id}{Nrof1stTxTrial_ULD} += $Nrof1stTxTrial_ULD;
				$status_hashAir5g{$given_NE}{$cell_id}{Nrof2ndTxTrial_ULD} += $Nrof2ndTxTrial_ULD;
				$status_hashAir5g{$given_NE}{$cell_id}{NrofResidualError_ULD} += $NrofResidualError_ULD;
			}
		}
		close(ULHARQ_D);
	}


	#S5NR_RACH_SR%
	if (-e "$TempPath/$prach_nr_5gFile") {
		open (PRACHNR, "<$TempPath/$prach_nr_5gFile");
		while(<PRACHNR>) {
			#if ($_ !~ /^$type/ ) { next; }
			my($du_id, $NE_name, $cellLocation, $RachPreambleA, $RachPreambleACFRA, $NumMSG3, $NumMSG3CFRA) = (split(',', $_))[0,2,6,7,9,12,13];
			# if ($du_id eq "$given_NE"){
			if (index($NE_name, $given_NE) != -1) {
				#my $cell_id =~ s/[^0-9]//g;
				my $cell_id=$cellLocation;
				$status_hashAir5g{$given_NE}{$cell_id}{RachPreambleA} += $RachPreambleA;
				$status_hashAir5g{$given_NE}{$cell_id}{RachPreambleACFRA} += $RachPreambleACFRA;
				$status_hashAir5g{$given_NE}{$cell_id}{NumMSG3} += $NumMSG3;
				$status_hashAir5g{$given_NE}{$cell_id}{NumMSG3CFRA} += $NumMSG3CFRA;
			}
		}
		close(PRACHNR);
	}

	if (-e "$TempPathDays/$prach_nr_5gFile") {
		open (PRACHNR_D, "<$TempPathDays/$prach_nr_5gFile");
		while(<PRACHNR_D>) {
			#if ($_ !~ /^$type/ ) { next; }
			my($du_id, $NE_nameD, $cellLocationD, $RachPreambleAD, $RachPreambleACFRAD, $NumMSG3D, $NumMSG3CFRAD) = (split(',', $_))[0,2,6,7,9,12,13];
			#if ($du_id eq "$given_NE"){
			if (index($NE_nameD, $given_NE) != -1) {
				#my $cell_id =~ s/[^0-9]//g;
				my $cell_id=$cellLocationD;
				$status_hashAir5g{$given_NE}{$cell_id}{RachPreambleAD} += $RachPreambleAD;
				$status_hashAir5g{$given_NE}{$cell_id}{RachPreambleACFRAD} += $RachPreambleACFRAD;
				$status_hashAir5g{$given_NE}{$cell_id}{NumMSG3D} += $NumMSG3D;
				$status_hashAir5g{$given_NE}{$cell_id}{NumMSG3CFRAD} += $NumMSG3CFRAD;
			}
		}
		close(PRACHNR_D);
	}

	#cellUnavailableTime
	if (-e "$TempPath/$cellUnavailableTime_5gFile") {
		open (CELLUNAVAIL, "<$TempPath/$cellUnavailableTime_5gFile");
		while(<CELLUNAVAIL>) {
			#if ($_ !~ /^$type/ ) { next; }
			my($du_id, $NE_name, $cellLocation, $CellUnavailableTimeLoc, $CellUnavailableTimeDown, $CellAvailPmPeriodTime) = (split(',', $_))[0,2,6,8,9,10];
			# if ($du_id eq "$given_NE"){
			if (index($NE_name, $given_NE) != -1) {
				#my $cell_id =~ s/[^0-9]//g;
				my $cell_id=$cellLocation;
				$status_hashAir5g{$given_NE}{$cell_id}{CellUnavailableTimeLoc} += $CellUnavailableTimeLoc;
				$status_hashAir5g{$given_NE}{$cell_id}{CellUnavailableTimeDown} += $CellUnavailableTimeDown;
				$status_hashAir5g{$given_NE}{$cell_id}{CellAvailPmPeriodTime} += $CellAvailPmPeriodTime;
			}
		}
		close(CELLUNAVAIL);
	}


	if (-e "$TempPathDays/$cellUnavailableTime_5gFile") {
		open (CELLUNAVAIL_D, "<$TempPathDays/$cellUnavailableTime_5gFile");
		while(<CELLUNAVAIL_D>) {
			#if ($_ !~ /^$type/ ) { next; }
			my($du_id, $NE_nameD, $cellLocationD, $CellUnavailableTimeLocD, $CellUnavailableTimeDownD, $CellAvailPmPeriodTimeD) = (split(',', $_))[0,2,6,8,9,10];
			# if ($du_id eq "$given_NE"){
			if (index($NE_nameD, $given_NE) != -1) {
				#my $cell_id =~ s/[^0-9]//g;
				my $cell_id=$cellLocationD;
				$status_hashAir5g{$given_NE}{$cell_id}{CellUnavailableTimeLocD} += $CellUnavailableTimeLocD;
				$status_hashAir5g{$given_NE}{$cell_id}{CellUnavailableTimeDownD} += $CellUnavailableTimeDownD;
				$status_hashAir5g{$given_NE}{$cell_id}{CellAvailPmPeriodTimeD} += $CellAvailPmPeriodTimeD;
			}
		}
		close(CELLUNAVAIL_D);
	}
	print Dumper \%status_hashAir5g;
	open (CANDIDATES, ">>$installDir/Logs/candidates_$dateTimeKpi.csv") or die "Can't open file : $installDir/Logs/candidates_$dateTimeKpi.csv\n";
	foreach my $du_id (keys %status_hashAir5g) {
		foreach my $cell_id ( keys %{$status_hashAir5g{$du_id}}) {
			#S5NR_DLMACLayerDataVolume_MB
			my $dlMacVal = $status_hashAir5g{$given_NE}{$cell_id}{AirMacDLByte_nr};
			##baseline avg
			my $dlMacValD = ($status_hashAir5g{$given_NE}{$cell_id}{AirMacDLByte_nrD});
			print "dlMacVal=$dlMacVal\n";
			my $failure_rateAir5g = ($dlMacVal / 1000);
			#baseline avg
			my $failure_rateAir5gD = ($dlMacValD / 1000);
			if ($failure_rateAir5gD != 0) {
				#final comparison
				my $finalAir5gFail = (($failure_rateAir5g - $failure_rateAir5gD)/$failure_rateAir5gD)*100;
				$finalAir5gFail = sprintf("%.3f", $finalAir5gFail); 
				$failure_rateAir5gD = sprintf("%.3f", $failure_rateAir5gD); 
				$failure_rateAir5g = sprintf("%.3f", $failure_rateAir5g);
				if ($finalAir5gFail < $airMac5gThresh) {
					print (CANDIDATES "$dateCst[0],$cstPrevHour,S5NR_DLMACLayerDataVolume_MB,$du_id,$cell_id,$failure_rateAir5gD,$failure_rateAir5g,$finalAir5gFail\n");
				}
			}


			#S5NR_DLInitBLER_%
			my $nm_dlHarq = ($status_hashAir5g{$given_NE}{$cell_id}{Nrof2ndTxTrial_DL});
			my $dr_dlHarq = ($status_hashAir5g{$given_NE}{$cell_id}{Nrof1stTxTrial_DL});
            if (($dr_dlHarq != 0)) {
				my $dlInitBler_failrate  = 100 * ($nm_dlHarq/$dr_dlHarq);
				#baseline_avg
				my $nm_dlHarqD = ($status_hashAir5g{$given_NE}{$cell_id}{Nrof2ndTxTrial_DLD});
				my $dr_dlHarqD = ($status_hashAir5g{$given_NE}{$cell_id}{Nrof1stTxTrial_DLD});
				if (($dr_dlHarqD != 0)) {
					my $dlInitBler_failrateD  = 100 * ($nm_dlHarqD/$dr_dlHarqD);
					if($dlInitBler_failrateD != 0){
						#final_comparison
						my $finalDlInitBlerFail = (($dlInitBler_failrate - $dlInitBler_failrateD)/$dlInitBler_failrateD)*100;
						$finalDlInitBlerFail = sprintf("%.3f", $finalDlInitBlerFail); 
						$dlInitBler_failrateD = sprintf("%.3f", $dlInitBler_failrateD); 
						$dlInitBler_failrate = sprintf("%.3f", $dlInitBler_failrate);
						if ($finalDlInitBlerFail > $dlHarq5gThresh) {
							print (CANDIDATES "$dateCst[0],$cstPrevHour,S5NR_DLInitBLER,$du_id,$cell_id,$dlInitBler_failrateD,$dlInitBler_failrate,$finalDlInitBlerFail\n");
						}
					}
				}
			}

			#S5NR_DLResidualBLER_%
			my $nm_dlresHarq = ($status_hashAir5g{$given_NE}{$cell_id}{NrofResidualError_DL});
			my $dr_dlresHarq = ($status_hashAir5g{$given_NE}{$cell_id}{Nrof1stTxTrial_DL});
            if (($dr_dlresHarq != 0)) {
				my $dlresBler_failrate  = 100 * ($nm_dlresHarq/$dr_dlresHarq);
				#baseline_avg
				my $nm_dlresHarqD = ($status_hashAir5g{$given_NE}{$cell_id}{NrofResidualError_DLD});
				my $dr_dlresHarqD = ($status_hashAir5g{$given_NE}{$cell_id}{Nrof1stTxTrial_DLD});
				if (($dr_dlresHarqD != 0)) {
					my $dlresBler_failrateD  = 100 * ($nm_dlresHarqD/$dr_dlresHarqD);
					if($dlresBler_failrateD != 0){
						#final_comparison
						my $finalDlresBlerFail = (($dlresBler_failrate - $dlresBler_failrateD)/$dlresBler_failrateD)*100;
						$finalDlresBlerFail = sprintf("%.3f", $finalDlresBlerFail); 
						$dlresBler_failrateD = sprintf("%.3f", $dlresBler_failrateD); 
						$dlresBler_failrate = sprintf("%.3f", $dlresBler_failrate);
						if ($finalDlresBlerFail > $dlHarq5gThresh) {
							print (CANDIDATES "$dateCst[0],$cstPrevHour,S5NR_DLResidualBLER,$du_id,$cell_id,$dlresBler_failrateD,$dlresBler_failrate,$finalDlresBlerFail\n");
						}
					}
				}
			}

			#S5NR_ULInitBLER_%
			my $nm_ulinitHarq = ($status_hashAir5g{$given_NE}{$cell_id}{Nrof2ndTxTrial_UL});
			my $dr_ulinitHarq = ($status_hashAir5g{$given_NE}{$cell_id}{Nrof1stTxTrial_UL});
            if ($dr_ulinitHarq != 0) {
				my $ulinitBler_failrate  = 100 * ($nm_ulinitHarq/$dr_ulinitHarq);
				#baseline_avg
				my $nm_ulinitHarqD = ($status_hashAir5g{$given_NE}{$cell_id}{Nrof2ndTxTrial_ULD});
				my $dr_ulinitHarqD = ($status_hashAir5g{$given_NE}{$cell_id}{Nrof1stTxTrial_ULD});
				if($dr_ulinitHarqD != 0){
					my $ulinitBler_failrateD  = 100 * ($nm_ulinitHarqD/$dr_ulinitHarqD);
					if($ulinitBler_failrateD != 0){
						#final_comparison
						my $finalUlinitHarqDFail = (($ulinitBler_failrate - $ulinitBler_failrateD)/$ulinitBler_failrateD)*100;
						$finalUlinitHarqDFail = sprintf("%.3f", $finalUlinitHarqDFail); 
						$ulinitBler_failrateD = sprintf("%.3f", $ulinitBler_failrateD); 
						$ulinitBler_failrate = sprintf("%.3f", $ulinitBler_failrate);
						if ($finalUlinitHarqDFail > $ulHarq5gThresh) {
							print (CANDIDATES "$dateCst[0],$cstPrevHour,S5NR_ULInitBLER,$du_id,$cell_id,$ulinitBler_failrateD,$ulinitBler_failrate,$finalUlinitHarqDFail\n");
						}
					}
				}
			}

			#S5NR_ULResidualBLER_%
			my $nm_ulresHarq = ($status_hashAir5g{$given_NE}{$cell_id}{NrofResidualError_UL});
			my $dr_ulresHarq = ($status_hashAir5g{$given_NE}{$cell_id}{Nrof1stTxTrial_UL});
            if ($dr_ulresHarq != 0) {
				my $ulresBler_failrate  = 100 * ($nm_ulresHarq/$dr_ulresHarq);
				#baseline_avg
				my $nm_ulresHarqD = ($status_hashAir5g{$given_NE}{$cell_id}{NrofResidualError_ULD});
				my $dr_ulresHarqD = ($status_hashAir5g{$given_NE}{$cell_id}{Nrof1stTxTrial_ULD});
				if($dr_ulresHarqD != 0){
					my $ulresBler_failrateD  = 100 * ($nm_ulresHarqD/$dr_ulresHarqD);
					if($ulresBler_failrateD != 0){
						#final_comparison
						my $finalUlResDFail = (($ulresBler_failrate - $ulresBler_failrateD)/$ulresBler_failrateD)*100;
						$finalUlResDFail = sprintf("%.3f", $finalUlResDFail); 
						$ulresBler_failrateD = sprintf("%.3f", $ulresBler_failrateD); 
						$ulresBler_failrate = sprintf("%.3f", $ulresBler_failrate);
						if ($finalUlResDFail > $ulHarq5gThresh) {
							print (CANDIDATES "$dateCst[0],$cstPrevHour,S5NR_ULResidualBLER_,$du_id,$cell_id,$ulresBler_failrateD,$ulresBler_failrate,$finalUlResDFail\n");
						}
					}
				}
			}

			#Cell_unavailable_time%
			my $nm_cellUnavail = ($status_hashAir5g{$given_NE}{$cell_id}{CellUnavailableTimeDown} - $status_hashAir5g{$du_id}{$cell_id}{CellUnavailableTimeLoc});
			my $dr_cellUnavail = ($status_hashAir5g{$given_NE}{$cell_id}{CellAvailPmPeriodTime});
            if ($dr_cellUnavail != 0) {
				my $cellUnavail_failrate  = 100 * ($nm_cellUnavail/$dr_cellUnavail);
				#baseline_avg
				my $nm_cellUnavailD = ($status_hashAir5g{$given_NE}{$cell_id}{CellUnavailableTimeDownD} - $status_hashAir5g{$du_id}{$cell_id}{CellUnavailableTimeLocD});
				my $dr_cellUnavailD = ($status_hashAir5g{$given_NE}{$cell_id}{CellAvailPmPeriodTimeD});
				if ($dr_cellUnavailD != 0) {
					my $cellUnavail_failrateD  = 100 * ($nm_cellUnavailD/$dr_cellUnavailD);
					if($cellUnavail_failrateD != 0){
						#final_comparison
						my $finalCellUnavailFail = (($cellUnavail_failrate - $cellUnavail_failrateD)/$cellUnavail_failrateD)*100;
						$finalCellUnavailFail = sprintf("%.3f", $finalCellUnavailFail); 
						$cellUnavail_failrateD = sprintf("%.3f", $cellUnavail_failrateD); 
						$cellUnavail_failrate = sprintf("%.3f", $cellUnavail_failrate);
						if ($finalCellUnavailFail > $cellUnavail5gThresh) {
							print (CANDIDATES "$dateCst[0],$cstPrevHour,Cell_unavailable_time,$du_id,$cell_id,$cellUnavail_failrateD,$cellUnavail_failrate,$finalCellUnavailFail\n");
						}
					}
				}
			}
			
		}
	}
	# }
	close(CANDIDATES);
}

sub EndcDrop_5g{
	if (-e "$TempPath/$cucpCslHexa_5gFile") {
		   open (CUCP, "<$TempPath/$cucpCslHexa_5gFile");
		   while(<CUCP>) {
			if (($_ !~ /gNB/)) { next; }
			my($ne_id, $NE_name, $cellLocation, $NoFault, $ConnectionReconfig, $ContextSetup, $E1BearerSetup, $E1BearerContextModification, $F1UeContextModification, $F1UeContextRelease, $X2SgnbReconfigurationComplete, $tX2ModificationConfirm, $ResourceSetup, $F1SctpOutOfService, $E1SctpOutOfService, $X2SctpOutOfService, $MDSSendFail, $CacCallCountOver, $NotSupportedQci, $InvalidCallContext, $ResourceAllocFail,$OMIntervention,$VmScaleIn ,$CellRelease,$CallAllocationFail,$UpAllocationFail,$InvalidCallId,$InvalidPlmn,$UserInactivity,$T310Expiry,$RandomAccessProblem,$RlcMaxNumRetx,$ScgChangeFailure,$ScgReconfigFailure,$Srb3IntegrityFailure,$ScgMobility ,$MeasurementReportBasedRelease,$F1apRadioUnspecified,$F1apRadioRLFailure,$F1apRadioUnknownOrAlreadyAllocatedCuUeF1apId,$F1apRadioUnknownOrAlreadyAllocatedDuUeF1apId,$F1apRadioUnknownInconsistentPairOfUeF1apId,$F1apRadioInteraction,$F1apRadioNotSupportedQCI,$F1apRadioDesirableRadioReasons,$F1apRadioUnavailableRadioReasons,$F1apRadioProcedureCancelled,$F1apRadioNormalRelease,$F1apRadioCellNotAvailable,$F1apRadioRLFailureothers,$F1apRadioUeRejection,$F1apRadioResourcesNotAvailableForTheSlice,$F1apTransportUnspecified,$F1apTransportResourceUnavailable,$F1apProtocolTransferSyntaxError,$F1apProtocolAbstractSyntaxErrorReject,$F1apProtocolAbstractSyntaxErrorIgnore,$F1apProtocolMessageNotCompatible,$F1apProtocolSemanticError,$F1apProtocolAbstractSyntaxError,$F1apProtocolUnspecified,$F1apMiscControlProcessingOverload,$F1apMiscUnavailableResources,$F1apMiscHardwareFailure,$F1apMiscOMIntervention,$F1apMiscUnspecifiedFailure,$X2apRadioNetworkLayerHandoverDesirableForRadioReasons,$X2apRadioNetworkLayerTimeCriticalHandover,$X2apRadioNetworkLayerResourceOptimisationHandover,$X2apRadioNetworkLayerReduceLoadInServingCell ,$X2apRadioNetworkLayerPartialHandover,$X2apRadioNetworkLayerUnknownNewEnbUeX2apId,$X2apRadioNetworkLayerUnknownOldEnbUeX2apId,$X2apRadioNetworkLayerUnknownPairOfUeX2apId,$X2apRadioNetworkLayerHoTargetNotAllowed,$X2apRadioNetworkLayerTx2relocoverallExpiry,$X2apRadioNetworkLayerTrelocoverallExpiry,$X2apRadioNetworkLayerCellNotAvailable,$X2apRadioNetworkLayerNoRadioResourcesAvailableInTargetCell,$X2apRadioNetworkLayerInvalidMMEGroupID,$X2apRadioNetworkLayerUnknownMMECode,$X2apRadioNetworkLayerEncryptionAndOrIntegrityProtectionAlgorithmsNotSupported,$X2apRadioNetworkLayerReportCharacteristicsEmpty,$X2apRadioNetworkLayerNoReportPeriodicity,$X2apRadioNetworkLayerExistingMeasurementID,$X2apRadioNetworkLayerUnknownEnbMeasurementID,$X2apRadioNetworkLayerMeasurementTemporarilyNotAvailable,$X2apRadioNetworkLayerUnspecified,$X2apRadioNetworkLayerLoadBalancing,$X2apRadioNetworkLayerHandoverOptimisation,$X2apRadioNetworkLayerValueOutOfAllowedRange,$X2apRadioNetworkLayerMultipleErabIdInstances,$X2apRadioNetworkLayerSwitchOffOngoing,$X2apRadioNetworkLayerNotSupportedQciValue,$X2apRadioNetworkLayerMeasurementNotSupportedForTheObject,$X2apRadioNetworkLayerTdcoverallExpiry,$X2apRadioNetworkLayerTdcprepExpiry,$X2apRadioNetworkLayerActionDesirableForRadioReasons,$X2apRadioNetworkLayerReduceLoad,$X2apRadioNetworkLayerResourceOptimisation,$X2apRadioNetworkLayerTimeCriticalAction,$X2apRadioNetworkLayerTargetNotAllowed,$X2apRadioNetworkLayerNoRadioResourcesAvailable,$X2apRadioNetworkLayerInvalidQosCombination,$X2apRadioNetworkLayerEncryptionAlgorithmsNotSupported,$X2apRadioNetworkLayerProcedureCancelled,$X2apRadioNetworkLayerRrmPurpose,$X2apRadioNetworkLayerImproveUserBitRate,$X2apRadioNetworkLayerUserInactivity,$X2apRadioNetworkLayerMcgMobility,$X2apRadioNetworkLayerScgMobility,$X2apRadioNetworkLayerRadioConnectionWithUeLost,$X2apRadioNetworkLayerFailureInTheRadioInterfaceProcedure,$X2apRadioNetworkLayerBearerOptionNotSupported,$X2apRadioNetworkLayerCountReachesMaxValue,$X2apRadioNetworkLayerUnknownOldEngnbUeX2apId,$X2apRadioNetworkLayerPdcpOverload,$X2apTransportNetworkLayerTransportResourceUnavailable,$X2apTransportNetworkLayerUnspecified,$X2apProtocolTransferSyntaxError,$X2apProtocolAbstractSyntaxErrorReject,$X2apProtocolAbstractSyntaxErrorIgnoreAndNotify,$X2apProtocolMessageNotCompatibleWithReceiverState,$X2apProtocolSemanticError,$X2apProtocolUnspecified,$X2apProtocolAbstractSyntaxErrorFalselyConstructedMessage,$X2apMiscControlProcessingOverload,$X2apMiscHardwareFailure,$X2apMiscOMIntervention ,$X2apMiscNotEnoughUserPlaneProcessingResources,$X2apMiscUnspecified,$E1apRadioNetworkLayerUnspecified,$E1apRadioNetworkLayerUnknownOrAlreadyAllocatedGnbCuCpUeE1apId,$E1apRadioNetworkLayerUnknownOrAlreadyAllocatedGnbCuUpUeE1apId,$E1apRadioNetworkLayerUnknownOrInconsistentPairOfUeE1apId,$E1apRadioNetworkLayerInteractionWithOtherProcedure,$E1apRadioNetworkLayerPdcpCountWrapAround,$E1apRadioNetworkLayerNotSupportedQciValue,$E1apRadioNetworkLayerNotSupported5QiValue,$E1apRadioNetworkLayerEncryptionAlgorithmsNotSupported,$E1apRadioNetworkLayerIntegrityProtectionAlgorithmsNotSupported,$E1apRadioNetworkLayerUpIntegrityProtectionNotPossible,$E1apRadioNetworkLayerUpConfidentialityProtectionNotPossible,$E1apRadioNetworkLayerMultiplePduSessionIdInstances,$E1apRadioNetworkLayerUnknownPduSessionId,$E1apRadioNetworkLayerMultipleQosFlowIdInstances,$E1apRadioNetworkLayerUnknownQosFlowId,$E1apRadioNetworkLayerMultipleDrbIdInstances,$E1apRadioNetworkLayerUnknownDrbId,$E1apRadioNetworkLayerInvalidQosCombination,$E1apRadioNetworkLayerProcedureCancelled,$E1apRadioNetworkLayerNormalRelease,$E1apRadioNetworkLayerNoRadioResourcesAvailable,$E1apRadioNetworkLayerActionDesirableForRadioReasons,$E1apRadioNetworkLayerResourcesNotAvailableForTheSlice,$E1apRadioNetworkLayerPdcpConfigurationNotSupported,$E1apTransportLayerUnspecified,$E1apTransportLayerTransportResourceUnavailable,$E1apProtocolTransferSyntaxError,$E1apProtocolAbstractSyntaxErrorReject,$E1apProtocolAbstractSyntaxErrorIgnoreAndNotify,$E1apProtocolMessageNotCompatibleWithReceiverState,$E1apProtocolSemanticError,$E1apProtocolAbstractSyntaxErrorFalselyConstructedMessage,$E1apProtocolUnspecified,$E1apMiscControlProcessingOverload,$E1apMiscNotEnoughUserPlaneProcessingResources,$E1apMiscHardwareFailure,$E1apMiscOMIntervention, $E1apMiscUnspecified,$DuULRadioLinkFailure,$DuRlcMaxNumRetx,$CpSrb3IntegrityFailure,$CuOverload,$StoreRrcMessageError,$StoreE1MessageError,$StoreF1MessageError,$SendRrcMessageError,$SendE1MessageError,$SendF1MessageError,$StoreX2MessageError,$SendX2MessageError,$TmOutX2ChangeConfirm,$TmOutX2SNStatusTransfer,$SpCellSelectionFail,$InvalidCellId,$F1apRadioAmfInitiatedAbnormalRelease,$F1apRadioReleaseDueToPreEmption,$F1apRadioPlmnNotServedByTheGnbCu,$E1apRadioNetworkLayerUeDlMaxIPDataRateReason,$E1apRadioNetworkLayerUpIntegrityProtectionFailure,$E1apRadioNetworkLayerReleaseDueToPreEmption,$TmOutResumeForMrBased,$SynchReconfigFailureScg,$InternalX2UEContextRelease ) = (split(',', $_))[0,2,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,71,72,73,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198];
			# my($du_id, $cell_id) = (split('/', $cellLocation))[0,1];
			my($gnbId, $cell_id) = (split('/', $cellLocation))[0,1];
			#print "gNBId =$du_id\n";
			#print "endc attempts cell_id = $cell_id\n";
			# my $DU_NUM = $given_NE;
			# $DU_NUM =~ s/DU_/gNB_DU_ID/g;
			#if ($du_id eq "$given_gNBId"){
			if ((index($NE_name, $given_AUID) != -1) || ($gnbId eq $given_gNBId)) {			
				 $status_hash5g{$du_id}{$cell_id}{ConnectionReconfig} += $ConnectionReconfig;
				 $status_hash5g{$du_id}{$cell_id}{ContextSetup} += $ContextSetup;
				 $status_hash5g{$du_id}{$cell_id}{E1BearerSetup} += $E1BearerSetup;
				 $status_hash5g{$du_id}{$cell_id}{E1BearerContextModification}+= $E1BearerContextModification;
				 $status_hash5g{$du_id}{$cell_id}{E1BearerContextModification}+= $E1BearerContextModification;
				 $status_hash5g{$du_id}{$cell_id}{F1UeContextModification} += $F1UeContextModification;
				 $status_hash5g{$du_id}{$cell_id}{F1UeContextRelease} += $F1UeContextRelease;
				 $status_hash5g{$du_id}{$cell_id}{X2SgnbReconfigurationComplete} += $X2SgnbReconfigurationComplete;
				 $status_hash5g{$du_id}{$cell_id}{tX2ModificationConfirm} += $tX2ModificationConfirm;
				 $status_hash5g{$du_id}{$cell_id}{ResourceSetup} +=$ResourceSetup;
				 $status_hash5g{$du_id}{$cell_id}{F1SctpOutOfService} += $F1SctpOutOfService;
				 $status_hash5g{$du_id}{$cell_id}{E1SctpOutOfService} += $E1SctpOutOfService;
				 $status_hash5g{$du_id}{$cell_id}{X2SctpOutOfService} += $X2SctpOutOfService;
				 $status_hash5g{$du_id}{$cell_id}{MDSSendFail} += $MDSSendFail;
				 $status_hash5g{$du_id}{$cell_id}{CacCallCountOver} += $CacCallCountOver;
				 $status_hash5g{$du_id}{$cell_id}{ResourceAllocFail} += $ResourceAllocFail;
				 $status_hash5g{$du_id}{$cell_id}{NotSupportedQci} += $NotSupportedQci;
				 $status_hash5g{$du_id}{$cell_id}{InvalidCallContext} += $InvalidCallContext;
				 $status_hash5g{$du_id}{$cell_id}{CellRelease} += $CellRelease;
				 $status_hash5g{$du_id}{$cell_id}{CallAllocationFail} += $CallAllocationFail;
				 $status_hash5g{$du_id}{$cell_id}{UpAllocationFail} += $UpAllocationFail;
				 $status_hash5g{$du_id}{$cell_id}{InvalidCallId} += $InvalidCallId;
				 $status_hash5g{$du_id}{$cell_id}{InvalidPlmn} += $InvalidPlmn;
				 $status_hash5g{$du_id}{$cell_id}{T310Expiry} += $T310Expiry;
				 $status_hash5g{$du_id}{$cell_id}{RandomAccessProblem} += $RandomAccessProblem;
				 $status_hash5g{$du_id}{$cell_id}{RlcMaxNumRetx} += $RlcMaxNumRetx;
				 $status_hash5g{$du_id}{$cell_id}{ScgChangeFailure} += $ScgChangeFailure;
				 $status_hash5g{$du_id}{$cell_id}{ScgReconfigFailure} += $ScgReconfigFailure;
				 $status_hash5g{$du_id}{$cell_id}{Srb3IntegrityFailure} += $Srb3IntegrityFailure;
				 $status_hash5g{$du_id}{$cell_id}{F1apRadioUnspecified} +=$F1apRadioUnspecified;
				 $status_hash5g{$du_id}{$cell_id}{F1apRadioRLFailure} += $F1apRadioRLFailure;
				 $status_hash5g{$du_id}{$cell_id}{F1apRadioUnknownOrAlreadyAllocatedCuUeF1apId} += $F1apRadioUnknownOrAlreadyAllocatedCuUeF1apId;
				 $status_hash5g{$du_id}{$cell_id}{F1apRadioUnknownOrAlreadyAllocatedDuUeF1apId} += $F1apRadioUnknownOrAlreadyAllocatedDuUeF1apId;
				 $status_hash5g{$du_id}{$cell_id}{F1apRadioUnknownInconsistentPairOfUeF1apId} += $F1apRadioUnknownInconsistentPairOfUeF1apId;
				 $status_hash5g{$du_id}{$cell_id}{F1apRadioInteraction} += $F1apRadioInteraction;
				 $status_hash5g{$du_id}{$cell_id}{F1apRadioNotSupportedQCI} += $F1apRadioNotSupportedQCI;
				 $status_hash5g{$du_id}{$cell_id}{F1apRadioDesirableRadioReasons} += $F1apRadioDesirableRadioReasons;
				 $status_hash5g{$du_id}{$cell_id}{F1apRadioUnavailableRadioReasons} += $F1apRadioUnavailableRadioReasons;
				 $status_hash5g{$du_id}{$cell_id}{F1apRadioProcedureCancelled} += $F1apRadioProcedureCancelled;
				 $status_hash5g{$du_id}{$cell_id}{F1apRadioNormalRelease} +=  $F1apRadioNormalRelease;
				 $status_hash5g{$du_id}{$cell_id}{F1apRadioCellNotAvailable} += $F1apRadioCellNotAvailable;
				 $status_hash5g{$du_id}{$cell_id}{F1apRadioRLFailureothers} += $F1apRadioRLFailureothers;
				 $status_hash5g{$du_id}{$cell_id}{F1apRadioUeRejection} += $F1apRadioUeRejection;
				 $status_hash5g{$du_id}{$cell_id}{F1apRadioResourcesNotAvailableForTheSlice} += $F1apRadioResourcesNotAvailableForTheSlice;
				 $status_hash5g{$du_id}{$cell_id}{F1apTransportUnspecified} += $F1apTransportUnspecified;
				 $status_hash5g{$du_id}{$cell_id}{F1apTransportResourceUnavailable} +=$F1apTransportResourceUnavailable;
				 $status_hash5g{$du_id}{$cell_id}{F1apProtocolTransferSyntaxError} += $F1apProtocolTransferSyntaxError;
				 $status_hash5g{$du_id}{$cell_id}{F1apProtocolAbstractSyntaxErrorReject} += $F1apProtocolAbstractSyntaxErrorReject;
				 $status_hash5g{$du_id}{$cell_id}{F1apProtocolAbstractSyntaxErrorIgnore} += $F1apProtocolAbstractSyntaxErrorIgnore;
				 $status_hash5g{$du_id}{$cell_id}{F1apProtocolMessageNotCompatible} += $F1apProtocolMessageNotCompatible;
				 $status_hash5g{$du_id}{$cell_id}{F1apProtocolSemanticError} += $F1apProtocolSemanticError;
				 $status_hash5g{$du_id}{$cell_id}{F1apProtocolAbstractSyntaxError} += $F1apProtocolAbstractSyntaxError;
				 $status_hash5g{$du_id}{$cell_id}{F1apProtocolUnspecified} += $F1apProtocolUnspecified;
				 $status_hash5g{$du_id}{$cell_id}{F1apMiscControlProcessingOverload} += $F1apMiscControlProcessingOverload;
				 $status_hash5g{$du_id}{$cell_id}{F1apMiscUnavailableResources} += $F1apMiscUnavailableResources;
				 $status_hash5g{$du_id}{$cell_id}{F1apMiscHardwareFailure} += $F1apMiscHardwareFailure;
				 $status_hash5g{$du_id}{$cell_id}{F1apMiscUnspecifiedFailure} += $F1apMiscUnspecifiedFailure;
				 $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerPartialHandover} += $X2apRadioNetworkLayerPartialHandover;
				 $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerUnknownNewEnbUeX2apId} += $X2apRadioNetworkLayerUnknownNewEnbUeX2apId;
				 $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerUnknownOldEnbUeX2apId} += $X2apRadioNetworkLayerUnknownOldEnbUeX2apId;
				 $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerUnknownPairOfUeX2apId} += $X2apRadioNetworkLayerUnknownPairOfUeX2apId;
				 $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerHoTargetNotAllowed} += $X2apRadioNetworkLayerHoTargetNotAllowed;
				 $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerTx2relocoverallExpiry} +=  $X2apRadioNetworkLayerTx2relocoverallExpiry;
				 $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerTrelocoverallExpiry} += $X2apRadioNetworkLayerTrelocoverallExpiry;
				 $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerCellNotAvailable} += $X2apRadioNetworkLayerCellNotAvailable;
				 $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerNoRadioResourcesAvailableInTargetCell} += $X2apRadioNetworkLayerNoRadioResourcesAvailableInTargetCell;
				 $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerInvalidMMEGroupID} += $X2apRadioNetworkLayerInvalidMMEGroupID;
				 $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerUnknownMMECode} += $X2apRadioNetworkLayerUnknownMMECode;
				 $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerEncryptionAndOrIntegrityProtectionAlgorithmsNotSupported} +=$X2apRadioNetworkLayerEncryptionAndOrIntegrityProtectionAlgorithmsNotSupported;
				 $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerReportCharacteristicsEmpty} += $X2apRadioNetworkLayerReportCharacteristicsEmpty;
				 $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerNoReportPeriodicity} += $X2apRadioNetworkLayerNoReportPeriodicity;
				 $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerExistingMeasurementID} += $X2apRadioNetworkLayerExistingMeasurementID;
				 $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerUnknownEnbMeasurementID} += $X2apRadioNetworkLayerUnknownEnbMeasurementID;
				 $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerMeasurementTemporarilyNotAvailable} += $X2apRadioNetworkLayerMeasurementTemporarilyNotAvailable;
				 $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerUnspecified} +=  $X2apRadioNetworkLayerUnspecified;
				 $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerLoadBalancing} += $X2apRadioNetworkLayerLoadBalancing;
				 $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerHandoverOptimisation} += $X2apRadioNetworkLayerHandoverOptimisation;
				 $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerValueOutOfAllowedRange} += $X2apRadioNetworkLayerValueOutOfAllowedRange;
				 $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerMultipleErabIdInstances} += $$X2apRadioNetworkLayerMultipleErabIdInstances;
				 $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerSwitchOffOngoing} += $X2apRadioNetworkLayerSwitchOffOngoing;
				 $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerNotSupportedQciValue} += $X2apRadioNetworkLayerNotSupportedQciValue;
				 $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerMeasurementNotSupportedForTheObject} += $X2apRadioNetworkLayerMeasurementNotSupportedForTheObject;
				 $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerTdcoverallExpiry} +=$X2apRadioNetworkLayerTdcoverallExpiry;
				 $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerTdcprepExpiry} += $X2apRadioNetworkLayerTdcprepExpiry;
				 $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerReduceLoad} += $X2apRadioNetworkLayerReduceLoad;
				 $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerResourceOptimisation} += $X2apRadioNetworkLayerResourceOptimisation;
				 $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerTimeCriticalAction} += $X2apRadioNetworkLayerTimeCriticalAction;
				 $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerTargetNotAllowed} += $X2apRadioNetworkLayerTargetNotAllowed;
				 $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerNoRadioResourcesAvailable} += $X2apRadioNetworkLayerNoRadioResourcesAvailable;
				 $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerInvalidQosCombination} += $X2apRadioNetworkLayerInvalidQosCombination;
				 $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerEncryptionAlgorithmsNotSupported} += $X2apRadioNetworkLayerEncryptionAlgorithmsNotSupported;
				 $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerProcedureCancelled} += $X2apRadioNetworkLayerProcedureCancelled;
				 $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerRrmPurpose} += $X2apRadioNetworkLayerRrmPurpose;
				 $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerImproveUserBitRate} +=  $X2apRadioNetworkLayerImproveUserBitRate;
				 $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerRadioConnectionWithUeLost} += $X2apRadioNetworkLayerRadioConnectionWithUeLost;
				 $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerFailureInTheRadioInterfaceProcedure} += $X2apRadioNetworkLayerFailureInTheRadioInterfaceProcedure;
				 $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerBearerOptionNotSupported} += $X2apRadioNetworkLayerBearerOptionNotSupported;
				 $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerCountReachesMaxValue} += $X2apRadioNetworkLayerCountReachesMaxValue;
				 $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerUnknownOldEngnbUeX2apId} += $X2apRadioNetworkLayerUnknownOldEngnbUeX2apId;
				 $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerPdcpOverload} += $X2apRadioNetworkLayerPdcpOverload;
				 $status_hash5g{$du_id}{$cell_id}{X2apTransportNetworkLayerTransportResourceUnavailable} += $X2apTransportNetworkLayerTransportResourceUnavailable;
				 $status_hash5g{$du_id}{$cell_id}{X2apTransportNetworkLayerUnspecified} += $X2apTransportNetworkLayerUnspecified;
				 $status_hash5g{$du_id}{$cell_id}{X2apProtocolTransferSyntaxError} += $X2apProtocolTransferSyntaxError;
				 $status_hash5g{$du_id}{$cell_id}{X2apProtocolAbstractSyntaxErrorReject} += $X2apProtocolAbstractSyntaxErrorReject;
				 $status_hash5g{$du_id}{$cell_id}{X2apProtocolAbstractSyntaxErrorIgnoreAndNotify} +=$X2apProtocolAbstractSyntaxErrorIgnoreAndNotify;
				 $status_hash5g{$du_id}{$cell_id}{X2apProtocolSemanticError} += $X2apProtocolSemanticError;
				 $status_hash5g{$du_id}{$cell_id}{X2apProtocolUnspecified} += $X2apProtocolUnspecified;
				 $status_hash5g{$du_id}{$cell_id}{X2apProtocolAbstractSyntaxErrorFalselyConstructedMessage} += $X2apProtocolAbstractSyntaxErrorFalselyConstructedMessage;
				 $status_hash5g{$du_id}{$cell_id}{X2apMiscControlProcessingOverload} +=  $X2apMiscControlProcessingOverload;
				 $status_hash5g{$du_id}{$cell_id}{X2apMiscHardwareFailure} += $X2apMiscHardwareFailure;
				 $status_hash5g{$du_id}{$cell_id}{X2apMiscNotEnoughUserPlaneProcessingResources} +=  $X2apMiscNotEnoughUserPlaneProcessingResources;
				 $status_hash5g{$du_id}{$cell_id}{X2apMiscUnspecified} +=  $X2apMiscUnspecified;
				 $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerUnspecified} += $E1apRadioNetworkLayerUnspecified;
				 $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerUnknownOrAlreadyAllocatedGnbCuCpUeE1apId} += $E1apRadioNetworkLayerUnknownOrAlreadyAllocatedGnbCuCpUeE1apId;
				 $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerUnknownOrAlreadyAllocatedGnbCuUpUeE1apId} += $E1apRadioNetworkLayerUnknownOrAlreadyAllocatedGnbCuUpUeE1apId;
				 $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerUnknownOrInconsistentPairOfUeE1apId} +=  $E1apRadioNetworkLayerUnknownOrInconsistentPairOfUeE1apId;
				 $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerInteractionWithOtherProcedure} += $E1apRadioNetworkLayerInteractionWithOtherProcedure;
				 $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerPdcpCountWrapAround} += $E1apRadioNetworkLayerPdcpCountWrapAround;
				 $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerNotSupportedQciValue} += $E1apRadioNetworkLayerNotSupportedQciValue;
				$status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerNotSupported5QiValue} += $E1apRadioNetworkLayerNotSupported5QiValue;
				$status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerEncryptionAlgorithmsNotSupported} +=      $E1apRadioNetworkLayerEncryptionAlgorithmsNotSupported;
				$status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerIntegrityProtectionAlgorithmsNotSupported} += $E1apRadioNetworkLayerIntegrityProtectionAlgorithmsNotSupported;
				$status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerUpIntegrityProtectionNotPossible} += $E1apRadioNetworkLayerUpIntegrityProtectionNotPossible;
				$status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerUpConfidentialityProtectionNotPossible} += $E1apRadioNetworkLayerUpConfidentialityProtectionNotPossible;
				$status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerMultiplePduSessionIdInstances} += $E1apRadioNetworkLayerMultiplePduSessionIdInstances;
				$status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerUnknownPduSessionId} += $E1apRadioNetworkLayerUnknownPduSessionId;
				$status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerMultipleQosFlowIdInstances} += $E1apRadioNetworkLayerMultipleQosFlowIdInstances;
				$status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerUnknownQosFlowId} += $E1apRadioNetworkLayerUnknownQosFlowId;
				$status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerMultipleDrbIdInstances} += $E1apRadioNetworkLayerMultipleDrbIdInstances;
				$status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerUnknownDrbId} += $E1apRadioNetworkLayerUnknownDrbId;
				$status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerInvalidQosCombination} += $E1apRadioNetworkLayerInvalidQosCombination;
				$status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerProcedureCancelled} +=  $E1apRadioNetworkLayerProcedureCancelled;
				$status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerNormalRelease} += $E1apRadioNetworkLayerNormalRelease;
				$status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerNoRadioResourcesAvailable} += $E1apRadioNetworkLayerNoRadioResourcesAvailable;
				$status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerActionDesirableForRadioReasons} += $E1apRadioNetworkLayerActionDesirableForRadioReasons;
				$status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerResourcesNotAvailableForTheSlice} += $E1apRadioNetworkLayerResourcesNotAvailableForTheSlice;
				$status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerPdcpConfigurationNotSupported} +=  $E1apRadioNetworkLayerPdcpConfigurationNotSupported;
				$status_hash5g{$du_id}{$cell_id}{E1apTransportLayerUnspecified} += $E1apTransportLayerUnspecified;
				$status_hash5g{$du_id}{$cell_id}{E1apTransportLayerTransportResourceUnavailable} += $E1apTransportLayerTransportResourceUnavailable;
				$status_hash5g{$du_id}{$cell_id}{E1apProtocolTransferSyntaxError} += $E1apProtocolTransferSyntaxError;
				$status_hash5g{$du_id}{$cell_id}{E1apProtocolAbstractSyntaxErrorReject} += $E1apProtocolAbstractSyntaxErrorReject;
				$status_hash5g{$du_id}{$cell_id}{E1apProtocolAbstractSyntaxErrorIgnoreAndNotify} += $E1apProtocolAbstractSyntaxErrorIgnoreAndNotify;
				$status_hash5g{$du_id}{$cell_id}{E1apProtocolMessageNotCompatibleWithReceiverState} +=  $E1apProtocolMessageNotCompatibleWithReceiverState;
				$status_hash5g{$du_id}{$cell_id}{E1apProtocolSemanticError} += $E1apProtocolSemanticError;
				$status_hash5g{$du_id}{$cell_id}{E1apProtocolAbstractSyntaxErrorFalselyConstructedMessage} +=  $E1apProtocolAbstractSyntaxErrorFalselyConstructedMessage;
				$status_hash5g{$du_id}{$cell_id}{E1apProtocolUnspecified} += $E1apProtocolUnspecified;
				$status_hash5g{$du_id}{$cell_id}{E1apMiscControlProcessingOverload} += $E1apMiscControlProcessingOverload;
				$status_hash5g{$du_id}{$cell_id}{E1apMiscNotEnoughUserPlaneProcessingResources} += $E1apMiscNotEnoughUserPlaneProcessingResources;
				$status_hash5g{$du_id}{$cell_id}{E1apMiscHardwareFailure} += $E1apMiscHardwareFailure;
				$status_hash5g{$du_id}{$cell_id}{E1apMiscUnspecified} += $E1apMiscUnspecified;
				$status_hash5g{$du_id}{$cell_id}{DuULRadioLinkFailure} += $DuULRadioLinkFailure;
				$status_hash5g{$du_id}{$cell_id}{DuRlcMaxNumRetx} += $DuRlcMaxNumRetx;
				$status_hash5g{$du_id}{$cell_id}{CpSrb3IntegrityFailure} += $CpSrb3IntegrityFailure;
				$status_hash5g{$du_id}{$cell_id}{CuOverload} += $CuOverload;
				$status_hash5g{$du_id}{$cell_id}{StoreRrcMessageError} += $StoreRrcMessageError;
				$status_hash5g{$du_id}{$cell_id}{StoreE1MessageError} += $StoreE1MessageError;
				$status_hash5g{$du_id}{$cell_id}{StoreF1MessageError} += $StoreF1MessageError;
				$status_hash5g{$du_id}{$cell_id}{SendRrcMessageError} += $SendRrcMessageError;
				$status_hash5g{$du_id}{$cell_id}{SendE1MessageError} +=  $SendE1MessageError;
				$status_hash5g{$du_id}{$cell_id}{SendF1MessageError} +=  $SendF1MessageError;
				$status_hash5g{$du_id}{$cell_id}{StoreX2MessageError} += $StoreX2MessageError;
				$status_hash5g{$du_id}{$cell_id}{SendX2MessageError} += $SendX2MessageError;
				$status_hash5g{$du_id}{$cell_id}{TmOutX2ChangeConfirm} += $TmOutX2ChangeConfirm;
				$status_hash5g{$du_id}{$cell_id}{TmOutX2SNStatusTransfer} += $TmOutX2SNStatusTransfer;
				$status_hash5g{$du_id}{$cell_id}{SpCellSelectionFail} += $SpCellSelectionFail;
				$status_hash5g{$du_id}{$cell_id}{InvalidCellId} += $InvalidCellId;
				$status_hash5g{$du_id}{$cell_id}{F1apRadioAmfInitiatedAbnormalRelease} += $F1apRadioAmfInitiatedAbnormalRelease ;
				$status_hash5g{$du_id}{$cell_id}{F1apRadioReleaseDueToPreEmption} += $F1apRadioReleaseDueToPreEmption;
				$status_hash5g{$du_id}{$cell_id}{F1apRadioPlmnNotServedByTheGnbCu} += $F1apRadioPlmnNotServedByTheGnbCu;
				$status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerUeDlMaxIPDataRateReason} +=$E1apRadioNetworkLayerUeDlMaxIPDataRateReason;
				$status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerUpIntegrityProtectionFailure} +=  $E1apRadioNetworkLayerUpIntegrityProtectionFailure;
				$status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerReleaseDueToPreEmption} += $$E1apRadioNetworkLayerReleaseDueToPreEmption;
				$status_hash5g{$du_id}{$cell_id}{TmOutResumeForMrBased} += $TmOutResumeForMrBased;
				$status_hash5g{$du_id}{$cell_id}{SynchReconfigFailureScg} += $$SynchReconfigFailureScg;
				$status_hash5g{$du_id}{$cell_id}{NoFault} += $NoFault;
				$status_hash5g{$du_id}{$cell_id}{OMIntervention} += $OMIntervention;
				$status_hash5g{$du_id}{$cell_id}{VmScaleIn} += $VmScaleIn;
				$status_hash5g{$du_id}{$cell_id}{UserInactivity} += $UserInactivity;
				$status_hash5g{$du_id}{$cell_id}{ScgMobility} += $ScgMobility;
				$status_hash5g{$du_id}{$cell_id}{MeasurementReportBasedRelease} += $MeasurementReportBasedRelease;
				$status_hash5g{$du_id}{$cell_id}{F1apMiscOMIntervention} += $F1apMiscOMIntervention;
				$status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerHandoverDesirableForRadioReasons} +=  $X2apRadioNetworkLayerHandoverDesirableForRadioReasons;
				$status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerTimeCriticalHandover} += $X2apRadioNetworkLayerTimeCriticalHandover;
				$status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerResourceOptimisationHandover} += $X2apRadioNetworkLayerResourceOptimisationHandover;
				$status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerReduceLoadInServingCell} += $X2apRadioNetworkLayerReduceLoadInServingCell;
				$status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerActionDesirableForRadioReasons} +=  $X2apRadioNetworkLayerActionDesirableForRadioReasons;
				$status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerUserInactivity} += $X2apRadioNetworkLayerUserInactivity;
				$status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerMcgMobility} += $X2apRadioNetworkLayerMcgMobility;
				$status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerScgMobility} += $X2apRadioNetworkLayerScgMobility;
				$status_hash5g{$du_id}{$cell_id}{X2apProtocolMessageNotCompatibleWithReceiverState} += $X2apProtocolMessageNotCompatibleWithReceiverState;
				$status_hash5g{$du_id}{$cell_id}{X2apMiscOMIntervention} += $X2apMiscOMIntervention;
				$status_hash5g{$du_id}{$cell_id}{E1apMiscOMIntervention} += $E1apMiscOMIntervention ;
				$status_hash5g{$du_id}{$cell_id}{InternalX2UEContextRelease} += $InternalX2UEContextRelease;
			}
		}
		close(CUCP);
	}

	# if (-e "$TempPathDays/$cucpCslHexa_5gFile") {
		# open (CUCP_D, "<$TempPathDays/$cucpCslHexa_5gFile");
		# while(<CUCP_D>) {
			# my($ne_idD, $NE_name, $cellLocationD, $NoFaultD,$ConnectionReconfigD, $ContextSetupD, $E1BearerSetupD, $E1BearerContextModificationD, $F1UeContextModificationD, $F1UeContextReleaseD, $X2SgnbReconfigurationCompleteD, $tX2ModificationConfirmD, $ResourceSetupD, $F1SctpOutOfServiceD, $E1SctpOutOfServiceD, $X2SctpOutOfServiceD, $MDSSendFailD, $CacCallCountOverD, $NotSupportedQciD, $InvalidCallContextD, $ResourceAllocFailD,$OMInterventionD,$VmScaleInD,$CellReleaseD,$CallAllocationFailD,$UpAllocationFailD,$InvalidCallIdD,$InvalidPlmnD,$UserInactivityD,$T310ExpiryD,$RandomAccessProblemD,$RlcMaxNumRetxD,$ScgChangeFailureD,$ScgReconfigFailureD,$Srb3IntegrityFailureD,$ScgMobilityD,$MeasurementReportBasedReleaseD,$F1apRadioUnspecifiedD,$F1apRadioRLFailureD,$F1apRadioUnknownOrAlreadyAllocatedCuUeF1apIdD,$F1apRadioUnknownOrAlreadyAllocatedDuUeF1apIdD,$F1apRadioUnknownInconsistentPairOfUeF1apIdD,$F1apRadioInteractionD,$F1apRadioNotSupportedQCID,$F1apRadioDesirableRadioReasonsD,$F1apRadioUnavailableRadioReasonsD,$F1apRadioProcedureCancelledD,$F1apRadioNormalReleaseD,$F1apRadioCellNotAvailableD,$F1apRadioRLFailureothersD,$F1apRadioUeRejectionD,$F1apRadioResourcesNotAvailableForTheSliceD,$F1apTransportUnspecifiedD,$F1apTransportResourceUnavailableD,$F1apProtocolTransferSyntaxErrorD,$F1apProtocolAbstractSyntaxErrorRejectD,$F1apProtocolAbstractSyntaxErrorIgnoreD,$F1apProtocolMessageNotCompatibleD,$F1apProtocolSemanticErrorD,$F1apProtocolAbstractSyntaxErrorD,$F1apProtocolUnspecifiedD,$F1apMiscControlProcessingOverloadD,$F1apMiscUnavailableResourcesD,$F1apMiscHardwareFailureD,$F1apMiscOMInterventionD,$F1apMiscUnspecifiedFailureD,$X2apRadioNetworkLayerHandoverDesirableForRadioReasonsD,$X2apRadioNetworkLayerTimeCriticalHandoverD,$X2apRadioNetworkLayerResourceOptimisationHandoverD,$X2apRadioNetworkLayerReduceLoadInServingCellD,$X2apRadioNetworkLayerPartialHandoverD,$X2apRadioNetworkLayerUnknownNewEnbUeX2apIdD,$X2apRadioNetworkLayerUnknownOldEnbUeX2apIdD,$X2apRadioNetworkLayerUnknownPairOfUeX2apIdD,$X2apRadioNetworkLayerHoTargetNotAllowedD,$X2apRadioNetworkLayerTx2relocoverallExpiryD,$X2apRadioNetworkLayerTrelocoverallExpiryD,$X2apRadioNetworkLayerCellNotAvailableD,$X2apRadioNetworkLayerNoRadioResourcesAvailableInTargetCellD,$X2apRadioNetworkLayerInvalidMMEGroupIDD,$X2apRadioNetworkLayerUnknownMMECodeD,$X2apRadioNetworkLayerEncryptionAndOrIntegrityProtectionAlgorithmsNotSupportedD,$X2apRadioNetworkLayerReportCharacteristicsEmptyD,$X2apRadioNetworkLayerNoReportPeriodicityD,$X2apRadioNetworkLayerExistingMeasurementIDD,$X2apRadioNetworkLayerUnknownEnbMeasurementIDD,$X2apRadioNetworkLayerMeasurementTemporarilyNotAvailableD,$X2apRadioNetworkLayerUnspecifiedD,$X2apRadioNetworkLayerLoadBalancingD,$X2apRadioNetworkLayerHandoverOptimisationD,$X2apRadioNetworkLayerValueOutOfAllowedRangeD,$X2apRadioNetworkLayerMultipleErabIdInstancesD,$X2apRadioNetworkLayerSwitchOffOngoingD,$X2apRadioNetworkLayerNotSupportedQciValueD,$X2apRadioNetworkLayerMeasurementNotSupportedForTheObjectD,$X2apRadioNetworkLayerTdcoverallExpiryD,$X2apRadioNetworkLayerTdcprepExpiryD,$X2apRadioNetworkLayerActionDesirableForRadioReasonsD,$X2apRadioNetworkLayerReduceLoadD,$X2apRadioNetworkLayerResourceOptimisationD,$X2apRadioNetworkLayerTimeCriticalActionD,$X2apRadioNetworkLayerTargetNotAllowedD,$X2apRadioNetworkLayerNoRadioResourcesAvailableD,$X2apRadioNetworkLayerInvalidQosCombinationD,$X2apRadioNetworkLayerEncryptionAlgorithmsNotSupportedD,$X2apRadioNetworkLayerProcedureCancelledD,$X2apRadioNetworkLayerRrmPurposeD,$X2apRadioNetworkLayerImproveUserBitRateD,$X2apRadioNetworkLayerUserInactivityD,$X2apRadioNetworkLayerMcgMobilityD,$X2apRadioNetworkLayerScgMobilityD,$X2apRadioNetworkLayerRadioConnectionWithUeLostD,$X2apRadioNetworkLayerFailureInTheRadioInterfaceProcedureD,$X2apRadioNetworkLayerBearerOptionNotSupportedD,$X2apRadioNetworkLayerCountReachesMaxValueD,$X2apRadioNetworkLayerUnknownOldEngnbUeX2apIdD,$X2apRadioNetworkLayerPdcpOverloadD,$X2apTransportNetworkLayerTransportResourceUnavailableD,$X2apTransportNetworkLayerUnspecifiedD,$X2apProtocolTransferSyntaxErrorD,$X2apProtocolAbstractSyntaxErrorRejectD,$X2apProtocolAbstractSyntaxErrorIgnoreAndNotifyD,$X2apProtocolMessageNotCompatibleWithReceiverStateD,$X2apProtocolSemanticErrorD,$X2apProtocolUnspecifiedD,$X2apProtocolAbstractSyntaxErrorFalselyConstructedMessageD,$X2apMiscControlProcessingOverloadD,$X2apMiscHardwareFailureD,$X2apMiscOMInterventionD,$X2apMiscNotEnoughUserPlaneProcessingResourcesD,$X2apMiscUnspecifiedD,$E1apRadioNetworkLayerUnspecifiedD,$E1apRadioNetworkLayerUnknownOrAlreadyAllocatedGnbCuCpUeE1apIdD,$E1apRadioNetworkLayerUnknownOrAlreadyAllocatedGnbCuUpUeE1apIdD,$E1apRadioNetworkLayerUnknownOrInconsistentPairOfUeE1apIdD,$E1apRadioNetworkLayerInteractionWithOtherProcedureD,$E1apRadioNetworkLayerPdcpCountWrapAroundD,$E1apRadioNetworkLayerNotSupportedQciValueD,$E1apRadioNetworkLayerNotSupported5QiValueD,$E1apRadioNetworkLayerEncryptionAlgorithmsNotSupportedD,$E1apRadioNetworkLayerIntegrityProtectionAlgorithmsNotSupportedD,$E1apRadioNetworkLayerUpIntegrityProtectionNotPossibleD,$E1apRadioNetworkLayerUpConfidentialityProtectionNotPossibleD,$E1apRadioNetworkLayerMultiplePduSessionIdInstancesD,$E1apRadioNetworkLayerUnknownPduSessionIdD,$E1apRadioNetworkLayerMultipleQosFlowIdInstancesD,$E1apRadioNetworkLayerUnknownQosFlowIdD,$E1apRadioNetworkLayerMultipleDrbIdInstancesD,$E1apRadioNetworkLayerUnknownDrbIdD,$E1apRadioNetworkLayerInvalidQosCombinationD,$E1apRadioNetworkLayerProcedureCancelledD,$E1apRadioNetworkLayerNormalReleaseD,$E1apRadioNetworkLayerNoRadioResourcesAvailableD,$E1apRadioNetworkLayerActionDesirableForRadioReasonsD,$E1apRadioNetworkLayerResourcesNotAvailableForTheSliceD,$E1apRadioNetworkLayerPdcpConfigurationNotSupportedD,$E1apTransportLayerUnspecifiedD,$E1apTransportLayerTransportResourceUnavailableD,$E1apProtocolTransferSyntaxErrorD,$E1apProtocolAbstractSyntaxErrorRejectD,$E1apProtocolAbstractSyntaxErrorIgnoreAndNotifyD,$E1apProtocolMessageNotCompatibleWithReceiverStateD,$E1apProtocolSemanticErrorD,$E1apProtocolAbstractSyntaxErrorFalselyConstructedMessageD,$E1apProtocolUnspecifiedD,$E1apMiscControlProcessingOverloadD,$E1apMiscNotEnoughUserPlaneProcessingResourcesD,$E1apMiscHardwareFailureD,$E1apMiscOMInterventionD, $E1apMiscUnspecifiedD,$DuULRadioLinkFailureD,$DuRlcMaxNumRetxD,$CpSrb3IntegrityFailureD,$CuOverloadD,$StoreRrcMessageErrorD,$StoreE1MessageErrorD,$StoreF1MessageErrorD,$SendRrcMessageErrorD,$SendE1MessageErrorD,$SendF1MessageErrorD,$StoreX2MessageErrorD,$SendX2MessageErrorD,$TmOutX2ChangeConfirmD,$TmOutX2SNStatusTransferD,$SpCellSelectionFailD,$InvalidCellIdD,$F1apRadioAmfInitiatedAbnormalReleaseD,$F1apRadioReleaseDueToPreEmptionD,$F1apRadioPlmnNotServedByTheGnbCuD,$E1apRadioNetworkLayerUeDlMaxIPDataRateReasonD,$E1apRadioNetworkLayerUpIntegrityProtectionFailureD,$E1apRadioNetworkLayerReleaseDueToPreEmptionD,$TmOutResumeForMrBasedD,$SynchReconfigFailureScgD,$InternalX2UEContextReleaseD ) = (split(',', $_))[0,2,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,71,72,73,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198];
			# my($du_id, $cell_id) = (split('/', $cellLocationD))[1,2];
			# #print "gNBId =$du_id\n";
			# #print "endc attempts cell_id = $cell_id\n";
			# # my $DU_NUM = $given_NE;
			# # $DU_NUM =~ s/DU_/gNB_DU_ID/g;
			# #if ($du_id eq "$given_gNBId"){
			# # if (($du_id eq "$given_gNBId") && ($DU_NUM eq $cell_id)){
			# if (index($NE_name, $given_AUID) != -1) || ($du_id eq $given_NE) {			
				# $status_hash5g{$du_id}{$cell_id}{ConnectionReconfigD} += $ConnectionReconfigD;
				# $status_hash5g{$du_id}{$cell_id}{ContextSetupD} += $ContextSetupD;
				# $status_hash5g{$du_id}{$cell_id}{ConnectionReconfigD} += $ConnectionReconfigD;
				# $status_hash5g{$du_id}{$cell_id}{ContextSetupD} += $ContextSetupD;
				# $status_hash5g{$du_id}{$cell_id}{E1BearerSetupD} += $E1BearerSetupD;
				# $status_hash5g{$du_id}{$cell_id}{E1BearerContextModificationD}+= $E1BearerContextModificationD;
				# $status_hash5g{$du_id}{$cell_id}{F1UeContextModificationD} += $F1UeContextModificationD;
				# $status_hash5g{$du_id}{$cell_id}{F1UeContextReleaseD} += $F1UeContextReleaseD;
				# $status_hash5g{$du_id}{$cell_id}{X2SgnbReconfigurationCompleteD} += $X2SgnbReconfigurationCompleteD;
				# $status_hash5g{$du_id}{$cell_id}{tX2ModificationConfirmD} += $tX2ModificationConfirmD;
				# $status_hash5g{$du_id}{$cell_id}{ResourceSetupD} +=$ResourceSetupD;
				# $status_hash5g{$du_id}{$cell_id}{F1SctpOutOfServiceD} += $F1SctpOutOfServiceD;
				# $status_hash5g{$du_id}{$cell_id}{E1SctpOutOfServiceD} += $E1SctpOutOfServiceD;
				# $status_hash5g{$du_id}{$cell_id}{X2SctpOutOfServiceD} += $X2SctpOutOfServiceD;
				# $status_hash5g{$du_id}{$cell_id}{MDSSendFailD} += $MDSSendFailD;
				# $status_hash5g{$du_id}{$cell_id}{CacCallCountOverD} += $CacCallCountOverD;
				# $status_hash5g{$du_id}{$cell_id}{ResourceAllocFailD} += $ResourceAllocFailD;
				# $status_hash5g{$du_id}{$cell_id}{NotSupportedQciD} += $NotSupportedQciD;
				# $status_hash5g{$du_id}{$cell_id}{InvalidCallContextD} += $InvalidCallContextD;
				# $status_hash5g{$du_id}{$cell_id}{CellReleaseD} += $CellReleaseD;
				# $status_hash5g{$du_id}{$cell_id}{CallAllocationFailD} += $CallAllocationFailD;
				# $status_hash5g{$du_id}{$cell_id}{UpAllocationFailD} += $UpAllocationFailD;
				# $status_hash5g{$du_id}{$cell_id}{InvalidCallIdD} += $InvalidCallIdD;
				# $status_hash5g{$du_id}{$cell_id}{InvalidPlmnD} += $InvalidPlmnD;
				# $status_hash5g{$du_id}{$cell_id}{T310ExpiryD} += $T310ExpiryD;
				# $status_hash5g{$du_id}{$cell_id}{RandomAccessProblemD} += $RandomAccessProblemD;
				# $status_hash5g{$du_id}{$cell_id}{RlcMaxNumRetxD} += $RlcMaxNumRetxD;
				# $status_hash5g{$du_id}{$cell_id}{ScgChangeFailureD} += $ScgChangeFailureD;
				# $status_hash5g{$du_id}{$cell_id}{ScgReconfigFailureD} += $ScgReconfigFailureD;
				# $status_hash5g{$du_id}{$cell_id}{Srb3IntegrityFailureD} += $Srb3IntegrityFailureD;
				# $status_hash5g{$du_id}{$cell_id}{F1apRadioUnspecifiedD} +=$F1apRadioUnspecifiedD;
				# $status_hash5g{$du_id}{$cell_id}{F1apRadioRLFailureD} += $F1apRadioRLFailureD;
				# $status_hash5g{$du_id}{$cell_id}{F1apRadioUnknownOrAlreadyAllocatedCuUeF1apIdD} += $F1apRadioUnknownOrAlreadyAllocatedCuUeF1apIdD;
				# $status_hash5g{$du_id}{$cell_id}{F1apRadioUnknownOrAlreadyAllocatedDuUeF1apIdD} += $F1apRadioUnknownOrAlreadyAllocatedDuUeF1apIdD;
				# $status_hash5g{$du_id}{$cell_id}{F1apRadioUnknownInconsistentPairOfUeF1apIdD} += $F1apRadioUnknownInconsistentPairOfUeF1apIdD;
				# $status_hash5g{$du_id}{$cell_id}{F1apRadioInteractionD} += $F1apRadioInteractionD;
				# $status_hash5g{$du_id}{$cell_id}{F1apRadioNotSupportedQCID} += $F1apRadioNotSupportedQCID;
				# $status_hash5g{$du_id}{$cell_id}{F1apRadioDesirableRadioReasonsD} += $F1apRadioDesirableRadioReasonsD;
				# $status_hash5g{$du_id}{$cell_id}{F1apRadioUnavailableRadioReasonsD} += $F1apRadioUnavailableRadioReasonsD;
				# $status_hash5g{$du_id}{$cell_id}{F1apRadioProcedureCancelledD} += $F1apRadioProcedureCancelledD;
				# $status_hash5g{$du_id}{$cell_id}{F1apRadioNormalReleaseD} +=  $F1apRadioNormalReleaseD;
				# $status_hash5g{$du_id}{$cell_id}{F1apRadioCellNotAvailableD} += $F1apRadioCellNotAvailableD;
				# $status_hash5g{$du_id}{$cell_id}{F1apRadioRLFailureothersD} += $F1apRadioRLFailureothersD;
				# $status_hash5g{$du_id}{$cell_id}{F1apRadioUeRejectionD} += $F1apRadioUeRejectionD;
				# $status_hash5g{$du_id}{$cell_id}{F1apRadioResourcesNotAvailableForTheSliceD} += $F1apRadioResourcesNotAvailableForTheSliceD;
				# $status_hash5g{$du_id}{$cell_id}{F1apTransportUnspecifiedD} += $F1apTransportUnspecifiedD;
				# $status_hash5g{$du_id}{$cell_id}{F1apTransportResourceUnavailableD} +=$F1apTransportResourceUnavailableD;
				# $status_hash5g{$du_id}{$cell_id}{F1apProtocolTransferSyntaxErrorD} += $F1apProtocolTransferSyntaxErrorD;
				# $status_hash5g{$du_id}{$cell_id}{F1apProtocolAbstractSyntaxErrorRejectD} += $F1apProtocolAbstractSyntaxErrorRejectD;
				# $status_hash5g{$du_id}{$cell_id}{F1apProtocolAbstractSyntaxErrorIgnoreD} += $F1apProtocolAbstractSyntaxErrorIgnoreD;
				# $status_hash5g{$du_id}{$cell_id}{F1apProtocolMessageNotCompatibleD} += $F1apProtocolMessageNotCompatibleD;
				# $status_hash5g{$du_id}{$cell_id}{F1apProtocolSemanticErrorD} += $F1apProtocolSemanticErrorD;
				# $status_hash5g{$du_id}{$cell_id}{F1apProtocolAbstractSyntaxErrorD} += $F1apProtocolAbstractSyntaxErrorD;
				# $status_hash5g{$du_id}{$cell_id}{F1apProtocolUnspecifiedD} += $F1apProtocolUnspecifiedD;
				# $status_hash5g{$du_id}{$cell_id}{F1apMiscControlProcessingOverloadD} += $F1apMiscControlProcessingOverloadD;
				# $status_hash5g{$du_id}{$cell_id}{F1apMiscUnavailableResourcesD} += $F1apMiscUnavailableResourcesD;
				# $status_hash5g{$du_id}{$cell_id}{F1apMiscHardwareFailureD} += $F1apMiscHardwareFailureD;
				# $status_hash5g{$du_id}{$cell_id}{F1apMiscUnspecifiedFailureD} += $F1apMiscUnspecifiedFailureD;
				# $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerPartialHandoverD} += $X2apRadioNetworkLayerPartialHandoverD;
				# $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerUnknownNewEnbUeX2apIdD} += $X2apRadioNetworkLayerUnknownNewEnbUeX2apIdD;
				# $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerUnknownOldEnbUeX2apIdD} += $X2apRadioNetworkLayerUnknownOldEnbUeX2apIdD;
				# $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerUnknownPairOfUeX2apIdD} += $X2apRadioNetworkLayerUnknownPairOfUeX2apIdD;
				# $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerHoTargetNotAllowedD} += $X2apRadioNetworkLayerHoTargetNotAllowedD;
				# $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerTx2relocoverallExpiryD} +=  $X2apRadioNetworkLayerTx2relocoverallExpiryD;
				# $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerTrelocoverallExpiryD} += $X2apRadioNetworkLayerTrelocoverallExpiryD;
				# $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerCellNotAvailableD} += $X2apRadioNetworkLayerCellNotAvailableD;
				# $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerNoRadioResourcesAvailableInTargetCellD} += $X2apRadioNetworkLayerNoRadioResourcesAvailableInTargetCellD;
				# $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerInvalidMMEGroupIDD} += $X2apRadioNetworkLayerInvalidMMEGroupIDD;
				# $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerUnknownMMECodeD} += $X2apRadioNetworkLayerUnknownMMECodeD;
				# $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerEncryptionAndOrIntegrityProtectionAlgorithmsNotSupportedD} +=$X2apRadioNetworkLayerEncryptionAndOrIntegrityProtectionAlgorithmsNotSupportedD;
				# $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerReportCharacteristicsEmptyD} += $X2apRadioNetworkLayerReportCharacteristicsEmptyD;
				# $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerNoReportPeriodicityD} += $X2apRadioNetworkLayerNoReportPeriodicityD;
				# $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerExistingMeasurementIDD} += $X2apRadioNetworkLayerExistingMeasurementIDD;
				# $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerUnknownEnbMeasurementIDD} += $X2apRadioNetworkLayerUnknownEnbMeasurementIDD;
				# $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerMeasurementTemporarilyNotAvailableD} += $X2apRadioNetworkLayerMeasurementTemporarilyNotAvailableD;
				# $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerUnspecifiedD} +=  $X2apRadioNetworkLayerUnspecifiedD;
				# $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerLoadBalancingD} += $X2apRadioNetworkLayerLoadBalancingD;
				# $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerHandoverOptimisationD} += $X2apRadioNetworkLayerHandoverOptimisationD;
				# $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerValueOutOfAllowedRangeD} += $X2apRadioNetworkLayerValueOutOfAllowedRangeD;
				# $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerMultipleErabIdInstancesD} += $$X2apRadioNetworkLayerMultipleErabIdInstancesD;
				# $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerSwitchOffOngoingD} += $X2apRadioNetworkLayerSwitchOffOngoingD;
				# $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerNotSupportedQciValueD} += $X2apRadioNetworkLayerNotSupportedQciValueD;
				# $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerMeasurementNotSupportedForTheObjectD} += $X2apRadioNetworkLayerMeasurementNotSupportedForTheObjectD;
				# $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerTdcoverallExpiryD} +=$X2apRadioNetworkLayerTdcoverallExpiryD;
				# $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerTdcprepExpiryD} += $X2apRadioNetworkLayerTdcprepExpiryD;
				# $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerReduceLoadD} += $X2apRadioNetworkLayerReduceLoadD;
				# $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerResourceOptimisationD} += $X2apRadioNetworkLayerResourceOptimisationD;
				# $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerTimeCriticalActionD} += $X2apRadioNetworkLayerTimeCriticalActionD;
				# $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerTargetNotAllowedD} += $X2apRadioNetworkLayerTargetNotAllowedD;
				# $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerNoRadioResourcesAvailableD} += $X2apRadioNetworkLayerNoRadioResourcesAvailableD;
				# $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerInvalidQosCombinationD} += $X2apRadioNetworkLayerInvalidQosCombinationD;
				# $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerEncryptionAlgorithmsNotSupportedD} += $X2apRadioNetworkLayerEncryptionAlgorithmsNotSupportedD;
				# $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerProcedureCancelledD} += $X2apRadioNetworkLayerProcedureCancelledD;
				# $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerRrmPurposeD} += $X2apRadioNetworkLayerRrmPurposeD;
				# $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerImproveUserBitRateD} +=  $X2apRadioNetworkLayerImproveUserBitRateD;
				# $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerRadioConnectionWithUeLostD} += $X2apRadioNetworkLayerRadioConnectionWithUeLostD;
				# $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerFailureInTheRadioInterfaceProcedureD} += $X2apRadioNetworkLayerFailureInTheRadioInterfaceProcedureD;
				# $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerBearerOptionNotSupportedD} += $X2apRadioNetworkLayerBearerOptionNotSupportedD;
				# $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerCountReachesMaxValueD} += $X2apRadioNetworkLayerCountReachesMaxValueD;
				# $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerUnknownOldEngnbUeX2apIdD} += $X2apRadioNetworkLayerUnknownOldEngnbUeX2apIdD;
				# $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerPdcpOverloadD} += $X2apRadioNetworkLayerPdcpOverloadD;
				# $status_hash5g{$du_id}{$cell_id}{X2apTransportNetworkLayerTransportResourceUnavailableD} += $X2apTransportNetworkLayerTransportResourceUnavailableD;
				# $status_hash5g{$du_id}{$cell_id}{X2apTransportNetworkLayerUnspecifiedD} += $X2apTransportNetworkLayerUnspecifiedD;
				# $status_hash5g{$du_id}{$cell_id}{X2apProtocolTransferSyntaxErrorD} += $X2apProtocolTransferSyntaxErrorD;
				# $status_hash5g{$du_id}{$cell_id}{X2apProtocolAbstractSyntaxErrorRejectD} += $X2apProtocolAbstractSyntaxErrorRejectD;
				# $status_hash5g{$du_id}{$cell_id}{X2apProtocolAbstractSyntaxErrorIgnoreAndNotifyD} +=$X2apProtocolAbstractSyntaxErrorIgnoreAndNotifyD;
				# $status_hash5g{$du_id}{$cell_id}{X2apProtocolSemanticErrorD} += $X2apProtocolSemanticErrorD;
				# $status_hash5g{$du_id}{$cell_id}{X2apProtocolUnspecifiedD} += $X2apProtocolUnspecifiedD;
				# $status_hash5g{$du_id}{$cell_id}{X2apProtocolAbstractSyntaxErrorFalselyConstructedMessageD} += $X2apProtocolAbstractSyntaxErrorFalselyConstructedMessageD;
				# $status_hash5g{$du_id}{$cell_id}{X2apMiscControlProcessingOverloadD} +=  $X2apMiscControlProcessingOverloadD;
				# $status_hash5g{$du_id}{$cell_id}{X2apMiscHardwareFailureD} += $X2apMiscHardwareFailureD;
				# $status_hash5g{$du_id}{$cell_id}{X2apMiscNotEnoughUserPlaneProcessingResourcesD} +=  $X2apMiscNotEnoughUserPlaneProcessingResourcesD;
				# $status_hash5g{$du_id}{$cell_id}{X2apMiscUnspecifiedD} +=  $X2apMiscUnspecifiedD;
				# $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerUnspecifiedD} += $E1apRadioNetworkLayerUnspecifiedD;
				# $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerUnknownOrAlreadyAllocatedGnbCuCpUeE1apIdD} += $E1apRadioNetworkLayerUnknownOrAlreadyAllocatedGnbCuCpUeE1apIdD;
				# $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerUnknownOrAlreadyAllocatedGnbCuUpUeE1apIdD} += $E1apRadioNetworkLayerUnknownOrAlreadyAllocatedGnbCuUpUeE1apIdD;
				# $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerUnknownOrInconsistentPairOfUeE1apIdD} +=  $E1apRadioNetworkLayerUnknownOrInconsistentPairOfUeE1apIdD;
				# $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerInteractionWithOtherProcedureD} += $E1apRadioNetworkLayerInteractionWithOtherProcedureD;
				# $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerPdcpCountWrapAroundD} += $E1apRadioNetworkLayerPdcpCountWrapAroundD;
				# $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerNotSupportedQciValueD} += $E1apRadioNetworkLayerNotSupportedQciValueD;
				# $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerNotSupported5QiValueD} += $E1apRadioNetworkLayerNotSupported5QiValueD;
				# $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerEncryptionAlgorithmsNotSupportedD} +=      $E1apRadioNetworkLayerEncryptionAlgorithmsNotSupportedD;
				# $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerIntegrityProtectionAlgorithmsNotSupportedD} += $E1apRadioNetworkLayerIntegrityProtectionAlgorithmsNotSupportedD;
				# $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerUpIntegrityProtectionNotPossibleD} += $E1apRadioNetworkLayerUpIntegrityProtectionNotPossibleD;
				# $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerUpConfidentialityProtectionNotPossibleD} += $E1apRadioNetworkLayerUpConfidentialityProtectionNotPossibleD;
				# $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerMultiplePduSessionIdInstancesD} += $E1apRadioNetworkLayerMultiplePduSessionIdInstancesD;
				# $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerUnknownPduSessionIdD} += $E1apRadioNetworkLayerUnknownPduSessionIdD;
				# $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerMultipleQosFlowIdInstancesD} += $E1apRadioNetworkLayerMultipleQosFlowIdInstancesD;
				# $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerUnknownQosFlowIdD} += $E1apRadioNetworkLayerUnknownQosFlowIdD;
				# $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerMultipleDrbIdInstancesD} += $E1apRadioNetworkLayerMultipleDrbIdInstancesD;
				# $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerUnknownDrbIdD} += $E1apRadioNetworkLayerUnknownDrbIdD;
				# $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerInvalidQosCombinationD} += $E1apRadioNetworkLayerInvalidQosCombinationD;
				# $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerProcedureCancelledD} +=  $E1apRadioNetworkLayerProcedureCancelledD;
				# $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerNormalReleaseD} += $E1apRadioNetworkLayerNormalReleaseD;
				# $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerNoRadioResourcesAvailableD} += $E1apRadioNetworkLayerNoRadioResourcesAvailableD;
				# $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerActionDesirableForRadioReasonsD} += $E1apRadioNetworkLayerActionDesirableForRadioReasonsD;
				# $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerResourcesNotAvailableForTheSliceD} += $E1apRadioNetworkLayerResourcesNotAvailableForTheSliceD;
				# $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerPdcpConfigurationNotSupportedD} +=  $E1apRadioNetworkLayerPdcpConfigurationNotSupportedD;
				# $status_hash5g{$du_id}{$cell_id}{E1apTransportLayerUnspecifiedD} += $E1apTransportLayerUnspecifiedD;
				# $status_hash5g{$du_id}{$cell_id}{E1apTransportLayerTransportResourceUnavailableD} += $E1apTransportLayerTransportResourceUnavailableD;
				# $status_hash5g{$du_id}{$cell_id}{E1apProtocolTransferSyntaxErrorD} += $E1apProtocolTransferSyntaxErrorD;
				# $status_hash5g{$du_id}{$cell_id}{E1apProtocolAbstractSyntaxErrorRejectD} += $E1apProtocolAbstractSyntaxErrorRejectD;
				# $status_hash5g{$du_id}{$cell_id}{E1apProtocolAbstractSyntaxErrorIgnoreAndNotifyD} += $E1apProtocolAbstractSyntaxErrorIgnoreAndNotifyD;
				# $status_hash5g{$du_id}{$cell_id}{E1apProtocolMessageNotCompatibleWithReceiverStateD} +=  $E1apProtocolMessageNotCompatibleWithReceiverStateD;
				# $status_hash5g{$du_id}{$cell_id}{E1apProtocolSemanticErrorD} += $E1apProtocolSemanticErrorD;
				# $status_hash5g{$du_id}{$cell_id}{E1apProtocolAbstractSyntaxErrorFalselyConstructedMessageD} +=  $E1apProtocolAbstractSyntaxErrorFalselyConstructedMessageD;
				# $status_hash5g{$du_id}{$cell_id}{E1apProtocolUnspecifiedD} += $E1apProtocolUnspecifiedD;
				# $status_hash5g{$du_id}{$cell_id}{E1apMiscControlProcessingOverloadD} += $E1apMiscControlProcessingOverloadD;
				# $status_hash5g{$du_id}{$cell_id}{E1apMiscNotEnoughUserPlaneProcessingResourcesD} += $E1apMiscNotEnoughUserPlaneProcessingResourcesD;
				# $status_hash5g{$du_id}{$cell_id}{E1apMiscHardwareFailureD} += $E1apMiscHardwareFailureD;
				# $status_hash5g{$du_id}{$cell_id}{E1apMiscUnspecifiedD} += $E1apMiscUnspecifiedD;
				# $status_hash5g{$du_id}{$cell_id}{DuULRadioLinkFailureD} += $DuULRadioLinkFailureD;
				# $status_hash5g{$du_id}{$cell_id}{DuRlcMaxNumRetxD} += $DuRlcMaxNumRetxD;
				# $status_hash5g{$du_id}{$cell_id}{CpSrb3IntegrityFailureD} += $CpSrb3IntegrityFailureD;
				# $status_hash5g{$du_id}{$cell_id}{CuOverloadD} += $CuOverloadD;
				# $status_hash5g{$du_id}{$cell_id}{StoreRrcMessageErrorD} += $StoreRrcMessageErrorD;
				# $status_hash5g{$du_id}{$cell_id}{StoreE1MessageErrorD} += $StoreE1MessageErrorD;
				# $status_hash5g{$du_id}{$cell_id}{StoreF1MessageErrorD} += $StoreF1MessageErrorD;
				# $status_hash5g{$du_id}{$cell_id}{SendRrcMessageErrorD} += $SendRrcMessageErrorD;
				# $status_hash5g{$du_id}{$cell_id}{SendE1MessageErrorD} +=  $SendE1MessageErrorD;
				# $status_hash5g{$du_id}{$cell_id}{SendF1MessageErrorD} +=  $SendF1MessageErrorD;
				# $status_hash5g{$du_id}{$cell_id}{StoreX2MessageErrorD} += $StoreX2MessageErrorD;
				# $status_hash5g{$du_id}{$cell_id}{SendX2MessageErrorD} += $SendX2MessageErrorD;
				# $status_hash5g{$du_id}{$cell_id}{TmOutX2ChangeConfirmD} += $TmOutX2ChangeConfirmD;
				# $status_hash5g{$du_id}{$cell_id}{TmOutX2SNStatusTransferD} += $TmOutX2SNStatusTransferD;
				# $status_hash5g{$du_id}{$cell_id}{SpCellSelectionFailD} += $SpCellSelectionFailD;
				# $status_hash5g{$du_id}{$cell_id}{InvalidCellIdD} += $InvalidCellIdD;
				# $status_hash5g{$du_id}{$cell_id}{F1apRadioAmfInitiatedAbnormalReleaseD} += $F1apRadioAmfInitiatedAbnormalReleaseD;
				# $status_hash5g{$du_id}{$cell_id}{F1apRadioReleaseDueToPreEmptionD} += $F1apRadioReleaseDueToPreEmptionD;
				# $status_hash5g{$du_id}{$cell_id}{F1apRadioPlmnNotServedByTheGnbCuD} += $F1apRadioPlmnNotServedByTheGnbCuD;
				# $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerUeDlMaxIPDataRateReasonD} +=$E1apRadioNetworkLayerUeDlMaxIPDataRateReasonD;
				# $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerUpIntegrityProtectionFailureD} +=  $E1apRadioNetworkLayerUpIntegrityProtectionFailureD;
				# $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerReleaseDueToPreEmptionD} += $$E1apRadioNetworkLayerReleaseDueToPreEmptionD;
				# $status_hash5g{$du_id}{$cell_id}{TmOutResumeForMrBasedD} += $TmOutResumeForMrBasedD;
				# $status_hash5g{$du_id}{$cell_id}{SynchReconfigFailureScgD} += $$SynchReconfigFailureScgD;
				# $status_hash5g{$du_id}{$cell_id}{NoFaultD} += $NoFaultD;
				# $status_hash5g{$du_id}{$cell_id}{OMInterventionD} += $OMInterventionD;
				# $status_hash5g{$du_id}{$cell_id}{VmScaleInD} += $VmScaleInD;
				# $status_hash5g{$du_id}{$cell_id}{UserInactivityD} += $UserInactivityD;
				# $status_hash5g{$du_id}{$cell_id}{ScgMobilityD} += $ScgMobilityD;
				# $status_hash5g{$du_id}{$cell_id}{MeasurementReportBasedReleaseD} += $MeasurementReportBasedReleaseD;
				# $status_hash5g{$du_id}{$cell_id}{F1apMiscOMInterventionD} += $F1apMiscOMInterventionD;
				# $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerHandoverDesirableForRadioReasonsD} +=  $X2apRadioNetworkLayerHandoverDesirableForRadioReasonsD;
				# $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerTimeCriticalHandoverD} += $X2apRadioNetworkLayerTimeCriticalHandoverD;
				# $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerResourceOptimisationHandoverD} += $X2apRadioNetworkLayerResourceOptimisationHandoverD;
				# $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerReduceLoadInServingCellD} += $X2apRadioNetworkLayerReduceLoadInServingCellD;
				# $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerActionDesirableForRadioReasonsD} +=  $X2apRadioNetworkLayerActionDesirableForRadioReasonsD;
				# $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerUserInactivityD} += $X2apRadioNetworkLayerUserInactivityD;
				# $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerMcgMobilityD} += $X2apRadioNetworkLayerMcgMobilityD;
				# $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerScgMobilityD} += $X2apRadioNetworkLayerScgMobilityD;
				# $status_hash5g{$du_id}{$cell_id}{X2apProtocolMessageNotCompatibleWithReceiverStateD} += $X2apProtocolMessageNotCompatibleWithReceiverStateD;
				# $status_hash5g{$du_id}{$cell_id}{X2apMiscOMInterventionD} += $X2apMiscOMInterventionD;
				# $status_hash5g{$du_id}{$cell_id}{E1apMiscOMInterventionD} += $E1apMiscOMInterventionD;
				# $status_hash5g{$du_id}{$cell_id}{InternalX2UEContextReleaseD} += $InternalX2UEContextReleaseD;
			# }
		# }
		# close(CUCP_D);
	# }

	if (-e "$TempPath/$intraSnPscell_5gFile") {
		open (SNP, "<$TempPath/$intraSnPscell_5gFile");
		while(<SNP>) {
			if (($_ !~ /gNB_/)) { next; }
			my($ne_id, $NE_name, $cellLocation, $EndcIntraChgAtt, $EndcIntraChgSucc) = (split(',', $_))[0,2,6,7,9];
			my($gnbId, $cell_id) = (split('/', $cellLocation))[0,1];
			$cell_id =~ s/Src//g;
			#print "cellid=$cell_id\n";
			# if ($du_id eq "$given_NE"){
			if ((index($NE_name, $given_AUID) != -1) || ($gnbId eq $given_gNBId)) {			
				$status_hash5g{$du_id}{$cell_id}{EndcIntraChgAtt} += $EndcIntraChgAtt;
				$status_hash5g{$du_id}{$cell_id}{EndcIntraChgSucc} += $EndcIntraChgSucc;
			}
		}
		close(SNP);
	}

	# if (-e "$TempPathDays/$intraSnPscell_5gFile") {
		# open (SNP_D, "<$TempPathDays/$intraSnPscell_5gFile");
		# while(<SNP_D>) {
			# if (($_ !~ /gNB_/)) { next; }
			# my($ne_id, $NE_name, $cellLocationD, $EndcIntraChgAttD, $EndcIntraChgSuccD) = (split(',', $_))[0,2,6,7,9];
			# my($du_id, $cell_id) = (split('/', $cellLocationD))[1,2];
			# $cell_id =~ s/Src//g;
			# #print "cellid=$cell_id\n";
			# # if ($du_id eq "$given_gNBId"){
			# if (index($NE_name, $given_AUID) != -1) || ($du_id eq $given_NE) {			
				# $status_hash5g{$du_id}{$cell_id}{EndcIntraChgAttD} += $EndcIntraChgAttD;
				# $status_hash5g{$du_id}{$cell_id}{EndcIntraChgSuccD} += $EndcIntraChgSuccD;
			# }
		# }
		# close(SNP_D);
	# }

	print Dumper \%status_hash5g;
	open (CANDIDATES, ">>$installDir/Logs/candidates_$dateTimeKpi.csv") or die "Can't open file : $installDir/Logs/candidates_$dateTimeKpi.csv\n";
	#print CANDIDATES "DU_ID,CELL_ID,CONN_ATTEMPT,CONN_SUCCESS,FAILURE_RATE\n";
	foreach my $du_id (keys %status_hash5g) {
		foreach my $cell_id ( keys %{$status_hash5g{$du_id}}) {
			#print "inside has cellId= $cell_id\n";
			#ENDC Drop rate
			my $nm_Endc = ($status_hash5g{$du_id}{$cell_id}{ConnectionReconfig} +  $status_hash5g{$du_id}{$cell_id}{ContextSetup} + $status_hash5g{$du_id}{$cell_id}{E1BearerSetup} +  $status_hash5g{$du_id}{$cell_id}{E1BearerContextModification} +  $status_hash5g{$du_id}{$cell_id}{F1UeContextModification} +  $status_hash5g{$du_id}{$cell_id}{F1UeContextRelease} +  $status_hash5g{$du_id}{$cell_id}{X2SgnbReconfigurationComplete} +  $status_hash5g{$du_id}{$cell_id}{tX2ModificationConfirm} +  $status_hash5g{$du_id}{$cell_id}{ResourceSetup} +  $status_hash5g{$du_id}{$cell_id}{F1SctpOutOfService} +  $status_hash5g{$du_id}{$cell_id}{E1SctpOutOfService} +  $status_hash5g{$du_id}{$cell_id}{X2SctpOutOfService} +  $status_hash5g{$du_id}{$cell_id}{MDSSendFail} +  $status_hash5g{$du_id}{$cell_id}{CacCallCountOver} +  $status_hash5g{$du_id}{$cell_id}{ResourceAllocFail} +  $status_hash5g{$du_id}{$cell_id}{NotSupportedQci} +  $status_hash5g{$du_id}{$cell_id}{InvalidCallContext} +  $status_hash5g{$du_id}{$cell_id}{CellRelease} +  $status_hash5g{$du_id}{$cell_id}{CallAllocationFail} +  $status_hash5g{$du_id}{$cell_id}{UpAllocationFail} +  $status_hash5g{$du_id}{$cell_id}{InvalidCallId} +  $status_hash5g{$du_id}{$cell_id}{InvalidPlmn} +  $status_hash5g{$du_id}{$cell_id}{T310Expiry} + $status_hash5g{$du_id}{$cell_id}{RandomAccessProblem} +  $status_hash5g{$du_id}{$cell_id}{RlcMaxNumRetx} +  $status_hash5g{$du_id}{$cell_id}{ScgChangeFailure} +  $status_hash5g{$du_id}{$cell_id}{ScgReconfigFailure} +  $status_hash5g{$du_id}{$cell_id}{Srb3IntegrityFailure} +  $status_hash5g{$du_id}{$cell_id}{F1apRadioUnspecified} +  $status_hash5g{$du_id}{$cell_id}{F1apRadioRLFailure} +  $status_hash5g{$du_id}{$cell_id}{F1apRadioUnknownOrAlreadyAllocatedCuUeF1apId} +  $status_hash5g{$du_id}{$cell_id}{F1apRadioUnknownOrAlreadyAllocatedDuUeF1apId} +  $status_hash5g{$du_id}{$cell_id}{F1apRadioUnknownInconsistentPairOfUeF1apId} +  ($status_hash5g{$du_id}{$cell_id}{F1apRadioInteraction} +  $status_hash5g{$du_id}{$cell_id}{F1apRadioNotSupportedQCI} +  $status_hash5g{$du_id}{$cell_id}{F1apRadioDesirableRadioReasons} +  $status_hash5g{$du_id}{$cell_id}{F1apRadioUnavailableRadioReasons} +  $status_hash5g{$du_id}{$cell_id}{F1apRadioProcedureCancelled} +  $status_hash5g{$du_id}{$cell_id}{F1apRadioNormalRelease} +  $status_hash5g{$du_id}{$cell_id}{F1apRadioCellNotAvailable} +  $status_hash5g{$du_id}{$cell_id}{F1apRadioRLFailureothers} +  $status_hash5g{$du_id}{$cell_id}{F1apRadioUeRejection} +  $status_hash5g{$du_id}{$cell_id}{F1apRadioResourcesNotAvailableForTheSlice} +  $status_hash5g{$du_id}{$cell_id}{F1apTransportUnspecified} +  $status_hash5g{$du_id}{$cell_id}{F1apTransportResourceUnavailable} +  $status_hash5g{$du_id}{$cell_id}{F1apProtocolTransferSyntaxError} +  $status_hash5g{$du_id}{$cell_id}{F1apProtocolAbstractSyntaxErrorReject} +  $status_hash5g{$du_id}{$cell_id}{F1apProtocolAbstractSyntaxErrorIgnore} +  $status_hash5g{$du_id}{$cell_id}{F1apProtocolMessageNotCompatible} +  $status_hash5g{$du_id}{$cell_id}{F1apProtocolSemanticError} +  $status_hash5g{$du_id}{$cell_id}{F1apProtocolAbstractSyntaxError} +  $status_hash5g{$du_id}{$cell_id}{F1apProtocolUnspecified} +  $status_hash5g{$du_id}{$cell_id}{F1apMiscControlProcessingOverload} +  $status_hash5g{$du_id}{$cell_id}{F1apMiscUnavailableResources} +  $status_hash5g{$du_id}{$cell_id}{F1apMiscHardwareFailure} +  $status_hash5g{$du_id}{$cell_id}{F1apMiscUnspecifiedFailure} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerPartialHandover} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerUnknownNewEnbUeX2apId} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerUnknownOldEnbUeX2apId} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerUnknownPairOfUeX2apId} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerHoTargetNotAllowed} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerTx2relocoverallExpiry} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerTrelocoverallExpiry} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerCellNotAvailable} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerNoRadioResourcesAvailableInTargetCell} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerInvalidMMEGroupID} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerUnknownMMECode} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerEncryptionAndOrIntegrityProtectionAlgorithmsNotSupported} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerReportCharacteristicsEmpty} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerNoReportPeriodicity} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerExistingMeasurementID} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerUnknownEnbMeasurementID} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerMeasurementTemporarilyNotAvailable} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerLoadBalancing}+  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerHandoverOptimisation} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerValueOutOfAllowedRange} + $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerMultipleErabIdInstances} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerSwitchOffOngoing} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerNotSupportedQciValue} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerMeasurementNotSupportedForTheObject} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerTdcoverallExpiry} + $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerReduceLoad} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerResourceOptimisation} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerTargetNotAllowed} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerNoRadioResourcesAvailable} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerInvalidQosCombination} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerEncryptionAlgorithmsNotSupported} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerProcedureCancelled} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerRrmPurpose} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerImproveUserBitRate} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerBearerOptionNotSupported} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerCountReachesMaxValue} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerUnknownOldEngnbUeX2apId} + $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerPdcpOverload} +  $status_hash5g{$du_id}{$cell_id}{X2apTransportNetworkLayerTransportResourceUnavailable} +  $status_hash5g{$du_id}{$cell_id}{X2apTransportNetworkLayerUnspecified} +  $status_hash5g{$du_id}{$cell_id}{X2apProtocolTransferSyntaxError} +  $status_hash5g{$du_id}{$cell_id}{X2apProtocolAbstractSyntaxErrorReject}+  $status_hash5g{$du_id}{$cell_id}{X2apProtocolAbstractSyntaxErrorIgnoreAndNotify} +  $status_hash5g{$du_id}{$cell_id}{X2apProtocolSemanticError} +  $status_hash5g{$du_id}{$cell_id}{X2apProtocolUnspecified} +  $status_hash5g{$du_id}{$cell_id}{X2apProtocolAbstractSyntaxErrorFalselyConstructedMessage} +  $status_hash5g{$du_id}{$cell_id}{X2apMiscControlProcessingOverload} +  $status_hash5g{$du_id}{$cell_id}{X2apMiscHardwareFailure} +  $status_hash5g{$du_id}{$cell_id}{X2apMiscNotEnoughUserPlaneProcessingResources} +  $status_hash5g{$du_id}{$cell_id}{X2apMiscUnspecified} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerUnspecified} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerUnknownOrAlreadyAllocatedGnbCuCpUeE1apId} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerUnknownOrAlreadyAllocatedGnbCuUpUeE1apId} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerUnknownOrInconsistentPairOfUeE1apId} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerInteractionWithOtherProcedure} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerPdcpCountWrapAround} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerNotSupportedQciValue} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerNotSupported5QiValue} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerEncryptionAlgorithmsNotSupported} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerIntegrityProtectionAlgorithmsNotSupported} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerUpIntegrityProtectionNotPossible} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerUpConfidentialityProtectionNotPossible} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerMultiplePduSessionIdInstances} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerUnknownPduSessionId} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerMultipleQosFlowIdInstances}+  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerUnknownQosFlowId} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerMultipleDrbIdInstances} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerUnknownDrbId} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerInvalidQosCombination} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerProcedureCancelled} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerNormalRelease} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerNoRadioResourcesAvailable} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerActionDesirableForRadioReasons} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerResourcesNotAvailableForTheSlice} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerPdcpConfigurationNotSupported} +  $status_hash5g{$du_id}{$cell_id}{E1apTransportLayerUnspecified} +  $status_hash5g{$du_id}{$cell_id}{E1apTransportLayerTransportResourceUnavailable} +  $status_hash5g{$du_id}{$cell_id}{E1apProtocolTransferSyntaxError} +  $status_hash5g{$du_id}{$cell_id}{E1apProtocolAbstractSyntaxErrorReject} +  $status_hash5g{$du_id}{$cell_id}{E1apProtocolAbstractSyntaxErrorIgnoreAndNotify} +  $status_hash5g{$du_id}{$cell_id}{E1apProtocolMessageNotCompatibleWithReceiverState} +  $status_hash5g{$du_id}{$cell_id}{E1apProtocolSemanticError} +  $status_hash5g{$du_id}{$cell_id}{E1apProtocolAbstractSyntaxErrorFalselyConstructedMessage} +  $status_hash5g{$du_id}{$cell_id}{E1apProtocolUnspecified} +  $status_hash5g{$du_id}{$cell_id}{E1apMiscControlProcessingOverload} +  $status_hash5g{$du_id}{$cell_id}{E1apMiscNotEnoughUserPlaneProcessingResources} +  $status_hash5g{$du_id}{$cell_id}{E1apMiscHardwareFailure} +  $status_hash5g{$du_id}{$cell_id}{E1apMiscUnspecified} +  $status_hash5g{$du_id}{$cell_id}{DuULRadioLinkFailure} +  $status_hash5g{$du_id}{$cell_id}{DuRlcMaxNumRetx} +  $status_hash5g{$du_id}{$cell_id}{CpSrb3IntegrityFailure} +  $status_hash5g{$du_id}{$cell_id}{CuOverload} +  $status_hash5g{$du_id}{$cell_id}{StoreRrcMessageError} +  $status_hash5g{$du_id}{$cell_id}{StoreE1MessageError} +  $status_hash5g{$du_id}{$cell_id}{StoreF1MessageError} +  $status_hash5g{$du_id}{$cell_id}{SendRrcMessageError} +  $status_hash5g{$du_id}{$cell_id}{SendE1MessageError}+  $status_hash5g{$du_id}{$cell_id}{SendF1MessageError} +  $status_hash5g{$du_id}{$cell_id}{StoreX2MessageError} +  $status_hash5g{$du_id}{$cell_id}{SendX2MessageError} +  $status_hash5g{$du_id}{$cell_id}{TmOutX2ChangeConfirm} +  $status_hash5g{$du_id}{$cell_id}{TmOutX2SNStatusTransfer} +  $status_hash5g{$du_id}{$cell_id}{SpCellSelectionFail} +  $status_hash5g{$du_id}{$cell_id}{InvalidCellId} +  $status_hash5g{$du_id}{$cell_id}{F1apRadioAmfInitiatedAbnormalRelease} +  $status_hash5g{$du_id}{$cell_id}{F1apRadioReleaseDueToPreEmption} +  $status_hash5g{$du_id}{$cell_id}{F1apRadioPlmnNotServedByTheGnbCu} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerUeDlMaxIPDataRateReason} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerUpIntegrityProtectionFailure} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerReleaseDueToPreEmption} +  $status_hash5g{$du_id}{$cell_id}{TmOutResumeForMrBased} +  $status_hash5g{$du_id}{$cell_id}{SynchReconfigFailureScg}));

			my $dn_Endc = ($status_hash5g{$du_id}{$cell_id}{ConnectionReconfig} +  $status_hash5g{$du_id}{$cell_id}{ContextSetup} +  $status_hash5g{$du_id}{$cell_id}{E1BearerSetup} +  $status_hash5g{$du_id}{$cell_id}{E1BearerContextModification} +  $status_hash5g{$du_id}{$cell_id}{F1UeContextModification} +  $status_hash5g{$du_id}{$cell_id}{F1UeContextRelease} + $status_hash5g{$du_id}{$cell_id}{X2SgnbReconfigurationComplete} +  $status_hash5g{$du_id}{$cell_id}{tX2ModificationConfirm} +  $status_hash5g{$du_id}{$cell_id}{ResourceSetup} +  $status_hash5g{$du_id}{$cell_id}{F1SctpOutOfService} +  $status_hash5g{$du_id}{$cell_id}{E1SctpOutOfService} +  $status_hash5g{$du_id}{$cell_id}{X2SctpOutOfService} +  $status_hash5g{$du_id}{$cell_id}{MDSSendFail} +  $status_hash5g{$du_id}{$cell_id}{CacCallCountOver} +  $status_hash5g{$du_id}{$cell_id}{ResourceAllocFail} +  $status_hash5g{$du_id}{$cell_id}{NotSupportedQci} +  $status_hash5g{$du_id}{$cell_id}{InvalidCallContext} +  $status_hash5g{$du_id}{$cell_id}{CellRelease} +  $status_hash5g{$du_id}{$cell_id}{CallAllocationFail} +  $status_hash5g{$du_id}{$cell_id}{UpAllocationFail} +  $status_hash5g{$du_id}{$cell_id}{InvalidCallId} +  $status_hash5g{$du_id}{$cell_id}{InvalidPlmn} +  $status_hash5g{$du_id}{$cell_id}{T310Expiry} +  $status_hash5g{$du_id}{$cell_id}{RandomAccessProblem} +  $status_hash5g{$du_id}{$cell_id}{RlcMaxNumRetx} +  $status_hash5g{$du_id}{$cell_id}{ScgChangeFailure} +  $status_hash5g{$du_id}{$cell_id}{ScgReconfigFailure} +  $status_hash5g{$du_id}{$cell_id}{Srb3IntegrityFailure} +  $status_hash5g{$du_id}{$cell_id}{F1apRadioUnspecified} +  $status_hash5g{$du_id}{$cell_id}{F1apRadioRLFailure} +  $status_hash5g{$du_id}{$cell_id}{F1apRadioUnknownOrAlreadyAllocatedCuUeF1apId} +  $status_hash5g{$du_id}{$cell_id}{F1apRadioUnknownOrAlreadyAllocatedDuUeF1apId} +  $status_hash5g{$du_id}{$cell_id}{F1apRadioUnknownInconsistentPairOfUeF1apId} +  $status_hash5g{$du_id}{$cell_id}{F1apRadioInteraction} +  $status_hash5g{$du_id}{$cell_id}{F1apRadioNotSupportedQCI} +  $status_hash5g{$du_id}{$cell_id}{F1apRadioDesirableRadioReasons} +  $status_hash5g{$du_id}{$cell_id}{F1apRadioUnavailableRadioReasons} +  $status_hash5g{$du_id}{$cell_id}{F1apRadioProcedureCancelled} +  $status_hash5g{$du_id}{$cell_id}{F1apRadioNormalRelease} +  $status_hash5g{$du_id}{$cell_id}{F1apRadioCellNotAvailable} +  $status_hash5g{$du_id}{$cell_id}{F1apRadioRLFailureothers} +  $status_hash5g{$du_id}{$cell_id}{F1apRadioUeRejection} +  $status_hash5g{$du_id}{$cell_id}{F1apRadioResourcesNotAvailableForTheSlice} +  $status_hash5g{$du_id}{$cell_id}{F1apTransportUnspecified} +  $status_hash5g{$du_id}{$cell_id}{F1apTransportResourceUnavailable} +  $status_hash5g{$du_id}{$cell_id}{F1apProtocolTransferSyntaxError} +  $status_hash5g{$du_id}{$cell_id}{F1apProtocolAbstractSyntaxErrorReject} +  $status_hash5g{$du_id}{$cell_id}{F1apProtocolAbstractSyntaxErrorIgnore} +  $status_hash5g{$du_id}{$cell_id}{F1apProtocolMessageNotCompatible} +  $status_hash5g{$du_id}{$cell_id}{F1apProtocolSemanticError} +  $status_hash5g{$du_id}{$cell_id}{F1apProtocolAbstractSyntaxError} +  $status_hash5g{$du_id}{$cell_id}{F1apProtocolUnspecified} +  $status_hash5g{$du_id}{$cell_id}{F1apMiscControlProcessingOverload} +  $status_hash5g{$du_id}{$cell_id}{F1apMiscUnavailableResources} +  $status_hash5g{$du_id}{$cell_id}{F1apMiscHardwareFailure} +  $status_hash5g{$du_id}{$cell_id}{F1apMiscUnspecifiedFailure} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerPartialHandover} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerUnknownNewEnbUeX2apId} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerUnknownOldEnbUeX2apId} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerUnknownPairOfUeX2apId} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerHoTargetNotAllowed} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerTx2relocoverallExpiry} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerTrelocoverallExpiry} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerCellNotAvailable} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerNoRadioResourcesAvailableInTargetCell} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerInvalidMMEGroupID} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerUnknownMMECode} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerEncryptionAndOrIntegrityProtectionAlgorithmsNotSupported} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerReportCharacteristicsEmpty} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerNoReportPeriodicity} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerExistingMeasurementID} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerUnknownEnbMeasurementID} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerMeasurementTemporarilyNotAvailable} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerUnspecified} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerLoadBalancing} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerHandoverOptimisation} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerValueOutOfAllowedRange} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerMultipleErabIdInstances} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerSwitchOffOngoing} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerNotSupportedQciValue} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerMeasurementNotSupportedForTheObject} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerTdcoverallExpiry} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerTdcprepExpiry} +   $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerReduceLoad} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerResourceOptimisation} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerTimeCriticalAction} + $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerTargetNotAllowed} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerNoRadioResourcesAvailable} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerInvalidQosCombination} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerEncryptionAlgorithmsNotSupported} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerProcedureCancelled} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerRrmPurpose} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerImproveUserBitRate} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerRadioConnectionWithUeLost} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerFailureInTheRadioInterfaceProcedure} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerBearerOptionNotSupported} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerCountReachesMaxValue} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerUnknownOldEngnbUeX2apId} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerPdcpOverload} +  $status_hash5g{$du_id}{$cell_id}{X2apTransportNetworkLayerTransportResourceUnavailable} +  $status_hash5g{$du_id}{$cell_id}{X2apTransportNetworkLayerUnspecified} +  $status_hash5g{$du_id}{$cell_id}{X2apProtocolTransferSyntaxError} +  $status_hash5g{$du_id}{$cell_id}{X2apProtocolAbstractSyntaxErrorReject} +  $status_hash5g{$du_id}{$cell_id}{X2apProtocolAbstractSyntaxErrorIgnoreAndNotify} +  $status_hash5g{$du_id}{$cell_id}{X2apProtocolSemanticError} +  $status_hash5g{$du_id}{$cell_id}{X2apProtocolUnspecified} +  $status_hash5g{$du_id}{$cell_id}{X2apProtocolAbstractSyntaxErrorFalselyConstructedMessage} +  $status_hash5g{$du_id}{$cell_id}{X2apMiscControlProcessingOverload} +  $status_hash5g{$du_id}{$cell_id}{X2apMiscHardwareFailure} +  $status_hash5g{$du_id}{$cell_id}{X2apMiscNotEnoughUserPlaneProcessingResources} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerUnspecified} + $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerUnknownOrAlreadyAllocatedGnbCuCpUeE1apId} + $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerUnknownOrAlreadyAllocatedGnbCuUpUeE1apId} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerUnknownOrInconsistentPairOfUeE1apId} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerInteractionWithOtherProcedure} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerPdcpCountWrapAround} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerNotSupportedQciValue} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerNotSupported5QiValue} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerEncryptionAlgorithmsNotSupported}+ $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerIntegrityProtectionAlgorithmsNotSupported} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerUpIntegrityProtectionNotPossible} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerUpConfidentialityProtectionNotPossible} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerMultiplePduSessionIdInstances} +$status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerUnknownPduSessionId} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerMultipleQosFlowIdInstances} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerUnknownQosFlowId} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerMultipleDrbIdInstances} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerUnknownDrbId} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerInvalidQosCombination} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerProcedureCancelled} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerNormalRelease} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerNoRadioResourcesAvailable} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerActionDesirableForRadioReasons} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerResourcesNotAvailableForTheSlice} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerPdcpConfigurationNotSupported} +  $status_hash5g{$du_id}{$cell_id}{E1apTransportLayerUnspecified} +  $status_hash5g{$du_id}{$cell_id}{E1apTransportLayerTransportResourceUnavailable} +  $status_hash5g{$du_id}{$cell_id}{E1apProtocolTransferSyntaxError} +  $status_hash5g{$du_id}{$cell_id}{E1apProtocolAbstractSyntaxErrorReject} +  $status_hash5g{$du_id}{$cell_id}{E1apProtocolAbstractSyntaxErrorIgnoreAndNotify} +  $status_hash5g{$du_id}{$cell_id}{E1apProtocolMessageNotCompatibleWithReceiverState} +  $status_hash5g{$du_id}{$cell_id}{E1apProtocolSemanticError} +  $status_hash5g{$du_id}{$cell_id}{E1apProtocolAbstractSyntaxErrorFalselyConstructedMessage} +  $status_hash5g{$du_id}{$cell_id}{E1apProtocolUnspecified} +  $status_hash5g{$du_id}{$cell_id}{E1apMiscControlProcessingOverload} +  $status_hash5g{$du_id}{$cell_id}{E1apMiscNotEnoughUserPlaneProcessingResources} +  $status_hash5g{$du_id}{$cell_id}{E1apMiscHardwareFailure} +  $status_hash5g{$du_id}{$cell_id}{E1apMiscUnspecified} +  $status_hash5g{$du_id}{$cell_id}{DuULRadioLinkFailure} +  $status_hash5g{$du_id}{$cell_id}{DuRlcMaxNumRetx} +  $status_hash5g{$du_id}{$cell_id}{CpSrb3IntegrityFailure} +  $status_hash5g{$du_id}{$cell_id}{CuOverload} +  $status_hash5g{$du_id}{$cell_id}{StoreRrcMessageError} +  $status_hash5g{$du_id}{$cell_id}{StoreE1MessageError} +  $status_hash5g{$du_id}{$cell_id}{StoreF1MessageError} +  $status_hash5g{$du_id}{$cell_id}{SendRrcMessageError} +  $status_hash5g{$du_id}{$cell_id}{SendE1MessageError} +  $status_hash5g{$du_id}{$cell_id}{SendF1MessageError} +  $status_hash5g{$du_id}{$cell_id}{StoreX2MessageError} +  $status_hash5g{$du_id}{$cell_id}{SendX2MessageError} +  $status_hash5g{$du_id}{$cell_id}{TmOutX2ChangeConfirm} +  $status_hash5g{$du_id}{$cell_id}{TmOutX2SNStatusTransfer} +  $status_hash5g{$du_id}{$cell_id}{SpCellSelectionFail} +  $status_hash5g{$du_id}{$cell_id}{InvalidCellId} +  $status_hash5g{$du_id}{$cell_id}{F1apRadioAmfInitiatedAbnormalRelease} +  $status_hash5g{$du_id}{$cell_id}{F1apRadioReleaseDueToPreEmption} +  $status_hash5g{$du_id}{$cell_id}{F1apRadioPlmnNotServedByTheGnbCu} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerUeDlMaxIPDataRateReason} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerUpIntegrityProtectionFailure} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerReleaseDueToPreEmption} +  $status_hash5g{$du_id}{$cell_id}{TmOutResumeForMrBased} +  $status_hash5g{$du_id}{$cell_id}{SynchReconfigFailureScg} +  $status_hash5g{$du_id}{$cell_id}{NoFault} +  $status_hash5g{$du_id}{$cell_id}{OMIntervention} +  $status_hash5g{$du_id}{$cell_id}{VmScaleIn} +  $status_hash5g{$du_id}{$cell_id}{UserInactivity} +  $status_hash5g{$du_id}{$cell_id}{ScgMobility} +  $status_hash5g{$du_id}{$cell_id}{MeasurementReportBasedRelease} +  $status_hash5g{$du_id}{$cell_id}{F1apMiscOMIntervention} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerHandoverDesirableForRadioReasons} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerTimeCriticalHandover} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerResourceOptimisationHandover} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerReduceLoadInServingCell} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerActionDesirableForRadioReasons} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerUserInactivity} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerMcgMobility} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerScgMobility} +  $status_hash5g{$du_id}{$cell_id}{X2apProtocolMessageNotCompatibleWithReceiverState} +  $status_hash5g{$du_id}{$cell_id}{X2apMiscUnspecified} +  $status_hash5g{$du_id}{$cell_id}{X2apMiscOMIntervention} +  $status_hash5g{$du_id}{$cell_id}{E1apMiscOMIntervention} +  $status_hash5g{$du_id}{$cell_id}{InternalX2UEContextRelease} + $status_hash5g{$du_id}{$cell_id}{EndcIntraChgSucc} );
			if($dn_Endc != 0){
				my $failure_rateEndc =  100 * ($nm_Endc / $dn_Endc);
				# my $nm_EndcD = ($status_hash5g{$du_id}{$cell_id}{ConnectionReconfigD} +  $status_hash5g{$du_id}{$cell_id}{ContextSetupD} + $status_hash5g{$du_id}{$cell_id}{E1BearerSetupD} +  $status_hash5g{$du_id}{$cell_id}{E1BearerContextModificationD} +  $status_hash5g{$du_id}{$cell_id}{F1UeContextModificationD} +  $status_hash5g{$du_id}{$cell_id}{F1UeContextReleaseD} +  $status_hash5g{$du_id}{$cell_id}{X2SgnbReconfigurationCompleteD} +  $status_hash5g{$du_id}{$cell_id}{tX2ModificationConfirmD} +  $status_hash5g{$du_id}{$cell_id}{ResourceSetupD} +  $status_hash5g{$du_id}{$cell_id}{F1SctpOutOfServiceD} +  $status_hash5g{$du_id}{$cell_id}{E1SctpOutOfServiceD} +  $status_hash5g{$du_id}{$cell_id}{X2SctpOutOfServiceD} +  $status_hash5g{$du_id}{$cell_id}{MDSSendFailD} +  $status_hash5g{$du_id}{$cell_id}{CacCallCountOverD} +  $status_hash5g{$du_id}{$cell_id}{ResourceAllocFailD} +  $status_hash5g{$du_id}{$cell_id}{NotSupportedQciD} +  $status_hash5g{$du_id}{$cell_id}{InvalidCallContextD} +  $status_hash5g{$du_id}{$cell_id}{CellReleaseD} +  $status_hash5g{$du_id}{$cell_id}{CallAllocationFailD} +  $status_hash5g{$du_id}{$cell_id}{UpAllocationFailD} +  $status_hash5g{$du_id}{$cell_id}{InvalidCallIdD} +  $status_hash5g{$du_id}{$cell_id}{InvalidPlmnD} +  $status_hash5g{$du_id}{$cell_id}{T310ExpiryD} + $status_hash5g{$du_id}{$cell_id}{RandomAccessProblemD} +  $status_hash5g{$du_id}{$cell_id}{RlcMaxNumRetxD} +  $status_hash5g{$du_id}{$cell_id}{ScgChangeFailureD} +  $status_hash5g{$du_id}{$cell_id}{ScgReconfigFailureD} +  $status_hash5g{$du_id}{$cell_id}{Srb3IntegrityFailureD} +  $status_hash5g{$du_id}{$cell_id}{F1apRadioUnspecifiedD} +  $status_hash5g{$du_id}{$cell_id}{F1apRadioRLFailureD} +  $status_hash5g{$du_id}{$cell_id}{F1apRadioUnknownOrAlreadyAllocatedCuUeF1apIdD} +  $status_hash5g{$du_id}{$cell_id}{F1apRadioUnknownOrAlreadyAllocatedDuUeF1apIdD} +  $status_hash5g{$du_id}{$cell_id}{F1apRadioUnknownInconsistentPairOfUeF1apIdD} +  ($status_hash5g{$du_id}{$cell_id}{F1apRadioInteractionD} +  $status_hash5g{$du_id}{$cell_id}{F1apRadioNotSupportedQCID} +  $status_hash5g{$du_id}{$cell_id}{F1apRadioDesirableRadioReasonsD} +  $status_hash5g{$du_id}{$cell_id}{F1apRadioUnavailableRadioReasonsD} +  $status_hash5g{$du_id}{$cell_id}{F1apRadioProcedureCancelledD} +  $status_hash5g{$du_id}{$cell_id}{F1apRadioNormalReleaseD} +  $status_hash5g{$du_id}{$cell_id}{F1apRadioCellNotAvailableD} +  $status_hash5g{$du_id}{$cell_id}{F1apRadioRLFailureothersD} +  $status_hash5g{$du_id}{$cell_id}{F1apRadioUeRejectionD} +  $status_hash5g{$du_id}{$cell_id}{F1apRadioResourcesNotAvailableForTheSliceD} +  $status_hash5g{$du_id}{$cell_id}{F1apTransportUnspecifiedD} +  $status_hash5g{$du_id}{$cell_id}{F1apTransportResourceUnavailableD} +  $status_hash5g{$du_id}{$cell_id}{F1apProtocolTransferSyntaxErrorD} +  $status_hash5g{$du_id}{$cell_id}{F1apProtocolAbstractSyntaxErrorRejectD} +  $status_hash5g{$du_id}{$cell_id}{F1apProtocolAbstractSyntaxErrorIgnoreD} +  $status_hash5g{$du_id}{$cell_id}{F1apProtocolMessageNotCompatibleD} +  $status_hash5g{$du_id}{$cell_id}{F1apProtocolSemanticErrorD} +  $status_hash5g{$du_id}{$cell_id}{F1apProtocolAbstractSyntaxErrorD} +  $status_hash5g{$du_id}{$cell_id}{F1apProtocolUnspecifiedD} +  $status_hash5g{$du_id}{$cell_id}{F1apMiscControlProcessingOverloadD} +  $status_hash5g{$du_id}{$cell_id}{F1apMiscUnavailableResourcesD} +  $status_hash5g{$du_id}{$cell_id}{F1apMiscHardwareFailureD} +  $status_hash5g{$du_id}{$cell_id}{F1apMiscUnspecifiedFailureD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerPartialHandoverD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerUnknownNewEnbUeX2apIdD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerUnknownOldEnbUeX2apIdD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerUnknownPairOfUeX2apIdD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerHoTargetNotAllowedD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerTx2relocoverallExpiryD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerTrelocoverallExpiryD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerCellNotAvailableD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerNoRadioResourcesAvailableInTargetCellD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerInvalidMMEGroupIDD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerUnknownMMECodeD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerEncryptionAndOrIntegrityProtectionAlgorithmsNotSupportedD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerReportCharacteristicsEmptyD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerNoReportPeriodicityD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerExistingMeasurementIDD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerUnknownEnbMeasurementIDD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerMeasurementTemporarilyNotAvailableD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerLoadBalancingD}+  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerHandoverOptimisationD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerValueOutOfAllowedRangeD} + $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerMultipleErabIdInstancesD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerSwitchOffOngoingD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerNotSupportedQciValueD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerMeasurementNotSupportedForTheObjectD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerTdcoverallExpiryD} + $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerReduceLoadD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerResourceOptimisationD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerTargetNotAllowedD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerNoRadioResourcesAvailableD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerInvalidQosCombinationD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerEncryptionAlgorithmsNotSupportedD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerProcedureCancelledD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerRrmPurposeD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerImproveUserBitRateD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerBearerOptionNotSupportedD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerCountReachesMaxValueD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerUnknownOldEngnbUeX2apIdD} + $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerPdcpOverloadD} +  $status_hash5g{$du_id}{$cell_id}{X2apTransportNetworkLayerTransportResourceUnavailableD} +  $status_hash5g{$du_id}{$cell_id}{X2apTransportNetworkLayerUnspecifiedD} +  $status_hash5g{$du_id}{$cell_id}{X2apProtocolTransferSyntaxErrorD} +  $status_hash5g{$du_id}{$cell_id}{X2apProtocolAbstractSyntaxErrorRejectD}+  $status_hash5g{$du_id}{$cell_id}{X2apProtocolAbstractSyntaxErrorIgnoreAndNotifyD} +  $status_hash5g{$du_id}{$cell_id}{X2apProtocolSemanticErrorD} +  $status_hash5g{$du_id}{$cell_id}{X2apProtocolUnspecifiedD} +  $status_hash5g{$du_id}{$cell_id}{X2apProtocolAbstractSyntaxErrorFalselyConstructedMessageD} +  $status_hash5g{$du_id}{$cell_id}{X2apMiscControlProcessingOverloadD} +  $status_hash5g{$du_id}{$cell_id}{X2apMiscHardwareFailureD} +  $status_hash5g{$du_id}{$cell_id}{X2apMiscNotEnoughUserPlaneProcessingResourcesD} +  $status_hash5g{$du_id}{$cell_id}{X2apMiscUnspecifiedD} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerUnspecifiedD} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerUnknownOrAlreadyAllocatedGnbCuCpUeE1apIdD} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerUnknownOrAlreadyAllocatedGnbCuUpUeE1apIdD} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerUnknownOrInconsistentPairOfUeE1apIdD} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerInteractionWithOtherProcedureD} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerPdcpCountWrapAroundD} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerNotSupportedQciValueD} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerNotSupported5QiValueD} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerEncryptionAlgorithmsNotSupportedD} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerIntegrityProtectionAlgorithmsNotSupportedD} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerUpIntegrityProtectionNotPossibleD} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerUpConfidentialityProtectionNotPossibleD} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerMultiplePduSessionIdInstancesD} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerUnknownPduSessionIdD} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerMultipleQosFlowIdInstancesD}+  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerUnknownQosFlowIdD} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerMultipleDrbIdInstancesD} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerUnknownDrbIdD} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerInvalidQosCombinationD} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerProcedureCancelledD} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerNormalReleaseD} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerNoRadioResourcesAvailableD} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerActionDesirableForRadioReasonsD} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerResourcesNotAvailableForTheSliceD} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerPdcpConfigurationNotSupportedD} +  $status_hash5g{$du_id}{$cell_id}{E1apTransportLayerUnspecifiedD} +  $status_hash5g{$du_id}{$cell_id}{E1apTransportLayerTransportResourceUnavailableD} +  $status_hash5g{$du_id}{$cell_id}{E1apProtocolTransferSyntaxErrorD} +  $status_hash5g{$du_id}{$cell_id}{E1apProtocolAbstractSyntaxErrorRejectD} +  $status_hash5g{$du_id}{$cell_id}{E1apProtocolAbstractSyntaxErrorIgnoreAndNotifyD} +  $status_hash5g{$du_id}{$cell_id}{E1apProtocolMessageNotCompatibleWithReceiverStateD} +  $status_hash5g{$du_id}{$cell_id}{E1apProtocolSemanticErrorD} +  $status_hash5g{$du_id}{$cell_id}{E1apProtocolAbstractSyntaxErrorFalselyConstructedMessageD} +  $status_hash5g{$du_id}{$cell_id}{E1apProtocolUnspecifiedD} +  $status_hash5g{$du_id}{$cell_id}{E1apMiscControlProcessingOverloadD} +  $status_hash5g{$du_id}{$cell_id}{E1apMiscNotEnoughUserPlaneProcessingResourcesD} +  $status_hash5g{$du_id}{$cell_id}{E1apMiscHardwareFailureD} +  $status_hash5g{$du_id}{$cell_id}{E1apMiscUnspecifiedD} +  $status_hash5g{$du_id}{$cell_id}{DuULRadioLinkFailureD} +  $status_hash5g{$du_id}{$cell_id}{DuRlcMaxNumRetxD} +  $status_hash5g{$du_id}{$cell_id}{CpSrb3IntegrityFailureD} +  $status_hash5g{$du_id}{$cell_id}{CuOverloadD} +  $status_hash5g{$du_id}{$cell_id}{StoreRrcMessageErrorD} +  $status_hash5g{$du_id}{$cell_id}{StoreE1MessageErrorD} +  $status_hash5g{$du_id}{$cell_id}{StoreF1MessageErrorD} +  $status_hash5g{$du_id}{$cell_id}{SendRrcMessageErrorD} +  $status_hash5g{$du_id}{$cell_id}{SendE1MessageErrorD}+  $status_hash5g{$du_id}{$cell_id}{SendF1MessageErrorD} +  $status_hash5g{$du_id}{$cell_id}{StoreX2MessageErrorD} +  $status_hash5g{$du_id}{$cell_id}{SendX2MessageErrorD} +  $status_hash5g{$du_id}{$cell_id}{TmOutX2ChangeConfirmD} +  $status_hash5g{$du_id}{$cell_id}{TmOutX2SNStatusTransferD} +  $status_hash5g{$du_id}{$cell_id}{SpCellSelectionFailD} +  $status_hash5g{$du_id}{$cell_id}{InvalidCellIdD} +  $status_hash5g{$du_id}{$cell_id}{F1apRadioAmfInitiatedAbnormalReleaseD} +  $status_hash5g{$du_id}{$cell_id}{F1apRadioReleaseDueToPreEmptionD} +  $status_hash5g{$du_id}{$cell_id}{F1apRadioPlmnNotServedByTheGnbCuD} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerUeDlMaxIPDataRateReasonD} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerUpIntegrityProtectionFailureD} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerReleaseDueToPreEmptionD} +  $status_hash5g{$du_id}{$cell_id}{TmOutResumeForMrBasedD} +  $status_hash5g{$du_id}{$cell_id}{SynchReconfigFailureScgD}));

				# my $dn_EndcD = ($status_hash5g{$du_id}{$cell_id}{ConnectionReconfigD} +  $status_hash5g{$du_id}{$cell_id}{ContextSetupD} +  $status_hash5g{$du_id}{$cell_id}{E1BearerSetupD} +  $status_hash5g{$du_id}{$cell_id}{E1BearerContextModificationD} +  $status_hash5g{$du_id}{$cell_id}{F1UeContextModificationD} +  $status_hash5g{$du_id}{$cell_id}{F1UeContextReleaseD} + $status_hash5g{$du_id}{$cell_id}{X2SgnbReconfigurationCompleteD} +  $status_hash5g{$du_id}{$cell_id}{tX2ModificationConfirmD} +  $status_hash5g{$du_id}{$cell_id}{ResourceSetupD} +  $status_hash5g{$du_id}{$cell_id}{F1SctpOutOfServiceD} +  $status_hash5g{$du_id}{$cell_id}{E1SctpOutOfServiceD} +  $status_hash5g{$du_id}{$cell_id}{X2SctpOutOfServiceD} +  $status_hash5g{$du_id}{$cell_id}{MDSSendFailD} +  $status_hash5g{$du_id}{$cell_id}{CacCallCountOverD} +  $status_hash5g{$du_id}{$cell_id}{ResourceAllocFailD} +  $status_hash5g{$du_id}{$cell_id}{NotSupportedQciD} +  $status_hash5g{$du_id}{$cell_id}{InvalidCallContextD} +  $status_hash5g{$du_id}{$cell_id}{CellReleaseD} +  $status_hash5g{$du_id}{$cell_id}{CallAllocationFailD} +  $status_hash5g{$du_id}{$cell_id}{UpAllocationFailD} +  $status_hash5g{$du_id}{$cell_id}{InvalidCallIdD} +  $status_hash5g{$du_id}{$cell_id}{InvalidPlmnD} +  $status_hash5g{$du_id}{$cell_id}{T310ExpiryD} +  $status_hash5g{$du_id}{$cell_id}{RandomAccessProblemD} +  $status_hash5g{$du_id}{$cell_id}{RlcMaxNumRetxD} +  $status_hash5g{$du_id}{$cell_id}{ScgChangeFailureD} +  $status_hash5g{$du_id}{$cell_id}{ScgReconfigFailureD} +  $status_hash5g{$du_id}{$cell_id}{Srb3IntegrityFailureD} +  $status_hash5g{$du_id}{$cell_id}{F1apRadioUnspecifiedD} +  $status_hash5g{$du_id}{$cell_id}{F1apRadioRLFailureD} +  $status_hash5g{$du_id}{$cell_id}{F1apRadioUnknownOrAlreadyAllocatedCuUeF1apIdD} +  $status_hash5g{$du_id}{$cell_id}{F1apRadioUnknownOrAlreadyAllocatedDuUeF1apIdD} +  $status_hash5g{$du_id}{$cell_id}{F1apRadioUnknownInconsistentPairOfUeF1apIdD} +  $status_hash5g{$du_id}{$cell_id}{F1apRadioInteractionD} +  $status_hash5g{$du_id}{$cell_id}{F1apRadioNotSupportedQCID} +  $status_hash5g{$du_id}{$cell_id}{F1apRadioDesirableRadioReasonsD} +  $status_hash5g{$du_id}{$cell_id}{F1apRadioUnavailableRadioReasonsD} +  $status_hash5g{$du_id}{$cell_id}{F1apRadioProcedureCancelledD} +  $status_hash5g{$du_id}{$cell_id}{F1apRadioNormalReleaseD} +  $status_hash5g{$du_id}{$cell_id}{F1apRadioCellNotAvailableD} +  $status_hash5g{$du_id}{$cell_id}{F1apRadioRLFailureothersD} +  $status_hash5g{$du_id}{$cell_id}{F1apRadioUeRejectionD} +  $status_hash5g{$du_id}{$cell_id}{F1apRadioResourcesNotAvailableForTheSliceD} +  $status_hash5g{$du_id}{$cell_id}{F1apTransportUnspecifiedD} +  $status_hash5g{$du_id}{$cell_id}{F1apTransportResourceUnavailableD} +  $status_hash5g{$du_id}{$cell_id}{F1apProtocolTransferSyntaxErrorD} +  $status_hash5g{$du_id}{$cell_id}{F1apProtocolAbstractSyntaxErrorRejectD} +  $status_hash5g{$du_id}{$cell_id}{F1apProtocolAbstractSyntaxErrorIgnoreD} +  $status_hash5g{$du_id}{$cell_id}{F1apProtocolMessageNotCompatibleD} +  $status_hash5g{$du_id}{$cell_id}{F1apProtocolSemanticErrorD} +  $status_hash5g{$du_id}{$cell_id}{F1apProtocolAbstractSyntaxErrorD} +  $status_hash5g{$du_id}{$cell_id}{F1apProtocolUnspecifiedD} +  $status_hash5g{$du_id}{$cell_id}{F1apMiscControlProcessingOverloadD} +  $status_hash5g{$du_id}{$cell_id}{F1apMiscUnavailableResourcesD} +  $status_hash5g{$du_id}{$cell_id}{F1apMiscHardwareFailureD} +  $status_hash5g{$du_id}{$cell_id}{F1apMiscUnspecifiedFailureD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerPartialHandoverD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerUnknownNewEnbUeX2apIdD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerUnknownOldEnbUeX2apIdD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerUnknownPairOfUeX2apIdD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerHoTargetNotAllowedD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerTx2relocoverallExpiryD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerTrelocoverallExpiryD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerCellNotAvailableD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerNoRadioResourcesAvailableInTargetCellD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerInvalidMMEGroupIDD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerUnknownMMECodeD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerEncryptionAndOrIntegrityProtectionAlgorithmsNotSupportedD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerReportCharacteristicsEmptyD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerNoReportPeriodicityD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerExistingMeasurementIDD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerUnknownEnbMeasurementIDD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerMeasurementTemporarilyNotAvailableD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerUnspecifiedD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerLoadBalancingD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerHandoverOptimisationD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerValueOutOfAllowedRangeD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerMultipleErabIdInstancesD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerSwitchOffOngoingD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerNotSupportedQciValueD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerMeasurementNotSupportedForTheObjectD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerTdcoverallExpiryD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerTdcprepExpiryD} +   $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerReduceLoadD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerResourceOptimisationD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerTimeCriticalActionD} + $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerTargetNotAllowedD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerNoRadioResourcesAvailableD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerInvalidQosCombinationD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerEncryptionAlgorithmsNotSupportedD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerProcedureCancelledD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerRrmPurposeD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerImproveUserBitRateD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerRadioConnectionWithUeLostD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerFailureInTheRadioInterfaceProcedureD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerBearerOptionNotSupportedD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerCountReachesMaxValueD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerUnknownOldEngnbUeX2apIdD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerPdcpOverloadD} +  $status_hash5g{$du_id}{$cell_id}{X2apTransportNetworkLayerTransportResourceUnavailableD} +  $status_hash5g{$du_id}{$cell_id}{X2apTransportNetworkLayerUnspecifiedD} +  $status_hash5g{$du_id}{$cell_id}{X2apProtocolTransferSyntaxErrorD} +  $status_hash5g{$du_id}{$cell_id}{X2apProtocolAbstractSyntaxErrorRejectD} +  $status_hash5g{$du_id}{$cell_id}{X2apProtocolAbstractSyntaxErrorIgnoreAndNotifyD} +  $status_hash5g{$du_id}{$cell_id}{X2apProtocolSemanticErrorD} +  $status_hash5g{$du_id}{$cell_id}{X2apProtocolUnspecifiedD} +  $status_hash5g{$du_id}{$cell_id}{X2apProtocolAbstractSyntaxErrorFalselyConstructedMessageD} +  $status_hash5g{$du_id}{$cell_id}{X2apMiscControlProcessingOverloadD} +  $status_hash5g{$du_id}{$cell_id}{X2apMiscHardwareFailureD} +  $status_hash5g{$du_id}{$cell_id}{X2apMiscNotEnoughUserPlaneProcessingResourcesD} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerUnspecifiedD} + $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerUnknownOrAlreadyAllocatedGnbCuCpUeE1apIdD} + $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerUnknownOrAlreadyAllocatedGnbCuUpUeE1apIdD} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerUnknownOrInconsistentPairOfUeE1apIdD} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerInteractionWithOtherProcedureD} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerPdcpCountWrapAroundD} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerNotSupportedQciValueD} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerNotSupported5QiValueD} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerEncryptionAlgorithmsNotSupportedD}+ $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerIntegrityProtectionAlgorithmsNotSupportedD} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerUpIntegrityProtectionNotPossibleD} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerUpConfidentialityProtectionNotPossibleD} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerMultiplePduSessionIdInstancesD} +$status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerUnknownPduSessionIdD} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerMultipleQosFlowIdInstancesD} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerUnknownQosFlowIdD} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerMultipleDrbIdInstancesD} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerUnknownDrbIdD} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerInvalidQosCombinationD} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerProcedureCancelledD} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerNormalReleaseD} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerNoRadioResourcesAvailableD} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerActionDesirableForRadioReasonsD} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerResourcesNotAvailableForTheSliceD} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerPdcpConfigurationNotSupportedD} +  $status_hash5g{$du_id}{$cell_id}{E1apTransportLayerUnspecifiedD} +  $status_hash5g{$du_id}{$cell_id}{E1apTransportLayerTransportResourceUnavailableD} +  $status_hash5g{$du_id}{$cell_id}{E1apProtocolTransferSyntaxErrorD} +  $status_hash5g{$du_id}{$cell_id}{E1apProtocolAbstractSyntaxErrorRejectD} +  $status_hash5g{$du_id}{$cell_id}{E1apProtocolAbstractSyntaxErrorIgnoreAndNotifyD} +  $status_hash5g{$du_id}{$cell_id}{E1apProtocolMessageNotCompatibleWithReceiverStateD} +  $status_hash5g{$du_id}{$cell_id}{E1apProtocolSemanticErrorD} +  $status_hash5g{$du_id}{$cell_id}{E1apProtocolAbstractSyntaxErrorFalselyConstructedMessageD} +  $status_hash5g{$du_id}{$cell_id}{E1apProtocolUnspecifiedD} +  $status_hash5g{$du_id}{$cell_id}{E1apMiscControlProcessingOverloadD} +  $status_hash5g{$du_id}{$cell_id}{E1apMiscNotEnoughUserPlaneProcessingResourcesD} +  $status_hash5g{$du_id}{$cell_id}{E1apMiscHardwareFailureD} +  $status_hash5g{$du_id}{$cell_id}{E1apMiscUnspecifiedD} +  $status_hash5g{$du_id}{$cell_id}{DuULRadioLinkFailureD} +  $status_hash5g{$du_id}{$cell_id}{DuRlcMaxNumRetxD} +  $status_hash5g{$du_id}{$cell_id}{CpSrb3IntegrityFailureD} +  $status_hash5g{$du_id}{$cell_id}{CuOverloadD} +  $status_hash5g{$du_id}{$cell_id}{StoreRrcMessageErrorD} +  $status_hash5g{$du_id}{$cell_id}{StoreE1MessageErrorD} +  $status_hash5g{$du_id}{$cell_id}{StoreF1MessageErrorD} +  $status_hash5g{$du_id}{$cell_id}{SendRrcMessageErrorD} +  $status_hash5g{$du_id}{$cell_id}{SendE1MessageErrorD} +  $status_hash5g{$du_id}{$cell_id}{SendF1MessageErrorD} +  $status_hash5g{$du_id}{$cell_id}{StoreX2MessageErrorD} +  $status_hash5g{$du_id}{$cell_id}{SendX2MessageErrorD} +  $status_hash5g{$du_id}{$cell_id}{TmOutX2ChangeConfirmD} +  $status_hash5g{$du_id}{$cell_id}{TmOutX2SNStatusTransferD} +  $status_hash5g{$du_id}{$cell_id}{SpCellSelectionFailD} +  $status_hash5g{$du_id}{$cell_id}{InvalidCellIdD} +  $status_hash5g{$du_id}{$cell_id}{F1apRadioAmfInitiatedAbnormalReleaseD} +  $status_hash5g{$du_id}{$cell_id}{F1apRadioReleaseDueToPreEmptionD} +  $status_hash5g{$du_id}{$cell_id}{F1apRadioPlmnNotServedByTheGnbCuD} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerUeDlMaxIPDataRateReasonD} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerUpIntegrityProtectionFailureD} +  $status_hash5g{$du_id}{$cell_id}{E1apRadioNetworkLayerReleaseDueToPreEmptionD} +  $status_hash5g{$du_id}{$cell_id}{TmOutResumeForMrBasedD} +  $status_hash5g{$du_id}{$cell_id}{SynchReconfigFailureScgD} +  $status_hash5g{$du_id}{$cell_id}{NoFaultD} +  $status_hash5g{$du_id}{$cell_id}{OMInterventionD} +  $status_hash5g{$du_id}{$cell_id}{VmScaleInD} +  $status_hash5g{$du_id}{$cell_id}{UserInactivityD} +  $status_hash5g{$du_id}{$cell_id}{ScgMobilityD} +  $status_hash5g{$du_id}{$cell_id}{MeasurementReportBasedReleaseD} +  $status_hash5g{$du_id}{$cell_id}{F1apMiscOMInterventionD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerHandoverDesirableForRadioReasonsD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerTimeCriticalHandoverD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerResourceOptimisationHandoverD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerReduceLoadInServingCellD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerActionDesirableForRadioReasonsD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerUserInactivityD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerMcgMobilityD} +  $status_hash5g{$du_id}{$cell_id}{X2apRadioNetworkLayerScgMobilityD} +  $status_hash5g{$du_id}{$cell_id}{X2apProtocolMessageNotCompatibleWithReceiverStateD} +  $status_hash5g{$du_id}{$cell_id}{X2apMiscUnspecifiedD} +  $status_hash5g{$du_id}{$cell_id}{X2apMiscOMInterventionD} +  $status_hash5g{$du_id}{$cell_id}{E1apMiscOMInterventionD} +  $status_hash5g{$du_id}{$cell_id}{InternalX2UEContextReleaseD} + $status_hash5g{$du_id}{$cell_id}{EndcIntraChgSuccD} );
				# if($dn_EndcD != 0){
					# my $failure_rateEndcD =  100 * ($nm_EndcD / $dn_EndcD);
					# if($failure_rateEndcD != 0){
						# my $finalCucpEndc = (($failure_rateEndc - $failure_rateEndcD)/$failure_rateEndcD)*100;
						# $finalCucpEndc = sprintf("%.3f", $finalCucpEndc); 
						# $failure_rateEndcD = sprintf("%.3f", $failure_rateEndcD); 
						$failure_rateEndc = sprintf("%.3f", $failure_rateEndc);
						print "nm_Endc=$nm_Endc,dn_Endc=$dn_Endc\n";
						# if ($finalCucpEndc > $cucp5gThresh) {
							print (CANDIDATES "$dateCst[0],$cstPrevHour,ENDC Drop rate,$du_id,$cell_id,$nm_Endc,$dn_Endc,$failure_rateEndc\n");
							# print (CANDIDATES "$dateCst[0],$cstPrevHour,ENDC Drop rate,$du_id,$cell_id,$failure_rateEndcD,$failure_rateEndc,$finalCucpEndc\n");
						# }
					# }
				# }
			}
		}
	}
	close(CANDIDATES);
}

sub Sgnb_5g{

	#S5NR_ReConfigurationFailureRat
	if (-e "$TempPath/$SgNBAddition_5gFile") {
		open (SGNB, "<$TempPath/$SgNBAddition_5gFile");
		while(<SGNB>) {
			if (($_ !~ /gNB_/)) { next; }
			my($ne_id, $NE_name, $cellLocation, $EndcAddAtt_DU, $EndcAddSucc_DU) = (split(',', $_))[0,2,6,7,9];
			my($gnbId, $cell_id) = (split('/', $cellLocation))[0,1];#has no duplicate cell ID
			$cell_id =~ s/CellIdentityWithInvalid/CellIdentity/g;
			# my $DU_NUM = $given_NE;
			# $DU_NUM =~ s/DU_/gNB_DU_ID/g;
			#if (($du_id eq "$given_gNBId") && ($DU_NUM eq $cell_id)){
			if ((index($NE_name, $given_AUID) != -1) || ($gnbId eq $given_gNBId)) {			
			$status_hashsgNb{$du_id}{$cell_id}{EndcAddAtt_DU} += $EndcAddAtt_DU;
			$status_hashsgNb{$du_id}{$cell_id}{EndcAddSucc_DU} += $EndcAddSucc_DU;
			}
		}
		close(SGNB);	   
	}

	# if (-e "$TempPathDays/$SgNBAddition_5gFile") {
	   # open (SGNB_D, "<$TempPathDays/$SgNBAddition_5gFile");
	   # while(<SGNB_D>) {
		   # if (($_ !~ /gNB_/)) { next; }
		   # my($ne_id, $NE_nameD,$cellLocationD, $EndcAddAtt_DUD, $EndcAddSucc_DUD) = (split(',', $_))[0,2,6,7,9];
		   # my($du_id, $cell_id) = (split('/', $cellLocationD))[1,2];#has no duplicate cell ID
		   # # my $DU_NUM = $given_NE;
		   # # $DU_NUM =~ s/DU_/gNB_DU_ID/g;
		   # #if (($du_id eq "$given_gNBId") && ($DU_NUM eq $cell_id)){
			# if (index($NE_name, $given_AUID) != -1) || ($du_id eq $given_NE) {			
			   # $status_hashsgNb{$du_id}{$cell_id}{EndcAddAtt_DUD} += $EndcAddAtt_DUD;
			   # $status_hashsgNb{$du_id}{$cell_id}{EndcAddSucc_DUD} += $EndcAddSucc_DUD;
		   # }
	   # }
		# close(SGNB_D);
	# }
	print Dumper \%status_hashsgNb;
	open (CANDIDATES, ">>$installDir/Logs/candidates_$dateTimeKpi.csv") or die "Can't open file : $installDir/Logs/candidates_$dateTimeKpi.csv\n";	
	foreach my $du_id (keys %status_hashsgNb) {
		foreach my $cell_id ( keys %{$status_hashsgNb{$du_id}}) {
			#S5NR_ReConfigurationFailureRate
			my $nm_sgnb = ($status_hashsgNb{$du_id}{$cell_id}{EndcAddAtt_DU} - $status_hashsgNb{$du_id}{$cell_id}{EndcAddSucc_DU});
			my $dn_sgnb = $status_hashsgNb{$du_id}{$cell_id}{EndcAddAtt_DU};
			my $reconf_FailRate= 100 * ($nm_sgnb / $dn_sgnb);
			# #baseline_avg
			# my $nm_sgnbD = ($status_hashsgNb{$du_id}{$cell_id}{EndcAddAtt_DUD} - $status_hashsgNb{$du_id}{$cell_id}{EndcAddSucc_DUD});
			# my $dn_sgnbD = ($status_hashsgNb{$du_id}{$cell_id}{EndcAddAtt_DUD});
			# my $reconf_FailRateD= 100 * ($nm_sgnbD / $dn_sgnbD);
			#final_comparison
			# my $finalReconfFail = (($reconf_FailRate - $reconf_FailRateD)/$reconf_FailRateD)*100;
			# $finalReconfFail = sprintf("%.3f", $finalReconfFail); 
			# $reconf_FailRateD = sprintf("%.3f", $reconf_FailRateD); 
			$reconf_FailRate = sprintf("%.3f", $reconf_FailRate);
			# if ($finalReconfFail > $sgNBAdd5gThresh) {
				# print (CANDIDATES "$dateCst[0],$cstPrevHour,S5NR_ReConfigurationFailureRat,$du_id,$cell_id,$reconf_FailRateD,$reconf_FailRate,$finalReconfFail\n");
				print (CANDIDATES "$dateCst[0],$cstPrevHour,S5NR_ReConfigurationFailureRate,$du_id,$cell_id,$nm_sgnb,$dn_sgnb,$reconf_FailRate\n");
			# }
		}
	}
	close(CANDIDATES);
}

sub interIntra {
	if (-e "$TempPath/$intraSnPscell_5gFile") {
		open (INTRA, "<$TempPath/$intraSnPscell_5gFile");
		while(<INTRA>) {
			if (($_ !~ /gNB_/)) { next; }
			my($ne_id, $NE_name, $cellLocation, $EndcIntraChgAtt_intra, $EndcIntraChgSucc_intra) = (split(',', $_))[0,2,6,7,9];
			my($gnbId, $cell_id) = (split('/', $cellLocation))[0,1];#has duplicate cell ID's
			# my $DU_NUM = $given_NE;
			# $DU_NUM =~ s/DU_/gNB_DU_ID/g;
			$cell_id =~ s/Src//g;
			#if ($du_id eq "$given_gNBId"){
			if ((index($NE_name, $given_AUID) != -1) || ($gnbId eq $given_gNBId)) {			
				$status_hashInt{$du_id}{$cell_id}{EndcIntraChgAtt_intra} += $EndcIntraChgAtt_intra;
				$status_hashInt{$du_id}{$cell_id}{EndcIntraChgSucc_intra} += $EndcIntraChgSucc_intra;
			}
		}
		close(INTRA);
	}

	# if (-e "$TempPathDays/$intraSnPscell_5gFile") {
		# open (INTRA_D, "<$TempPathDays/$intraSnPscell_5gFile");
		# while(<INTRA_D>) {
			# if (($_ !~ /gNB_/)) { next; }
			# my($ne_id, $NE_nameD,$cellLocationD, $EndcIntraChgAtt_intraD, $EndcIntraChgSucc_intraD) = (split(',', $_))[0,2,6,7,9];
			# my($du_id, $cell_id) = (split('/', $cellLocationD))[1,2];#has duplicate cell ID's
			# my $DU_NUM = $given_NE;
			# # $DU_NUM =~ s/DU_/gNB_DU_ID/g;
			# $cell_id =~ s/Src//g;
			# #if ($du_id eq "$given_gNBId"){
			# if (index($NE_name, $given_AUID) != -1) || ($du_id eq $given_NE) {			
				# $status_hashInt{$du_id}{$cell_id}{EndcIntraChgAtt_intraD} += $EndcIntraChgAtt_intraD;
				# $status_hashInt{$du_id}{$cell_id}{EndcIntraChgSucc_intraD} += $EndcIntraChgSucc_intraD;
			# }
		# }
		# close(INTRA_D);
	# }
	if (-e "$TempPath/$interSnPcell_5gFile") {
		open (INTER, "<$TempPath/$interSnPcell_5gFile");
		while(<INTER>) {
			if (($_ !~ /gNB_/)) { next; }
			my($ne_id,$NE_name, $cellLocation, $EndcInterChgSrcAtt_inter, $EndcInterChgSrcSucc_inter) = (split(',', $_))[0,2,6,7,9];
			my($gnbId $cell_id) = (split('/', $cellLocation))[0,1];#has duplicate cell ID's
			# my $DU_NUM = $given_NE;
			# $DU_NUM =~ s/DU_/gNB_DU_ID/g;
			$cell_id =~ s/Src//g;
			#if (($du_id eq "$given_gNBId") && ($DU_NUM eq $cell_id)){
			if ((index($NE_name, $given_AUID) != -1) || ($gnbId eq $given_gNBId)) {			
			   $status_hashInt{$du_id}{$cell_id}{EndcInterChgSrcAtt_inter} += $EndcInterChgSrcAtt_inter;
			   $status_hashInt{$du_id}{$cell_id}{EndcInterChgSrcSucc_inter} += $EndcInterChgSrcSucc_inter;
			}
		}
		close(INTER);
	}

	# if (-e "$TempPathDays/$interSnPcell_5gFile") {
		# open (INTER_D, "<$TempPathDays/$interSnPcell_5gFile");
		# while(<INTER_D>) {
		# if (($_ !~ /gNB_/)) { next; }
			# my($ne_id,$NE_nameD, $cellLocationD, $EndcInterChgSrcAtt_interD, $EndcInterChgSrcSucc_interD) = (split(',', $_))[0,2,6,7,9];
			# my($du_id, $cell_id) = (split('/', $cellLocationD))[1,2];#has duplicate cell ID's
			# my $DU_NUM = $given_NE;
			# # $DU_NUM =~ s/DU_/gNB_DU_ID/g;
			# $cell_id =~ s/Src//g;
			# #if (($du_id eq "$given_gNBId") && ($DU_NUM eq $cell_id)){
			# if (index($NE_nameD, $given_NE) != -1) {
				# $status_hashInt{$du_id}{$cell_id}{EndcInterChgSrcAtt_interD} += $EndcInterChgSrcAtt_interD;
				# $status_hashInt{$du_id}{$cell_id}{EndcInterChgSrcSucc_interD} += $EndcInterChgSrcSucc_interD;
			# }
		# }
		# close(INTER_D);
	# }
	print Dumper \%status_hashInt;
	open (CANDIDATES, ">>$installDir/Logs/candidates_$dateTimeKpi.csv") or die "Can't open file : $installDir/Logs/candidates_$dateTimeKpi.csv\n";
	foreach my $du_id (keys %status_hashInt) {
		foreach my $cell_id ( keys %{$status_hashInt{$du_id}}) {
			#S5NR_IntragNBHOFailRate
			my $nm_IntragNBHO = ($status_hashInt{$du_id}{$cell_id}{EndcIntraChgAtt_intra} - $status_hashInt{$du_id}{$cell_id}{EndcIntraChgSucc_intra});
			my $dn_IntragNBHO = $status_hashInt{$du_id}{$cell_id}{EndcIntraChgAtt_intra};
			if($dn_IntragNBHO != 0){
				my $IntragNBHO_FailRate= 100 * ($nm_IntragNBHO / $dn_IntragNBHO);
				#baseline_avg
				# my $nm_IntragNBHOD = ($status_hashInt{$du_id}{$cell_id}{EndcIntraChgAtt_intraD} - $status_hashInt{$du_id}{$cell_id}{EndcIntraChgSucc_intraD});
				# my $dn_IntragNBHOD = ($status_hashInt{$du_id}{$cell_id}{EndcIntraChgAtt_intraD});
				# if($dn_IntragNBHOD != 0){
					# my $IntragNBHO_FailRateD= 100 * ($nm_IntragNBHOD / $dn_IntragNBHOD);
					# if($IntragNBHO_FailRateD != 0){
						#final_comparison
						# my $finalIntragNBHOFail = (($IntragNBHO_FailRate - $IntragNBHO_FailRateD)/$IntragNBHO_FailRateD)*100;
						# $finalIntragNBHOFail = sprintf("%.3f", $finalIntragNBHOFail); 
						# $IntragNBHO_FailRateD = sprintf("%.3f", $IntragNBHO_FailRateD); 
						$IntragNBHO_FailRate = sprintf("%.3f", $IntragNBHO_FailRate);	
						# if ($finalIntragNBHOFail > $intra5gThresh) {
							 # print (CANDIDATES "$dateCst[0],$cstPrevHour,S5NR_IntragNBHOFailRate,$du_id,$cell_id,$IntragNBHO_FailRateD,$IntragNBHO_FailRate,$finalIntragNBHOFail\n");
							 print (CANDIDATES "$dateCst[0],$cstPrevHour,S5NR_IntragNBHOFailRate,$du_id,$cell_id,$nm_IntragNBHO,$dn_IntragNBHO,$IntragNBHO_FailRate\n");
						# }
					# }
				# }
			}

			#S5NR_IntergNBHOFailRate
			my $nm_IntergNBHO = ($status_hashInt{$du_id}{$cell_id}{EndcInterChgSrcAtt_inter} - $status_hashInt{$du_id}{$cell_id}{EndcInterChgSrcSucc_inter});
			my $dn_IntergNBHO = $status_hashInt{$du_id}{$cell_id}{EndcInterChgSrcAtt_inter};
			if($dn_IntergNBHO != 0){
				my $IntergNBHO_FailRate= 100 * ($nm_IntergNBHO / $dn_IntergNBHO);
				# #baseline_avg
				# my $nm_IntergNBHOD = ($status_hashInt{$du_id}{$cell_id}{EndcInterChgSrcAtt_interD} - $status_hashInt{$du_id}{$cell_id}{EndcInterChgSrcSucc_interD});
				# my $dn_IntergNBHOD = ($status_hashInt{$du_id}{$cell_id}{EndcInterChgSrcAtt_interD});
				# if($dn_IntergNBHOD != 0){
					# my $IntergNBHO_FailRateD= 100 * ($nm_IntergNBHOD / $dn_IntergNBHOD);
					# if($IntergNBHO_FailRateD != 0){
						# #final_comparison
						# my $finalIntergNBHOFail= (($IntergNBHO_FailRate - $IntergNBHO_FailRateD)/$IntergNBHO_FailRateD)*100;
						# $finalIntergNBHOFail = sprintf("%.3f", $finalIntergNBHOFail); 
						# $IntergNBHO_FailRateD = sprintf("%.3f", $IntergNBHO_FailRateD); 
						$IntergNBHO_FailRate = sprintf("%.3f", $IntergNBHO_FailRate);
						# if ($finalIntergNBHOFail > $inter5gThresh) {
							 # print (CANDIDATES "$dateCst[0],$cstPrevHour,S5NR_IntergNBHOFailRate,$du_id,$cell_id,$IntergNBHO_FailRateD,$IntergNBHO_FailRate,$finalIntergNBHOFail\n");
							 print (CANDIDATES "$dateCst[0],$cstPrevHour,S5NR_IntergNBHOFailRate,$du_id,$cell_id,$nm_IntergNBHO,$dn_IntergNBHO,$IntergNBHO_FailRate\n");
						# }
					# }
				# }
			}
		}
	}
	close(CANDIDATES);
}
