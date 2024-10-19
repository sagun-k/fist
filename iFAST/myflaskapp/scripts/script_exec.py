#!/usr/bin/python3
import sys
import subprocess
import pandas as pd
import re
log_file_path = ""
if len(sys.argv) < 2:
   print("Wrong args")
   sys.exit()
counter = sys.argv[1]
cond =  sys.argv[2]
sites = sys.argv[3]
issue = sys.argv[4]
output= subprocess.run(['bash','/home/sieluser/iFAST_OM_Executer/om_exec.sh',counter,cond,sites,"21_2"], stdout=subprocess.PIPE, stderr=subprocess.PIPE)

file = output.stdout.decode('utf-8')
output_file_path = file.split(':')[-1].strip()
df = pd.read_csv(output_file_path)
unique_ne_ids = df['NE_ID'].unique().tolist()
if len(unique_ne_ids) > 0:
    ne_ids_string = ",".join(map(str, unique_ne_ids))
else:
    ne_ids_string = str(unique_ne_ids[0]) if unique_ne_ids else ""

print(ne_ids_string)


try:
    print('cli_exec.sh',f'{ne_ids_string}')
    sys.exit()
    result = subprocess.run(
        ['bash', 'cli_exec.sh',f'{ne_ids_string}'],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        universal_newlines=True,
        check=True
    )

    output = result.stdout
    print("Expect Script Output:")
    print(output)

    match = re.search(r'COMMAND Output can be found @ (.+)', output)
    if match:
        log_file_path = match.group(1).strip()
        print("Log File Path:", log_file_path)
    else:
        print("Log file path not found in output.")

except subprocess.CalledProcessError as e:
    print(f"An error occurred: {e}")
    print("Output:")
    print(e.stdout)
    print("Errors:")
    print(e.stderr)
try:
    if log_file_path is None:
       log_file_path = "/home/sieluser/iFAST_CLI_Executer/Logs/21_2_081424_010043_execution.log"
    log_file_path = "/home/sieluser/iFAST_CLI_Executer/Logs/21_2_081424_010043_execution.log"
    result = subprocess.run(
        ['bash', '/home/sieluser/iFAST_GREP_Executer/grep_exec.sh',f'{log_file_path}','Alarm','21_2'],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        universal_newlines=True,
        check=True
    )

    output = result.stdout
    file = output.split(':')[-1].strip()
    print("GREP Script Output:")
    print(file)
    df = pd.read_csv(file)
    print(df.to_html())

except subprocess.CalledProcessError as e:
    print(f"An error occurred: {e}")
    print("Output:")
    print(e.stdout)
    print("Errors:")
    print(e.stderr)

