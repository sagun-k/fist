#!/usr/bin/python3

import socket
import pexpect
import select

main_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
main_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
main_socket.bind(('0.0.0.0', 6789))
main_socket.listen(5)
print("Waiting on 6789")

main_socket.setblocking(False)
print("Now waiting for user input")

clients = []

while True:
    ready_to_read, _, _ = select.select([main_socket] + clients, [], [], 0.1)
    for sock in ready_to_read:
        if sock == main_socket:
            new_sock, _ = main_socket.accept()
            new_sock.setblocking(False)
            clients.append(new_sock)
            print("New client connected")
        else:
            try:
                buf = sock.recv(1024).decode().strip()
                if buf:
                    print(f"\nGot from user: {buf}")
                    exp.sendline(buf)
                    exp.expect(prompt)
                    recv_buffer = exp.before.decode() + exp.after.decode()
                    print(f"\nGot from USM: {recv_buffer}")
                    sock.sendall(recv_buffer.encode())
                else:
                    print("Closing client connection")
                    clients.remove(sock)
                    sock.close()
            except socket.error as e:
                print(f"Socket error: {e}")
                clients.remove(sock)
                sock.close()
            except pexpect.exceptions.ExceptionPexpect as e:
                print(f"pexpect error: {e}")
                clients.remove(sock)
                sock.close()

