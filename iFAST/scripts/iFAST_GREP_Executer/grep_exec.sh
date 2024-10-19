#!/bin/bash

installDir="/opt/vz_raw_data/Scripts/Test/iFAST_GREP_Executer"

dateTime=`date +%m%d%Y_%H%M%S`

Date=`date +%Y%m%d`
#Arguments
file_path_name=$1
grepString=$2
#no_of_siteIds=$3
PID=$3
LogFilePath="$installDir/Logs/"
LogFile="$LogFilePath/output_${PID}_${dateTime}.csv"

mkdir -p $LogFilePath

#if arg empty
if [ "$1" = "" ]; then
    echo "Usage :  grep_exec.sh <Path/to/file> <grep_condition> <issueID_seqID>"
    exit
fi
#if file exists and not empty
if [[ -s $file_path_name ]]; then
    if grep -q "$grepString" $file_path_name; then
        sed -n '/Exec_Start,NE_ID/,/Exec_End,NE_ID/p' $file_path_name | grep -e "Exec_Start,NE_ID" -e "$grepString" | sed 's/Exec_Start,NE_ID://g' > $LogFile
        sed -i 'N;s/\n/,/' $LogFile
        sed -i '1i NE_ID,MATCH' $LogFile
        sleep 1
        echo ""
        echo "Matches Found"
        echo "" 
        echo "Output_file: $LogFile"
        echo ""
    else
        echo "No Matches Found" | tee $LogFile
    fi

else
    echo "File is empty"
fi
