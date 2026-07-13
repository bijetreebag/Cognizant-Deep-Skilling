-- exercise_6_cursors/scenario_2.sql
-- Scenario 2: Apply annual fee to all accounts.
--
-- Business Logic:
-- Write a PL/SQL block using an explicit cursor ApplyAnnualFee that deducts 
-- an annual maintenance fee from the balance of all accounts.
--
-- Humanized Features:
-- - Uses a flat annual maintenance fee of $20.00 (configured as a constant).
-- - Implements a cursor FOR loop with FOR UPDATE to safely lock accounts during deduction.
-- - Synchronizes the Customer table balance by deducting the same fee from the customer's aggregate balance.
-- - Captures account balances and records a 'Withdrawal' transaction representing the 'Annual Fee'.
-- - Explicitly flags accounts that fall below $0 as a warning.
-- - Commits transaction upon success and rolls back on exception.

DECLARE
    -- Constant for the annual maintenance fee
    c_annual_fee CONSTANT NUMBER := 20.00;
    
    -- Explicit cursor to select all accounts for fee application
    CURSOR c_apply_annual_fee IS
        SELECT AccountID, CustomerID, Balance
        FROM Accounts
        FOR UPDATE;
        
    v_updated_count NUMBER := 0;
    v_tx_id NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Starting Annual Maintenance Fee Application ---');
    DBMS_OUTPUT.PUT_LINE('Fee Amount: $' || TO_CHAR(c_annual_fee, 'FM99.00'));
    
    -- Fetch the starting Transaction ID
    SELECT NVL(MAX(TransactionID), 0) INTO v_tx_id FROM Transactions;
    
    FOR r_acc IN c_apply_annual_fee LOOP
        -- 1. Deduct fee from account balance
        UPDATE Accounts
        SET Balance = Balance - c_annual_fee,
            LastModified = SYSDATE
        WHERE CURRENT OF c_apply_annual_fee;
        
        -- 2. Deduct fee from corresponding customer balance (to maintain synchronization)
        UPDATE Customers
        SET Balance = Balance - c_annual_fee,
            LastModified = SYSDATE
        WHERE CustomerID = r_acc.CustomerID;
        
        -- 3. Record the transaction in the Transactions table
        v_tx_id := v_tx_id + 1;
        INSERT INTO Transactions (TransactionID, AccountID, TransactionDate, Amount, TransactionType)
        VALUES (v_tx_id, r_acc.AccountID, SYSDATE, c_annual_fee, 'Withdrawal');
        
        v_updated_count := v_updated_count + 1;
        
        -- Log progress and flag warning if account is overdrawn
        IF (r_acc.Balance - c_annual_fee) < 0 THEN
            DBMS_OUTPUT.PUT_LINE('Account ID: ' || r_acc.AccountID || ' | Owner: ' || r_acc.CustomerID ||
                                 ' | New Bal: $' || TO_CHAR(r_acc.Balance - c_annual_fee, 'FM999,999.00') || 
                                 ' [WARNING: Account Overdrawn!]');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Account ID: ' || r_acc.AccountID || ' | Owner: ' || r_acc.CustomerID ||
                                 ' | New Bal: $' || TO_CHAR(r_acc.Balance - c_annual_fee, 'FM999,999.00'));
        END IF;
    END LOOP;
    
    IF v_updated_count > 0 THEN
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('--- Success: Annual fees successfully applied to ' || v_updated_count || ' account(s). Transaction committed. ---');
    ELSE
        DBMS_OUTPUT.PUT_LINE('--- Info: No accounts found to process. ---');
    END IF;
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('--- Error: Fee application process failed. Transaction rolled back. ---');
        DBMS_OUTPUT.PUT_LINE('Error Code: ' || SQLCODE);
        DBMS_OUTPUT.PUT_LINE('Error Message: ' || SQLERRM);
END;
/
