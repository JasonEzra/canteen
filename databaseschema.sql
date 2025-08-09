-- Database setup
CREATE DATABASE IF NOT EXISTS canteen_db;
USE canteen_db;

-- Clients table
CREATE TABLE clients (
    client_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Menu items
CREATE TABLE menu_items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    description TEXT,
    category ENUM('Food','Drink','Snack') NOT NULL,
    is_available BOOLEAN DEFAULT TRUE
);

-- Orders
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    client_id INT NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_price DECIMAL(10,2) NOT NULL,
    status ENUM('Pending','Preparing','Ready','Delivered') DEFAULT 'Pending',
    notes TEXT,
    FOREIGN KEY (client_id) REFERENCES clients(client_id)
);

-- Order items (junction table)
CREATE TABLE order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    item_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    special_requests TEXT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (item_id) REFERENCES menu_items(item_id)
);

-- Sample data
INSERT INTO clients (name, email, phone) VALUES 
('Acme Corporation', 'acme@example.com', '+1234567890'),
('John Smith', 'john@example.com', '+1987654321');

INSERT INTO menu_items (name, price, description, category) VALUES
('Chicken Sandwich', 8.99, 'Grilled chicken with veggies', 'Food'),
('Iced Coffee', 3.50, 'Cold brew with milk', 'Drink'),
('Chocolate Cake', 4.75, 'Homemade chocolate cake', 'Snack');

-- Create a view for order summaries
CREATE VIEW order_summary AS
SELECT o.order_id, c.name AS client, 
       COUNT(oi.item_id) AS items_count,
       o.total_price, o.status
FROM orders o
JOIN clients c ON o.client_id = c.client_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id;