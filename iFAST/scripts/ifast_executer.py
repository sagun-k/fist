#!/usr/bin/python3
######################################################################################################################
#Author      :  Shrutisagar
#Description :  Wrapper script to run CLI/OM/GREP and fetch outputs
######################################################################################################################
import sys
import subprocess
import pandas as pd
import re
import pexpect
log_file_path = ""
import os
import warnings
warnings.filterwarnings("ignore", category=UserWarning, module='cryptography')
warnings.filterwarnings("ignore", category=UserWarning, module='paramiko')
warnings.filterwarnings("ignore", category=DeprecationWarning)

import random
from datetime import datetime,timedelta
from abc import ABCMeta, abstractmethod
import paramiko

sys.stderr = open(os.devnull,'w')
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__),'..')))
from Database import Database

class MockApp:
   def __init__(self, config):
      self.config = config

config = {
'MYSQL_HOST' : 'localhost',
'MYSQL_USER' : 'root',
'MYSQL_PASSWORD' : 'Tools@123',
'MYSQL_DB' : 'iFAST'
}

class Printer:
    __metaclass__ = ABCMeta

    @abstractmethod
    def cli_print(self, message, status=None):
        pass

class CliPrinter(Printer):
    def cli_print(self, message, status=None):
        count = 150# Total line width
        RED = "\033[91m"
        RESET = "\033[0m"
        if "ERROR" in message:
            message = f"{RED}{message}{RESET}"
            status = f"{RED}{status}{RESET}"
        if status is not None:
            remaining_width = count - len(status)+30 - 5
            output = '{:<{width}} [{}]'.format(message, status, width=remaining_width)
        else:
            output = message

        sys.stdout.write(output + '\n')
        sys.stdout.flush()

class Utils:
    def insert_into_session(self, session_id=None, sequence_id=None, action_type=None, task_id=None, username=None, timestamp=None, 
                            log_path=None, log_file_name=None, arguments=None, server_ip=None, server_id = None,script_path=None, script_name=None, 
                            copy_file_name=None, status=None, exec_res=None, NE_MATCH=None):
       try:
          ins_ses_query = "insert into session(session_id,sequence_id,action_type,task_id,username,timestamp) values (%s,%s,%s,%s,%s,%s)"
          ins_ses_vals = (session_id,sequence_id,action_type,task_id,username,timestamp)
          db.execute_query(ins_ses_query, ins_ses_vals, commit=True)
          ins_sd_query = "insert into session_details(session_id,sequence_id,action_type,task_id,username,timestamp,log_path,log_file_name,arguments,server_ip,server_id,script_path,script_name,copy_file_name,status,exec_res,NE_MATCH) values (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)"
          ins_sd_vals = (session_id,sequence_id,action_type,task_id,username,timestamp,log_path,log_file_name,arguments,server_ip,server_id,script_path,script_name,copy_file_name,status,exec_res,NE_MATCH)
          db.execute_query(ins_sd_query, ins_sd_vals, commit=True)
       except Exception as e:
          print(e)

    def update_session_details(self,status,NE_MATCH,session_id):
       try:
          upd_query = "update session_details set status=%s,NE_MATCH=%s where session_id=%s"
          values = (status,NE_MATCH,session_id,)
          db.execute_query(upd_query,values,commit=True)   
       except Exception as e:
          print(e)

class EXEC:
    def __init__(self, sites, counter, cond, issue, session, env, log, pc):
        self.counter = counter
        self.cond = cond
        self.sites = sites
        self.issue = issue
        self.session = session
        self.env = env
        self.omscript = "/home/sieluser/iFAST_OM_Executer/om_processor.py"
        self.jumpbox = "10.100.1.79"
        self.juser = "toolsuser"
        self.passwd = "Tools@123"
        self.cli_path = "/opt/vz_raw_data/Scripts/Test/iFAST_CLI_Executer/"
        self.grep_script = "/home/sieluser/iFAST_GREP_Executer/grep_exec.py"
        self.log = log
        self.printer = pc
        self.session_id = self.ifast_rand(8,self.issue)
        self.printer.cli_print(f"[INFO]:  {self.session_id} Created for current execution","OK")
         
    def ifast_rand(self,length,issue):
        random_val = ''.join(random.choices('0123456789', k=length))
        random_val = f'iFAST_{issue}_{random_val}'
        return random_val

   
    def check_scripts(self):
        if not os.path.exists(self.omscript):
           error_message = "OM Executor script is not present."
           return error_message, False
        
        if not os.path.exists(self.grep_script):
           error_message = "GREP Executor script is not present."
           return error_message, False           
        return "All scripts are present.", True

    def om_executer(self):
        username = "shruti.sagar"
        timestamp = datetime.now()
        timestamp = timestamp.strftime("%Y-%m-%d %H:%M:%S")
        log_path = os.getcwd()
        log_file_name = "test.log"
        arguments = ""
        script_path =""
        script_name = self.omscript
        copy_file_name = ""
        status = "inprogress"
        server_id = ""
        server_ip = ""
        self.log.insert_into_session(self.session_id,"1","PULL OM","1",username,timestamp,log_path,log_file_name,arguments,server_ip,server_id,script_path,script_name,copy_file_name,status)        
        try:
            output = subprocess.run(['python3', f'{self.omscript}', self.sites, self.counter, self.cond, self.issue],stdout=subprocess.PIPE,stderr=subprocess.PIPE)
             
            stdout_output = output.stdout.decode('utf-8')
            stderr_output = output.stderr.decode('utf-8')
    
            if stderr_output:
               print("Standard Error:\n", stderr_output)
               sys.exit()

            return stdout_output, self.session_id

        except Exception as e:
           print("Exception:", str(e))
           return "", ""

    def cli_executer_new(self,ne_ids_string,issue_id):
        username = "shruti.sagar"
        cur_date = datetime.now()
        today_date = cur_date.strftime("%m%d%Y") 
        timestmp = cur_date.strftime("%H%M%S")
        timestamp = cur_date.strftime("%Y-%m-%d %H:%M:%S")
        PID = os.getpid()
        log_path = os.getcwd()
        log_file = f"CLI_LOGS/{PID}_{today_date}_{timestmp}_cliexecution.log"
        arguments = ""
        script_path =""
        script_name = "/home/sieluser/myflaskapp/scripts/ifast_executer.py"
        copy_file_name = ""
        status = "inprogress"
        server_id = ""
        server_ip = ""
        host = "10.100.1.241"
        port = 22
        username = "toolsuser"
        password = "Tools@123"
        command = f'cd /opt/vz_raw_data/Scripts/Test/iFAST_CLI_Executer/;./multi_site_cli.py "gca NE_ID,vendgrp" "{ne_ids_string}" "{self.issue}"'
        self.log.insert_into_session(self.session_id,"2","RUN CLI","2",username,timestamp,log_path,log_file,arguments,server_ip,server_id,script_path,script_name,copy_file_name,status) 

        try:
          ssh = paramiko.SSHClient()

          ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
          ssh.connect(hostname=host, port=port, username=username, password=password)
          self.printer.cli_print(f"[INFO]:  conneted to {host}","OK")
          stdin, stdout, stderr = ssh.exec_command(command)

          output = stdout.read().decode('utf-8')
          error = stderr.read().decode('utf-8')
          with open(log_file, 'w') as log:
            if output:
                log.write("Output:\n")
                log.write(output + "\n")
            if error:
                log.write("Error:\n")
                log.write(error + "\n")
          return log_file

        except Exception as e:
          self.printer.cli_print(f"[ERROR]:  Failed to connect Host exiting!!","NOK")
          exit()

        finally:
          ssh.close()
          self.printer.cli_print(f"[ERROR]:  Connection to Host {host} closed!!","OK")

  
    def grep_executer(self,log_file_path):
        username = "shruti.sagar"
        timestamp = datetime.now()
        timestamp = timestamp.strftime("%Y-%m-%d %H:%M:%S")
        log_path = os.getcwd()
        log_file_name = "test_grep.log"
        arguments = "Alarm"
        script_path =""
        script_name = self.grep_script
        copy_file_name = ""
        status = "inprogress"
        server_id = ""
        server_ip = ""
        self.log.insert_into_session(self.session_id,"3","RUN GREP","3",username,timestamp,log_path,log_file_name,arguments,server_ip,server_id,script_path,script_name,copy_file_name,status)
        try: 
          result = subprocess.run(
                   [f'{self.grep_script}',f'{log_file_path}','Alarm','21_2'],
                   stdout=subprocess.PIPE,
                   stderr=subprocess.PIPE,
                   universal_newlines=True,
                   check=True
          )
          output = result.stdout
          file = output.split(':')[-1].strip()
          df = pd.read_csv(file)
          htm = df.to_html(index=False)
          
          return htm
        except subprocess.CalledProcessError as e:
            print(f"An error occurred: {e}")

class check_args:
    def usage(self):
        print(f"""
        	To pull OM
        	Usage: {sys.argv[0]} <counter> <cond> <sites> <issue> <session> <env>
        	<counter> :  counters
        	<cond>    :  condition
        	<sites>   :  list of sites
        	<issue>   :  Issue ID
        	<session> :  Session ID
        	<env>     :  Type of ENV
        """)

    def args(self):
        if len(sys.argv) != 7:
           print("Error: Incorrect number of arguments.")
           self.usage()
           sys.exit()
     



if __name__ == "__main__":
    misc = Utils()
    app = MockApp(config)
    db = Database(app)
    res = db.execute_query('select * from user',fetch_all=True)
    ag = check_args()
    ag.args()
    printer = CliPrinter()
    ex = EXEC(*sys.argv[1:], misc, printer)
    msg,bool_val = ex.check_scripts()
    if not bool_val:
       printer.cli_print(f"[ERROR]:   {msg}","NOK")
       sys.stdout.flush()
       exit()
    else:
       printer.cli_print(f"[INFO]:  {msg}","OK")
    om_out,session_id= ex.om_executer()
    if om_out.strip() == "No matches Found":
       misc.update_session_details('completed',0,session_id)
       sys.exit(0)
    else:
       output_file_path = om_out.split(':')[-1].strip()
       df = pd.read_csv(output_file_path)
       unique_ne_ids = df['NE_ID'].unique().tolist()
       cnt = len(unique_ne_ids)
       misc.update_session_details('completed',cnt,session_id)
       if len(unique_ne_ids) > 0:
          ne_ids_string = ",".join(map(str, unique_ne_ids))
       else:
          ne_ids_string = str(unique_ne_ids[0]) if unique_ne_ids else ""
       printer.cli_print(f"[INFO]:  OM EXECUTION COMPLETED!!","OK")
       log = ex.cli_executer_new(ne_ids_string,sys.argv[4])
       printer.cli_print(f"[INFO]:  CLI EXECUTION COMPLETED!!","OK")
       final_output = ex.grep_executer(log)
       printer.cli_print(f"[INFO]:  GREP EXECUTION COMPLETED!!","OK")
       filename = "final_output.html"
       with open(filename, 'w') as file:
           file.write(final_output)
