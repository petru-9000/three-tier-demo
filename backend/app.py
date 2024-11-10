"""
Backend
"""
import os
from flask import Flask, jsonify
from flask_cors import CORS
import psycopg2

app = Flask(__name__)
CORS(app)

# Connect to PostgreSQL
def get_db_connection():
    """
    Get connection
    """
    conn = psycopg2.connect(
        host = os.environ['DB_FQDN'],
        dbname = os.environ['DB_NAME'],
        user = os.environ['DB_USER'],
        password = os.environ['DB_PASSWORD']
    )
    return conn

@app.route("/")
def hello_world():
    """
    Hello /
    """
    return "Hello Slash!"

@app.route('/api/records', methods=['GET'])
def get_records():
    """
    Get records
    """
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM records')
    records = cursor.fetchall()
    cursor.close()
    conn.close()

    # Return JSON response
    return jsonify(records)

if __name__ == '__main__':
    app.run(debug=True)
