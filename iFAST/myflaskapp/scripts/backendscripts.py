#!/usr/bin/python3

import subprocess
import re

try:
    result = subprocess.run(
        ['bash', 'cli_exec.sh'],
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

