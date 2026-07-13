-- exercise_2_error_handling/scenario_3.sql
-- Scenario 3: Prevent duplicate customer IDs using exception handling.
--
-- Business Logic:
-- Write a stored procedure AddNewCustomer that inserts a new customer into the 
-- Customers table. If a customer with the same ID already exists, handle the 
-- exception by logging an error and preventing the insertion.
--
-- Humanized Features:
-- - Specifically traps the predefined exception DUP_VAL_ON_INDEX.
-- - Performs validation on essential fields (e.g. balance cannot be negative on registration).
-- - Standardizes date inputs and logs successful customer additions.
-- - Includes custom error handling for all potential validation errors.

CREATE OR REPLACE PROCEDURE AddNewCustomer (
    p_customer_id IN NUMBER,
    p_name        IN VARCHAR2,
    p_dob         IN DATE,
    p_balance     IN NUMBER
) IS
    -- Custom Exceptions
    e_negative_balance EXCEPTION;
    e_missing_details  EXCEPTION;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Attempting to Add New Customer (ID: ' || p_customer_id || ', Name: ' || p_name || ') ---');

    -- 1. Validations
    IF p_customer_id IS NULL OR p_name IS NULL OR p_dob IS NULL OR p_balance IS NULL THEN
        RAISE e_missing_details;
    END IF;
    
    IF p_balance < 0 THEN
        RAISE e_negative_balance;
    END IF;

    -- 2. Insert execution
    INSERT INTO Customers (CustomerID, Name, DOB, Balance, LastModified, IsVIP)
    VALUES (p_customer_id, p_name, p_dob, p_balance, SYSDATE, 'FALSE');
    
    -- Commit the insert
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('--- Success: Customer added successfully. ---');

EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('--- Error: Customer insertion aborted. A customer with ID ' || p_customer_id || ' already exists in the database. ---');
    WHEN e_negative_balance THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('--- Error: Opening balance cannot be negative (Requested: $' || p_balance || '). ---');
    WHEN e_missing_details THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('--- Error: Customer ID, Name, Date of Birth, and Opening Balance are all required fields. ---');
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('--- Error: Unexpected failure during customer insertion. ---');
        DBMS_OUTPUT.PUT_LINE('Error Code: ' || SQLCODE);
        DBMS_OUTPUT.PUT_LINE('Error Message: ' || SQLERRM);
END AddNewCustomer;
/
