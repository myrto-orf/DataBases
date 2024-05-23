DROP DATABASE IF EXISTS `user_auth`;
CREATE DATABASE user_auth;

USE user_auth;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    privilige ENUM('admin', 'cook', 'default') NOT NULL
);
