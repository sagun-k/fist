import pymysql.cursors

class Database:
    def __init__(self, app=None):
        if app is not None:
            self.init_app(app)
        

    def init_app(self, app):
        self.host = app.config['MYSQL_HOST']
        self.user = app.config['MYSQL_USER']
        self.password = app.config['MYSQL_PASSWORD']
        self.db = app.config['MYSQL_DB']
        self.connection = None
        self.connect()
        print(self.host)

    def connect(self):
        if self.connection:
            self.connection.close()
        self.connection = pymysql.connect(
            host=self.host,
            user=self.user,
            password=self.password,
            db=self.db,
            cursorclass=pymysql.cursors.DictCursor
        )

    def check_connection(self):
        if self.connection:
            try:
                self.connection.ping(reconnect=True)
                return True
            except pymysql.MySQLError as e:
                print("Error connecting to the database:", str(e))
                return False
        else:
            print("MySQL connection not initialized.")
            return False

    def get_cursor(self):
        if self.check_connection():
            return self.connection.cursor()
        else:
            return None

    def execute_query(self, query, params=None, fetch_all=True, commit=False):
        cursor = self.get_cursor()
        if cursor:
            cursor.execute(query, params)
            if commit:
                print("COMMIT")
                self.connection.commit()
            if fetch_all:
                result = cursor.fetchall()
            else:
                result = cursor.fetchone()
            cursor.close()
            return result
        else:
            return None
        
    def last_insert_id(self):
        """Return the last inserted ID."""
        return self.connection.insert_id()
