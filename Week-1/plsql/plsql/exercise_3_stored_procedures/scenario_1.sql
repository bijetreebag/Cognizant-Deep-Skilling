-- exercise_3_stored_procedures/scenario_1.sql
-- Scenario 1: Process monthly interest for savings accounts.
--
-- Business Logic:
-- Write a stored procedure ProcessMonthlyInterest that calculates and updates the 
-- balance of all savings accounts by applying an interest rate of 1% to the current balance.
--
-- Humanized Features:
-- - Uses a cursor-based FOR loop with FOR UPDATE locks to ensure safe concurrent execution.
-- - Also updates the parent Customer's balance to ensure data consistency between the 
--   Accounts and Customers tables.
-- - Logs the number of savings accounts updated and the total interest disbursed.
-- - Employs transactions (COMMIT on success, ROLLBACK on exception).

CREATE OR REPLACE PROCEDURE ProcessMonthlyInterest IS
    v_updated_count NUMBER := 0;
    v_total_interest NUMBER := 0;
    
    -- Cursor to log individual updates for audit purposes
    CURSOR c_savings_accounts IS
        SELECT AccountID, CustomerID, Balance
        FROM Accounts
        WHERE AccountType = 'Savings'
        FOR UPDATE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Processing Monthly Savings Interest (1% Rate) ---');
    
    FOR r_acc IN c_savings_accounts LOOP
        DECLARE
            v_interest NUMBER;
        BEGIN
            v_interest := r_acc.Balance * 0.01;
            v_total_interest := v_total_interest + v_interest;
            
            -- 1. Update Accounts table
            UPDATE Accounts
            SET Balance = Balance + v_interest,
                LastModified = SYSDATE
            WHERE AccountID = r_acc.AccountID;
            
            -- 2. Update Customers table (synchronized balance)
            UPDATE Customers
            SET Balance = Balance + v_interest,
                LastModified = SYSDATE
            WHERE CustomerID = r_acc.CustomerID;
            
            v_updated_count := v_updated_count + 1;
            DBMS_OUTPUT.PUT_LINE('Account ID: ' || r_acc.AccountID || ' | Owner Customer ID: ' || r_acc.CustomerID || 
                                 ' | Interest Earned: $' || TO_CHAR(v_interest, 'FM999,999.00') || 
                                 ' | New Balance: $' || TO_CHAR(r_acc.Balance + v_interest, 'FM999,999.00'));
        END;
    END LOOP;
    
    IF v_updated_count > 0 THEN
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('--- Success: Monthly interest processed. ---');
        DBMS_OUTPUT.PUT_LINE('  - Accounts Updated: ' || v_updated_count);
        DBMS_OUTPUT.PUT_LINE('  - Total Interest Disbursed: $' || TO_CHAR(v_total_interest, 'FM999,999.00'));
    ELSE
        DBMS_OUTPUT.PUT_LINE('--- Info: No savings accounts found to process. ---');
    END IF;
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('--- Error: Monthly interest processing failed. ---');
        DBMS_OUTPUT.PUT_LINE('Error Code: ' || SQLCODE);
        DBMS_OUTPUT.PUT_LINE('Error Message: ' || SQLERRM);
END ProcessMonthlyInterest;
/
