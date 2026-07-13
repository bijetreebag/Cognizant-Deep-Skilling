-- exercise_2_error_handling/scenario_1.sql
-- Scenario 1: SafeTransferFunds stored procedure with comprehensive error handling.
--
-- Business Logic:
-- Write a stored procedure SafeTransferFunds that transfers funds between two accounts. 
-- Ensure that if any error occurs (e.g., insufficient funds, non-existent accounts), 
-- an appropriate error message is logged and the transaction is rolled back.
--
-- Humanized Features:
-- - Implements explicit parameter validation (positive transfer amount).
-- - Validates account existence using SELECT FOR UPDATE to prevent race conditions (locking the rows).
-- - Handles insufficient funds using a user-defined exception.
-- - Catches OTHERS to rollback any failures (including unexpected DB errors like connection loss, etc.).
-- - Promotes transactional integrity via explicit COMMIT/ROLLBACK control.

CREATE OR REPLACE PROCEDURE SafeTransferFunds (
    p_source_acc_id IN NUMBER,
    p_dest_acc_id   IN NUMBER,
    p_amount        IN NUMBER
) IS
    v_source_bal    NUMBER;
    v_dest_bal      NUMBER;
    
    -- Custom Exceptions
    e_insufficient_funds EXCEPTION;
    e_invalid_amount     EXCEPTION;
    e_same_account       EXCEPTION;
    e_account_not_found  EXCEPTION;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Transfer Request: $' || p_amount || ' from Account ID: ' || p_source_acc_id || ' to ' || p_dest_acc_id || ' ---');
    
    -- 1. Parameter Validation
    IF p_amount <= 0 THEN
        RAISE e_invalid_amount;
    END IF;
    
    IF p_source_acc_id = p_dest_acc_id THEN
        RAISE e_same_account;
    END IF;

    -- 2. Check and lock source account (FOR UPDATE)
    BEGIN
        SELECT Balance INTO v_source_bal
        FROM Accounts
        WHERE AccountID = p_source_acc_id
        FOR UPDATE;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE e_account_not_found;
    END;

    -- 3. Check and lock destination account (FOR UPDATE)
    BEGIN
        SELECT Balance INTO v_dest_bal
        FROM Accounts
        WHERE AccountID = p_dest_acc_id
        FOR UPDATE;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE e_account_not_found;
    END;

    -- 4. Check for sufficient funds
    IF v_source_bal < p_amount THEN
        RAISE e_insufficient_funds;
    END IF;

    -- 5. Perform the transfer
    UPDATE Accounts
    SET Balance = Balance - p_amount, LastModified = SYSDATE
    WHERE AccountID = p_source_acc_id;

    UPDATE Accounts
    SET Balance = Balance + p_amount, LastModified = SYSDATE
    WHERE AccountID = p_dest_acc_id;

    -- 6. Log the transaction
    -- Insert withdrawal transaction
    INSERT INTO Transactions (TransactionID, AccountID, TransactionDate, Amount, TransactionType)
    VALUES (
        (SELECT NVL(MAX(TransactionID), 0) + 1 FROM Transactions), 
        p_source_acc_id, 
        SYSDATE, 
        p_amount, 
        'Withdrawal'
    );

    -- Insert deposit transaction
    INSERT INTO Transactions (TransactionID, AccountID, TransactionDate, Amount, TransactionType)
    VALUES (
        (SELECT NVL(MAX(TransactionID), 0) + 1 FROM Transactions), 
        p_dest_acc_id, 
        SYSDATE, 
        p_amount, 
        'Deposit'
    );

    -- Commit if everything went fine
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('--- Success: Transfer completed and transaction committed. ---');

EXCEPTION
    WHEN e_invalid_amount THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('--- Error: Transfer amount must be positive. Transaction rolled back. ---');
    WHEN e_same_account THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('--- Error: Source and destination accounts cannot be the same. Transaction rolled back. ---');
    WHEN e_account_not_found THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('--- Error: One or both Account IDs do not exist. Transaction rolled back. ---');
    WHEN e_insufficient_funds THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('--- Error: Insufficient funds in Source Account (ID: ' || p_source_acc_id || '). Available: $' || v_source_bal || '. Transaction rolled back. ---');
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('--- Error: Unexpected failure occurred. Transaction rolled back. ---');
        DBMS_OUTPUT.PUT_LINE('Error Code: ' || SQLCODE);
        DBMS_OUTPUT.PUT_LINE('Error Message: ' || SQLERRM);
END SafeTransferFunds;
/
