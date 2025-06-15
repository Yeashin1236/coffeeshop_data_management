
-- Creating Table
-- Drop tables in reverse dependency order to avoid errors
DROP TABLE IF EXISTS OrderItem;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Product;
DROP TABLE IF EXISTS Location;
DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS Customer;

-- Customer Table
CREATE TABLE Customer (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Employee Table
CREATE TABLE Employee (
    employee_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    position VARCHAR(50),
    salary NUMERIC(10, 2),
    hired_date DATE
);

-- Location Table
CREATE TABLE Location (
    location_id SERIAL PRIMARY KEY,
    address TEXT,
    city VARCHAR(50),
    state VARCHAR(50),
    zip_code VARCHAR(10)
);

-- Product Table
CREATE TABLE Product (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    category VARCHAR(50),
    price NUMERIC(10,2)
);

-- Orders Table
CREATE TABLE Orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT,
    employee_id INT,
    location_id INT,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    CONSTRAINT fk_orders_employee
        FOREIGN KEY (employee_id) REFERENCES Employee(employee_id),
    CONSTRAINT fk_orders_location
        FOREIGN KEY (location_id) REFERENCES Location(location_id)
);

-- OrderItem Table
CREATE TABLE OrderItem (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    item_price NUMERIC(10,2),
    CONSTRAINT fk_orderitem_order
        FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    CONSTRAINT fk_orderitem_product
        FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

--- Inserting the Data

-- Sample for Customers (only first 10 shown, extend pattern as needed)
INSERT INTO Customer (name, email, phone) VALUES
('Alice Smith', 'alice@example.com', '1234567890'),
('Bob Johnson', 'bob@example.com', '0987654321'),
('Charlie Lee', 'charlie@example.com', '1112223333'),
('David Kim', 'david@example.com', '4445556666'),
('Eva Green', 'eva@example.com', '7778889999'),
('Frank Wright', 'frank@example.com', '2223334444'),
('Grace Adams', 'grace@example.com', '5556667777'),
('Hannah Hill', 'hannah@example.com', '8889990000'),
('Ian Black', 'ian@example.com', '3334445555'),
('Jane Carter', 'jane@example.com', '6667778888');


-- Sample for Employees (first 5 shown)
INSERT INTO Employee (name, position, salary, hired_date) VALUES
('John Doe', 'Barista', 2500.00, '2023-04-01'),
('Jane Doe', 'Cashier', 2300.00, '2023-05-10'),
('Mike Ross', 'Manager', 3500.00, '2022-12-15'),
('Rachel Zane', 'Barista', 2600.00, '2023-01-10'),
('Harvey Specter', 'Supervisor', 4000.00, '2022-10-05');

-- Sample for Locations
INSERT INTO Location (address, city, state, zip_code) VALUES
('123 Main St', 'New York', 'NY', '10001'),
('456 Elm St', 'Los Angeles', 'CA', '90001'),
('789 Pine St', 'Chicago', 'IL', '60601'),
('321 Oak St', 'Houston', 'TX', '77001'),
('654 Maple Ave', 'Phoenix', 'AZ', '85001');

-- Sample for Products
INSERT INTO Product (name, category, price) VALUES
('Espresso', 'Coffee', 3.50),
('Croissant', 'Pastry', 2.00),
('Cappuccino', 'Coffee', 4.00),
('Bagel', 'Snack', 1.50),
('Latte', 'Coffee', 4.50),
('Muffin', 'Pastry', 2.50),
('Americano', 'Coffee', 3.00),
('Tea', 'Drink', 2.20),
('Donut', 'Pastry', 1.80),
('Smoothie', 'Drink', 5.00);

-- Sample for Orders
INSERT INTO Orders (customer_id, employee_id, location_id) VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 3),
(4, 4, 4),
(5, 5, 5),
(6, 1, 1),
(7, 2, 2),
(8, 3, 3),
(9, 4, 4),
(10, 5, 5);


-- Sample for OrderItems
INSERT INTO OrderItem (order_id, product_id, quantity, item_price) VALUES
(1, 1, 2, 7.00),
(1, 2, 1, 2.00),
(2, 3, 1, 4.00),
(2, 4, 2, 3.00),
(3, 5, 1, 4.50),
(3, 6, 2, 5.00),
(4, 7, 1, 3.00),
(4, 8, 1, 2.20),
(5, 9, 2, 3.60),
(5, 10, 1, 5.00);







