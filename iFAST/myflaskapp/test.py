from flask import Flask, request, render_template
import logging

app = Flask(__name__)

# Set up logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger()

@app.before_request
def before_request():
    forwarded_host = request.headers.get('X-Forwarded-Host')
    forwarded_port = request.headers.get('X-Forwarded-Port')
    if forwarded_host:
        app.config['SERVER_NAME'] = forwarded_host
    if forwarded_port:
        app.config['SERVER_PORT'] = forwarded_port

@app.route('/')
def index():
    logger.info(f"Request headers: {request.headers}")
    return 'Hello, World!'

@app.route('/test')
def test():
    return render_template('ifast_main.html')

@app.route('/landing_page')
def landing_page():
    return render_template('ifast_main.html')

@app.route('/logout')
def logout():
    return render_template('ifast_main.html')

@app.route('/fetch_kb')
def fetch_kb():
   return ""

@app.route('/fetch_issues')
def fetch_issues():
   return ""


if __name__ == '__main__':
    app.run(debug=True)  # Use debug=True to get more detailed logs

