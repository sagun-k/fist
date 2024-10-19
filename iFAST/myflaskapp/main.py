import io
import time
from math import ceil
import json
# import MySQLdb
from flask import Flask, request, render_template, redirect, session, url_for, flash, send_file, jsonify, Response
from openpyxl import Workbook
from Database import Database
import paramiko
import os
import tempfile
from paramiko import SSHClient,AutoAddPolicy,SSHException
from flask_paginate import Pagination, get_page_args
import datetime
from flask_socketio import SocketIO
import pandas as pd
from io import StringIO

APP_VERSION = "v1"
app = Flask(__name__)
app.config['DEBUG'] = True
app.secret_key = 'asdsdfsdfs13sdf_df%&'

app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = 'admin'
app.config['MYSQL_DB'] = 'iFAST'
app.config['SESSION_COOKIE_EXPIRES'] = False
app.config['UPLOAD_FOLDER'] = "/static/execution_log/"
db = Database(app)
socketio = SocketIO(app)
# Placeholder function for your actual logic to fetch next set of records


@app.route("/")
def index():
    role=None
    if 'role' in session:
        role = session['role']
    return render_template("new_index.html",roles=role)

@app.route("/adduser", methods=['POST','GET'])
def adduser():
    if request.method == 'POST':
        knoxid = request.form.get('knoxid')
        fullname = request.form.get('fname')
        email = request.form.get('email')
        team = request.form.get('team')
        status = request.form.get('status')
        role = request.form.get('role')
        print(request.form)
        query = "insert into user(knox_id,password,fullname,email,role,team,status,mode) values (%s,md5(%s),%s,%s,%s,%s,%s,%s)"
        values=(knoxid,"temp",fullname,email,role,team,status,"view",)
        print(values)
        db.execute_query(query,params=values,commit=True)
        response = {'suc': 'User added successfully'}
        return jsonify(response)
    else:
        return jsonify({'err': 'Method not allowed'})


@app.route("/usermanagement",methods=['GET','POST'])
def usermanagement():
    query = 'select * from user'
    roles = ['admin','user']
    status = ['active','inactive']
    #acct = db.execute_query(query)
    user_tuples = db.execute_query(query)
    users = list(user_tuples)
    total_entries = len(users)
    entries_per_page = 5  # Assuming 5 entries per page
    total_pages = ceil(total_entries / entries_per_page)
    page_number = int(request.args.get('page', 1))

    return render_template("usermanagement.html",
                           roles=roles,users=users,
                           total_entries=total_entries,
                           total_pages=total_pages,
                           page_number=page_number,
                           status=status
                           )
   # return render_template("usermanagement.html",users=users)

@app.route("/deluser",methods=['GET','POST'])
def deluser():
    if request.method=="POST":
        user_id=request.form['user_id']
        query = "delete from user where user_id=%s"
        value=(user_id,)
        db.execute_query(query=query,params=value,commit=True)
    return jsonify({"suc":"User deleted successfully!!"})

@app.route("/login", methods=['GET', 'POST'])
def login():
    if request.args.get('inactive_modal') == "true":
        inactive_modal = "true"
    else:
        inactive_modal = "false"
    return render_template('new_index.html', inactive_modal=str(inactive_modal).lower())

@app.route('/landing_page',methods=['GET','POST'])
def landing_page():
    role=None
    if 'role' in session:
        role = session['role']
    return render_template("ifast_main.html")
    #return render_template("index.html",roles=role)

@app.route("/login_succ", methods=['POST', 'GET'])
def login_succ():
    if request.method == "POST":
        username = request.form.get('username')
        passwd = request.form.get('passwd')
        mode = request.form.get('mode')
        session['mode'] = mode
        query = 'select * from user where knox_id=%s and password=md5(%s)'
        values = (username, passwd)
        acct = db.execute_query(query, values)
        if acct:
            acct = dict(acct[0])
            session['user_name'] = username
            print(acct)
            if acct['status'] == 'active':
                session['user_name'] = username
                session['role'] = acct
                return redirect(url_for('landing_page'))
            else:
                return redirect(url_for('login', inactive_modal="true"))
        else:
            flash('Wrong Creds. If you do not have an account, please apply through JIRA.')
            return redirect(url_for('login'))
    elif request.method == "GET":
        # Handle GET requests by returning an appropriate response
        return "Method not allowed", 405

@app.route("/search", methods=['POST', 'GET'])
def search():
    return render_template('action.html')
class ExecutionError(Exception):
    def __init__(self, message):
        self.message = message

@app.route("/download_log/<path:filename>")
def download_log(filename):
    print("Root Path:", app.root_path)
    full_path = os.path.join(app.root_path, filename)

    return send_file(full_path,as_attachment=True)

@app.route("/view_log/<path:filename>")
def view_log(filename):
    print("Root Path:", app.root_path)
    full_path = os.path.join(app.root_path, filename)
    print("Full Path:", full_path)
    with open(full_path, 'r') as file:
        content = file.read()
    return Response(content, mimetype='text/plain')

@app.route("/sshconnect",methods=['GET','POST'])
def sshconnect():
    issue_id = request.form.get('issue_id')

    scname = request.form.get('scName')
    target_hostname = request.form.get('ip')
    target_username = request.form.get('uid')
    target_password = request.form.get('pwd')
    scPath = request.form.get('scPath')
    filename = request.form.get('file')
    act_type = request.form.get('action_type')
    args = request.form.get('regex')
    target_port = 22

    gateway_hostname = '105.57.243.148'
    gateway_port = 22
    gateway_username = 'sieluser'
    gateway_password = 'Tools@123'

    #target_hostname = '10.100.1.241'

    #target_username = 'toolsuser'

    remote_script_path = f'{scPath}/{scname}'

    try:
        # Create an SSH client for the gateway
        gateway_client = SSHClient()
        gateway_client.set_missing_host_key_policy(AutoAddPolicy())

        # Connect to the gateway
        gateway_client.connect(gateway_hostname, gateway_port, gateway_username, gateway_password)

        # Create an SSH tunnel to the target server through the gateway
        transport = gateway_client.get_transport()
        dest_addr = (target_hostname, target_port)
        local_addr = ('127.0.0.1', 0)  # Automatically select a free local port
        channel = transport.open_channel("direct-tcpip", dest_addr, local_addr)

        # Create an SSH client for the target server
        target_client = SSHClient()
        target_client.set_missing_host_key_policy(AutoAddPolicy())

        # Connect to the target server through the tunnel
        target_client.connect('127.0.0.1', target_port, target_username, "Tools@123", sock=channel)
        print("SSH connection established successfully to target server:", target_hostname)
        if act_type == "GET FILE":
            print("Inside GET")
            sftp = target_client.open_sftp()
            sftp.chdir(scPath)
            remote_file_path = scPath + "/" + filename
            local_file_path = os.path.join("static/execution_log", filename)
            print("Remote file path:", remote_file_path)
            print("Local file path:", local_file_path)
            sftp.get(remote_file_path, local_file_path)
            sftp.close()
            target_client.close()
            print("File downloaded successfully")
            output_file_path = local_file_path
            return jsonify({'log_url': f'{output_file_path}'})
        elif act_type == "GREP":
            _, stdout, stderr = target_client.exec_command(f'grep {args} {scPath + "/" +filename}')
        elif act_type == "RUN SCRIPT":
            _, stdout, stderr = target_client.exec_command(f'python3 {remote_script_path} 1 2 3 4')
            exit_status = stdout.channel.recv_exit_status()
            if "No such file" in stderr.read().decode('utf-8') and exit_status != 0:
                return jsonify({'error':'File Not Found error!!!'})
            if "FAILED" in stderr.read().decode('utf-8') and exit_status != 0:
                return jsonify({'error':'Execution error (Administratively prohibited)!!!'})
            # Get the output of the script
            script_output = stdout.read().decode('utf-8')
            output_directory = r'static/execution_log'
            if not os.path.exists(output_directory):
                os.makedirs(output_directory)
            listopt = []
            output_file_path = os.path.join(output_directory, 'script_output.txt')

            with tempfile.NamedTemporaryFile(delete=False, suffix='.txt', mode='w') as output_file:
                with open(output_file_path, 'w') as output_file:
                    output_file.write(script_output)
                    listopt.append(script_output)
            gateway_client.close()
            target_client.close()
            return jsonify({'success': f'Completed'})


    except ExecutionError as e:
        return jsonify({'error': e.message}), 500
    except SSHException as e:
        return jsonify({'error':  f'SSH Error: {e}'}), 500
    except FileNotFoundError as e:
        return jsonify({'error': f'File not found: {e}'}), 500
    except Exception as e:
        print("An error occurred:", str(e))
        return jsonify({'error': f'Generic Error: {e}'}), 500


def send_email(email_to, attachment, issue):
    #email_to = request.form.get('email_to')

    if "," in email_to:
        email_list = email_to.split(',')
    else:
        email_list = email_to
    #issue_id = request.form.get('issueId')
    gateway_hostname = '105.57.243.148'
    gateway_port = 22
    gateway_username = 'sieluser'
    gateway_password = 'Tools@123'
    target_server = '10.100.1.241'
    target_login = 'toolsuser'
    target_password = 'Tools@123'
    script_name = '/home/toolsuser/Scripts/iFAST/mail.py'
    target_port = 22
    try:
        gateway_client = SSHClient()
        gateway_client.set_missing_host_key_policy(AutoAddPolicy())
        gateway_client.connect(gateway_hostname, gateway_port, gateway_username, gateway_password)
        transport = gateway_client.get_transport()
        dest_addr = (target_server, target_port)
        local_addr = ('127.0.0.1', 0)
        channel = transport.open_channel("direct-tcpip", dest_addr, local_addr)
        target_client = SSHClient()
        target_client.set_missing_host_key_policy(AutoAddPolicy())
        target_client.connect('127.0.0.1', target_port, target_login, target_password, sock=channel)
        print("SSH connection established successfully to target server:", target_server)
        command = f"python3 {script_name} {email_list} {str('21')}"
        print(command)
        stdin, stdout, stderr = target_client.exec_command(command)
        script_output = stdout.read().decode('utf-8')
        error_output = stderr.read().decode('utf-8')

        if script_output:
            print(script_output)
        elif error_output:
            print(error_output)
        return 'Email sent successfully.'

    except Exception as e:
        print("Something went wrong ",e)
        return 'Something went wrong {e}'



@app.route("/send_exe_email", methods=['POST', 'GET'])
def send_exe_email():
    email_to = request.form.get('email_to')
    message = request.form.get('message')
    if "," in email_to:
        email_list = email_to.split(',')
    else:
        email_list = email_to
    issue_id = request.form.get('issueId')
    gateway_hostname = '105.57.243.148'
    gateway_port = 22
    gateway_username = 'sieluser'
    gateway_password = 'Tools@123'
    target_server = '10.100.1.241'
    target_login = 'toolsuser'
    target_password = 'Tools@123'
    script_name = '/home/toolsuser/Scripts/iFAST/mail.py'
    target_port = 22
    try:
        gateway_client = SSHClient()
        gateway_client.set_missing_host_key_policy(AutoAddPolicy())
        gateway_client.connect(gateway_hostname, gateway_port, gateway_username, gateway_password)
        transport = gateway_client.get_transport()
        dest_addr = (target_server, target_port)
        local_addr = ('127.0.0.1', 0)
        channel = transport.open_channel("direct-tcpip", dest_addr, local_addr)
        target_client = SSHClient()
        target_client.set_missing_host_key_policy(AutoAddPolicy())
        target_client.connect('127.0.0.1', target_port, target_login, target_password, sock=channel)
        print("SSH connection established successfully to target server:", target_server)
        command = f"python3 {script_name} {email_list} {str(issue_id)} {message}"
        print(command)
        stdin, stdout, stderr = target_client.exec_command(command)
        script_output = stdout.read().decode('utf-8')
        error_output = stderr.read().decode('utf-8')

        if script_output:
            print(script_output)
        elif error_output:
            print(error_output)
        return jsonify({'message':'Email sent successfully.'})

    except Exception as e:
        print("Something went wrong ",e)
        return jsonify({'error':f'Something went wrong {e}'})


@app.route("/execute_all", methods=['POST', 'GET'])
def execute_all():
    issue = request.form.get('issue_id')
    query = "SELECT total_steps FROM known_knowledge_base WHERE issue=%s"
    values = (issue,)
    cnt = db.execute_query(query, values)
    print(cnt)
    cnt = cnt[0]['total_steps']
    print(cnt)

    progress_updates = []
    for sequence_num in range(1, cnt + 1):
        if not db.execute_query("SELECT 1 FROM scripts WHERE issue_id = %s AND sequence_num = %s",
                                (issue, sequence_num), fetch_all=False):
            continue

        query = """
            SELECT kb.*, s.* 
            FROM known_knowledge_base kb 
            INNER JOIN scripts s ON kb.issue = s.issue_id AND s.sequence_num = %s 
            WHERE kb.issue = %s
        """
        res = db.execute_query(query, (sequence_num, issue))
        if not res:
            continue

        res = res[0]
        #email_to = res['email_to']
        action_type = res['action_type']
        script_name = res['script_name']
        target_server = res['Server_IP']
        target_login = res['server_Login']
        target_password = res['server_password']
        condition = res['check_condition']
        proceed = res['proceed']
        args = res['args']
        counter_info = res['counter_info']
        target_port = 22
        gateway_hostname = '105.57.243.148'
        gateway_port = 22
        gateway_username = 'sieluser'
        gateway_password = 'Tools@123'
        global ne_ids_string
        global csv_file
        global cli_output_file_path
        gateway_client = None
        target_client = None
        try:
            gateway_client = SSHClient()
            gateway_client.set_missing_host_key_policy(AutoAddPolicy())
            gateway_client.connect(gateway_hostname, gateway_port, gateway_username, gateway_password)
            transport = gateway_client.get_transport()
            dest_addr = (target_server, target_port)
            local_addr = ('127.0.0.1', 0)
            channel = transport.open_channel("direct-tcpip", dest_addr, local_addr)
            target_client = SSHClient()
            target_client.set_missing_host_key_policy(AutoAddPolicy())
            target_client.connect('127.0.0.1', target_port, target_login, target_password, sock=channel)
            print("SSH connection established successfully to target server:", target_server)

            command = None
            if action_type == "RUN OM SCRIPT":
                command = f"bash {script_name} \"{counter_info}\" \"{condition}\" \"{args}\" \"{str('21')}_{str('1')}\""
                print(command)
                stdin, stdout, stderr = target_client.exec_command(command, timeout=160)
                script_output = stdout.read().decode('utf-8')
                error_output = stderr.read().decode('utf-8')

                output_directory = 'static/execution_log'
                error_dir = 'static/execution_log'
                output_file_path = f"{output_directory}/issue_{issue}_sequence_{sequence_num}.log"
                error_log_path = f"{output_directory}/error_log/issue_{issue}_sequence_{sequence_num}_error.log"

                os.makedirs(output_directory, exist_ok=True)
                os.makedirs(error_dir, exist_ok=True)

                if script_output:
                    with open(output_file_path, 'w') as output_file:
                        output_file.write(script_output)
                if error_output:
                    with open(error_log_path, 'w') as error_file:
                        error_file.write(error_output)

                if "No matches Found" in script_output and proceed == "No":
                    progress = {
                        'sequence_num': sequence_num,
                        'status': 'No matches Found',
                        'color': '#9C0006',
                        'message': 'No Matches Found \n Process stopped due to proceed next is No',
                        'condition': condition,
                        'action':action_type
                    }
                    progress_updates.append(progress)
                    socketio.emit('progress_update', progress)
                    response_data = {
                        'progress_updates': progress_updates,
                        'all_tasks_completed': 'true'
                    }
                    return Response(json.dumps(response_data), content_type='application/json')
                else:
                    output_file_path = script_output.split(':')[-1].strip()
                    sftp = target_client.open_sftp()
                    with sftp.open(output_file_path, 'r') as csv_file:
                        df = pd.read_csv(csv_file)
                        unique_ne_ids = df['NE_ID'].unique().tolist()
                        if len(unique_ne_ids) > 0:
                            ne_ids_string = ",".join(map(str, unique_ne_ids))
                        else:
                            ne_ids_string = str(unique_ne_ids[0]) if unique_ne_ids else ""
                    sftp.close()
                    progress = {
                        'sequence_num': sequence_num,
                        'status': 'Completed',
                        'color': 'green',
                        'message': script_output,
                        'condition': condition,
                        'action': action_type
                    }
                    progress_updates.append(progress)
                socketio.emit('progress_update', progress)
            elif action_type == "RUN CLI SCRIPT":
                cli_command = f"bash {script_name} \"venpr8r\" \"90327463\"  \"{ne_ids_string}\" \"{condition}\" \"{str('21')}_{str('1')}\""
                #cli_command = f"bash {script_name}   \"{ne_ids_string}\" \"{condition}\" \"{str('21')}_{str('1')}\""
                print(cli_command)
                stdin, stdout, stderr = target_client.exec_command(cli_command)
                cli_script_output = stdout.read().decode('utf-8')
                error_output = stderr.read().decode('utf-8')
                if error_output:
                    progress = {
                        'sequence_num': sequence_num,
                        'status': 'Error',
                        'color': 'red',
                        'message': error_output,
                        'condition': condition,
                        'action': action_type
                    }
                    progress_updates.append(progress)
                    socketio.emit('progress_update', progress)
                    response_data = {
                        'progress_updates': progress_updates,
                        'all_tasks_completed': 'true'
                    }
                    return Response(json.dumps(response_data), content_type='application/json')
                else:
                    cli_output_file_path = cli_script_output.split('@')[-1].strip()
                    print(cli_output_file_path)
                    progress = {
                        'sequence_num': sequence_num,
                        'status': 'Completed',
                        'color': 'green',
                        'message': cli_script_output,
                        'condition': condition,
                        'action': action_type
                    }
                    progress_updates.append(progress)
                socketio.emit('progress_update', progress)
            elif action_type == "GREP":
                grep_command = f"bash {script_name} {cli_output_file_path} {condition} \"{str('21')}_{str('1')}\""
                print(grep_command)
                stdin, stdout, stderr = target_client.exec_command(grep_command)
                grep_script_output = stdout.read().decode('utf-8')
                error_output = stderr.read().decode('utf-8')
                print(grep_script_output)
                if "No Matches Found" in grep_script_output:
                    progress = {
                        'sequence_num': sequence_num,
                        'status': 'No matches Found',
                        'color': '#9C0006',
                        'message': f'No Matches Found for Condition:{condition}\n',
                        'condition': condition,
                        'action': action_type
                    }
                    progress_updates.append(progress)
                    socketio.emit('progress_update', progress)
                    response_data = {
                        'progress_updates': progress_updates,
                        'all_tasks_completed': 'true'
                    }
                    return Response(json.dumps(response_data), content_type='application/json')
                else:
                    final_opt_file = grep_script_output.split(':')[-1].strip()
                    print(final_opt_file)
                    sftp = target_client.open_sftp()
                    with sftp.open(final_opt_file, 'r') as csv_file:
                        file_content = csv_file.read().decode('utf-8')
                        print(csv_file.read())
                        df = pd.read_csv(StringIO(file_content))
                        html_output = df.to_html(index=False, escape=False)
                    sftp.close()
                    progress = {
                        'sequence_num': sequence_num,
                        'status': 'Completed',
                        'color': 'green',
                        'message': html_output,
                        'condition': condition,
                        'action': action_type
                    }
                    progress_updates.append(progress)
                    socketio.emit('progress_update', progress)
                response_data = {
                    'progress_updates': progress_updates,
                    'all_tasks_completed': 'true'
                }
                return Response(json.dumps(response_data), content_type='application/json')
        except Exception as e:
            print("An error occurred:", str(e))
            error_message = f"An error occurred: {str(e)}"
            db.execute_query(
                "REPLACE INTO logs (issue_id, sequence_num, message, executed_by) VALUES (%s, %s, %s, %s)",
                (issue, sequence_num, error_message, session['user_name']), commit=True)
            progress = {
                'sequence_num': sequence_num,
                'status': 'Error',
                'color': 'red',
                'message': error_message,
                'condition': condition,
                'action': action_type
            }
            progress_updates.append(progress)
            socketio.emit('progress_update', progress)
            response_data = {
                'progress_updates': progress_updates,
                'all_tasks_completed': 'true'
            }
            return Response(json.dumps(response_data), content_type='application/json')
        finally:
            if gateway_client:
                gateway_client.close()
            if target_client:
                target_client.close()

    all_tasks_completed = len(progress_updates) == cnt

    response_data = {
        'progress_updates': progress_updates,
        'all_tasks_completed': all_tasks_completed
    }

    return Response(json.dumps(response_data), content_type='application/json')




@app.route("/fetch_kb", methods=['POST','GET'])
def fetch_kb():
    role = None
    if 'role' in session:
        role = session['role']
    page = int(request.args.get("page", 1))
    per_page = 1
    total_records_query = "SELECT COUNT(*) as cnt FROM known_knowledge_base"
    total_records = db.execute_query(total_records_query, fetch_all=True)[0]['cnt']
    query = "SELECT * FROM known_knowledge_base"
    res = db.execute_query(query, fetch_all=True)
    pagination = Pagination(page=page, per_page=per_page, total=total_records, css_framework='bootstrap4')
    # Paginate the records
    offset = (page - 1) * per_page
    # pagination_users = res[offset: offset + per_page]
    status_info = [user['Status'] for user in res]
    return render_template('viewknowledgebase.html', users=res, page=page, per_page=per_page,
                           pagination=pagination,status_info=status_info, roles=role)



@app.route("/sshcon")
def sshcon():
    return render_template("sshcon.html")

@app.route("/action_exe/<issue>", methods=['POST', 'GET'])
def action_exe(issue):
    sequence_num=1
    if db.execute_query("SELECT 1 FROM scripts WHERE issue_id = %s AND sequence_num = %s", (issue,sequence_num), fetch_all=False):
        query = """
            SELECT kb.*, s.* 
            FROM known_knowledge_base kb 
            INNER JOIN scripts s ON kb.issue = s.issue_id AND s.sequence_num = 1 
            WHERE kb.issue = %s
        """

    elif db.execute_query("SELECT 1 FROM get_file WHERE issue_id = %s AND sequence_num = %s", (issue,sequence_num), fetch_all=False):
        query = """
            SELECT kb.*, g.* 
            FROM known_knowledge_base kb 
            INNER JOIN get_file g ON kb.issue = g.issue_id AND g.sequence_num = 1 
            WHERE kb.issue = %s
        """
    elif db.execute_query("SELECT 1 FROM grep WHERE issue_id = %s AND sequence_num = %s",(issue,sequence_num), fetch_all=False):
        query = """
            SELECT kb.*, gr.* 
            FROM known_knowledge_base kb 
            INNER JOIN grep gr ON kb.issue = gr.issue_id AND gr.sequence_num = 1 
            WHERE kb.issue = %s
        """
    res = db.execute_query(query, (issue,))
    if res:
        res = res[0]
    return render_template('action_exe.html',issue=issue,record=res)

@app.route("/kb_hit", methods=['POST', 'GET'])
def kb_hit():
    return render_template('kb_GUI.html')

def get_page_args():
    try:
        page = int(request.args.get('page', default=1))
        per_page = int(request.args.get('per_page', default=10))
    except ValueError:
        page = 1
        per_page = 10

    offset = (page - 1) * per_page
    print("Page Args:", page, per_page, offset)
    return page, per_page, offset

@app.route("/fetch_issues", methods=['POST', 'GET'])
def fetch_issues():
    if request.method == 'POST':
        search_value = request.form.get('searchValue', '')
        select_SW = request.form.get('select_SW', '')
        select_Tech = request.form.get('select_Tech', '')
        select_kpi = request.form.get('select_kpi', '')
        select_Area = request.form.get('select_Area', '')

        query = "SELECT * FROM known_knowledge_base WHERE 1=1"
        if search_value:
            query += f" AND issue_category LIKE '%{search_value}%'"
        if select_SW and select_SW != 'nothing_sw':
            query += f" AND SW = '{select_SW}'"
        if select_Tech and select_Tech != 'nothing_tech':
            query += f" AND Technology = '{select_Tech}'"
        if select_kpi and select_kpi != 'nothing_kpi':
            query += f" AND Major_KPI_Degradation = '{select_kpi}'"
        if select_Area and select_Area != 'nothing_area':
            query += f" AND Area = '{select_Area}'"

        res = db.execute_query(query, fetch_all=True)
        return jsonify(res)
    else:  # GET request (initial page load)
        return render_template('viewOverallIssues.html', users=[])

@app.route("/act_srch/<issue>", methods=['POST', 'GET'])
def act_srch(issue):
    query = "SELECT * FROM known_knowledge_base k,scripts s WHERE k.issue = %s and k.issue = s.issue_id"
    res = db.execute_query(query, (issue,),fetch_all=True)
    return render_template('viewSingleIssue.html', users=res)


def fetch_next_records(page, per_page=1, sing_srch=None, sw=None, tech=None, area=None):
    # Calculate the offset based on the current page
    offset = (page - 1) * per_page

    # Build the SQL query based on search criteria
    query = "SELECT * FROM known_knowledge_base WHERE Major_KPI_Degradation = %s"
    conditions = []
    values = [sing_srch]

    if sw and sw != "nothing":
        conditions.append("SW = %s")
        values.append(sw)
    if tech and tech != "nothing":
        conditions.append("Technology = %s")
        values.append(tech)
    if area and area != "nothing":
        conditions.append("Area = %s")
        values.append(area)

    if conditions:
        query += " AND ".join(conditions)

    query += " LIMIT %s OFFSET %s"
    values += [per_page, offset]

    # Prepare values for the query
    values = tuple(filter(lambda x: x != 'nothing', values))

    # Execute the query to fetch records
    records = db.execute_query(query, values, fetch_all=True)

    # Fetch the total number of records for pagination
    total_records_query = "SELECT COUNT(*) as cnt FROM known_knowledge_base WHERE Major_KPI_Degradation = %s"
    total_values = tuple(filter(lambda x: x != 'nothing', [sing_srch]))
    total_records = db.execute_query(total_records_query, total_values)[0]['cnt']

    # Create pagination object
    pagination = Pagination(page=page, per_page=per_page, total=total_records, css_framework='bootstrap4')

    return records, pagination





@app.route("/next_page", methods=['POST', 'GET'])
def next_page():
    # Get the search parameters from the form or session
    sing_srch=session['sing_srch']
    sw = session['sw']
    tech=session['tech']
    kpi=session['kpi']
    area= session['area']
    # Fetch the page parameter from the request
    page = request.args.get('page', type=int, default=10)

    # Fetch the records based on the current page for pagination
    records = fetch_next_records(page, sing_srch=sing_srch, sw=sw, tech=tech, area=area)
    print(records)
    # Get current page, per_page, and offset
    page, per_page, offset = get_page_args()
    print(page)
    # Create pagination object
    pagination = Pagination(page=page, per_page=per_page, total=len(records), css_framework='bootstrap4')

    return render_template("viewSingleIssue.html", records=records, pagination=pagination)

users = list(range(100))
def get_users(offset=0,per_page=10):
    return users[offset: offset+per_page]

@app.route("/pagiante_route")
def pagiante_route():
    page = int(request.args.get("page", 1))
    per_page = 1
    offset = (page - 1) * per_page

    total_records_query = "SELECT COUNT(*) as cnt FROM known_knowledge_base WHERE Major_KPI_Degradation = 'Accessibility'"
    total_records = db.execute_query(total_records_query, fetch_all=True)[0]['cnt']

    query = "SELECT * FROM known_knowledge_base WHERE Major_KPI_Degradation = 'Accessibility'"
    res = db.execute_query(query, fetch_all=True)

    print("total_records", total_records)

    pagination = Pagination(page=page, per_page=per_page, total=total_records, css_framework='bootstrap4')


    # Paginate the records
    offset = (page - 1) * per_page
    pagination_users = res[offset: offset + per_page]

    return render_template('page_display.html', users=pagination_users, page=page, per_page=per_page,
                           pagination=pagination)

@app.route("/update_user",methods=['POST','GET'])
def update_user():
    if request.method == "POST":
        knox =request.form.get('knoxid')
        username=request.form.get('username')
        email=request.form.get('email')
        role=request.form.get('role')
        team=request.form.get('team')
        status=request.form.get('status')
        mode=request.form.get('mode')
        print(mode)
        user_id=request.form.get('user_id')
        query = "update user set knox_id=%s,fullname=%s,email=%s,role=%s,team=%s,status=%s,mode=%s where user_id=%s"
        values = [knox,username,email,role,team,status,mode,user_id]
        db.execute_query(query,params=tuple(values),commit=True)

        return jsonify({'suc':f"user {knox} updated successfully!!!"})
    else:
        return jsonify({'err':"Failed"})

@app.route("/download_user",methods=['POST','GET'])
def download_user():
    total_users_query = "SELECT * FROM user"
    total_records = db.execute_query(total_users_query, fetch_all=True)
    total_records = list(total_records)
    wb = Workbook()
    ws = wb.active
    headers = list(total_records[0].keys())
    ws.append(headers)
    for row_data in total_records:
        ws.append([row_data[header] for header in headers])
    excel_file = io.BytesIO()
    wb.save(excel_file)
    excel_file.seek(0)
    return send_file(
        excel_file,
        as_attachment=True,
        download_name='users_list.xlsx',
        mimetype='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
    )


@app.route("/action_edit/<issue>",methods=['POST','GET'])
def action_edit(issue):
    query = "SELECT * FROM known_knowledge_base k LEFT JOIN action_steps act ON k.issue = act.issue WHERE k.issue = %s order by step_num asc"
    val = (issue,)
    res = db.execute_query(query,val,fetch_all=False)

    return render_template("action_edit.html",issue=res)


@app.route('/fetch_step_data', methods=['GET','POST'])
def fetch_step_data():
    issue = request.form.get('issue')
    sequence_num = request.form.get('step')
    query = None
    if db.execute_query("SELECT 1 FROM scripts WHERE issue_id = %s AND sequence_num = %s", (issue, sequence_num),
                        fetch_all=False):
        query = """
            SELECT kb.*, s.* 
            FROM known_knowledge_base kb 
            INNER JOIN scripts s ON kb.issue = s.issue_id AND s.sequence_num = %s 
            WHERE kb.issue = %s
        """
    elif db.execute_query("SELECT 1 FROM get_file WHERE issue_id = %s AND sequence_num = %s", (issue, sequence_num),
                          fetch_all=False):
        query = """
            SELECT kb.*, g.* 
            FROM known_knowledge_base kb 
            INNER JOIN get_file g ON kb.issue = g.issue_id AND g.sequence_num = %s 
            WHERE kb.issue = %s
        """
    elif db.execute_query("SELECT 1 FROM grep WHERE issue_id = %s AND sequence_num = %s", (issue, sequence_num), fetch_all=False):
        query = """
            SELECT kb.*, gr.* 
            FROM known_knowledge_base kb 
            INNER JOIN grep gr ON kb.issue = gr.issue_id AND gr.sequence_num = %s
            WHERE kb.issue = %s
        """

    if query:
        res = db.execute_query(query, (sequence_num, issue,))
        if res:
            res = res[0]
    else:
        return jsonify({"error": "No data found"})
    return res

@app.route("/save_singleissue", methods=['POST', 'GET'])
def save_singleissue():
    issue = request.form.get('msId')
    sw = request.form.get('swname')
    status = request.form.get('statusval')
    area= request.form.get('area')
    tech=request.form.get('tech')
    visible=request.form.get('Visibility')
    kpi = request.form.get('kpi')
    desc = request.form.get('desc')
    rca = request.form.get('rca')
    impact =request.form.get('impact')
    script = request.form.get('Detection_Methodology_Log_Script')
    oms=request.form.get('Detection_Methodology_OMs')
    wa = request.form.get('Interim_Solution_Workaround')
    pf = request.form.get('Permanent_Fix')
    ic=request.form.get('ic')
    update_query = "UPDATE known_knowledge_base SET SW=%s, Status=%s, Area=%s, Technology=%s, Major_KPI_Degradation=%s, Issue_Category=%s, " \
                   "Description=%s, Root_Cause=%s, Impact=%s, Detection_Methodology_OMs=%s, Detection_Methodology_Log_Script=%s, " \
                   "Interim_Solution_Workaround=%s, Permanent_Fix=%s WHERE issue=%s"
    values = (sw,status,area,tech,kpi,ic,desc,rca,impact,oms,script,wa,pf,issue)
    try:
        db.execute_query(update_query,values,commit=True)
        return jsonify({'message':"updated succesfully!! Click on next to update action steps"})
    except Exception as e:
        return jsonify({'error':f"Something went wrong {e}"})

@app.route("/save_action", methods=['POST', 'GET'])
def save_action():
    if request.method == "POST":
        issue = request.form.get('issue_id')
        swval = request.form.get('issue_sw')
        is_st = request.form.get('issue_st')
        currentStep= request.form.get('currentStep')
        act_type=request.form.get('action_type')
        scname=request.form.get('scName')
        uid = request.form.get('uid')
        pwd = request.form.get('pwd')
        ip=request.form.get('ip')
        scloc=request.form.get('scLoc')
        scowner=request.form.get('scOwner')
        scpath=request.form.get('scPath')
        issuecat=request.form.get('issuecat')
        file=request.form.get('file')
        regex=request.form.get('regex')
        email = request.form.get('email')
        print(act_type)
        if act_type == "GET FILE":
            query = "INSERT INTO get_file (issue_id, SW, Technology, Status, action_type, file_name, Script_owner, Script_location, server_Login, server_password, Server_IP, Sequence_num, Task_id, script_path, args) " \
                    "VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"
            values = (issue, swval, "", is_st, act_type, file, scowner, scloc, uid, pwd, ip, currentStep.replace("step",''), int(issue), scpath, regex)

        elif act_type == "GREP":
            query = "insert into grep (issue_id,Sequence_num,grep_target,grep_string,expected_output_regex,type_grep_arguments,Task_id,action_type,script_path,file_name,Script_owner,Script_location,server_Login,server_password,Server_IP)" \
                    " values (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)"
            values = (issue,currentStep.replace("step",''),file,regex,"","",issue,act_type,scpath,"",scowner,scloc,uid,pwd,ip)

        elif act_type == "RUN SCRIPT":
            query = "insert into  scripts( issue_id,SW,Technology,Status,action_type,script_name,Script_owner,Script_location,server_Login,server_password,Server_IP,Sequence_num,Task_id,script_path,args)" \
                    " values( % s, % s, % s, % s, % s, % s, % s, % s, % s, % s, % s, % s, % s, % s, % s)"
            values = (issue,swval,"",is_st,act_type,scname,scowner,scloc,uid,pwd,ip,currentStep.replace("step",''),issue,scpath,regex)
        else:
            return jsonify({"error": "Invalid action type"})

        check_query = "select count(*) as cnt from action_steps where issue=%s and sw = %s and status=%s and issuecategory=%s and step_num=%s"
        cnt = list(db.execute_query(check_query,(issue,swval,is_st,issuecat,currentStep,)))
        if cnt[0]['cnt']> 0:
            update_query = "update action_steps set script_type=%s,script_name=%s,ssh_user_id=%s,ssh_password=%s,server_ip=%s," \
                           "server_location=%s,script_owner=%s,script_path=%s,file_name=%s,arguments=%s,email_to=%s" \
                           " where issue=%s and sw = %s and status=%s and issuecategory=%s and step_num=%s"
            vals = (act_type,scname,uid,pwd,ip,scloc,scowner,scpath,file,regex,email,issue,swval,is_st,"",currentStep,)
            try:
                db.execute_query(query, values, commit=True)
                db.execute_query(update_query,vals,commit=True)
                return jsonify({"msg":"Record Updated successfully"})
            except Exception as e:
                return jsonify({"error":f"Couldnot update because {e}"})
        else:
            insert_query = "INSERT INTO action_steps (issue, sw, status, issuecategory, step_num, script_name, ssh_user_id, ssh_password, server_ip, server_location, script_owner, script_path, file_name, arguments, email_to, script_type) " \
                           "VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"
            insert_vals = (issue,swval,is_st,"",currentStep,scname,uid,pwd,ip,scloc,scowner,scpath,file,regex,email,act_type)
            try:
                db.execute_query(query,values,commit=True)
                db.execute_query(insert_query, insert_vals, commit=True)
                return jsonify({"msg": "Record Inserted successfully"})
            except Exception as e:
                return jsonify({"error":f"something went wrong in insert {e}"})

@app.route("/insert_kb",methods=['GET','POST'])
def insert_kb():
    SW_val = request.form.get('issue_sw')
    status = request.form.get('status')
    area_val = request.form.get('area_val')
    tech = request.form.get('tech')
    Visibility = request.form.get('Visibility')
    kpi = request.form.get('kpi')
    icat = request.form.get('icat')
    desc = request.form.get('desc')
    rca = request.form.get('rca')
    impact = request.form.get('impact')
    m_oms = request.form.get('m_oms')
    script = request.form.get('script')
    wa = request.form.get('wa')
    pf = request.form.get('pf')
    poc = request.form.get('POC')
    sel_query = "select * from known_knowledge_base where SW=%s and area=%s and Technology=%s" \
                "and Major_KPI_Degradation=%s"
    values = (SW_val,area_val,tech,kpi)
    try:
        res = db.execute_query(sel_query,values,fetch_all=False)
        if res:
            redirect_url = url_for('act_srch', issue=res['issue'])
            return jsonify({"message": f"Issue {res['issue']} already exists. Redirecting...","redirect_url": redirect_url})
        else:
            insert_query="insert into known_knowledge_base(SW,Status,Area,Technology,Visibility,Major_KPI_Degradation," \
                         "Issue_Category,Description,Root_Cause,Impact,Detection_Methodology_OMs," \
                         "Detection_Methodology_Log_Script,Interim_Solution_Workaround,Permanent_Fix,poc) values" \
                         "(%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)"
            values=(SW_val,status,area_val,tech,Visibility,kpi,icat,desc,rca,impact,m_oms,script,wa,pf,poc)
            db.execute_query(insert_query, values, commit=True)
            print("inserted")
            result = db.execute_query("SELECT LAST_INSERT_ID() as issue_id")
            print(result)
            issue_id = result[0]['issue_id'] if result else None
            print(issue_id)
            if issue_id:
                print(issue_id)
                return jsonify({"message": "Inserted successfully", "issue_id": issue_id, "sw_val":SW_val, "status_val":status})
            else:
                return jsonify({"message": "Insertion failed"}), 500
    except Exception as e:
        return {"error":f"{e}"}


@app.route("/insert_issue_seq",methods=['GET','POST'])
def insert_issue_seq():
    issue_id =request.form.get('issue_id')
    sw_val = request.form.get('sw_val')
    seq_id = request.form.get('sequenceid')
    status_val = request.form.get('status_val')
    act_type = request.form.get('action_type')
    scname = request.form.get('scName')
    uid = request.form.get('uid')
    pwd = request.form.get('pwd')
    ip = request.form.get('ip')
    scloc = request.form.get('scLoc')
    scowner = request.form.get('scOwner')
    scpath = request.form.get('scPath')
    c_type = request.form.get('check_type')
    proceed = request.form.get('proceed')
    c_cond = request.form.get('check_condition')
    args = request.form.get('regex')
    if act_type == "RUN OM SCRIPT" or act_type == "RUN CLI SCRIPT" or act_type == "RUN ADHOC SCRIPT":
        if act_type == "RUN OM SCRIPT":
            scloc = "REMOTE"
            scpath = ""
        insert_query = """
                    INSERT INTO scripts (issue_id,SW,Technology,Status,action_type,script_name,Script_owner,Script_location,server_Login,server_password,Server_IP,Sequence_num,Task_id,script_path,args,check_type,proceed,check_condition)
                    VALUES(%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)
                """
        values = (issue_id,sw_val,"",status_val,act_type,scname,scowner,scloc,uid,pwd,ip,seq_id,issue_id,scpath,args,c_type,proceed,c_cond)
    try:
        db.execute_query(insert_query, values, commit=True)
    # except MySQLdb.Error as e:
    #     return jsonify({"message": f"Something Went Wrong {e}"}), 500
    except Exception as ee:
        return jsonify({"message": f"Something Went Wrong main exception {ee}"}), 500
    return jsonify({"message": "Inserted successfully"}), 201



@app.route("/kb/<id>", methods=['POST', 'GET'])
def kb_detail(id):
    query = ("SELECT * FROM known_knowledge_base k WHERE k.issue = %s;")
    res = db.execute_query(query, (id,), fetch_all=True)

    return render_template('DetailKbPage.html', users=res)

@app.route("/logout", methods=['POST', 'GET'])
def logout():
    session.clear()
    return redirect(url_for('index'))

if __name__ == "__main__":
    # app.run(port=5004, debug=True)
    socketio.run(app,port=5004, debug=True)
