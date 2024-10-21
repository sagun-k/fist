import base64
import hashlib
import bcrypt
from flask import abort, jsonify, current_app as app, session

class InsertIssueSeqService:
    def __init__(self, db):
        self.db = db
        self.action_mapp = {
            'RUN GREP': 'GREP_ACTION_ID',
            'RUN CLI': 'CLI_ACTION_ID',
            'PULL OM': 'OM_ACTION_ID'
        }
        self.new_map = {
            'scripts': 'CLI_',
            'grep': 'GREP_',
            'om_exec': 'OM_'
        }
        self.ACTION_DB_MAPPPING = {
            'RUN CLI':'scripts',
            'RUN GREP':'grep',
            'PULL OM': 'om_exec'
        }

    def insert_issue_seq(self, form_data):
        app.logger.info("Inserting issue sequence")
        action_id =form_data['action_id']
        issue_id = form_data['issue_id']
        sw_val = form_data['sw_val']
        act_type = form_data['act_type']
        status_val = form_data['status_val']
        scname = form_data['scname']
        seq_id = form_data['seq_id']
        args = form_data['args']
        c_type = form_data['c_type']
        proceed = form_data['proceed']
        c_cond = form_data['c_cond']
        grep = form_data['grep']
        om_counters = form_data['om_counters']
        ip = form_data['ip']
        uid = form_data['uid']
        pwd = form_data['pwd']
        action_id = form_data.get('action_id')  # Optional value
        prev_act_type = form_data.get('prev_act_type')  # Optional value
        if not action_id:
            return self.post_issue_sequence(issue_id, sw_val, act_type, status_val, scname, seq_id, args, c_type, proceed, c_cond, grep, om_counters, ip, uid, pwd, session)
        else:
            return self.update_issue_sequence(issue_id, sw_val, act_type, status_val, scname, seq_id, args, c_type, proceed, c_cond, grep, om_counters, ip, action_id, prev_act_type, uid, pwd, session)
    
    def post_issue_sequence(self, issue_id, sw_val, act_type, status_val, scname, seq_id,args, c_type, proceed, c_cond, grep, om_counters, ip, uid, pwd, session):
        existing_exec_order = self.get_exec_orders(issue_id) #fetching the exec orders
        new_added_child = self.determine_action_type_and_add(issue_id, sw_val, act_type, status_val, scname, seq_id,args, c_type, proceed, c_cond, grep, om_counters, ip, uid, pwd, session)
        mapped_action_id = self.map_action_type_id(act_type, new_added_child)
        #mapping the action_id
        existing_exec_order.append(self.map_action_type_id(act_type, new_added_child))
        self.update_exec_orders(issue_id, existing_exec_order)
        return jsonify({"message": "Inserted successfully","action_id":mapped_action_id}), 201


    def update_issue_sequence(self, issue_id, sw_val, act_type, status_val, scname, seq_id,args, c_type, proceed, c_cond, grep, om_counters, ip, action_id, prev_act_type, uid, pwd, session):
        exec_orders = self.get_exec_orders(issue_id)
        if not self.is_action_type_changed(act_type, action_id, exec_orders):
            return self.update_when_action_type_not_changed(sw_val, act_type, status_val, scname, seq_id, args, c_type, proceed, c_cond, grep, om_counters, ip, action_id, uid, pwd, session)
        else :
            return self.update_when_action_type_changed(sw_val, act_type, status_val, scname, seq_id, args, c_type, proceed, c_cond, grep, om_counters, ip, action_id, issue_id, uid, pwd,session)        

    def update_or_insert_user_credentials_when_type_cli(self ,uid, pwd, session):
        if uid and pwd:
            hashed_pwd = pwd
            if not pwd.startswith(("$2a$", "$2b$", "$2y$")):
                hashed_pwd = bcrypt.hashpw(
                    base64.b64encode(hashlib.sha256(pwd.encode('utf-8')).digest()),
                    bcrypt.gensalt()
                ).decode('utf-8') 
            select_query = "SELECT * FROM user_sane_details WHERE user_id=%s"
            values = (session['user_name'],)
            result = self.db.execute_query(select_query, values)

            if result:
                if not (result[0]['sane_id'] == uid and result[0]['sane_password'] == hashed_pwd):
                    self.db.execute_query(
                        """UPDATE user_sane_details SET sane_id=%s, sane_password=%s WHERE user_id=%s""",
                        (uid, hashed_pwd, session['user_name']),
                        commit=True
                    )
            else:
                self.db.execute_query(
                    "INSERT INTO user_sane_details (user_id, sane_id, sane_password) VALUES (%s, %s, %s)",
                    (session['user_name'], uid, hashed_pwd),
                    commit=True
                )


    def determine_action_type_and_add(self, issue_id, sw_val, act_type, status_val, scname, seq_id,args, c_type, proceed, c_cond, grep, om_counters, ip, uid, pwd, session):
        new_added_child = None
        if act_type == "RUN CLI":
            new_added_child = self.add_cli(sw_val, act_type, status_val, scname,ip, seq_id,args, c_type, proceed, c_cond)
            self.update_or_insert_user_credentials_when_type_cli(uid, pwd, session)
        elif act_type == "PULL OM":
            new_added_child = self.add_om(status_val, act_type, scname, ip,seq_id, proceed, c_cond, om_counters)
        elif act_type == "RUN GREP":
            new_added_child = self.add_grep(seq_id, grep, act_type)
        else:
            raise Exception("Invalid action type")
        return new_added_child

    def update_when_action_type_not_changed(self, sw_val, act_type, status_val, scname, seq_id,args, c_type, proceed, c_cond, grep, om_counters, ip, action_id, uid, pwd, session):
        updated_child = None
        if act_type == "RUN CLI":
                updated_child = self.update_cli(sw_val, act_type, status_val, scname, ip, seq_id, args, c_type, proceed, c_cond, action_id)
                self.update_or_insert_user_credentials_when_type_cli(uid, pwd, session)
        elif act_type == "PULL OM":
            updated_child = self.update_om(status_val, act_type, scname, ip, om_counters, proceed, c_cond, seq_id, action_id)
        elif act_type == "RUN GREP":
            updated_child = self.update_grep(act_type, seq_id, grep, action_id)
        else:
            raise Exception("Invalid action type")
        return jsonify({"message":"Updated issue successfully","action_id":action_id}), 201

    def update_when_action_type_changed(self, sw_val, act_type, status_val, scname, seq_id,args, c_type, proceed, c_cond, grep, om_counters, ip, action_id, issue_id, uid, pwd, session):
        exec_orders = self.get_exec_orders(issue_id)
        current_exec_position = self.find_index_of_current_exec(exec_orders, action_id)
        self.delete_existed_exec(action_id)
        new_added_data_id = self.determine_action_type_and_add(issue_id, sw_val, act_type, status_val, scname, seq_id, args, c_type, proceed, c_cond, grep, om_counters, ip, uid, pwd, session)
        new_exec_id = self.map_action_type_id(act_type, new_added_data_id)
        updated_exec_order = self.update_value_of_exec_order_in_specific_index(exec_orders, current_exec_position, new_exec_id)
        self.update_exec_orders(issue_id, updated_exec_order)
        mapped_action_id = self.map_action_type_id(act_type, new_added_data_id)
        return jsonify({"message":"Updated issue successfully","action_id":mapped_action_id}), 201

    def update_value_of_exec_order_in_specific_index(self, exec_orders, index, new_value_in_index):
        if 0 <= index < len(exec_orders):
            exec_orders[index] = new_value_in_index  # Update the value at the specified index
        else:
            print("Index out of range. No updates made.")

        return exec_orders  #

    def find_index_of_current_exec(self, exec_orders, previous_existed_exec_id):
        for index, exec_order in enumerate(exec_orders):
            if exec_order == previous_existed_exec_id:
                return index  # Return the index if a match is found
        return -1      

    def delete_existed_exec(self, action_id):
        prefix_from_id = action_id.split("_")
        DB_TABLE = self.map_table_from_prefix(prefix_from_id[0])
        action_id_column= self.map_column_id_name(action_id)
        delete_query = f"DELETE FROM {DB_TABLE} WHERE {action_id_column}=%s"
        self.db.execute_query(delete_query, prefix_from_id[1], commit=True)

    def map_action_type_id(self, act_type, id):
        if act_type == "RUN CLI":
            return "CLI_"+str(id)
        elif act_type == "PULL OM":
            return "OM_"+str(id)
        elif act_type == "RUN GREP":
            return "GREP_"+str(id)
    
    def map_table_from_prefix(self, prefix):
        if "OM" in prefix:
            return "om_exec"
        elif "CLI" in prefix:
            return "scripts"
        elif "GREP" in prefix:
            return "grep"

        
    def map_column_id_name(self, action_id):
        if "CLI_" in action_id :
            return "CLI_ACTION_ID"
        elif "OM_" in action_id:
            return "OM_ACTION_ID"
        elif  "GREP_" in action_id:
            return "GREP_ACTION_ID"


    def is_action_type_changed(self, action_type, mapped_action_id, exec_orders):
        # exec_id = self.map_action_type_id(action_type, action_id)
        action_first = mapped_action_id.split("_")
        return action_first[0] not in action_type
        
    def add_cli(self, sw_val, act_type, status_val, scname, ip, seq_id, args, c_type, proceed, c_cond):
        insert_query = """INSERT INTO scripts (SW, action_type, Status, script_name,  Server_IP, Sequence_num, args, check_type, proceed, check_condition, email_to, counter_info) VALUES(%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)"""
        values = ( sw_val, act_type, status_val, scname,  ip, seq_id,args,c_type,proceed,c_cond,"", "")
        self.db.execute_query(insert_query, values)
        return self.db.last_insert_id()

    def update_cli(self, sw_val, act_type, status_val, scname, ip, seq_id, args, c_type, proceed, c_cond, action_id):
        action = self.action_mapp[act_type]
        update_query = f"""UPDATE scripts SET SW=%s, action_type=%s, Status=%s, script_name=%s,  Server_IP=%s, 
        Sequence_num=%s, args=%s, check_type=%s, proceed=%s, check_condition=%s, email_to=%s, counter_info=%s
        WHERE {action}=%s """
        values = (sw_val, act_type, status_val, scname,  ip, seq_id, args, c_type, proceed, c_cond, "", "", action_id.split("_")[1])
        self.db.execute_query(update_query, values, commit=True)
        return action_id

    def add_grep(self, seq_id, grep, act_type):
        insert_query = """ INSERT INTO grep (Sequence_num, grep_target,  action_type) VALUES(%s,%s,%s) """
        values = (seq_id,grep,act_type)
        self.db.execute_query(insert_query, values)
        return self.db.last_insert_id()


    def update_grep(self, act_type, seq_id, grep, action_id):
        action = self.action_mapp[act_type]
        update_query = f"""UPDATE grep SET Sequence_num=%s, grep_target=%s, action_type=%s WHERE {action}=%s """
        values = (seq_id,grep,act_type,action_id.split("_")[1])
        self.db.execute_query(update_query, values)
        return action_id

    def add_om(self, status_val,act_type,scname,ip, seq_id, proceed,c_cond, om_counters):
        insert_query = """INSERT INTO OM_EXEC (Status, action_type, script_name, Server_IP,Sequence_num,  proceed, check_condition, counter_info)VALUES(%s, %s, %s, %s, %s, %s, %s, %s)"""
        values = (status_val,act_type,scname,ip, seq_id, proceed,c_cond, om_counters)
        self.db.execute_query(insert_query, values)
        return self.db.last_insert_id()


    def update_om(self, status_val, act_type, scname, ip, om_counters, proceed, c_cond, seq_id, action_id):
        action = self.action_mapp[act_type]
        update_query = f"""UPDATE om_exec SET Status=%s, action_type=%s, script_name=%s,Server_IP=%s,counter_info=%s, proceed=%s, check_condition=%s, Sequence_num=%s WHERE {action}=%s """
        values = (status_val, act_type, scname, ip, om_counters, proceed, c_cond, seq_id, action_id.split("_")[1])
        self.db.execute_query(update_query, values)
        return action_id

    def get_exec_orders(self,issue_id):
        try:
            result = self.db.execute_query(
                'SELECT EXEC_ORDER FROM known_knowledge_base WHERE issue=%s',
                (issue_id,),
                fetch_all=False
            )
            
            if result and 'EXEC_ORDER' in result and result['EXEC_ORDER'] is not None:
                return result['EXEC_ORDER'].split(',')
            else:
                return []
        except Exception as e:
            print(f"Error fetching execution orders for issue_id {issue_id}: {e}")
            abort(500, description="Internal Server Error: Could not fetch execution orders.")

    def update_exec_orders(self,issue_id, new_exec_order):
        print(new_exec_order)
        new_exec_order_string = ",".join(new_exec_order)  
        self.db.execute_query('UPDATE known_knowledge_base SET EXEC_ORDER=%s WHERE issue=%s ',
                                                        (new_exec_order_string, issue_id), commit=True)


