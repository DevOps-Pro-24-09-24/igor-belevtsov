GRANT ALL ON flaskdb TO 'flask-app'@'%';
FLUSH PRIVILEGES;

USE flaskdb;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL
);
