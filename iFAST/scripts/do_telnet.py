#!/usr/bin/python3
import sys
import pexpect
import subprocess
import time

if len(sys.argv) < 3:
   print("WRONG ARGS")
   print(f"Right usage : {sys.argv[0]} <IP> <PID>")
   sys.exit()

ip_addr = sys.argv[1]
pid = sys.argv[2]


port = 22

# Start the telnet session
telnet_session = pexpect.spawn(f'telnet {ip_addr} {port}')

try:
    index = telnet_session.expect(['Escape character is \'\^\]\'.', pexpect.EOF, pexpect.TIMEOUT])

    if index == 0:
        status = telnet_session.before.decode('utf-8')
        if "Connected" in status:
          print(f"Proceed to step5!!got from process {pid}") 
          time.sleep(1)
    elif index == 1:
        status = telnet_session.before.decode('utf-8')
        if "Name or service not known" in status:
            print("proceed no from process {pid}")
        else:
            print(status)
    elif index == 2:
        print("Telnet command timed out")
        
except pexpect.exceptions.ExceptionPexpect as e:
    print(f"Exiting due to {e}")

finally:
    telnet_session.close()

