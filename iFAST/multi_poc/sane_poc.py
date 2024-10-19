#!/usr/bin/python2.7
##################################################################
#SHRUTISAGAR
#LSMR_CONN
#####################################################################
import socket
import select
import pexpect
import sys

sane_server = '198.226.62.123'
login = 'ravixxx'
passcode = '08642086'
timeout = 60
prompt = "HNRTNYCRLSM-MS02:"

command = "ssh -o ProxyJump=toolsuser@10.100.1.79 {}@{}".format(login,sane_server)
print(command)

# Initialize the Expect process
exp = pexpect.spawn(command, timeout=timeout)
print(exp)
exp.expect([
    r'Are you sure you want to continue connecting', 
    r'passcode:', 
    r'Please Enter Selection: >', 
    pexpect.TIMEOUT
])

print('prompt')
# Handle SSH key confirmation and password prompt
if exp.match_index == 0:
    exp.sendline('yes')
    exp.expect(r'passcode:')
if exp.match_index == 1:
    exp.sendline(passcode)
    exp.expect(r'Please Enter Selection: >')
    
print('send commands')
# Send commands sequentially as in the Perl script
commands = ["5","583713"]
for cmd in commands:
    exp.sendline(cmd)
    exp.expect(r'Please Enter Selection: >')

exp.expect(prompt)
print(exp.expect(prompt))

# Set up the main socket to listen for connections
main_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
main_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
main_socket.bind(('0.0.0.0', 6789))
main_socket.listen(5)
print("Waiting on 6789")

main_socket.setblocking(False)
clients = []

print("Now waiting for user input")

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
                    print("\nGot from user: {buf}")
                    exp.sendline(buf)
                    exp.expect(prompt)
                    recv_buffer = exp.before.decode() + exp.after.decode()
                    print("\nGot from USM: {recv_buffer}")
                    sock.sendall(recv_buffer.encode())
                else:
                    print("Closing client connection")
                    clients.remove(sock)
                    sock.close()
            except socket.error as e:
                print("Socket error: {e}")
                clients.remove(sock)
                sock.close()
            except pexpect.exceptions.ExceptionPexpect as e:
                print("pexpect error: {e}")
                clients.remove(sock)
                sock.close()

