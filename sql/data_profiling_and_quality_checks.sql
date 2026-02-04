-- =====================================================
-- Project: Data Cleaning & Quality Assessment
-- Database: data_cleaning_project
-- Purpose: Data profiling, missing value detection,
--          duplicate identification, and staging
-- =====================================================

-- Use the correct database
USE data_cleaning_project;

-- -----------------------------------------------------
-- 1. Row count validation
-- -----------------------------------------------------
SELECT COUNT(*) AS total_rows
FROM operational_transactions_raw;

-- -----------------------------------------------------
-- 2. Table existence check
-- -----------------------------------------------------
SHOW TABLES;

-- -----------------------------------------------------
-- 3. Schema inspection
-- -----------------------------------------------------
DESCRIBE operational_transactions_raw;

-- -----------------------------------------------------
-- 4. Missing value profiling (NULL values only)
-- -----------------------------------------------------
SELECT
    SUM(transaction_id IS NULL) AS missing_transaction_id,
    SUM(order_date IS NULL) AS missing_order_date,
    SUM(customer_id IS NULL) AS missing_customer_id,
    SUM(customer_name IS NULL) AS missing_customer_name,
    SUM(region IS NULL) AS missing_region,
    SUM(product_category IS NULL) AS missing_product_category,
    SUM(quantity IS NULL) AS missing_quantity,
    SUM(unit_price IS NULL) AS missing_unit_price,
    SUM(total_amount IS NULL) AS missing_total_amount,
    SUM(payment_mode IS NULL) AS missing_payment_mode,
    SUM(order_status IS NULL) AS missing_order_status,
    SUM(created_timestamp IS NULL) AS missing_created_timestamp
FROM operational_transactions_raw;

-- -----------------------------------------------------
-- 5. Missing value profiling (NULL + empty strings)
-- -----------------------------------------------------
SELECT
    SUM(transaction_id IS NULL OR transaction_id = '') AS missing_transaction_id,
    SUM(order_date IS NULL OR order_date = '') AS missing_order_date,
    SUM(customer_id IS NULL OR customer_id = '') AS missing_customer_id,
    SUM(customer_name IS NULL OR customer_name = '') AS missing_customer_name,
    SUM(region IS NULL OR region = '') AS missing_region,
    SUM(product_category IS NULL OR product_category = '') AS missing_product_category,
    SUM(quantity IS NULL) AS missing_quantity,
    SUM(unit_price IS NULL) AS missing_unit_price,
    SUM(total_amount IS NULL) AS missing_total_amount,
    SUM(payment_mode IS NULL OR payment_mode = '') AS missing_payment_mode,
    SUM(order_status IS NULL OR order_status = '') AS missing_order_status,
    SUM(created_timestamp IS NULL OR created_timestamp = '') AS missing_created_timestamp
FROM operational_transactions_raw;

-- -----------------------------------------------------
-- 6. Duplicate detection in raw data
-- -----------------------------------------------------
SELECT
    transaction_id,
    COUNT(*) AS duplicate_count
FROM operational_transactions_raw
GROUP BY transaction_id
HAVING COUNT(*) > 1
LIMIT 10;

-- -----------------------------------------------------
-- 7. Create working copy for cleaning
-- -----------------------------------------------------
CREATE TABLE operational_transactions_cleaned AS
SELECT *
FROM operational_transactions_raw;

-- -----------------------------------------------------
-- 8. Validate duplicates in cleaned table
-- -----------------------------------------------------
SELECT
    transaction_id,
    COUNT(*) AS duplicate_count
FROM operational_transactions_cleaned
GROUP BY transaction_id
HAVING COUNT(*) > 1
LIMIT 10;
