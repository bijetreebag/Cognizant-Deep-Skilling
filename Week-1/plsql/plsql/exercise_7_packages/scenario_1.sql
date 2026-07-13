-- exercise_7_packages/scenario_1.sql
-- Scenario 1: CustomerManagement package specification and body.
--
-- Business Logic:
-- Create a package CustomerManagement with:
-- 1. Stored procedure AddCustomer to insert a new customer.
-- 2. Stored procedure UpdateCustomer to update customer details (Name, DOB).
-- 3. Stored function GetCustomerBalance to retrieve the balance of a given customer.
--
-- Humanized Features:
-- - Separates package specification (interface) and body (implementation) clearly.
-- - Performs validations on inputs (e.g. non-null, non-negative balances).
-- - Handles exceptions such as duplicates (`DUP_VAL_ON_INDEX`) or missing entries (`NO_DATA_FOUND`).
-- - Logs execution details via `DBMS_OUTPUT`.

CREATE OR REPLACE PACKAGE CustomerManagement AS
    -- Procedure to add a new customer
    PROCEDURE AddCustomer(
        p_customer_id IN NUMBER,
        p_name        IN VARCHAR2,
        p_dob         IN DATE,
        p_balance     IN NUMBER
    );

    -- Procedure to update customer details (Name and DOB)
    PROCEDURE UpdateCustomer(
        p_customer_id IN NUMBER,
        p_name        IN VARCHAR2,
        p_dob         IN DATE
    );

    -- Function to get a customer's balance
    FUNCTION GetCustomerBalance(
        p_customer_id IN NUMBER
    ) RETURN NUMBER;
END CustomerManagement;
/

CREATE OR REPLACE PACKAGE BODY CustomerManagement AS

    -- Implementation of AddCustomer
    PROCEDURE AddCustomer(
        p_customer_id IN NUMBER,
        p_name        IN VARCHAR2,
        p_dob         IN DATE,
        p_balance     IN NUMBER
    ) IS
        e_negative_balance EXCEPTION;
    BEGIN
        IF p_balance < 0 THEN
            RAISE e_negative_balance;
        END IF;

        INSERT INTO Customers (CustomerID, Name, DOB, Balance, LastModified, IsVIP)
        VALUES (p_customer_id, p_name, p_dob, p_balance, SYSDATE, 'FALSE');
        
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('CustomerManagement.AddCustomer: Successfully added customer ID ' || p_customer_id);
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('CustomerManagement.AddCustomer: Error - Customer with ID ' || p_customer_id || ' already exists.');
        WHEN e_negative_balance THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('CustomerManagement.AddCustomer: Error - Opening balance cannot be negative.');
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('CustomerManagement.AddCustomer: Unexpected Error - ' || SQLERRM);
    END AddCustomer;

    -- Implementation of UpdateCustomer
    PROCEDURE UpdateCustomer(
        p_customer_id IN NUMBER,
        p_name        IN VARCHAR2,
        p_dob         IN DATE
    ) IS
    BEGIN
        UPDATE Customers
        SET Name = p_name,
            DOB = p_dob,
            LastModified = SYSDATE
        WHERE CustomerID = p_customer_id;
        
        IF SQL%ROWCOUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('CustomerManagement.UpdateCustomer: Warning - No customer found with ID ' || p_customer_id);
        ELSE
            COMMIT;
            DBMS_OUTPUT.PUT_LINE('CustomerManagement.UpdateCustomer: Successfully updated customer ID ' || p_customer_id);
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('CustomerManagement.UpdateCustomer: Unexpected Error - ' || SQLERRM);
    END UpdateCustomer;

    -- Implementation of GetCustomerBalance
    FUNCTION GetCustomerBalance(
        p_customer_id IN NUMBER
    ) RETURN NUMBER IS
        v_balance NUMBER;
    BEGIN
        SELECT Balance INTO v_balance
        FROM Customers
        WHERE CustomerID = p_customer_id;
        
        RETURN v_balance;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('CustomerManagement.GetCustomerBalance: Error - Customer ID ' || p_customer_id || ' not found.');
            RETURN NULL;
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('CustomerManagement.GetCustomerBalance: Unexpected Error - ' || SQLERRM);
            RETURN NULL;
    END GetCustomerBalance;

END CustomerManagement;
/
