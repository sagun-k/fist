#!/usr/bin/python3
import warnings
warnings.filterwarnings("ignore", category=UserWarning, module='cryptography')
warnings.filterwarnings("ignore", category=UserWarning, module='paramiko')
warnings.filterwarnings("ignore", category=DeprecationWarning)
from paramiko import SSHClient,AutoAddPolicy,SSHException
target_host = "10.100.1.79"
target_port = 22
target_login = "toolsuser"
target_password = "Tools@123"

target_client = SSHClient()
target_client.set_missing_host_key_policy(AutoAddPolicy())
target_client.connect(target_host, target_port, target_login, target_password)
print(f"SSH connection established successfully to target server:{target_host}")
command =  'bash /opt/vz_raw_data/Scripts/Test/iFAST_OM_Executer/om_exec.sh "NR_PRACH_BEAM| RachPreambleAPerBeam,RachPreambleACFRAPerBeam,NumMSG3PerBeam,NumMSG3CFRAPerBeam\nCU-CSL| CauseInternalRandomAccessProblem" "RachPreambleAPerBeam+RachPreambleACFRAPerBeam,=,0\nNumMSG3PerBeam+NumMSG3CFRAPerBeam,=,0\nCauseInternalRandomAccessProblem,!=,0\n#proceed,No" "24593002050_5GDU_CATAWBA_SOUTH-CLMB,24593002373_5GDU_MERCHANTS_LANDING-CLMB,24593003029_5GDU_FOSTORIA-CLMB" "21_1"'
stdin, stdout, stderr = target_client.exec_command(command, timeout=160)
print(f"{stdout.read().decode('utf-8')}")
