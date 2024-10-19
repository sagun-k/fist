#!/usr/bin/python3
import threading
import sys
import subprocess
import multiprocessing
import re
import pexpect
from functools import partial
from contextlib import contextmanager
import time

#USER = sys.argv[1]
#PASS = sys.argv[2]
#SITE_LIST = sys.argv[3]
#CMD_STR = sys.argv[4]
#PID = sys.argv[5]
global cli_script
cli_script = 'path/to/cli_script'

USER = "venpr8r"
PASS = "90327463"
CMD_STR = "gah NE_ID,vendgrp"

SITE_LIST = 'eNB_131307,eNB_135571,eNB_250743,eNB_59209,eNB_73321,eNB_136668'
PID = "21_2"

def split_sites(str_value):
    values = str_value.split(',')
    sep = [[] for _ in range(3)]
    for i in range(len(values)):
        sep[i % 3].append(values[i])

    return sep


@contextmanager
def poolcontext(*args, **kwargs):
    pool = multiprocessing.Pool(*args, **kwargs)
    yield pool
    pool.terminate()


def process():
    site_split = split_sites(SITE_LIST)
    
    with poolcontext(processes=3) as pool:
        # results = pool.map(partial(run_cli_script, [['eNB_131307', 'eNB_59209', '100'], ['eNB_135571', 'eNB_73321'],['eNB_250743', 'eNB_136668']]), pid, cmd_args, issues_id)
        #results = pool.map(partial(run_cli_script, site_split), USER, PASS, CMD_STR, PID)
        results = partial(run_cli_script,USER, PASS, CMD_STR, PID)
        pool.map(results,site_split)
    end = time.perf_counter()


def run_cli_script(duo_id, pswd, cmd_args, pid,site_pods):
       site_arg = ",".join(site_pods)
       site_arg = '"'+ site_arg +'"'
       output = subprocess.run(['bash', '/home/sieluser/myflaskapp/scripts/cli_exec.sh', duo_id, pswd, site_arg, cmd_args, pid],
                            stdout=subprocess.PIPE,
                            stderr=subprocess.PIPE)
       output = output.stdout.decode('utf-8')
       print(output)

#process("venpr8r", "90327463", "eNB_131307,eNB_135571,eNB_250743,eNB_59209,eNB_73321,eNB_136668,100", "gah NE_ID,HNRTNYCRLSM", "21_2")
process()
