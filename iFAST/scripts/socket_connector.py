#!/usr/bin/python3
import paramiko

def ssh_and_execute_command(host, port, username, password, command):
    try:
        log_file = "ssh_exec.log"
        ssh = paramiko.SSHClient()

        ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        ssh.connect(hostname=host, port=port, username=username, password=password)
        print(f"Connected to {host}")
        stdin, stdout, stderr = ssh.exec_command(command)
        

        output = stdout.read().decode('utf-8')
        error = stderr.read().decode('utf-8')
        print(output)
        with open(log_file, 'w') as log:
            if output:
                log.write("Output:\n")
                log.write(output + "\n")
            if error:
                log.write("Error:\n")
                log.write(error + "\n")       

    except Exception as e:
        print(f"Failed to connect or execute command: {e}")

    finally:
        ssh.close()
        print("Connection closed")

host = "10.100.1.241"  
port = 22             
username = "toolsuser"
password = "Tools@123"
command = 'cd /opt/vz_raw_data/Scripts/Test/iFAST_CLI_Executer/;./multi_site_cli.py "gca NE_ID,vendgrp" "eNB_131307,eNB_135571,eNB_250743,eNB_59209,eNB_73321,eNB_136668" "21_2"'

ssh_and_execute_command(host, port, username, password, command)

