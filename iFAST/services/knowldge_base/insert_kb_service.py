from flask import jsonify, url_for, current_app as app

class InsertKbService:
    def __init__(self, db):
        self.db = db

    def insert_kb(self, form_data):
        app.logger.info("INFODODO")

        try:
            existing_issue = self._check_existing_issue(form_data)
            if existing_issue:
                return self._handle_existing_issue(existing_issue)

            new_issue_id = self._insert_new_issue(form_data)
            if new_issue_id:
                return jsonify({
                    "message": "Inserted successfully",
                    "issue_id": new_issue_id,
                    "sw_val": form_data['SW_val'],
                    "status_val": form_data['status']
                })
            else:
                return jsonify({"message": "Insertion failed"}), 500

        except Exception as e:
            app.logger.error(e)
            return jsonify({"error": str(e)}), 500

    def _check_existing_issue(self, form_data):
        sel_query = "SELECT * FROM known_knowledge_base WHERE SW=%s AND area=%s AND Technology=%s AND Major_KPI_Degradation=%s"
        values = (form_data['SW_val'], form_data['area_val'], form_data['tech'], form_data['kpi'])
        return self.db.execute_query(sel_query, values)

    def _handle_existing_issue(self, existing_issue):
        try:
            redirect_url = url_for('act_srch', issue=int(existing_issue['issue']))
            return jsonify({
                "message": f"Issue {existing_issue['issue']} already exists. Redirecting...",
                "redirect_url": redirect_url
            })
        except Exception as e:
            app.logger.error("Redirection failed: %s", str(e))
            return jsonify({"message": "Redirection failed"}), 409

    def _insert_new_issue(self, form_data):
        qry = 'SELECT issue FROM known_knowledge_base ORDER BY issue DESC LIMIT 1'
        last_issue_idx = self.db.execute_query(qry, fetch_all=False)
        cur_idx = last_issue_idx["issue"] + 1 if last_issue_idx else 1

        insert_query = """INSERT INTO known_knowledge_base(issue, SW, Status, Area, Technology, Visibility, Major_KPI_Degradation,
                         Issue_Category, Description, Root_Cause, Impact, reference_link, Remarks_Notes,
                         Interim_Solution_Workaround, Permanent_Fix, poc, email_to, total_steps, Cell_or_Site_Level)
                         VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"""

        values = (
            cur_idx, form_data['SW_val'], form_data['status'], form_data['area_val'], form_data['tech'],
            form_data['Visibility'], form_data['kpi'], form_data['icat'], form_data['desc'],
            form_data['rca'], form_data['impact'], form_data['reference'], form_data['remarks'],
            form_data['wa'], form_data['pf'], form_data['poc'], form_data['email'],
            form_data['steps'], form_data['cell']
        )

        try:
            self.db.execute_query(insert_query, values, commit=True)
            result = self.db.execute_query("SELECT issue FROM known_knowledge_base ORDER BY issue DESC LIMIT 1;")
            return result[0]['issue'] if result else None
        except Exception as e:
            app.logger.error("Insertion error: %s", str(e))
            return None
