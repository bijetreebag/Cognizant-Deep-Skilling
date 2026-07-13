-- exercise_6_cursors/scenario_1.sql
-- Scenario 1: Generate monthly statements for all customers.
--
-- Business Logic:
-- Write a PL/SQL block using an explicit cursor GenerateMonthlyStatements that 
-- retrieves all transactions for the current month and prints a statement for each customer.
--
-- Humanized Features:
-- - Uses a primary explicit cursor to iterate through all active customers.
-- - Uses a nested explicit cursor with parameters to fetch the current month's transactions 
--   for each customer's accounts.
-- - Filters transactions specifically within the current calendar month using TRUNC(TransactionDate, 'MM') = TRUNC(SYSDATE, 'MM').
-- - Generates a beautifully structured statement for each customer, summarizing their deposits, withdrawals, and ending balance.
-- - Handles accounts with no activity in the current month gracefully.

DECLARE
    -- Primary cursor: Retrieves all customers
    CURSOR c_customers IS
        SELECT CustomerID, Name, Balance
        FROM Customers;
        
    -- Nested parameterized cursor: Retrieves current month transactions for a customer
    CURSOR c_transactions(p_cust_id NUMBER) IS
        SELECT a.AccountID, a.AccountType, t.TransactionID, t.TransactionDate, t.Amount, t.TransactionType
        FROM Accounts a
        JOIN Transactions t ON a.AccountID = t.AccountID
        WHERE a.CustomerID = p_cust_id
          AND TRUNC(t.TransactionDate, 'MM') = TRUNC(SYSDATE, 'MM')
        ORDER BY t.TransactionDate ASC;
        
    v_cust_has_tx BOOLEAN;
BEGIN
    DBMS_OUTPUT.PUT_LINE('================================================================');
    DBMS_OUTPUT.PUT_LINE('         MONTHLY STATEMENTS FOR ' || TO_CHAR(SYSDATE, 'MONTH YYYY'));
    DBMS_OUTPUT.PUT_LINE('================================================================');
    
    -- Open primary customer cursor
    FOR r_cust IN c_customers LOOP
        DBMS_OUTPUT.PUT_LINE('CUSTOMER: ' || r_cust.Name || ' (ID: ' || r_cust.CustomerID || ')');
        DBMS_OUTPUT.PUT_LINE('Current Portfolio Balance: $' || TO_CHAR(r_cust.Balance, 'FM999,999.00'));
        DBMS_OUTPUT.PUT_LINE('----------------------------------------------------------------');
        DBMS_OUTPUT.PUT_LINE(RPAD('TX ID', 10) || RPAD('ACC ID', 10) || RPAD('TYPE', 12) || RPAD('DATE', 15) || LPAD('AMOUNT', 12));
        
        v_cust_has_tx := FALSE;
        
        -- Open nested transaction cursor for current customer
        FOR r_tx IN c_transactions(r_cust.CustomerID) LOOP
            v_cust_has_tx := TRUE;
            DBMS_OUTPUT.PUT_LINE(
                RPAD(TO_CHAR(r_tx.TransactionID), 10) || 
                RPAD(TO_CHAR(r_tx.AccountID), 10) || 
                RPAD(r_tx.AccountType, 12) || 
                RPAD(TO_CHAR(r_tx.TransactionDate, 'YYYY-MM-DD'), 15) || 
                LPAD(CASE WHEN r_tx.TransactionType = 'Withdrawal' THEN '-' ELSE '+' END || TO_CHAR(r_tx.Amount, 'FM999,999.00'), 12)
            );
        END LOOP;
        
        IF NOT v_cust_has_tx THEN
            DBMS_OUTPUT.PUT_LINE('   * No transaction activity recorded for this period.');
        END IF;
        
        DBMS_OUTPUT.PUT_LINE('================================================================');
    END LOOP;
END;
/
