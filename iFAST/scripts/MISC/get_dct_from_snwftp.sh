#!/bin/bash
shopt -s nullglob


date=`date +%Y%m%d`
directory="/SW_LOAD_TEST/4G_DCT_Output"

echo $directory

echo
{
        /usr/bin/expect  << EOF
        set timeout 180
        proc myExpect {string} {
                expect {
                        "Are you sure you want to continue connecting (yes/no)?" {send "yes\r";exp_continue}
                        timeout { send_user "Timeout waiting for \$string\n"; exit }
                        "\$string" {}
                }
        }
        spawn sftp b.viswasai@65.169.250.25
        expect {
                "Are you sure you want to continue connecting (yes/no)?" {send "yes\r";exp_continue}
                timeout { send_user "\nDEBUG : SSH Timeout \n"; exit 1}
                eof { send_user "Timeout waiting for \$string\n"; exit }
                "password:"
        }
        send "|HscwDH5\r"
        myExpect "sftp"
        send "lcd /home/toolsuser/Scripts/DCT/Logs/$date\r"
	#send "lcd /opt/vz_raw_data/Scripts/Test/$date\r"
        myExpect "sftp"
        send "cd $directory/\r"
        myExpect "sftp>"
        send  "ls -lrt\r"
        myExpect "sftp>"
        send  "get FSM_DCT_DATA_*\r"
        myExpect "sftp>"
        sleep 10
        send  "get SEA_DCT_DATA_*\r"
        myExpect "sftp>"
        send  "rm *.csv*\r"
        myExpect "sftp>"
        sleep 10
        send "exit\r"
        myExpect "toolsuser"
        
EOF
}
        File_Count=`ls /home/toolsuser/Scripts/DCT/Logs/$date/ | wc -l`
        echo $File_Count



        if [[ $File_Count -gt 2 ]] ; then
            echo "This file exists on your filesystem."
            touch /home/toolsuser/Scripts/DCT/Logs/$date/4g_om_files_received.txt
            chmod 775 /home/toolsuser/Scripts/DCT/Logs/$date/*
        else
            echo "No DCT File Exists"
        fi
