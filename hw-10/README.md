
# HW-10 : Simple Docker Compose project

This guide sets up a Flask application with a MySQL database using Docker Compose.

## Project Structure

```
my-flask-app/
├── db_data/
├── app.py
├── requirements.txt
├── Dockerfile
├── docker-compose.yml
├── init.sql
```

## Steps

1. **Write Flask App (`app.py`)**
   - The app connects to MySQL and has routes for managing users.

2. **Write SQL Script for Database Initialization (`init.sql`)**
   - Creates the `flaskdb` database and a `users` table.

3. **Create `requirements.txt`**
   ```
   flask
   mysql-connector-python
   ```

4. **Create Dockerfile**
   ```dockerfile
   FROM python:3.11-slim

   WORKDIR /app

   COPY requirements.txt ./

   RUN pip install --no-cache-dir -r requirements.txt

   COPY . .

   EXPOSE 5000

   CMD ["flask", "run", "--host=0.0.0.0", "--port=5000"]
   ```

5. **Write Docker Compose Configuration (`docker-compose.yml`)**
   ```yaml
   version: '3.9'

   services:
     flask-app:
       build: .
       ports:
         - "8000:5000"
       environment:
         FLASK_ENV: development
       depends_on:
         - db

     db:
       image: mysql:8.0
       container_name: mysql-db
       restart: always
       environment:
         MYSQL_ROOT_PASSWORD: rootpassword
         MYSQL_DATABASE: flaskdb
       ports:
         - "3306:3306"
       volumes:
         - db_data:/var/lib/mysql
         - ./init.sql:/docker-entrypoint-initdb.d/init.sql

   volumes:
     db_data:
   ```

6. **Build and Run Containers**
   ```bash
   docker-compose up --build
   ```

7. **Test the Flask App**
   - Add a User (POST):
     ```bash
     curl -X POST -H "Content-Type: application/json" -d '{"name": "John", "email": "john@example.com"}' http://localhost:8000/users
     ```
   - Retrieve Users (GET):
     ```bash
     curl http://localhost:8000/users
     ```

## Notes

- MySQL database is initialized with the `init.sql` script.
- Flask app communicates with the MySQL container using the hostname `db`.
- Use Docker Compose for easy container management.
