#!/usr/bin/python3
import socket
import time

server_address = '127.0.0.1'
server_port = 6789

print(f"Connecting to {server_address} on port {server_port}")
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

try:
    sock.connect((server_address, server_port))
    print("Connected to server")
    
    commands = ["pwd","ls"]
    for command in commands:
        print(f"Sending command: {command}")
        sock.sendall(command.encode())
        time.sleep(1)  
        response = sock.recv(4096).decode()
        print(f"Response: {response}")
    
    print("Closing connection")
    sock.close()
except socket.error as e:
    print(f"Socket error: {e}")
finally:
    sock.close()

