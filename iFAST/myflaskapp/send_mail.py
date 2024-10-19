#########################################################################################################
#
#    Author: Shrutisagar M Kulkarni
#
#    Script: send_email.py
#
#   Purpose: To sendout email of reports generated for ifast Executions
#
#       DOC: 09-Feb-2024
#########################################################################################################
import telnetlib
import time
import base64
import os

class TelnetMailer:
    def __init__(self, host, port):
        self.host = host
        self.port = port
        self.tn = None

    def connect(self):
        try:
            self.tn = telnetlib.Telnet(self.host, self.port)
        except Exception as e:
            print(f"An error occurred while connecting: {str(e)}")

    def close(self):
        if self.tn:
            self.tn.close()

    def send_telnet_command(self, command):
        try:
            if self.tn:
                self.tn.write(command.encode('utf-8') + b"\r\n")
                time.sleep(0.5)  # Increased sleep time
        except Exception as e:
            print(f"An error occurred during command execution: {str(e)}")

    def create_mail(self, recipients, issue_id,attachment_path=None):
        if self.tn:
            if len(recipients) > 1:
                dearval = "".join(recipients)
            else:				
                dearval = "/".join(recipients)
            body = f"Dear All,\n\n"
            body += f"Please find the  executed script log for issue number {issue_id}\n"
            body += f"\n\nRegards,\n"
            body += f"PS : This is an automated report, please dont reply to this email."
			   
            self.send_telnet_command("HELO east.nss.vzwnet.com")
            self.send_telnet_command("MAIL FROM: <report@ntpcadmin.com>")
            for recipient in recipients:
                rcpt_to_command = f"RCPT TO: <{recipient}>"
                self.send_telnet_command(rcpt_to_command)
            self.send_telnet_command("DATA")
            self.send_telnet_command(f"Subject: iFAST Automated Script execution log for issue number {issue_id}")
            self.send_telnet_command("MIME-Version: 1.0")
            self.send_telnet_command("Content-Type: multipart/mixed; boundary=boundary1")
            self.send_telnet_command("")
            self.send_telnet_command("--boundary1")
            self.send_telnet_command("Content-Type: text/plain; charset=UTF-8")
            self.send_telnet_command("")
            self.send_telnet_command(body)
			
			
            if attachment_path:
                with open(attachment_path, 'rb') as file:
                    attachment_data = file.read()
                encoded_attachment = base64.b64encode(attachment_data).decode('utf-8')
                attachment_filename = os.path.basename(attachment_path)
                self.send_telnet_command("--boundary1")
                self.send_telnet_command("Content-Type: application/octet-stream")
                self.send_telnet_command(f"Content-Disposition: attachment; filename={attachment_filename}")
                self.send_telnet_command("Content-Transfer-Encoding: base64")
                self.send_telnet_command("")
                self.send_telnet_command(encoded_attachment)
				
            self.send_telnet_command("--boundary1--")
            self.send_telnet_command(".")
            self.send_telnet_command("QUIT")
