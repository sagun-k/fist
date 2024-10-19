#!/usr/bin/python3
import subprocess
import re
import sys
import time

if len(sys.argv) < 3:
    print("WRONG ARGS")
    print(f"Right usage : {sys.argv[0]} <IP> <PID>")
    sys.exit()

ip_addr = sys.argv[1]
pid = sys.argv[2]

try:
    # Run getip.sh
    subprocess.run(["bash", "/home/sieluser/myflaskapp/scripts/getip.sh"], check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    # Read the output from the temporary file
    with open("/tmp/getip_output.txt", "r") as file:
        proc = file.read()
except subprocess.CalledProcessError as e:
    print(f"Command failed with error {e.returncode}")
    sys.exit()
except FileNotFoundError as e:
    print("Temporary file not found")
    sys.exit()

# Extract IP addresses from the output
ip_addresses = re.findall(r'inet (?:addr:)?(\d+\.\d+\.\d+\.\d+)', proc)

non_local_ips = [ip for ip in ip_addresses if ip != '127.0.0.1']
if non_local_ips:
    if non_local_ips[0] and non_local_ips[0] == ip_addr:
        print(non_local_ips[0], f"found proceed to step3!! PID {pid}")
        time.sleep(1)
    else:
        print(f"Proceed no from PID {pid}")
        sys.exit()
else:
    print("no IPS found exiting")
    sys.exit()

