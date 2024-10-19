#!/usr/bin/python3
import sys
import subprocess
import time

if len(sys.argv) < 3:
   print("WRONG ARGS")
   print(f"Right usage : {sys.argv[0]} <IP> <PID>")
   sys.exit()

ip_addr = sys.argv[1]
pid = sys.argv[2]


ping_result = subprocess.run(["ping", "-c", "3", f"{ip_addr}"], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
if ping_result.returncode == 0:
   print(f"{ip_addr} worked proceed to step4 from pid {pid}")
   time.sleep(1)
else:
   print(f"{ip_addr} is not reachable proceed no from process {pid}")
