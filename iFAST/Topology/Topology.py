import os
import pandas as pd
from datetime import datetime
import glob
import paramiko
import time
import pymysql
import re
import numpy as np

# Topology Files Storage
pwd = "/home/sieluser/Topology/"

today_dir = datetime.now().strftime("%Y%m%d")

###### iFast DB Details   ###########
# IP address of the MySQL database server
Host = "127.0.0.1"
# Username and PW of the database server
User = "admin"; Password = "@DBadmin123"
# Connection to the server
conn = pymysql.connect(host=Host, user=User, password=Password, database="iFAST")
print("Connection established to iFast Server")
#conn = pymysql.connect(host=Host, user=User, password=Password, database="testdb_flagged")
# Create a cursor object
cur = conn.cursor()

#=================================================================================#

###############   Sub Market Dictionary  #############

sub_mkt_dict = {'CTX': ['131', '132', '133', '134', '135', '136', '137', '138', '139', '140', '184'],
            'NYM': ['78', '79', '80', '81', '82', '83', '84', '85', '378', '380', '384', '528', '780', '789', '790', '799', '800', '809', '810', '819', '820', '829', '840', '849', '850', '859', '878'],
            'TRI': ['86', '87', '88', '89', '90', '91', '96', '97', '98', '99', '100', '101', '102'],
            'HGC': ['120', '121', '122', '123', '124', '125', '126', '127', '129', '420', '421', '426', '427'],
            'SOC': ['180', '181', '182', '185', '186', '781', '782', '785'],
            'OPW': ['229', '232', '241', '242', '243', '244', '245', '246', '247', '250', '251', '252', '253', '254', '255', '553', '545', '546', '550'],
            'WBV': ['106', '107', '109', '110', '111', '112', '113', '114', '115', '116', '117', '406', '407', '409', '411', '412', '413', '414', '416', '417', '713', '715'],
            'NE': ['56', '57', '58', '59', '60', '61', '62', '64', '65', '66', '68'],
            'UPNY': ['70', '71', '72', '73', '74'],
            'SACR': ['31', '36'],
            'GAAL': ['170', '172', '173', '174'], 
            'ILWI': ['202'],  
            'SCAL': ['47']}

def def_market(x):
    try:
       return [k for k,v in sub_mkt_dict.items() if x in v][0]
    except IndexError:
        return None
    
#=================================================================================#

def mk_dir():
    os.chdir(pwd)
    if not today_dir in os.listdir():
        os.mkdir(today_dir)
    else:
        files = glob.glob(f'{pwd}/{today_dir}/*')
        for f in files:
            os.remove(f)
    print(f"New directory {today_dir} created")

def ssh_gather(cmd_to_execute):
    client = paramiko.SSHClient()
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    # Connect to the source server
    client.connect(hostname='10.100.1.79', username='a.ravindranath', password='P@ssword1')
    # Exceute the command
    client.exec_command(cmd_to_execute)
    time.sleep(10)
    client.close()

def transfer_topology_files():
    topology_folder = f"/opt/vz_raw_data/INVT/{today_dir}"
    command = f'sshpass -p "Tools@123" scp {topology_folder}/*-topology.csv sieluser@10.100.1.159:{pwd}{today_dir}'
    ssh_gather(command)
    print("Topolgy files copied from Gather server")

def concat_csv(topology_dir):
    final_df_list = []
    for f in glob.glob(f'{topology_dir}/*'):
        try:
            df = pd.read_csv(f, dtype=str, sep = "\t")
            df['USM'] = f.split("/")[-1].replace("-topology.csv", "")
            final_df_list.append(df)
        except:
            print(f"Unable to read {topology_dir}/{f}")
    df_final = pd.concat(final_df_list, ignore_index=True)
    df_final['NE_NAME'] = df_final['NE_NAME'].apply(lambda x: x.strip("\\t"))
    return df_final

def sub_mrkt(ne_type,ne_id):
    if ne_type == "gnb_cu_cp":
        return str(int(ne_id.zfill(9)[:3]))
    elif ne_type == "gnb_du_cnf":
        return str(int(ne_id.zfill(11)[:3]))
    elif ne_type == "gnb_cu_up":
        return str(int(ne_id.zfill(9)[:3]))
    elif ne_type == "gnb_au":
        return str(int(ne_id.zfill(11)[:3]))
    elif ne_type == "gnb_au_sc":
        return str(int(ne_id.zfill(11)[:3]))
    elif ne_type == "c_fsu":
        return str(int(ne_id.zfill(9)[:3]))
    elif ne_type == "macro_indoor_dist":
        return str(int(ne_id.zfill(6)[:3]))
    elif ne_type == "udu_cnf":
        return str(int(ne_id.zfill(11)[:3]))
    elif ne_type == "vhac":
        return str(int(ne_id.zfill(9)[:3]))
    else:
        return None

def valuecounts(df, col1, col2):
    vc =df[col1].value_counts()
    return df.loc[df[col1].isin(vc[vc>1].index)].groupby(col1)[col2].apply(lambda x: list(x))

def group_col(df, col_list):
    vc = df.groupby(col_list).size()
    vc = vc[vc>1]
    df1 = df.set_index(col_list, drop=True)
    return df1.loc[vc]

def main():
    mk_dir()
    transfer_topology_files()
    df_topology = concat_csv(f'{pwd}{today_dir}')
    df_topology['ne-id'] = df_topology['NE_ID'].apply(lambda x: re.search(r"\d+",x).group())
    df_topology['Market'] = df_topology.apply(lambda x: sub_mrkt(x['NE_TYPE'], x['ne-id']), axis=1)
    df_topology.loc[df_topology['Market']=='0', 'ne-id'] = df_topology.loc[df_topology['Market']=='0', 'NE_NAME'].apply(lambda x: re.search(r"(\d+)_?",x).group(1))
    df_topology['Market'] = df_topology.apply(lambda x: sub_mrkt(x['NE_TYPE'], x['ne-id']), axis=1)
    df_topology['Region'] = df_topology['Market'].apply(lambda x: def_market(x))
    df_topology.drop(['ne-id'], axis=1, inplace=True)
    df_topology['Modified_Time'] = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    df_topology.fillna("", inplace=True)
    print("\n")
    print("The following table displays the elements with more than one entry in the combined toplogy files")
    print(valuecounts(df_topology, "NE_NAME", "USM"))
    print("====================================")
    print("\n")
    df_dups = group_col(df_topology, ["NE_ID", "USM"])
    print("The following table displays the elements with more than one entry (NE_ID + USM) in the combined toplogy files")
    print(df_dups)
    print("\n")
    df_topology = df_topology.drop_duplicates(subset = ["NE_ID", "USM"])
    df_topology.replace([np.nan], [None])
    df_topology.to_csv(f"{pwd}Combined_Topology_Files/Combined_Topology_{today_dir}.csv", index=False)
    print("Combined Topolgy file created")
    
    #########   Reading Database  ########
    df_db = pd.read_sql_query("SELECT * FROM iFAST.network_topology", conn)
    
    common_usms = set(df_db['USM']).intersection(df_topology['USM'])
    add_usms = set(df_topology['USM'])-set(df_db['USM'])
    old_usms = set(df_db['USM'])-set(df_topology['USM'])
    
    ##########   Updating Database with common usms between new and old data ############
    print(f"Updating data beloging to {common_usms}")
    print("\n")
    print(f"Deleting {common_usms} from network_topology table")
    usm_del_query = f"DELETE FROM iFAST.network_topology WHERE USM in ({str(tuple(common_usms))[1:-1]})"
    cur.execute(usm_del_query)
    conn.commit()
    print(f"\nUpdating network_topology table with {common_usms} data")
    write_query = (f'INSERT IGNORE INTO iFAST.network_topology VALUES ({("%s,"*len(df_topology.loc[df_topology["USM"].isin(common_usms)].columns)).rstrip(",")})')
    cur.executemany(write_query, df_topology.loc[df_topology['USM'].isin(common_usms)].values.tolist())
    conn.commit()
    #######    Updating Database with new usms from new data ############
    print("\n")
    print(f"{add_usms} not available in old data; adding new data")
    write_query = (f'INSERT IGNORE INTO iFAST.network_topology VALUES ({("%s,"*len(df_topology.loc[df_topology["USM"].isin(add_usms)].columns)).rstrip(",")})')
    cur.executemany(write_query, df_topology.loc[df_topology['USM'].isin(add_usms)].values.tolist())
    conn.commit()  
    
    print(f"\n{old_usms} data untouched")     
    print("iFast network_topology table updated with latest data")
    print("-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*")
    print("\n")
    conn.close()

main()


