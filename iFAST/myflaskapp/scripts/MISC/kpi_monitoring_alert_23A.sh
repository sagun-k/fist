#!/bin/bash
cd /opt/vz_raw_data/Scripts/CICD_FR2_23A_Upgrade/

installDir=`pwd`
dateTime=`date +%m-%d-%-Y_%H%M%S`
dateFormatHtml=`date +%m-%d-%-Y_%H_%M_%S`
today=`date +%Y%m%d -d '+5 hour 0 min'`
yesterday=$(date -d "$today -1 days" "+%Y%m%d")
curr_Hour=`date -d '+5 hour' +%H`
prev_Hour=`date -d '+4 hour' +%H`
cst_curr_Hour=`date -d '1 hour ago' +%H`
cst_prev_Hour=`date -d '2 hour ago' +%H`
flag=0
prevHOur00="${prev_Hour}00"
currHour00="${curr_Hour}00"
today00=`date +%Y%m%d -d '+5 hour 0 min'`


#prints
#echo "date=$today"
#echo "yest=$yesterday"
#echo "curr_Hour=$curr_Hour"
#echo "prev_Hour=$prev_Hour"
#echo "CSTcurr_Hour=$cst_curr_Hour"
#echo "CSTprev_Hour=$cst_prev_Hour"
#echo "$dateFormatHtml"

#paths
srcPath="/opt/vz_raw_data"
ConfFile="$installDir/Conf/site.conf"
LogsPath="$installDir/Logs"
eventName=$(awk -F',' 'FNR == 2 {print $NF}' $ConfFile)
TempPath="$installDir/Logs/TEMP_$dateTime"
TempPathDays="$installDir/Logs/Day_$dateTime"
kpiListFile="$installDir/Conf/kpi_list.conf"
usmMapping="$installDir/Conf/usmPsmaMapping.csv"

shopt -s nullglob


# y=$(grep '^4G' $kpiListFile | grep -v "#")

if [[ "$currHour00" == "0000" ]]; then
	# prevDate00=$yesterday
	today00=$today
fi

if [[ "$curr_Hour" == "00" ]]; then
        today=$yesterday
fi

#prevDate00=$(date -d "20221231 -1 days" "+%Y%m%d")

sort_output() {
        while IFS=, read -r f1 f2 f3 f4 f5 f6 f7 f8
        do
		#echo "grep -w ".*,$f3.*$f4.*$f5" $LogsPath/diff_combined_kpi_report_$dateTime\.csv"
		grep -w ".*,$f3.*$f4.*$f5" $LogsPath/diff_combined_kpi_report_$dateTime\.csv | sort >> $LogsPath/sorted_kpi_report_$dateTime\.csv

	done < <(grep ",$cst_prev_Hour," $LogsPath/diff_combined_kpi_report_$dateTime\.csv)

}


get_hours_csv() {

#echo $1
        for i in $(seq 0 $1);
        do
		str0="$(echo $dateFormatHtml | cut -d'_' -f1)"
		str1="$(echo $dateFormatHtml | cut -d'_' -f2)"
		echo $dateFormatHtml
		echo "str0=$str0,str1=$str1"
                #str0="01-03-2023"
                #str1=23
		j=$(( $str1-i ))
		#ymd="${str0}_${j}"
		
		len=`expr length "$j"`
		if [[ "$len" == "1" ]]; then
			j="0${j}"
			echo $j
		fi
		ymd="${str0}_${j}"
		
		filename=( $(find "$LogsPath/" -type f -iname "*detect_kpi_threshold_alert_$ymd*csv") )
		echo "filename=$filename"
		if [[ "$filename" != "" ]]; then
			cat $filename >> $LogsPath/combined_kpi_report_$dateTime\.csv
		fi
	done
	awk -F, 'NR==FNR{a[$3,$4,$5]++; next} a[$3,$4,$5]>2' $LogsPath/combined_kpi_report_$dateTime\.csv $LogsPath/combined_kpi_report_$dateTime\.csv > $LogsPath/diff_combined_kpi_report_$dateTime\.csv

}

dates_base=()
get_baseline_days() {
	#echo $1
	dates_base=()

	for i in $(seq 1 $1);
	do
		#echo "i=$i"
		j=$(( 7*i ))
		#dates_base+=$(date --date=' '$i' days ago' '+%Y%m%d')
		dates_base[i]=$(date --date=' '$j' days ago' '+%Y%m%d')
	done
	flag=1
	#echo "${dates_base[@]}"
}

get_baseline_avg_4g() {
	#echo $1
	 #rm -f $TempPathDays/*csv
	mkdir $TempPathDays 2>/dev/null
	while IFS=, read -r f1 f2 f3 f4
	do
        neType=$1
        if [[ "$f1" == "4G" && "$f4" != "3" ]]; then
                echo "baseline is $f4"
                get_baseline_days "$f4"
                flag=0
        fi
        for prevDate in ${dates_base[@]}; do
			dayFiles=()
			#dayFiles=($myPsm/$prevDate/*$prevDate-$prev_Hour*)
                        #dayFiles=( $(ls $myPsm/$prevDate/*{$prevDate-$prev_Hour,$prevDate-$currHour00}* | grep -v $prevHOur00) )
			prevDate00=$prevDate
			if [[ "$currHour00" == "0000" ]]; then
        			# prevDate00=$yesterday
        			prevDate00=$(date -d "$prevDate -1 days" "+%Y%m%d")
			fi
			dayFiles=(`printf "%s\n" $myPsm/$prevDate00/*$prevDate00-$prev_Hour* $myPsm/$prevDate/*$prevDate-$currHour00* | grep -v $prevHOur00`)
			#echo "${dayFiles[@]}"
			for myFile in ${dayFiles[@]}; do
				if [ "$f2" = "RRC_Connection_Establishment_Message" ]; then
					tar -xzf "$myFile" --to-command='grep -a '$NEID' || true' "*_RRC Connection Establishment Message_*\.csv" >> $TempPathDays/RRC_conn_est_msg.csv
				elif [ "$f2" = "S1_Context_Setup" ]; then
					tar -xzf "$myFile" --to-command='grep -a '$NEID' || true' "*_S1 Context Setup_*\.csv" >> $TempPathDays/s1_cont_setup.csv
				elif [ "$f2" = "RLF_Detection_Number_per_Cell" ]; then
					tar -xzf "$myFile" --to-command='grep -a '$NEID' || true' "*_RLF Detection Number per Cell_*\.csv" >> $TempPathDays/rlf_detect_numpercell.csv
					tar -xzf "$myFile" --to-command='grep -a '$NEID' || true' "*_RRC Connection Establishment_*\.csv" >> $TempPathDays/rrc_conn_est.csv
				elif [ "$f2" = "Context_Release_by_MME_and_eNB_per_cell" ]; then
					tar -xzf "$myFile" --to-command='grep -a '$NEID' || true' "*_Context Release by MME and eNB per Cell_*\.csv" >> $TempPathDays/cont_rel_mmeEnbCell.csv
				elif [ "$f2" = "RRC_Connection_Number" ]; then
					tar -xzf "$myFile" --to-command='grep -a '$NEID' || true' "*_RRC Connection Number_*\.csv" >> $TempPathDays/rrc_conn_num.csv
				elif [ "$f2" = "Air_RLC_Packet" ]; then
					tar -xzf "$myFile" --to-command='grep -a '$NEID' || true' "*_Air RLC Packet_*\.csv" >> $TempPathDays/air_rlc_pk.csv
				elif [ "$f2" = "AirMAC_Packet" ]; then
					tar -xzf "$myFile" --to-command='grep -a '$NEID' || true' "*_Air MAC Packet_*\.csv" >> $TempPathDays/air_mac_pk.csv
				elif [ "$f2" = "DownlinkHARQ_Transmission_BLER" ]; then
					tar -xzf "$myFile" --to-command='grep -a '$NEID' || true' "*_Downlink HARQ Transmission BLER_*\.csv" >> $TempPathDays/dl_harq_transBler.csv
				elif [ "$f2" = "Downlink_HARQ_Transmission_BLER_in_256_QAM_Support" ]; then
					tar -xzf "$myFile" --to-command='grep -a '$NEID' || true' "*_Downlink HARQ Transmission BLER in 256QAM supported UE_*\.csv" >> $TempPathDays/dl_harq_transBler_256.csv
				elif [ "$f2" = "Uplink_HARQ_Transmission_BLER" ]; then
					tar -xzf "$myFile" --to-command='grep -a '$NEID' || true' "*_Uplink HARQ Transmission BLER_*\.csv" >> $TempPathDays/ul_harq_transBler.csv
				elif [ "$f2" = "X2_Out_Handover" ]; then
					tar -xzf "$myFile" --to-command='grep -a '$NEID' || true' "*_X2 outgoing handover without failure causes_*\.csv" >> $TempPathDays/x2_outHo_woFail.csv
				elif [ "$f2" = "EN-DC_Addition_Information" ]; then
					tar -xzf "$myFile" --to-command='grep -a '$NEID' || true' "*_EN-DC Addition Information_*\.csv" >> $TempPathDays/endc_addInfo.csv
				elif [ "$f2" = "EN-DC_Release_Information" ]; then
					tar -xzf "$myFile" --to-command='grep -a '$NEID' || true' "*_EN-DC Release Information_*\.csv" >> $TempPathDays/endc_relInfo.csv
				elif [ "$f2" = "RRC_Connection_Release_of_EN-DC_Capable_UE" ]; then
					tar -xzf "$myFile" --to-command='grep -a '$NEID' || true' "*_RRC Connection Release of EN-DC Capable UE_*\.csv" >> $TempPathDays/endc_capUE.csv
				elif [ "$f2" = "Cell_Availability" ]; then
					tar -xzf "$myFile" --to-command='grep -a '$NEID' || true' "*_Availability_*\.csv" >> $TempPathDays/cellAvailability.csv
				elif [ "$f2" = "VOLTE_UL_PDCP_Packet_Loss_Rate" ]; then
					tar -xzf "$myFile" --to-command='grep -a '$NEID' || true' "*_Packet Loss Rate_*\.csv" >> $TempPathDays/packetLossRate.csv
				elif [ "$f2" = "EMTC_RRC_Setup_Failure" ]; then
					tar -xzf "$myFile" --to-command='grep -a '$NEID' || true' "*_eMTC RRC Connection Establishment_*\.csv" >> $TempPathDays/emtcRrcConnEst.csv
				elif [ "$f2" = "EMTC_Context_Drop_Rate" ]; then
					tar -xzf "$myFile" --to-command='grep -a '$NEID' || true' "*_eMTC Call Drop_*\.csv" >> $TempPathDays/emtcCallDrop.csv
					tar -xzf "$myFile" --to-command='grep -a '$NEID' || true' "*_eMTC UE-associated logical S1 Connection Establishment_*\.csv" >> $TempPathDays/emtcUeS1ConnEst.csv
				elif [ "$f2" = "NBIOT_RRC_Setup_Failure" ]; then
					tar -xzf "$myFile" --to-command='grep -a '$NEID' || true' "*_NB-IoT RRC Connection Establishment_*\.csv" >> $TempPathDays/nbiotRrcConnEst.csv
				elif [ "$f2" = "NBIOT_Context_Drop_Rate" ]; then
					tar -xzf "$myFile" --to-command='grep -a '$NEID' || true' "*_NB-IoT Call Drop_*\.csv" >> $TempPathDays/nbiotCallDrop.csv
					tar -xzf "$myFile" --to-command='grep -a '$NEID' || true' "*_NB-IoT UE-associated logical S1 Connection Establishment_*\.csv" >> $TempPathDays/nbiotUeS1ConnEst.csv

				fi
			done
        done
        #to get previous 3 days dates
        if [[ "${flag}" == 0 ]]; then
			get_baseline_days "3"
        fi
	done < <(grep 4G $kpiListFile)
}

get_baseline_avg_5g() {
	#echo $1
	#rm -f $TempPathDays/*csv
	mkdir $TempPathDays 2>/dev/null
	while IFS=, read -r f1 f2 f3 f4
	do
        neType=$1
        if [[ "$f1" == "5G" && "$f4" != "3" ]]; then
			echo "baseline is $f4"
			get_baseline_days "$f4"
			flag=0
        fi
        #printf '%s\n' "dates=${dates_base[@]}"
        for prevDate5g in ${dates_base[@]}; do
			dayFiles5g=()
			#dayFiles5g=($myPsm/$prevDate5g/*$prevDate5g-$prev_Hour*)
        		#dayFiles5g=( $(ls $myPsm/$prevDate5g/*{$prevDate5g-$prev_Hour,$prevDate5g-$currHour00}* | grep -v $prevHOur00) )
			prevDate5g00=$prevDate5g
                        if [[ "$currHour00" == "0000" ]]; then
                                # prevDate00=$yesterday
                                prevDate5g00=$(date -d "$prevDate5g -1 days" "+%Y%m%d")
                        fi
                        dayFiles5g=(`printf "%s\n" $myPsm/$prevDate5g00/*$prevDate5g00-$prev_Hour* $myPsm/$prevDate5g/*$prevDate5g-$currHour00* | grep -v $prevHOur00`)
                        #echo "${dayFiles5g[@]}"
			for myFile5g in ${dayFiles5g[@]}; do
				#echo "$f2,$prevDate5g,$myFile5g"
				if [ "$f2" = "SgNB_Addition_per_gNB" ]; then
					tar -xzf "$myFile5g" --to-command='grep -a '$NEID' || true' "*_SgNB Addition per gNB_*\.csv" >> $TempPathDays/SgNBAddition_perDU_pergNB_5g.csv
				elif [ "$f2" = "CU_CP_CSL_Hexa_per_gNB" ]; then
					tar -xzf "$myFile5g" --to-command='grep -a '$NEID' || true' "*_CU-CP CSL per gNB \(Hexa\)_*\.csv" >> $TempPathDays/cucpCslHexa_5g.csv
				elif [ "$f2" = "Intra_SN_Pscell_Change_per_gNB" ]; then
					tar -xzf "$myFile5g" --to-command='grep -a '$NEID' || true' "*_Intra SN Pscell Change per gNB_*\.csv" >> $TempPathDays/intraSnPscell_5g.csv
				elif [ "$f2" = "Inter_SN_Pscell_Change_per_gNB" ]; then
					tar -xzf "$myFile5g" --to-command='grep -a '$NEID' || true' "*_Inter SN Pscell Change per gNB_*\.csv" >> $TempPathDays/interSnPcell_5g.csv
				# elif [ "$f2" = "NR_Air_MAC_Packet" ]; then
					# tar -xzf "$myFile5g" --to-command='grep -a '$NEID' || true' "*_Air MAC Packet_*\.csv" >> $TempPathDays/air_macpk_5g.csv
				# elif [ "$f2" = "Downlink_UE_Throughput" ]; then
					# tar -xzf "$myFile5g" --to-command='grep -a '$NEID' || true' "*_Downlink UE Throughput_*\.csv" >> $TempPathDays/dl_ueThroughput_5g.csv
				# elif [ "$f2" = "Uplink_UE_Throughput" ]; then
					# tar -xzf "$myFile5g" --to-command='grep -a '$NEID' || true' "*_Uplink UE Throughput_*\.csv" >> $TempPathDays/ul_UeThroughput_5g.csv
				# elif [ "$f2" = "DL_HARQ_TRANSMISSION_count_and_BLER" ]; then
					# tar -xzf "$myFile5g" --to-command='grep -a '$NEID' || true' "*_DL HARQ Transmission Count and BLER_*\.csv" >> $TempPathDays/dl_harq_transBler_5g.csv
				# elif [ "$f2" = "UL_HARQ_TRANSMISSION_count_and_BLER" ]; then
					# tar -xzf "$myFile5g" --to-command='grep -a '$NEID' || true' "*_UL HARQ Transmission Count and BLER_*\.csv" >> $TempPathDays/ul_harq_transBler_5g.csv
				# elif [ "$f2" = "Physical_Random_Access_Channel_in_NR_for_beam" ]; then
					# tar -xzf "$myFile5g" --to-command='grep -a '$NEID' || true' "*_Physical Random Access Channel in NR for beam_*\.csv" >> $TempPathDays/prach_nrBeam_5g.csv
				# elif [ "$f2" = "Physical_Random_Access_Channel_in_NR" ]; then
					# tar -xzf "$myFile5g" --to-command='grep -a '$NEID' || true' "*_Physical Random Access Channel in NR_*\.csv" >> $TempPathDays/prach_nr_5g.csv
				# elif [ "$f2" = "NR_Cell_Unavailable_Time" ]; then
					# tar -xzf "$myFile5g" --to-command='grep -a '$NEID' || true' "*_Cell Unavailable Time_*\.csv" >> $TempPathDays/cellUnavailableTime_5g.csv
				# elif [ "$f2" = "UE_Connection_Number_per_gNB_DU" ]; then
					# tar -xzf "$myFile5g" --to-command='grep -a '$NEID' || true' "*_UE Connection Number per gNB-DU_*\.csv" >> $TempPathDays/ue_connNumPerGnb_5g.csv
				fi
			done
        done
        #to get previous 3 days dates
        if [[ "${flag}" == 0 ]]; then
            get_baseline_days "3"
        fi

	done < <(grep 5G $kpiListFile)
}

lte_kpi_calculation() {
	#echo $1
	#rm -f $TempPathDays/*csv
for myPsm in ${psmList_4g[@]}; do
	mkdir $TempPath 2>/dev/null
	#echo $TempPath
	hourFiles=()
	#hourFiles=($myPsm/$today/*$today-$prev_Hour*)
        #hourFiles=( $(ls $myPsm/$today/*{$today-$prev_Hour,$today00-$currHour00}* | grep -v $prevHOur00) )
	hourFiles=(`printf "%s\n" $myPsm/$today/*$today-$prev_Hour* $myPsm/$today00/*$today00-$currHour00* | grep -v $prevHOur00`)
        #printf '%s\n' "${hourFiles[@]}"

	for myMinFile in ${hourFiles[@]}; do
		#echo "$myMinFile"
		if tar xf $myMinFile -O | grep -q "$NEID"; then
			echo "$myMinFile"
			#get data
			tar -xzf "$myMinFile" --to-command='grep -a '$NEID' || true' "*_RRC Connection Establishment Message_*\.csv" >> $TempPath/RRC_conn_est_msg.csv
			tar -xzf "$myMinFile" --to-command='grep -a '$NEID' || true' "*_S1 Context Setup_*\.csv" >> $TempPath/s1_cont_setup.csv
			tar -xzf "$myMinFile" --to-command='grep -a '$NEID' || true' "*_RLF Detection Number per Cell_*\.csv" >> $TempPath/rlf_detect_numpercell.csv
			tar -xzf "$myMinFile" --to-command='grep -a '$NEID' || true' "*_RRC Connection Establishment_*\.csv" >> $TempPath/rrc_conn_est.csv
			tar -xzf "$myMinFile" --to-command='grep -a '$NEID' || true' "*_Context Release by MME and eNB per Cell_*\.csv" >> $TempPath/cont_rel_mmeEnbCell.csv
			tar -xzf "$myMinFile" --to-command='grep -a '$NEID' || true' "*_RRC Connection Number_*\.csv" >> $TempPath/rrc_conn_num.csv
			tar -xzf "$myMinFile" --to-command='grep -a '$NEID' || true' "*_Air RLC Packet_*\.csv" >> $TempPath/air_rlc_pk.csv
			tar -xzf "$myMinFile" --to-command='grep -a '$NEID' || true' "*_Air MAC Packet_*\.csv" >> $TempPath/air_mac_pk.csv
			tar -xzf "$myMinFile" --to-command='grep -a '$NEID' || true' "*_Downlink HARQ Transmission BLER_*\.csv" >> $TempPath/dl_harq_transBler.csv
			tar -xzf "$myMinFile" --to-command='grep -a '$NEID' || true' "*_Downlink HARQ Transmission BLER in 256QAM supported UE_*\.csv" >> $TempPath/dl_harq_transBler_256.csv
			tar -xzf "$myMinFile" --to-command='grep -a '$NEID' || true' "*_Uplink HARQ Transmission BLER_*\.csv" >> $TempPath/ul_harq_transBler.csv
			tar -xzf "$myMinFile" --to-command='grep -a '$NEID' || true' "*_X2 outgoing handover without failure causes_*\.csv" >> $TempPath/x2_outHo_woFail.csv
			tar -xzf "$myMinFile" --to-command='grep -a '$NEID' || true' "*_EN-DC Addition Information_*\.csv" >> $TempPath/endc_addInfo.csv
			tar -xzf "$myMinFile" --to-command='grep -a '$NEID' || true' "*_EN-DC Release Information_*\.csv" >> $TempPath/endc_relInfo.csv
			tar -xzf "$myMinFile" --to-command='grep -a '$NEID' || true' "*_RRC Connection Release of EN-DC Capable UE_*\.csv" >> $TempPath/endc_capUE.csv
			tar -xzf "$myMinFile" --to-command='grep -a '$NEID' || true' "*_Availability_*\.csv" >> $TempPath/cellAvailability.csv
			tar -xzf "$myMinFile" --to-command='grep -a '$NEID' || true' "*_Packet Loss Rate_*\.csv" >> $TempPath/packetLossRate.csv
			tar -xzf "$myMinFile" --to-command='grep -a '$NEID' || true' "*_eMTC RRC Connection Establishment_*\.csv" >> $TempPath/emtcRrcConnEst.csv
			tar -xzf "$myMinFile" --to-command='grep -a '$NEID' || true' "*_eMTC Call Drop_*\.csv" >> $TempPath/emtcCallDrop.csv
			tar -xzf "$myMinFile" --to-command='grep -a '$NEID' || true' "*_eMTC UE-associated logical S1 Connection Establishment_*\.csv" >> $TempPath/emtcUeS1ConnEst.csv
			tar -xzf "$myMinFile" --to-command='grep -a '$NEID' || true' "*_NB-IoT RRC Connection Establishment_*\.csv" >> $TempPath/nbiotRrcConnEst.csv
			tar -xzf "$myMinFile" --to-command='grep -a '$NEID' || true' "*_NB-IoT Call Drop_*\.csv" >> $TempPath/nbiotCallDrop.csv
			tar -xzf "$myMinFile" --to-command='grep -a '$NEID' || true' "*_NB-IoT UE-associated logical S1 Connection Establishment_*\.csv" >> $TempPath/nbiotUeS1ConnEst.csv
		fi
	done
done
	if [ -z "$(ls -A $TempPath)" ]; then
		echo ""
	else
		echo "Calculating KPI's for 4G"
		get_baseline_avg_4g "4G"
		sleep 1
		perl $installDir/pkpi_threshold_alert_23A.pl "LTE" $NEID $dateTime $TempPath $TempPathDays $cst_prev_Hour "x" "x" RRC_conn_est_msg.csv s1_cont_setup.csv rlf_detect_numpercell.csv rrc_conn_est.csv cont_rel_mmeEnbCell.csv rrc_conn_num.csv air_rlc_pk.csv air_mac_pk.csv dl_harq_transBler.csv dl_harq_transBler_256.csv ul_harq_transBler.csv x2_outHo_woFail.csv endc_addInfo.csv endc_relInfo.csv endc_capUE.csv cellAvailability.csv packetLossRate.csv emtcRrcConnEst.csv emtcCallDrop.csv emtcUeS1ConnEst.csv nbiotRrcConnEst.csv nbiotCallDrop.csv nbiotUeS1ConnEst.csv
		#break
	fi
}

nr_kpi_calculation() {
	echo "nr sub $1"
	#rm -f $TempPathDays/*csv
for myPsm in ${psmList_5g[@]}; do

	mkdir $TempPath 2>/dev/null
	#echo $TempPath
	hourFiles=()
	#hourFiles=($myPsm/$today/*$today-$prev_Hour*)
        #hourFiles=( $(ls $myPsm/$today/*{$today-$prev_Hour,$today00-$currHour00}* | grep -v $prevHOur00) )
        hourFiles=(`printf "%s\n" $myPsm/$today/*$today-$prev_Hour* $myPsm/$today00/*$today00-$currHour00* | grep -v $prevHOur00`)
	# hourFiles=(`printf '%s\n' "${hourFiles[@]}" | sort -V`)
	#printf '%s\n' "${hourFiles[@]}"

	for myMinFile in ${hourFiles[@]}; do
		echo "myMinFile = $myMinFile"
		if tar xf $myMinFile -O | grep -q "$AU_ID"; then
			echo "myMinFile=$myMinFile, NE=$NEID"
			#get data
			tar -xzf "$myMinFile" --to-command='grep -a '$NEID|$AU_ID' || true' "*_SgNB Addition per gNB_*\.csv" >> $TempPath/SgNBAddition_perDU_pergNB_5g.csv
			#tar -xzf "$myMinFile" --to-command='grep -a '$NEID|$AU_ID' || true' "*_CU-CP CSL per gNB \(Hexa\)_*\.csv" >> $TempPath/cucpCslHexa_5g.csv
			tar -xzf "$myMinFile" --to-command='grep -a '$NEID|$AU_ID' || true' "*_CU-CP CSL per gNB*\.csv" >> $TempPath/cucpCslHexa_5g.csv
			tar -xzf "$myMinFile" --to-command='grep -a '$NEID|$AU_ID' || true' "*_Intra SN Pscell Change per gNB_*\.csv" >> $TempPath/intraSnPscell_5g.csv
			tar -xzf "$myMinFile" --to-command='grep -a '$NEID|$AU_ID' || true' "*_Inter SN Pscell Change per gNB_*\.csv" >> $TempPath/interSnPcell_5g.csv
			# tar -xzf "$myMinFile" --to-command='grep -a '$NEID' || true' "*_Air MAC Packet_*\.csv" >> $TempPath/air_macpk_5g.csv
			# tar -xzf "$myMinFile" --to-command='grep -a '$NEID' || true' "*_Downlink UE Throughput_*\.csv" >> $TempPath/dl_ueThroughput_5g.csv
			# tar -xzf "$myMinFile" --to-command='grep -a '$NEID' || true' "*_Uplink UE Throughput_*\.csv" >> $TempPath/ul_UeThroughput_5g.csv
			# tar -xzf "$myMinFile" --to-command='grep -a '$NEID' || true' "*_DL HARQ Transmission Count and BLER_*\.csv" >> $TempPath/dl_harq_transBler_5g.csv
			# tar -xzf "$myMinFile" --to-command='grep -a '$NEID' || true' "*_UL HARQ Transmission Count and BLER_*\.csv" >> $TempPath/ul_harq_transBler_5g.csv
			# tar -xzf "$myMinFile" --to-command='grep -a '$NEID' || true' "*_Physical Random Access Channel in NR for beam_*\.csv" >> $TempPath/prach_nrBeam_5g.csv
			# tar -xzf "$myMinFile" --to-command='grep -a '$NEID' || true' "*_Physical Random Access Channel in NR_*\.csv" >> $TempPath/prach_nr_5g.csv
			# tar -xzf "$myMinFile" --to-command='grep -a '$NEID' || true' "*_Cell Unavailable Time_*\.csv" >> $TempPath/cellUnavailableTime_5g.csv
			# tar -xzf "$myMinFile" --to-command='grep -a '$NEID' || true' "*_UE Connection Number per gNB-DU_*\.csv" >> $TempPath/ue_connNumPerGnb_5g.csv
		fi
	done
done	
	if [ -z "$(ls -A $TempPath)" ]; then
		echo ""
	else
		echo "Calculating KPI's for $NEID"
		# get_baseline_avg_5g "5G"
		# sleep 1
		perl $installDir/pkpi_threshold_alert_23A.pl "NR" $NEID $dateTime $TempPath $TempPathDays $cst_prev_Hour $gNBId $AU_ID "x" "x" "x" "x" "x" "x" "x" "x" "x" "x" "x" "x" "x" "x" "x" "x" "x" "x" "x" "x" "x" "x" "x" SgNBAddition_perDU_pergNB_5g.csv cucpCslHexa_5g.csv intraSnPscell_5g.csv interSnPcell_5g.csv air_macpk_5g.csv dl_ueThroughput_5g.csv ul_UeThroughput_5g.csv dl_harq_transBler_5g.csv ul_harq_transBler_5g.csv prach_nrBeam_5g.csv prach_nr_5g.csv cellUnavailableTime_5g.csv ue_connNumPerGnb_5g.csv
		#break
	fi

}

#main
for NEID in `cat $ConfFile | cut -d"," -f1 | grep -v "#"`
do
        #swVer=$(awk -F',' '{ if ($1 == "'$NEID'") { print $3 } }' $ConfFile )
        mcmip=$(awk -F',' '{ if ($1 == "'$NEID'") { print $3 } }' $ConfFile )
        gNBId=$(awk -F',' '{ if ($1 == "'$NEID'") { print $4 } }' $ConfFile )
        usmName=$(awk -F',' '{ if ($2 == "'$mcmip'") { print $1 } }' $usmMapping)
        AU_ID=$(awk -F',' '{ if ($1 == "'$NEID'") { print $2 } }' $ConfFile)
	echo $NEID
        # psmList=()
		psmList_4g=()
		psmList_5g=()
        #dates_base=()

        #to get previous 3 days dates
        if [[ "${flag}" == 0 ]]; then
                get_baseline_days "3"
        fi

        #printf '%s\n' "${dates_base[@]}"

        #check usmMapping
        if [[ "$usmName" == "" ]]; then
                echo "Check the MCMIP configured for $NEID"
                continue
        fi

         if [[ "$NEID" == *"eNB"* ]]; then
                # echo "4G NEID=$NEID"
                psmList_4g=($srcPath/USMlte_$usmName\_*)
                psmList_4g=(`printf '%s\n' "${psmList_4g[@]}" | sort -V`)
                printf '%s\n' "${psmList_4g[@]}"
				lte_kpi_calculation 
         else
                # echo "5G NEID=$NEID"
                psmList_5g=($srcPath/USM_$usmName\_*)
                psmList_5g=(`printf '%s\n' "${psmList_5g[@]}" | sort -V`)
                printf '%s\n' "${psmList_5g[@]}"
				nr_kpi_calculation
         fi
 
        sleep 1
done | tee -a $installDir/Logs/detect_kpi_thresh_$dateTime\.log


sort -g $installDir/Logs/candidates_$dateTime\.csv > $installDir/Logs/detect_kpi_threshold_alert_$dateTime\.csv
#mv $installDir/Logs/candidates.csv $installDir/Logs/detect_kpi_threshold_alert_$dateTime\.csv
rm -f $installDir/Logs/candidates_$dateTime\.csv
# get_hours_csv 2
# sort_output
#sed -i 1i"CST_DATE,CST_HOUR,KPI,NE_ID,CELL_ID,CURR_KPI,BASELINE_AVG_KPI,DELTA_CHANGE%" $installDir/Logs/sorted_kpi_report_$dateTime\.csv

if [ `cat $LogsPath/detect_kpi_threshold_alert_${dateTime}.csv | wc -l` -gt 1 ]; then
        # if [ -s $LogsPath/sorted_kpi_report_${dateTime}.csv ]; then
                sed -i 1i"CST_DATE,CST_HOUR,KPI,NE_ID,CELL_ID,NUM,DEN,CURR_KPI%" $installDir/Logs/detect_kpi_threshold_alert_$dateTime\.csv
                $installDir/Utils/csvToHtml.sh sorted_kpi_report_$dateTime\.csv > $installDir/Logs/detect_kpi_threshold_alert_$dateTime\.html
                #$installDir/Utils/csvToHtml.sh combined_kpi_report_$dateTime\.csv diff_combined_kpi_report_$dateTime\.csv> $installDir/Logs/detect_kpi_threshold_alert_$dateTime\.html
                $installDir/Utils/mailReport.sh "KPI Failure Cells - $eventName" detect_kpi_threshold_alert_$dateTime\.csv detect_kpi_threshold_alert_$dateTime\.html | tee -a $LogsPath/detect_kpi_thresh_$dateTime\.log
        # fi
else
        echo "Issue not detected; Mail not sent" | tee -a $LogsPath/detect_kpi_thresh_$dateTime\.log
fi
#rm -f $LogsPath/diff_combined_kpi_report_$dateTime\.csv
#rm -f $LogsPath/combined_kpi_report_$dateTime\.csv

