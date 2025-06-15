
---- Step 1: Create Tables
CREATE TABLE customer_data_1 (
    customer_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(30),
    address VARCHAR(255),
    city VARCHAR(50),
    state VARCHAR(50),
    zip_code VARCHAR(10),
    date_of_birth DATE
);

CREATE TABLE customer_data_2 (
    customer_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(30),
    address VARCHAR(255),
    city VARCHAR(50),
    state VARCHAR(50),
    zip_code VARCHAR(10),
    date_of_birth DATE
);

--- Step 2: Import CSV Data

COPY customer_data_1(full_name, email, phone, address, city, state, zip_code, date_of_birth)
FROM 'F:\HSE\Advance Data Management\Project\Step 04\customer_data_1.csv' DELIMITER ',' CSV HEADER;

COPY customer_data_2(full_name, email, phone, address, city, state, zip_code, date_of_birth)
FROM 'F:\HSE\Advance Data Management\Project\Step 04/customer_data_2.csv' DELIMITER ',' CSV HEADER;


SELECT * FROM customer_data_1;
SELECT * FROM customer_data_2;

-- Step 3: Assess Data Quality for customer_data_1
-- NULL check
SELECT * FROM customer_data_1
WHERE full_name IS NULL OR email IS NULL OR phone IS NULL;

-- Phone format analysis
SELECT phone FROM customer_data_1
WHERE phone !~ '^[0-9\-\(\) ]+$';

-- Duplicates on name + DOB
SELECT full_name, date_of_birth, COUNT(*)
FROM customer_data_1
GROUP BY full_name, date_of_birth
HAVING COUNT(*) > 1;

-- Assess Data Quality for customer_data_2
-- NULL check
SELECT * FROM customer_data_2
WHERE full_name IS NULL OR email IS NULL OR phone IS NULL;

-- Phone format analysis
SELECT phone FROM customer_data_2
WHERE phone !~ '^[0-9\-\(\) ]+$';

-- Duplicates on name + DOB
SELECT full_name, date_of_birth, COUNT(*)
FROM customer_data_1
GROUP BY full_name, date_of_birth
HAVING COUNT(*) > 1;



-- Step 4: Clean and Standardize Data

-- Normalize phone numbers (remove characters)
UPDATE customer_data_1
SET phone = REGEXP_REPLACE(phone, '[-()\s]', '', 'g');

UPDATE customer_data_2
SET phone = REGEXP_REPLACE(phone, '[-()\s]', '', 'g');

-- Lowercase name and email
UPDATE customer_data_1
SET full_name = LOWER(full_name), email = LOWER(email);

UPDATE customer_data_2
SET full_name = LOWER(full_name), email = LOWER(email);

-- Add cleaned phone column
ALTER TABLE customer_data_1 ADD COLUMN phone_cleaned VARCHAR(20);
ALTER TABLE customer_data_2 ADD COLUMN phone_cleaned VARCHAR(20);

-- Keep only digits
UPDATE customer_data_1
SET phone_cleaned = REGEXP_REPLACE(phone, '[^0-9]', '', 'g');

UPDATE customer_data_2
SET phone_cleaned = REGEXP_REPLACE(phone, '[^0-9]', '', 'g');

-- Remove invalid phone numbers
DELETE FROM customer_data_1
WHERE LENGTH(phone_cleaned) != 10;

DELETE FROM customer_data_2
WHERE LENGTH(phone_cleaned) != 10;

-- Update main phone and remove temp column
UPDATE customer_data_1 SET phone = phone_cleaned;
UPDATE customer_data_2 SET phone = phone_cleaned;

ALTER TABLE customer_data_1 DROP COLUMN phone_cleaned;
ALTER TABLE customer_data_2 DROP COLUMN phone_cleaned;

---Step 5: Match & Merge

-- Create combined table
CREATE TABLE combined_customers AS
SELECT * FROM customer_data_1
UNION ALL
SELECT * FROM customer_data_2;

-- Add match_group column
ALTER TABLE combined_customers ADD COLUMN match_group INT;

-- Use a CTE to generate match groups
WITH match_groups AS (
    SELECT 
        customer_id,
        MIN(customer_id) OVER (PARTITION BY email, date_of_birth) AS group_id
    FROM combined_customers
)
UPDATE combined_customers c
SET match_group = m.group_id
FROM match_groups m
WHERE c.customer_id = m.customer_id;


-- Step 6: Survivorship Logic (Golden Record)
CREATE TABLE golden_record_customers AS
SELECT 
    MIN(customer_id) AS master_id,
    MIN(full_name) AS full_name,
    MIN(email) AS email,
    MAX(phone) AS phone,
    MAX(address) AS address,
    MIN(city) AS city,
    MIN(state) AS state,
    MIN(zip_code) AS zip_code,
    MIN(date_of_birth) AS date_of_birth,
    match_group
FROM combined_customers
GROUP BY match_group;


-- 

SELECT * FROM golden_record_customers;



