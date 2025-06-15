-- 1. Drop existing tables (if they exist)
DROP TABLE IF EXISTS DataRoleCRUD, DataProcessCRUD, ResourceRoleCRUD CASCADE;
DROP TABLE IF EXISTS Person, Role, Permission, DataEntity, Process, Resource CASCADE;

-- 2. Create core entity tables
CREATE TABLE Role (
    role_id SERIAL PRIMARY KEY,
    role_name VARCHAR(50) UNIQUE
);

CREATE TABLE Person (
    person_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    role_id INT REFERENCES Role(role_id)
);

CREATE TABLE Permission (
    permission_id SERIAL PRIMARY KEY,
    permission_name VARCHAR(10) -- C, R, U, D
);

CREATE TABLE DataEntity (
    entity_id SERIAL PRIMARY KEY,
    entity_name VARCHAR(50)
);

CREATE TABLE Process (
    process_id SERIAL PRIMARY KEY,
    process_name VARCHAR(100)
);

CREATE TABLE Resource (
    resource_id SERIAL PRIMARY KEY,
    resource_name VARCHAR(100)
);

-- 3. Insert values

-- Roles
INSERT INTO Role (role_name) VALUES
('Manager'),         -- role_id = 1
('Barista'),         -- role_id = 2
('Cashier'),         -- role_id = 3
('Inventory Staff'), -- role_id = 4
('Admin');           -- role_id = 5

-- Permissions
INSERT INTO Permission (permission_name) VALUES
('C'), -- 1: Create
('R'), -- 2: Read
('U'), -- 3: Update
('D'); -- 4: Delete

-- Data Entities
INSERT INTO DataEntity (entity_name) VALUES
('Customer'),   -- 1
('Order'),      -- 2
('Product'),    -- 3
('Employee'),   -- 4
('Feedback'),   -- 5
('Inventory');  -- 6

-- Processes
INSERT INTO Process (process_name) VALUES
('Order Management'),     -- 1
('Inventory Management'), -- 2
('Staff Management'),     -- 3
('Sales Tracking'),       -- 4
('Customer Feedback');    -- 5

-- Resources
INSERT INTO Resource (resource_name) VALUES
('POS System'),           -- 1
('Inventory Database'),   -- 2
('Staff Schedule System'),-- 3
('Feedback Portal'),      -- 4
('Financial Reports');    -- 5

-- 4. Create CRUD Matrix Tables

-- A. Data to Role CRUD Matrix
CREATE TABLE DataRoleCRUD (
    id SERIAL PRIMARY KEY,
    role_id INT REFERENCES Role(role_id),
    entity_id INT REFERENCES DataEntity(entity_id),
    permission_id INT REFERENCES Permission(permission_id)
);

-- B. Data to Process CRUD Matrix
CREATE TABLE DataProcessCRUD (
    id SERIAL PRIMARY KEY,
    process_id INT REFERENCES Process(process_id),
    entity_id INT REFERENCES DataEntity(entity_id),
    permission_id INT REFERENCES Permission(permission_id)
);

-- C. Resource to Role CRUD Matrix
CREATE TABLE ResourceRoleCRUD (
    id SERIAL PRIMARY KEY,
    role_id INT REFERENCES Role(role_id),
    resource_id INT REFERENCES Resource(resource_id),
    permission_id INT REFERENCES Permission(permission_id)
);

--- Data-to-Role CRUD Matrix Inserts
-- Manager full access to Orders
INSERT INTO DataRoleCRUD (role_id, entity_id, permission_id) VALUES (1, 2, 1);
INSERT INTO DataRoleCRUD (role_id, entity_id, permission_id) VALUES (1, 2, 2);
INSERT INTO DataRoleCRUD (role_id, entity_id, permission_id) VALUES (1, 2, 3);
INSERT INTO DataRoleCRUD (role_id, entity_id, permission_id) VALUES (1, 2, 4);

-- Cashier can Create and Read Orders
INSERT INTO DataRoleCRUD (role_id, entity_id, permission_id) VALUES (3, 2, 1);
INSERT INTO DataRoleCRUD (role_id, entity_id, permission_id) VALUES (3, 2, 2);

-- Inventory Staff Read/Update Products
INSERT INTO DataRoleCRUD (role_id, entity_id, permission_id) VALUES (4, 3, 2);
INSERT INTO DataRoleCRUD (role_id, entity_id, permission_id) VALUES (4, 3, 3);

-- Barista can Read Orders and Update Inventory
INSERT INTO DataRoleCRUD (role_id, entity_id, permission_id) VALUES (2, 2, 2);
INSERT INTO DataRoleCRUD (role_id, entity_id, permission_id) VALUES (2, 6, 3);


--- Data-to-Process CRUD Matrix Inserts
-- Order Management handles Orders (CRUD)
INSERT INTO DataProcessCRUD (process_id, entity_id, permission_id) VALUES (1, 2, 1);
INSERT INTO DataProcessCRUD (process_id, entity_id, permission_id) VALUES (1, 2, 2);
INSERT INTO DataProcessCRUD (process_id, entity_id, permission_id) VALUES (1, 2, 3);
INSERT INTO DataProcessCRUD (process_id, entity_id, permission_id) VALUES (1, 2, 4);

-- Inventory Management updates Products and Inventory
INSERT INTO DataProcessCRUD (process_id, entity_id, permission_id) VALUES (2, 3, 3);
INSERT INTO DataProcessCRUD (process_id, entity_id, permission_id) VALUES (2, 6, 3);

-- Staff Management updates Employees
INSERT INTO DataProcessCRUD (process_id, entity_id, permission_id) VALUES (3, 4, 3);

-- Customer Feedback reads/writes Feedback
INSERT INTO DataProcessCRUD (process_id, entity_id, permission_id) VALUES (5, 5, 1);
INSERT INTO DataProcessCRUD (process_id, entity_id, permission_id) VALUES (5, 5, 2);


---  Resource-to-Role CRUD Matrix Inserts

-- Cashier reads POS System
INSERT INTO ResourceRoleCRUD (role_id, resource_id, permission_id) VALUES (3, 1, 2);

-- Manager full access to Financial Reports
INSERT INTO ResourceRoleCRUD (role_id, resource_id, permission_id) VALUES (1, 5, 2);
INSERT INTO ResourceRoleCRUD (role_id, resource_id, permission_id) VALUES (1, 5, 3);
INSERT INTO ResourceRoleCRUD (role_id, resource_id, permission_id) VALUES (1, 5, 4);

-- Inventory Staff read/write to Inventory DB
INSERT INTO ResourceRoleCRUD (role_id, resource_id, permission_id) VALUES (4, 2, 2);
INSERT INTO ResourceRoleCRUD (role_id, resource_id, permission_id) VALUES (4, 2, 3);

-- Admin has full access to Staff Schedule System
INSERT INTO ResourceRoleCRUD (role_id, resource_id, permission_id) VALUES (5, 3, 1);
INSERT INTO ResourceRoleCRUD (role_id, resource_id, permission_id) VALUES (5, 3, 2);
INSERT INTO ResourceRoleCRUD (role_id, resource_id, permission_id) VALUES (5, 3, 3);
INSERT INTO ResourceRoleCRUD (role_id, resource_id, permission_id) VALUES (5, 3, 4);

----- View: Data-to-Role CRUD Matrix
SELECT 
    r.role_name,
    d.entity_name,
    p.permission_name AS access_type
FROM DataRoleCRUD dr
JOIN Role r ON dr.role_id = r.role_id
JOIN DataEntity d ON dr.entity_id = d.entity_id
JOIN Permission p ON dr.permission_id = p.permission_id
ORDER BY r.role_name, d.entity_name;


--- View: Data-to-Process CRUD Matrix
SELECT 
    pr.process_name,
    d.entity_name,
    p.permission_name AS access_type
FROM DataProcessCRUD dp
JOIN Process pr ON dp.process_id = pr.process_id
JOIN DataEntity d ON dp.entity_id = d.entity_id
JOIN Permission p ON dp.permission_id = p.permission_id
ORDER BY pr.process_name, d.entity_name;

--- View: Resource-to-Role CRUD Matrix

SELECT 
    r.role_name,
    res.resource_name,
    p.permission_name AS access_type
FROM ResourceRoleCRUD rr
JOIN Role r ON rr.role_id = r.role_id
JOIN Resource res ON rr.resource_id = res.resource_id
JOIN Permission p ON rr.permission_id = p.permission_id
ORDER BY r.role_name, res.resource_name;



