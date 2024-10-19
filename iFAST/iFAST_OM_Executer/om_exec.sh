#!/bin/bash

installDir="/home/sieluser/iFAST_OM_Executer"
COUNTERINFO="$1"
CMD_STR="$2"
SITE_LIST="$3"
PID="$4"
#OM_DRILL_MAPPING="$installDir/Conf/OMfamily_Drill_Mapping.csv"
temp_file="$installDir/Conf/New_query_2024_08_11.csv"

dateTime=`date +%m-%d-%-Y_%H%M%S`
today=`date +%Y-%m-%d -d '+5 hour 0 min'` #use
yesterday=$(date -d "$today -1 days" "+%Y-%m-%d")
curr_Hour=`date -d '+5 hour' +%H`
prev_Hour=`date -d '+4 hour' +%H` #use
cst_curr_Hour=`date -d '1 hour ago' +%H`
cst_prev_Hour=`date -d '3 hour ago' +%H` #use this for prev hr
flag=0
prevHOur00="${prev_Hour}00"
currHour00="${curr_Hour}00"
today00=`date +%Y%m%d -d '+5 hour 0 min'`

#db_creds
# drill_id="etl_devuser"
# drill_pass="P@ssword1"
# drill_ip="10.100.1.107"
CMD_FILE="$installDir/Conf/cmd_${PID}_${dateTime}.conf"
scriptLog="$installDir/Logs/${PID}_${dateTime}_script.log"
#prints
#echo "date=$today"
#echo "prev_Hour=$prev_Hour"

#drill_date="${today} ${prev_Hour}"
drill_date="${yesterday} ${prev_Hour}"
#echo "$drill_date"

if [ "$1" = "" ]; then
    echo "Usage :  om_exec.sh <OM_Info> <OM_condition> <siteIds comma seperated> <issueId_sequenceId>"
        exit
fi

#./om_exec.sh "NR_PRACH_BEAM| RachPreambleAPerBeam,RachPreambleACFRAPerBeam,NumMSG3PerBeam,NumMSG3CFRAPerBeam\nCU-CSL| CauseInternalRandomAccessProblem" "RachPreambleAPerBeam+RachPreambleACFRAPerBeam,=,0\nNumMSG3PerBeam+NumMSG3CFRAPerBeam,=,0\nCauseInternalRandomAccessProblem,!=,0\n#proceed,No" "24593002050_5GDU_CATAWBA_SOUTH-CLMB,24593002373_5GDU_MERCHANTS_LANDING-CLMB,24593003029_5GDU_FOSTORIA-CLMB" 21_2

#./om_exec.sh "S5NR_DLMACLayerDataVolume_MB,S5NR_ULMACLayerDataVolume_MB,S5NR_ULMACcellAggregateTput_Mbps_Num,S5NR_DLTTIUtilization_Pct_Num\n" "S5NR_DLMACLayerDataVolume_MB+S5NR_ULMACLayerDataVolume_MB,=,0\nS5NR_ULMACcellAggregateTput_Mbps_Num+S5NR_DLTTIUtilization_Pct_Num,=,0\n#proceed,No" "VZ_07901640052,VZ_06000090001,VZ_06000090003" 21_2
SITE_LIST1=$SITE_LIST

if [ "$SITE_LIST" = "" ]; then
    echo "Cannot find NE information. Please double check the siteid"
    exit
else

    SITE_LIST="'$(echo "$SITE_LIST" | sed "s/,/','/g")'"
    echo "SITE_LIST=$SITE_LIST" >> $scriptLog

fi

if [ "$CMD_STR" = "" ]; then
    echo "No Commands found. Please pass command to be executed"
else
    printf "$CMD_STR\n" >> $CMD_FILE
    sed -i '/^#/d' $CMD_FILE
fi


#get_OMCounterInfo_drill() {

#for omFamilyName in `cat $COUNTERINFO | cut -d"|" -f1 | egrep -v "#|^\$"`

###commenting Apache part
# for omFamilyName in `printf "$COUNTERINFO\n"| cut -d"|" -f1`
# do
    # tableName=$(awk -F',' '{ if ($1 == "'$omFamilyName'") { print $2 } }' $OM_DRILL_MAPPING )

    # #echo "/opt/drill/apache-drill-1.19.0/bin/sqlline -u jdbc:drill:zk=local -e \"select * from dfs.vzdb.$tableName where NE_NAME IN ($SITE_LIST) and datetime_utc like '%${drill_date}%';\" --outputformat=\"csv\" > /opt/data/${omFamilyName}.csv"

   # drill_cmd="/opt/drill/apache-drill-1.19.0/bin/sqlline -u jdbc:drill:zk=local -e \"select * from dfs.vzdb.$tableName where NE_NAME IN (${SITE_LIST}) and datetime_utc like '%${drill_date}%';\" --outputformat=\"csv\" > /opt/data/iFAST_Logs/${omFamilyName}_${PID}_${dateTime}.csv ; sed -i -e \"s/'//g\" -e \"s/apache drill>//g\" /opt/data/iFAST_Logs/${omFamilyName}_${PID}_${dateTime}.csv"

   # echo "$drill_cmd" >> $scriptLog

   # sshpass -p$drill_pass ssh -o StrictHostKeyChecking=no $drill_id@$drill_ip "$drill_cmd" >> $scriptLog 2>&1
# done

# echo
# {
        # /usr/bin/expect  << EOF
        # set timeout 100
        # proc myExpect {string} {
                # expect {
                        # "Are you sure you want to continue connecting (yes/no)?" {send "yes\r";exp_continue}
                        # timeout { send_user "TIMEOUT_WAITING_FOR_\$string\n"; exit }
                        # "\$string" {}
                # }
        # }
        # spawn sftp $drill_id@$drill_ip
        # expect {
                # "Are you sure you want to continue connecting (yes/no)?" {send "yes\r";exp_continue}
                # timeout { send_user "CIQ_SERVER_SSH_TIMEOUT"; exit 1}
                # eof { send_user "TIMEOUT_WAITING_FOR_\$string\n"; exit 1 }
                # "password:"
        # }
        # send "$drill_pass\r"
        # myExpect "sftp>"
        # send "lcd $installDir/Logs/\r"
        # myExpect "sftp>"
        # send "cd /opt/data/iFAST_Logs/\r"
        # myExpect "sftp>"
        # send "ls -lrt\r"
        # myExpect "sftp>"
        # send "get *${PID}_${dateTime}.csv*\r"
        # myExpect "sftp>"
        # send_user "GET_OM_DATA SUCCESSFUL\n"
        # send "exit\r"
        # exit
# EOF
# } >> $scriptLog

# for csvFile in `ls $installDir/Logs/*${PID}_${dateTime}.csv*`
# do
    # #echo "csvFile=$csvFile"
    # sed -i -e 's/^.*NE_NAME,/NE_NAME,/' $csvFile
# done

# omFilesArr=($(ls $installDir/Logs/*${PID}_${dateTime}.csv*))
# #printf '%s\n' "${omFilesArr[@]}"
# echo "om_exec complete" >> $scriptLog
# #echo ""
# }

#main
#get_OMCounterInfo_drill

# perl $installDir/om_processor.pl "$SITE_LIST1" "$installDir/Logs/NR_PRACH_BEAM_${PID}_${dateTime}.csv" "$CMD_FILE" "$OM_DRILL_MAPPING" "${PID}_${dateTime}" "$scriptLog"
perl $installDir/om_processor.pl "$SITE_LIST1" "$temp_file" "$CMD_FILE" "${PID}_${dateTime}" "$scriptLog" "$cst_prev_Hour" "$COUNTERINFO"
