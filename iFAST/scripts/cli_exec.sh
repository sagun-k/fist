#!/usr/bin/bash
###########################################################
# Description : Script to run cli script
# ---------------------------------------------------------
# Version | Date       | Author      | Description
# ---------------------------------------------------------
# V1      | 08/14/2024 | Shrutisagar | Script Creation
# ---------------------------------------------------------
###########################################################

if [ $# -lt 1 ]; then
  echo "Wrong args"
  exit 1
else
  echo "Argument 1: $1"
fi
echo
{

/usr/local/bin/expect << EOF
    set timeout 300
    proc myExpect {string} {
        expect {
            "Are you sure you want to continue connecting (yes/no)?" {
                send "yes\r"
                exp_continue
            }
            timeout {
                send_user "TIMEOUT_WAITING_FOR_\$string\n"
                exit
            }
            "\$string" {}
        }
    }

    spawn ssh toolsuser@10.100.1.79
    expect {
        "Are you sure you want to continue connecting (yes/no)?" {
            send "yes\r"
            exp_continue
        }
        timeout {
            send_user "sane_ftp_server_SSH_TIMEOUT\n"
            exit 1
        }
        eof {
            send_user "TIMEOUT_WAITING_FOR_\$string\n"
            exit 1
        }
        "password:"
    }

    send "Tools@123\r"

    expect {
        "$ " {
            # Change directory and execute the script on the remote server
            send "cd /opt/vz_raw_data/Scripts/Test/iFAST_CLI_Executer/\r"
            expect "$ " { send "./cli_exec.sh venpr8r 90327463 $1 \"gca NE_ID,vendgrp\ngah NE_ID,vendgrp\n\" 21_2\r"  }
        }
        timeout {
            send_user "TIMEOUT_WAITING_FOR_PROMPT\n"
            exit 1
        }
        eof {
            send_user "REMOTE_SESSION_CLOSED\n"
            exit 1
        }
    }

    expect {
        "$ " {
            send_user "Script executed successfully.\n"
            exit
        }
        timeout {
            send_user "TIMEOUT_WAITING_FOR_SCRIPT_COMPLETION\n"
            exit 1
        }
        eof {
            send_user "REMOTE_SESSION_CLOSED\n"
            exit 1
        }
    }

EOF
}


