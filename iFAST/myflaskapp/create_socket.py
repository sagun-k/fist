#!/usr/bin/python3
###################################################################################
# Author: SHRUTISAGAR M K
# Purpose: To create multiple sockets to aid iFAST
# DOI: 18-07-2024
# Dependency: Please do not remove this as it runs from socket_server.service
###################################################################################
import socket
import sys
import signal
import logging
import multiprocessing

logging.basicConfig(filename='/home/sieluser/myflaskapp/socket_server.log', level=logging.INFO,
                    format='%(asctime)s - %(levelname)s - Port %(port)d - %(message)s')

def signal_handler(sig, frame):
    logging.info('Exiting gracefully...')
    sys.exit(0)

signal.signal(signal.SIGINT, signal_handler)

def run_server(port):
    server_address = ('localhost', port)
    server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server_socket.bind(server_address)
    server_socket.listen(5)
    logging.info(f"Server is listening on {server_address[0]}:{server_address[1]}")

    while True:
        client_socket = None
        try:
            client_socket, client_address = server_socket.accept()
            logging.info(f"Connection from {client_address}")

            while True:
                data = client_socket.recv(1024)
                if not data:
                    break

                response = "Message received: " + data.decode()

                client_socket.sendall(response.encode())

        except KeyboardInterrupt:
            logging.info("Server stopped by user.")
            break

        except socket.error as e:
            logging.error(f"Socket error occurred: {e}")

        except Exception as e:
            logging.error(f"Error handling connection: {e}")

        finally:
            if client_socket:
                client_socket.close()

    server_socket.close()

if __name__ == "__main__":
    ports = [8002, 8003, 8004, 8006, 8007]

    processes = []
    for port in ports:
        try:
            logging.info(f"Starting server on port {port}")
            process = multiprocessing.Process(target=run_server, args=(port,))
            processes.append(process)
            process.start()
        except Exception as e:
            logging.error(f"Server on port {port} crashed: {e}")

    for process in processes:
        process.join()

