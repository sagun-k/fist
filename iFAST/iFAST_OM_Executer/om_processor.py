#!/usr/bin/python3

import csv
import os
import pandas as pd
import re
import pprint
import sys
from collections import defaultdict
from databricks import sql
from datetime import datetime, timedelta

# get current working directory path
cwd = "/home/sieluser/iFAST_OM_Executer/"
# get current date time
now = datetime.now()
dt_string = now.strftime("%d-%m-%Y_%H%M%S")
d_dtm = datetime.today() - timedelta(hours=4, minutes=0)
d_dtm = d_dtm.strftime('%Y-%m-%d %H')
d_dtm = d_dtm + ':00:00+00:00'
# print("date and time =", d_dtm)

# remove this once live wide table is available
d_dtm = '2024-08-12 16:00:00+00:00'

# these arguments will be dynamic from GUI
sites = sys.argv[1]
counters = sys.argv[2]
cond_checks = sys.argv[3]
PID = sys.argv[4]

# trimming white space
sites = sites.strip()
counters = counters.strip()
cond_checks = cond_checks.strip()

# string to list conversion
site = sites.split(',')
counter = counters.split(',')
cond_checks = cond_checks.replace('\\n', '\n')
validations = cond_checks.splitlines()

# dynamic file paths for execution and script logs
CANDIDATES = cwd + '/Logs/' + PID + '_' + dt_string + '_execution.csv'
scriptLog = cwd + '/Logs/' + PID + '_' + dt_string + '_script.log'

# DBR query result to csv
DBR_CounterFile = cwd + '/Logs/' + PID + '_' + dt_string + '_omCounterFile.csv'

# sites = 'eNB_131307,eNB_135571,eNB_250743,eNB_59209,eNB_73321,eNB_136668'
# counters = '53_AirMacULByteCnt_count_SUM,53_AirMacULThruAvg_Kbps_AVG,53_AirMacDLByte_Kbytes_SUM'
# cond_checks = "53_AirMacULByteCnt_count_SUM+53_AirMacULThruAvg_Kbps_AVG,>,0\n53_AirMacULByteCnt_count_SUM+53_AirMacDLByte_Kbytes_SUM,>,0"
# print(validations)
# print(counters)
# print(sites)

# Declarations
cell_ids = []


# connects to DBR runs the dynamic query and gets related data
def databricks_connector():
    with sql.connect(server_hostname="dbc-d2b3035b-54c3.cloud.databricks.com",
                     http_path="/sql/1.0/warehouses/4db10f38cf9cef7a",
                     access_token="dapieb049d1404e46225b9445d713fcaae5a") as connection:
        with connection.cursor() as cursor:
            ne_ids = tuple(site)
            query = "select * from hive_metastore.default.megatable_4g_site_gold_tmp2 where D_DTM='" + d_dtm + "' and NE_ID IN {}".format(ne_ids)
            cursor.execute(query)
            result = cursor.fetchall()
            # print(result)
            headers = [col[0] for col in cursor.description]  # get headers
            result.insert(0, tuple(headers))
            # fp = open('file.csv', 'w', newline='')
            fp = open(DBR_CounterFile, 'w', newline='')
            my_file = csv.writer(fp)
            my_file.writerows(result)
            fp.close()


# get values for site --> omcounter
def get_counter_value(file_name, row_match, col_header):
    with open(file_name, "r") as counter_file:
        reader = csv.reader(counter_file)
        headers = next(reader)  # Read the header row
        col_index = headers.index(col_header)  # Get the column index
        for row in reader:
            if row_match in row:  # Check if the row contains the match string
                return row[col_index]  # Return the value in the specified column
                return None  # Return None if no match found


# get cell id's of each site id
def get_cell_ids(filename, site_id):
    df = pd.read_csv(filename)
    cells = df['LOCATION'][df['NE_ID'] == site_id].values
    return cells


# nested dictionary to store variables hash like
def nested_dict(n, dtype):
    if n == 1:
        return defaultdict(dtype)
    else:
        return defaultdict(lambda: nested_dict(n - 1, dtype))


# get and store values in dictionary for respective site, cell and counter
def parse_data():
    if os.path.isfile(DBR_CounterFile):
        for site_id in site:
            # ("site=" + site_id)
            cell_ids = get_cell_ids(DBR_CounterFile, site_id)
            # print(cell_ids)
            for cell in cell_ids:
                for om_counter in counter:
                    # print("counter=" + om_counter)
                    counterval = get_counter_value(DBR_CounterFile, site_id, om_counter)
                    # print("value=" + counterval )
                    sites_hash[site_id][cell][om_counter] = counterval
                    # print("values=[" + site_id + "][" + cell + "][" + om_counter + "]=" + sites_hash[site_id][cell][om_counter])
    else:
        print("file does not exist")


# OM conditions validation and output
def condition_check():
    with open(CANDIDATES, "a") as execution_file, open(scriptLog, "a") as scriptlog_file:
        execution_file.write("NE_ID,CELL_ID,STATUS")
        pprint.pprint(sites_hash, stream=scriptlog_file)
        scriptlog_file.write("NE_ID,CELL_ID,CONDITION,PROCESSED_VALUE,OPERATOR,COMPARE_VALUE\n")

        status = "FAIL"
        bool_arr = []
        for site_id in sites_hash.keys():
            # print(site_id)
            for cell in sites_hash[site_id].keys():
                # print(cell)
                # with open('cmd.conf') as cmd_file:
                for line in validations:
                    # print(line, )  # The comma to suppress the extra new line char
                    if line.startswith('#'):
                        continue
                    # cond_counters = re.findall(r'\b\S+\b', line)
                    # cond_arr = [x for x in cond_counters if not (x.isdigit()
                    #                                             or x[0] == '-' and x[1:].isdigit())]
                    # print(cond_arr)
                    # print((lambda cond_arr: line)(sites_hash[site_id][cell][cond_arr[0]], sites_hash[site_id][cell][cond_arr[1]]))

                    cond_line, operator, value = map(str.strip, line.split(',')[:3])
                    # my_line_sep = tuple(my_line)
                    # cond_line = my_line_sep[0]
                    # operator = my_line_sep[1]
                    # value = my_line_sep[2]

                    # cond_line, operator, value = [v.strip() for v in line.split(',')[:3]]
                    cond_line = cond_line.strip()
                    operator = operator.strip()
                    value = value.strip()
                    cond_arr = re.split(r'[\+\-\*\s\/]+', cond_line)

                    if '+' in cond_line and len(cond_arr) == 2:
                        cond = float(sites_hash[site_id][cell][cond_arr[0]]) + float(sites_hash[site_id][cell][cond_arr[1]])
                    elif '-' in cond_line and len(cond_arr) == 2:
                        cond = float(sites_hash[site_id][cell][cond_arr[0]]) - float(sites_hash[site_id][cell][cond_arr[1]])
                    elif len(cond_arr) == 1:
                        cond = float(sites_hash[site_id][cell][cond_arr[0]])
                    cond = int(cond)
                    value = int(value)
                    scriptlog_file.write(f"{site_id},{cell},{cond_line},{cond},{operator},{value}\n")
                    # print(f"{site_id},{cell},{cond_line},{cond},{operator},{value}", file=scriptlog_file)

                    if operator == "=":
                        # print("cond="+ cond +"value=" + value)
                        if cond == value:
                            bool_arr.append(1)
                            status = "PASS"
                        else:
                            bool_arr.append(0)
                            status = "FAIL"
                    elif operator == ">":
                        # print(cond)
                        # print(value)
                        if cond > value:
                            bool_arr.append(1)
                            status = "PASS"
                            # print(status)
                        else:
                            bool_arr.append(0)
                            status = "FAIL"
                            # print(status)
                    elif operator == "<":
                        # print("cond="+ cond +"value=" + value)
                        if cond < value:
                            bool_arr.append(1)
                            status = "PASS"
                        else:
                            bool_arr.append(0)
                            status = "FAIL"
                    elif operator == "!=" and value != "":
                        # print("cond="+ cond +"value=" + value)
                        if cond != value:
                            bool_arr.append(1)
                            status = "PASS"
                        else:
                            bool_arr.append(0)
                            status = "FAIL"
                # cmd_file.close()
                # print(bool_arr)
                i = 1
                if i in bool_arr:
                    # print(site_id + "," + cell + "," + status + "\n")
                    execution_file.write(f"{site_id},{cell},{status}\n")
    execution_file.close()
    scriptlog_file.close()

    with open(CANDIDATES) as fp:
        lines = len(fp.readlines())
        if lines > 1:
            print("\nMatches Found\nOutput_file:" + CANDIDATES)
        else:
            print("No matches Found\n")


databricks_connector()
sites_hash = nested_dict(3, str)
parse_data()
condition_check()

# test_string = "53_AirMacULByteCnt_count_SUM - 53_AirMacULThruAvg_Kbps_AVG != 2"
# cond_counters = re.findall(r'\b\S+\b', line)
# condArr = [x for x in cond_counters if not (x.isdigit()
#                                       or x[0] == '-' and x[1:].isdigit())]
# print(condArr)

# print((lambda x, y: x+y > 0)(4, 5))
# print((lambda 53_AirMacULByteCnt_count_SUM, 53_AirMacULThruAvg_Kbps_AVG: line)(sites_hash[site_id][cell][cond_arr[0]], sites_hash[site_id][cell][cond_arr[1]]))

