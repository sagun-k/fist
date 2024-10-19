#!/bin/bash

installDir="/home/sieluser/iFAST_GREP_Executer"

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
if [[ -s $file_path_name ]]; then
    if grep -q "$grepString" "$file_path_name"; then
        # Extract relevant lines between Exec_Start and Exec_End, then filter and format
        sed -n '/Exec_Start,NE_ID/,/Exec_End,NE_ID/p' "$file_path_name" | grep -e "Exec_Start,NE_ID" -e "$grepString" | sed 's/Exec_Start,NE_ID://g' > "$LogFile"

        # Add the header line
        echo "NE_ID,DESC,MATCH" > "${LogFile}_temp"

        # Process the log file to append "No Match" if "No current Alarm" is found
        while IFS=, read -r ne_id match; do
            if [[ "$match" =~ "No current Alarm" ]]; then
                echo "$ne_id,$match,No Match" >> "${LogFile}_temp"
            else
                echo "$ne_id,$match,Match" >> "${LogFile}_temp"
            fi
        done < "$LogFile" # Process the file line by line

        # Replace the original log file with the updated one
        mv "${LogFile}_temp" "$LogFile"

        sleep 1
        echo ""
        echo "Matches Found"
        echo ""
        echo "Output_file: $LogFile"
        echo ""
    else
        echo "No Matches Found" | tee "$LogFile"
    fi
else
    echo "File is empty"
fi

