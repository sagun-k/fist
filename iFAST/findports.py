#!/usr/bin/env python3
import socket

def find_available_ports(start_port, end_port, required_ports=5):
    available_ports = []
    for port in range(start_port, end_port + 1):
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            s.settimeout(1)
            result = s.connect_ex(('localhost', port))
            if result != 0:
                available_ports.append(port)
                if len(available_ports) == required_ports:
                    break
    return available_ports

if __name__ == "__main__":
    start_port = 8001
    end_port = 8010  # Adjust this range as needed
    required_ports = 5
    available_ports = find_available_ports(start_port, end_port, required_ports)
    
    if len(available_ports) < required_ports:
        print(f"Warning: Only {len(available_ports)} available ports found.")
    
    print("Available ports:", available_ports)

