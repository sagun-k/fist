#!/bin/bash

subject=$1

filename=$2
htmlFile=$3

Date=`date +%Y-%m-%d_%H:%M:%S`

installDir=`pwd`

send() {
        echo $1
        sleep 0.2
}

create_mail () {
   send "HELO east.nss.vzwnet.com"
   send "MAIL FROM:KPI_alert@mailserver.com"
   for email in `cat $installDir/Conf/email_list.conf | grep -v "^#"`
   do
      send "RCPT TO:$email"
   done
   send "DATA"
   send "Subject: $subject - $Date"
   send "Mime-Version: 1.0"
   send "Content-Type: text/html;"
   send "Please perform analysis for below sites for KPI Failure"
   printf "\n"
   #send "Content-Type: text/csv;"
   #send "Content-Disposition: attachment; filename=\"$filename\""
   #cat $installDir/Logs/$filename
   cat $installDir/Logs/$htmlFile
   printf "\n"
   send "Note:  Baseline KPI is calculated by taking into account the previous 3 similar weekdays for the same hour and by doing a sum of all the 3 numerators and dividing by the sum of 3 denominators"
   printf "\n"
   send "."
}

create_mail | telnet 10.100.1.54 25

