#!/usr/bin/python3

import paramiko
import socket
import selectors
import pexpect
import time

# Configuration
jumplogin='toolsuser'
jumpserver='10.100.1.79'
sane_server = '198.226.62.6'
login = 'saibh'
password = '90327463'
timeout = 30
prompt = 'sftp>'


# Initialize the server socket
server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
server_socket.bind(('0.0.0.0', 8002))
server_socket.listen(5)
print("Waiting on 6789")

# Selector for handling multiple sockets
selector = selectors.DefaultSelector()
selector.register(server_socket, selectors.EVENT_READ, data=None)


### USER BASED INPUT
"""
def handle_ssh_interaction():
    command = f"ssh-o ProxyJump=toolsuser@10.100.1.79 "
    print(f"Executing command: {command}")  # Debug print
    exp = pexpect.spawn(command)
    try:
        initial_output = exp.before.decode('utf-8') if exp.before else ''
        if exp.match is not None:
           initial_output += exp.match.decode('utf-8') if exp.match else ''
        print(f"Initial output: {initial_output.strip()}")
        index = exp.expect(['Are you sure you want to continue connecting', 'Password:', pexpect.TIMEOUT, pexpect.EOF])
        if index == 0:
            print("Server's authenticity could not be established. Accepting the host key.")
            exp.sendline("yes")
            exp.expect("Password:")
        elif index == 1:
            print("Password prompt received.")
        elif index == 2:
            print("Connection timeout. Check server status or command syntax.")
            exp.close()
            return None
        elif index == 3:
            print("End of file reached. Check command syntax or server availability.")
            exp.close()
            return None
        
        exp.sendline(jumppassword)
#        exp.expect("assword:")
#        exp.sendline(password)
#        exp.expect(prompt)
        print(f"Connected successfully. Prompt received: {prompt}")

        return exp
    except pexpect.exceptions.TIMEOUT:
        print("Timeout occurred during SSH interaction.")
    except pexpect.exceptions.EOF:
        print("End of file occurred during SSH interaction.")
    except Exception as e:
        print(f"Exception occurred: {e}")
    
    return None
"""

def handle_ssh_interaction():
    command = f"ssh -o ProxyJump=toolsuser@10.100.1.79"
    print(f"Executing command: {command}")  # Debug print
    exp = pexpect.spawn(command)
    try:
        initial_output = (exp.before or b'').decode('utf-8')
        if exp.match:
            initial_output += (exp.match or b'').decode('utf-8')
        print(f"Initial output: {initial_output.strip()}")
        
        index = exp.expect(['Are you sure you want to continue connecting', 'Password:', pexpect.TIMEOUT, pexpect.EOF])
        if index == 0:
            print("Server's authenticity could not be established. Accepting the host key.")
            exp.sendline("yes")
            exp.expect("Password:")
        elif index == 1:
            print("Password prompt received.")
        elif index == 2:
            print("Connection timeout. Check server status or command syntax.")
            exp.close()
            return None
        elif index == 3:
            print("End of file reached. Check command syntax or server availability.")
            exp.close()
            return None

        exp.sendline(jumppassword)
#        exp.expect("assword:")
#        exp.sendline(password)
#        exp.expect(prompt)
        print(f"Connected successfully. Prompt received: {prompt}")

        return exp
    except pexpect.exceptions.TIMEOUT:
        print("Timeout occurred during SSH interaction.")
    except pexpect.exceptions.EOF:
        print("End of file occurred during SSH interaction.")
    except Exception as e:
        print(f"Exception occurred: {e}")

    return None




ssh_session = handle_ssh_interaction()
if ssh_session:
    print("Now waiting for user input")

    while True:
        events = selector.select(timeout=0.1)
        for key, _ in events:
            if key.data is None:
                # Handle new client connection
                client_socket, addr = key.fileobj.accept()
                print(f"Accepted connection from {addr}")
                client_socket.setblocking(False)
                selector.register(client_socket, selectors.EVENT_READ, data=client_socket)
            else:
                # Handle client data
                client_socket = key.data
                try:
                    data = client_socket.recv(1024).decode('utf-8')
                    if data:
                        print(f"\nGot from user: {data.strip()}")
                        ssh_session.sendline(data.strip())
                        ssh_session.expect(prompt, timeout=timeout)
                        recv_buffer = ssh_session.before.decode('utf-8') + ssh_session.match.decode('utf-8') + ssh_session.after.decode('utf-8')
                        print(f"\nGot from USM: {recv_buffer.strip()}")
                        client_socket.sendall(recv_buffer.encode('utf-8'))
                    else:
                        print("Closing client connection")
                        selector.unregister(client_socket)
                        client_socket.close()
                except Exception as e:
                    print(f"Exception occurred: {e}")
                    selector.unregister(client_socket)
                    client_socket.close()
else:
    print("Failed to establish SSH session.")
