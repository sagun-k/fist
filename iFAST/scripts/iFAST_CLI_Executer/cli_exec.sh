#!/bin/bash

##########################################################
# Tool : CLI_Executer                                    #
# Author :Praseeda <p.venkata@partner.sea.samsung.com>   #
##########################################################
/bin/rm  -f ~/.ssh/known_hosts > /dev/null 2>&1

InstallDir="/opt/vz_raw_data/Scripts/Test/iFAST_CLI_Executer"
TOOLS="$InstallDir/Conf/tools.conf"
USER="$1"
PASS="$2"
SITE_LIST="$3"
CMD_STR="$4"
PID="$5"

DateTime=`date +%m%d%y_%H%M%S`

CMD_FILE="$InstallDir/Conf/cmd_${DateTime}_${PID}.conf"

#CMD_FILE="$InstallDir/Conf/cmd_temp.conf"
LOGFILE="$InstallDir/Logs/${PID}_${DateTime}_execution.log"
scriptLog="$InstallDir/Logs/${PID}_${DateTime}_script.log"
#NE_ID="13291523020"

#IFS=', ' read -r -a site_array <<< "$SITE_LIST"
#echo "${site_array[@]}"

#if sitelist empty or not comma seperated prompt error
if [ "$1" = "" ]; then
    echo "Usage :  cli_exec.sh <duo_id> <duo_password> <siteIds comma seperated> <commands line seperated> <issueId_sequenceId>"
        exit
fi

if [ "$SITE_LIST" = "" ]; then
    echo "Cannot find NE information. Please double check the siteid"
    exit
else
    IFS=', ' read -r -a site_array <<< "$SITE_LIST"
fi

if [ "$CMD_STR" = "" ]; then
    echo "No Commands found. Please pass command to be executed"
else
    printf "$CMD_STR\n" >> $CMD_FILE
    sed -i '/^#/d' $CMD_FILE
fi
echo "SITE_LIST=$SITE_LIST\nCommands=$CMD_STR\nIssue_Seq=$PID\nDUO_ID=$USER" >> $scriptLog


#CMD_FILE="$InstallDir/Conf/cmd_temp.conf" #remove this later
SANE_SERVER=198.226.62.123
tmp=$(mktemp /tmp/tmp.XXXXX.deleteme)


SSH_OPTS='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
for S_SERVER in $SANE_SERVER 198.226.62.{123,125,124,123} 198.226.62.{124,123,125,124} # try a second time... (if all failing)
do
    ssh $SSH_OPTS  -o ConnectTimeout=3  -o NumberOfPasswordPrompts=0   ConnectionCheck@$S_SERVER > $tmp 2>&1 < /dev/null
    if ! grep 'Connection refused' $tmp > /dev/null 2>&1 # silent
    then
        SANE_SERVER=$S_SERVER
        break
    # else echo $S_SERVER FAILED
    fi
done
rm -f $tmp
unset S_SERVER

echo -n
{
        /bin/expect  << EOF
        set match_max 5000
        set FD [open $TOOLS r]
        set CMDS [split [read \$FD] "\n"]
        set CLI_FD  [open $CMD_FILE r]
        set CLI_CMDS [split [read \$CLI_FD] "\n"]
        log_file -a $LOGFILE
        set timeout 300
        global expect_out
        proc myExpect {string} {
                global expect_out
                expect {
                        -re "Are you sure you want to continue connecting (yes/no)?" {send "yes\r";exp_continue}
                        timeout { send_user "\nFAILED : Expect timed out waiting for '\$string' \n"; exit 1}
                        -re "\$string" { }
                }
                unset expect_out(buffer)
        }
        spawn ssh $USER@$SANE_SERVER
        expect {
                "Are you sure you want to continue connecting (yes/no)?" {send "yes\r";exp_continue}
                timeout { send_user "\nFAILED : Sane login failure\n"; exit 1}
                "Password:" {
                        send "$PASS\r"
                        expect {
                                timeout { send_user "\nFAILED : Sane login failure\n"; exit 1}
                                "Please Enter Selection: >" {}
                        }
                }
        }

        foreach CMD \$CMDS {
                set string1 [exec echo \$CMD | cut -f1 -d,]
                set string2 [exec echo \$CMD | cut -f2 -d,]
                if {\$string2 ne ""} then {
                        send "\$string1\r"
                        myExpect "\$string2"
                }
        }

        send_user "\nSane login successful\n"

        #exit

        foreach NE_ID {${site_array[@]}} {
            send_user "\nExec_Start,NE_ID:\$NE_ID\n"
            puts "NE_ID : \$NE_ID"
            foreach CLI_CMD \$CLI_CMDS {
                set cmd1 [regsub -all -- {NE_ID} [exec echo \$CLI_CMD | cut -f1 -d,] \$NE_ID]
                set exp2 [exec echo \$CLI_CMD | cut -f2 -d,]
                    if {\$exp2 ne ""} then {
                            send "\$cmd1\r"
                            sleep 5
                            myExpect "\$exp2"
                    }
            }
            send_user "\nExec_End,NE_ID:\$NE_ID\n"
        }

EOF
} >> $scriptLog
sleep 5
#echo "logfile= $LOGFILE"

if test -f "$LOGFILE"; then
        sed -i 's/ ^M//g' $LOGFILE
        sed -i 's/^M//g' $LOGFILE
        if grep --quiet FAILED $LOGFILE; then
                echo;echo
                echo "Tool execution failure refer $LOGFILE for more details"
                echo;echo
        else
                echo;echo
                echo "COMMAND Output can be found @ $LOGFILE"
                echo;echo
        fi
else
        echo;echo
        echo "Tool execution failure.. contact support!"
        echo;echo
fi


