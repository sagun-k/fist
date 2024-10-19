from flask import Flask
from services.knowldge_base.insert_kb_service import InsertKbService
from services.knowldge_base.insert_issue_seq_service import InsertIssueSeqService

app = Flask(__name__)

class KnowledgeBaseManagerService:
    def __init__(self, db):
        self.db = db
        self.insert_kb_service = InsertKbService(self.db)
        self.insert_issue_seq_service = InsertIssueSeqService(self.db)

    def insert_kb(self, form_data):
        return self.insert_kb_service.insert_kb(form_data)
    
    def insert_issue_seq(self, form_data):
        return self.insert_issue_seq_service.insert_issue_seq(form_data)
    
    def extract_form_data_for_insert_issue_seq(self, form):
        return {
            "issue_id": form.get('issue_id'),
            "action_id":form.get('action_id'),
            "sw_val": form.get('sw_val'),
            "seq_id": form.get('sequenceid'),
            "status_val": form.get('status_val'),
            "prev_act_type": form.get('prev_action_type'),
            "act_type": form.get('action_type'),
            "scname": form.get('scName'),
            "uid": form.get('uid'),
            "pwd": form.get('pwd'),
            "ip": form.get('ip'),
            "scloc": form.get('scLoc'),
            "scowner": form.get('scOwner'),
            "scpath": form.get('scPath'),
            "c_type": form.get('check_type'),
            "proceed": form.get('proceed'),
            "c_cond": form.get('check_condition'),
            "args": form.get('regex'),
            "om_counters": form.get('om_counters'),
            "grep": form.get('pattern_grep'),
        }


    def extract_form_data_for_insert_kb(self, form):
        """Extract form data from the request."""
        return {
            "SW_val": form.get('issue_sw'),
            "status": form.get('status'),
            "area_val": form.get('area_val'),
            "tech": form.get('tech'),
            "Visibility": form.get('Visibility'),
            "kpi": form.get('kpi'),
            "email": form.get('email'),
            "cell": form.get('cell'),
            "icat": form.get('icat'),
            "desc": form.get('desc'),
            "rca": form.get('rca'),
            "impact": form.get('impact'),
            "reference": form.get('reference'),
            "remarks": form.get('remarks'),
            "steps": form.get('totalSteps'),
            "wa": form.get('wa'),
            "pf": form.get('pf'),
            "poc": form.get('POC')
        }
