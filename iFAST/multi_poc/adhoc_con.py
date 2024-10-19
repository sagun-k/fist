#!/usr/bin/python3
################################
#SHRUTISAGAR
################################
import paramiko

def handle_sftp_interaction():
    try:
        jump_host = '10.100.1.79'
        jump_user = 'toolsuser'
        jump_password = 'Tools@123'
        
        jump_transport = paramiko.Transport((jump_host, 22))
        jump_transport.connect(username=jump_user, password=jump_password)
        print("Connected to jump host.")

        jump_client = paramiko.SSHClient()
        jump_client._transport = jump_transport

        target_host = '198.226.62.123'
        target_user = 'saibh'
        target_password = '90327463'

        jump_channel = jump_client.get_transport().open_channel(
            'direct-tcpip', (target_host, 22), ('', 0)
        )

        target_client = paramiko.SSHClient()
        target_client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        target_client.connect(target_host, username=target_user, password=target_password, sock=jump_channel)
        print("Connected to target server via jump host.")

        sftp = target_client.open_sftp()
        print("SFTP session established.")

        file_list = sftp.listdir('.')
        print(f"Files: {file_list}")

        # Close the SFTP session
        sftp.close()
        target_client.close()
        jump_client.close()
        print("SFTP session and jump host connection closed.")

    except paramiko.AuthenticationException:
        print("Authentication failed.")
    except paramiko.SSHException as e:
        print(f"SSH error: {e}")
    except Exception as e:
        print(f"Exception occurred: {e}")

handle_sftp_interaction()

