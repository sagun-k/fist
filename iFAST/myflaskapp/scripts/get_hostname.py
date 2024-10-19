#!/usr/bin/python3
import socket
import sys
import subprocess
import os
import time


if len(sys.argv) < 4:
   print("WRONG ARGS")
   print(f"Right usage : {sys.argv[0]} <HOSTNAME> <IP> <PID>")
   sys.exit()
hostname = socket.gethostname()
ip_addr = sys.argv[2]
pid = sys.argv[3]

if hostname == sys.argv[1]:
   print(f"Proceed to step 2 from process number {pid}")
   time.sleep(1)
else:
   print("Proceed no. Exiting")
   sys.exit()


