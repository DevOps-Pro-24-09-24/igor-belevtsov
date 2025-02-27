import mysql.connector
import os
from flask import Flask, request, jsonify
from mysql.connector import Error

app = Flask(__name__)

# Database connection function
def get_db_connection():
    try:
        connection = mysql.connector.connect(
            host=os.environ["MYSQL_HOST"],
            user=os.environ["MYSQL_USER"],
            password=os.environ["MYSQL_PASSWORD"],
            database=os.environ["MYSQL_DB"],
        )
        return connection
    except Error as e:
        print(f"Error: {e}")
        return None


@app.route("/")
def home():
    return f"Welcome to the flask app server with MySQL! \n"


@app.route("/health")
def health():
    return jsonify(status="OK"), 200


@app.route("/users", methods=["GET", "POST"])
def manage_users():
    if request.method == "POST":
        data = request.json
        name = data.get("name")
        email = data.get("email")
        connection = get_db_connection()
        if connection:
            cursor = connection.cursor()
            cursor.execute(
                "INSERT INTO users (name, email) VALUES (%s, %s)", (name, email)
            )
            connection.commit()
            connection.close()
            return jsonify({"message": "User added!"}), 201
        return jsonify({"error": "Database connection failed"}), 500

    elif request.method == "GET":
        connection = get_db_connection()
        if connection:
            cursor = connection.cursor(dictionary=True)
            cursor.execute("SELECT * FROM users")
            users = cursor.fetchall()
            connection.close()
            return jsonify(users), 200
        return jsonify({"error": "Database connection failed"}), 500


if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0")
