#!/bin/bash

##########################################################
# Tool : CLI_Executer                                    #
# Author :Praseeda <p.venkata@partner.sea.samsung.com>   #
##########################################################
/bin/rm  -f ~/.ssh/known_hosts > /dev/null 2>&1

InstallDir=`pwd`
TOOLS="$InstallDir/Conf/tools.conf"
USER="$1"
PASS="$2"
SITE_LIST="$3"
# CMD_FILE="$4"
PID="$4"
CMD_FILE="$InstallDir/Conf/cmd_temp.conf"
LOGFILE="$InstallDir/Logs/CLIExecuter_${DateTime}_${PID}.log"

#NE_ID="13291523020"

IFS=', ' read -r -a site_array <<< "$SITE_LIST"
echo "${site_array[@]}"


NE_ID=${site_array[@]}

neID=""

#for NE_ID in "${site_array[@]}"
#do
#    echo "$NE_ID"
#done

SANE_SERVER=198.226.62.124
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

echo SANE_LOGIN=$USER
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
        foreach NE_ID {${site_array[@]}} {

            foreach CLI_CMD \$CLI_CMDS {
            
                puts "NE_ID=\$NE_ID"
                set i "\$NE_ID"
                puts "\$i"
                puts "set cmd1 [regsub -all -- {NE_ID} [exec echo \$CLI_CMD | cut -f1 -d,] \$NE_ID]"
                #set cmd1 [regsub -all -- {NE_ID} [exec echo \$CLI_CMD | cut -f1 -d,] {${site_array[0]}}]
                #puts "set cmd1 [regsub -all -- {NE_ID} [exec echo \$CLI_CMD | cut -f1 -d,] {$NE_ID}]"
                #set exp2 [exec echo \$CLI_CMD | cut -f2 -d,]
                    #if {\$exp2 ne ""} then {
                    #        send "\$cmd1\r"
                    #        sleep 1
                    #        myExpect "\$exp2"
                    #}
            }
        }

EOF
}
