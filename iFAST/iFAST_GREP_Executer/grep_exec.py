#!/usr/bin/python3
#############################################################################
#Author:Shrutisagar
#Script:grep_exec.py
#Purpose: TO grep the matches of NEIDs
#############################################################################

import os
import sys
import pandas as pd
from datetime import datetime

def main(file_path_name, grep_string, pid):
    install_dir = "/home/sieluser/iFAST_GREP_Executer"
    log_file_path = os.path.join(install_dir, "Logs")
    os.makedirs(log_file_path, exist_ok=True)

    date_time = datetime.now().strftime("%m%d%Y_%H%M%S")
    log_file = os.path.join(log_file_path, f"output_{pid}_{date_time}.csv")

    if not file_path_name or not grep_string:
        print("Usage : grep_exec.py <Path/to/file> <grep_condition> <issueID_seqID>")
        sys.exit()

    if os.path.isfile(file_path_name) and os.path.getsize(file_path_name) > 0:
        with open(file_path_name, 'r') as file:
            lines = file.readlines()

        data = {
            "NE_ID": [],
            "DESC": [],
            "MATCH": []
        }

        is_matching = False
        current_ne_id = None

        for line in lines:
            if "Exec_Start,NE_ID" in line:
                is_matching = True
                current_ne_id = line.replace("Exec_Start,NE_ID:", "").strip()
            elif "Exec_End,NE_ID" in line:
                is_matching = False
            elif is_matching and grep_string in line:
                data["NE_ID"].append(current_ne_id)
                data["DESC"].append(line.strip())
                if "No current Alarm" in line:
                    data["MATCH"].append("No Match")
                else:
                    data["MATCH"].append("Match")

        if data["NE_ID"]:
            df = pd.DataFrame(data)
            df.to_csv(log_file, index=False)
            print("\nMatches Found\n")
            print(f"Output_file: {log_file}\n")
        else:
            with open(log_file, 'w') as output_file:
                output_file.write("No Matches Found\n")
            print("No Matches Found")
    else:
        print("File is empty")

if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("Usage : grep_exec.py <Path/to/file> <grep_condition> <issueID_seqID>")
        sys.exit()

    main(sys.argv[1], sys.argv[2], sys.argv[3])

