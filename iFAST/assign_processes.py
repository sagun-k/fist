#!/usr/bin/python3
###################################################################################
# Author: SHRUTISAGAR M K
# Purpose: To release ports if held and run SSH commands in parallel
# DOI: 18-07-2024
###################################################################################
import warnings
warnings.filterwarnings("ignore", category=UserWarning, module='cryptography')
warnings.filterwarnings("ignore", category=UserWarning, module='paramiko')
warnings.filterwarnings("ignore", category=DeprecationWarning)
import socket
import paramiko
import multiprocessing
import logging
import time
import subprocess
import os

info_logger = logging.getLogger('info_logger')
info_logger.setLevel(logging.INFO)
info_handler = logging.FileHandler('/home/sieluser/myflaskapp/Logs/multi_socket_info.log')
info_handler.setFormatter(logging.Formatter('%(asctime)s - %(levelname)s - %(message)s'))
info_logger.addHandler(info_handler)

debug_logger = logging.getLogger('debug_logger')
debug_logger.setLevel(logging.DEBUG)
debug_handler = logging.FileHandler('/home/sieluser/myflaskapp/Logs/multi_socket_debug.log')
debug_handler.setFormatter(logging.Formatter('%(asctime)s - %(levelname)s - %(message)s'))
debug_logger.addHandler(debug_handler)

for handler in logging.root.handlers[:]:
    logging.root.removeHandler(handler)

ssh_configurations = {
    8002: {"host": "10.100.1.159", "username": "sieluser", "password": "Tools@123", "command": f"/home/sieluser/myflaskapp/scripts/get_hostname.py buildrut 10.100.1.159 8002"},
    8003: {"host": "10.100.1.159", "username": "sieluser", "password": "Tools@123", "command": f"/home/sieluser/myflaskapp/scripts/get_hostname.py buildrut1 10.100.1.159 8003"},
    8004: {"host": "10.100.1.159", "username": "sieluser", "password": "Tools@123", "command": f"/home/sieluser/myflaskapp/scripts/get_hostname.py buildrut 10.100.1.132213 8004"},
    8006: {"host": "10.100.1.159", "username": "sieluser", "password": "Tools@123", "command": f"/home/sieluser/myflaskapp/scripts/get_hostname.py buildrut 10.100.1.159 8006"},
    8007: {"host": "10.100.1.159", "username": "sieluser", "password": "Tools@123", "command": f"/home/sieluser/myflaskapp/scripts/get_hostname.py buildrut 10.100.1.159 8007"}
}

def execute_command_via_ssh(config, command):
    ssh_client = paramiko.SSHClient()
    ssh_client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    try:
        ssh_client.connect(hostname=config["host"], username=config["username"], password=config["password"])
        stdin, stdout, stderr = ssh_client.exec_command(command)
        output = stdout.read().decode()
        error = stderr.read().decode()
        ssh_client.close()
        if error:
            return f"Error: {error}"
        return output
    except Exception as e:
        debug_logger.error(f"SSH connection error: {e}")
        return f"SSH connection error: {e}"


def connect_to_socket(port):
    server_address = ('localhost', port)
    client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    client_socket.connect(server_address)

    try:
        message = f"Executing command on port {port}"
        client_socket.sendall(message.encode())

        response = client_socket.recv(1024)
        info_logger.info(f"Response from server on port {port}: {response.decode()}")

        config = ssh_configurations.get(port)
        if config:
            ssh_output = execute_command_via_ssh(config, config['command'])
            info_logger.info(f"SSH output for port {port}: {ssh_output}")

    except Exception as e:
        debug_logger.error(f"Error communicating with server on port {port}: {e}")
    finally:
        client_socket.close()


if __name__ == "__main__":
    ports = [8002, 8003, 8004, 8006, 8007]

    processes = []
    for port in ports:
        p = multiprocessing.Process(target=connect_to_socket, args=(port,))
        p.start()
        processes.append(p)
    for p in processes:
        p.join()

