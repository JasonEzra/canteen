-- Complete database creation
CREATE DATABASE IF NOT EXISTS canteen_system;
USE canteen_system;

-- Table definitions
CREATE TABLE clients (
    client_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
    -- Other fields...
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;