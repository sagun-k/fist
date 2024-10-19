from databricks import sql

class DatabricksConnector:
    def __init__(self, server_hostname, http_path, access_token):
        self.server_hostname = server_hostname
        self.http_path = http_path
        self.access_token = access_token
        self.connection = None

    def connect(self):
        """Establish a connection to Databricks."""
        try:
            self.connection = sql.connect(
               server_hostname=self.server_hostname,
               http_path=self.http_path,
               access_token=self.access_token
            )
        except Exception as e:
            print(f"Failed to connect to Databricks: {e}")
            self.connection = None

    def execute_query(self, query, params=None):
        """Execute a query and return the results."""
        if self.connection is None:
            self.connect()
            if self.connection is None:
                raise Exception("Failed to establish a connection to Databricks.")

        try:
            with self.connection.cursor() as cursor:
                cursor.execute(query, params)
                result = cursor.fetchall()
                headers = [col[0] for col in cursor.description]
                result_with_headers = [headers] + result
            return result_with_headers
        except Exception as e:
            print(f"Failed to execute query: {e}")
            return None
    
    def save_to_csv(self, data, file_path):
        """Save the result data to a CSV file."""
        try:
            with open(file_path, 'w', newline='') as fp:
                my_file = csv.writer(fp)
                my_file.writerows(data)
            print(f"Data saved to {file_path}")
        except Exception as e:
            print(f"Failed to save data to CSV: {e}")


    def close(self):
        """Close the connection."""
        if self.connection:
            self.connection.close()
            self.connection = None
