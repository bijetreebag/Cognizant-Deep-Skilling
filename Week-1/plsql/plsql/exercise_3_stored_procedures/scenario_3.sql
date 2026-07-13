-- exercise_3_stored_procedures/scenario_3.sql
-- Scenario 3: Transfer funds between accounts with balance checking.
--
-- Business Logic:
-- Write a stored procedure TransferFunds that transfers a specified amount from one 
-- account to another, checking that the source account has sufficient balance 
-- before making the transfer.
--
-- Humanized Features:
-- - Validates that the amount is positive.
-- - Validates account existence.
-- - Performs a direct balance check before running any UPDATEs.
-- - Performs updates to Accounts.
-- - Inserts Audit Transactions for both deposit and withdrawal.
-- - Properly locks rows for safety and uses transaction control (COMMIT/ROLLBACK).

CREATE OR REPLACE PROCEDURE TransferFunds (
    p_from_account_id IN NUMBER,
    p_to_account_id   IN NUMBER,
    p_amount          IN NUMBER
) IS
    v_from_balance    NUMBER;
    v_to_balance      NUMBER;
    
    -- Custom Exceptions
    e_insufficient_funds EXCEPTION;
    e_invalid_amount     EXCEPTION;
    e_same_account       EXCEPTION;
    e_account_not_found  EXCEPTION;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- TransferFunds Request: $' || p_amount || ' from Account: ' || p_from_account_id || ' to ' || p_to_account_id || ' ---');
    
    -- 1. Parameter validation
    IF p_amount <= 0 OR p_amount IS NULL THEN
        RAISE e_invalid_amount;
    END IF;
    
    IF p_from_account_id = p_to_account_id THEN
        RAISE e_same_account;
    END IF;
    
    -- 2. Check and lock accounts
    BEGIN
        SELECT Balance INTO v_from_balance
        FROM Accounts
        WHERE AccountID = p_from_account_id
        FOR UPDATE;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE e_account_not_found;
    END;
    
    BEGIN
        SELECT Balance INTO v_to_balance
        FROM Accounts
        WHERE AccountID = p_to_account_id
        FOR UPDATE;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE e_account_not_found;
    END;
    
    -- 3. Verify sufficient balance
    IF v_from_balance < p_amount THEN
        RAISE e_insufficient_funds;
    END IF;
    
    -- 4. Update Balances
    UPDATE Accounts
    SET Balance = Balance - p_amount,
        LastModified = SYSDATE
    WHERE AccountID = p_from_account_id;
    
    UPDATE Accounts
    SET Balance = Balance + p_amount,
        LastModified = SYSDATE
    WHERE AccountID = p_to_account_id;
    
    -- 5. Record transactions
    INSERT INTO Transactions (TransactionID, AccountID, TransactionDate, Amount, TransactionType)
    VALUES ((SELECT NVL(MAX(TransactionID), 0) + 1 FROM Transactions), p_from_account_id, SYSDATE, p_amount, 'Withdrawal');
    
    INSERT INTO Transactions (TransactionID, AccountID, TransactionDate, Amount, TransactionType)
    VALUES ((SELECT NVL(MAX(TransactionID), 0) + 1 FROM Transactions), p_to_account_id, SYSDATE, p_amount, 'Deposit');
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('--- Success: Transfer of $' || p_amount || ' completed successfully. ---');
    DBMS_OUTPUT.PUT_LINE('  - Source Account ' || p_from_account_id || ' New Balance: $' || (v_from_balance - p_amount));
    DBMS_OUTPUT.PUT_LINE('  - Dest Account ' || p_to_account_id || ' New Balance: $' || (v_to_balance + p_amount));

EXCEPTION
    WHEN e_invalid_amount THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('--- Error: Transfer amount must be positive. ---');
    WHEN e_same_account THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('--- Error: Cannot transfer to/from the same account. ---');
    WHEN e_account_not_found THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('--- Error: One or both of the specified accounts do not exist. ---');
    WHEN e_insufficient_funds THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('--- Error: Transfer failed. Source account ' || p_from_account_id || ' has insufficient funds. Available: $' || v_from_balance || ' | Requested: $' || p_amount);
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('--- Error: Unexpected error occurred. ---');
        DBMS_OUTPUT.PUT_LINE('Error Code: ' || SQLCODE);
        DBMS_OUTPUT.PUT_LINE('Error Message: ' || SQLERRM);
END TransferFunds;
/
