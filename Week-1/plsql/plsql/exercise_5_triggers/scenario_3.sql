-- exercise_5_triggers/scenario_3.sql
-- Scenario 3: Enforce business rules on deposits and withdrawals.
--
-- Business Logic:
-- Write a trigger CheckTransactionRules that ensures withdrawals do not exceed 
-- the balance and deposits are positive before inserting a record into the 
-- Transactions table.
--
-- Humanized Features:
-- - Uses a BEFORE INSERT trigger (FOR EACH ROW) to intercept and validate transactions 
--   before they are persisted.
-- - Validates that both deposits and withdrawals are positive amounts.
-- - For withdrawals, retrieves the current balance of the associated account from the 
--   Accounts table and prevents the transaction if the withdrawal exceeds the balance.
-- - Uses RAISE_APPLICATION_ERROR to return standardized, descriptive Oracle error messages.

CREATE OR REPLACE TRIGGER CheckTransactionRules
BEFORE INSERT ON Transactions
FOR EACH ROW
DECLARE
    v_current_balance NUMBER;
BEGIN
    -- 1. Enforce that transaction amounts must be strictly positive
    IF :NEW.Amount <= 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Transaction amount must be greater than zero. Provided: $' || :NEW.Amount);
    END IF;

    -- 2. Fetch the current balance of the target account
    BEGIN
        SELECT Balance INTO v_current_balance
        FROM Accounts
        WHERE AccountID = :NEW.AccountID;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20002, 'Transaction failed: Account ID ' || :NEW.AccountID || ' does not exist.');
    END;

    -- 3. Apply business rules based on transaction type
    IF :NEW.TransactionType = 'Deposit' THEN
        -- Deposit is already validated to be positive.
        NULL;
    ELSIF :NEW.TransactionType = 'Withdrawal' THEN
        -- Verify if the account has enough funds for the withdrawal
        IF v_current_balance < :NEW.Amount THEN
            RAISE_APPLICATION_ERROR(-20003, 'Transaction failed: Insufficient funds in Account ID ' || :NEW.AccountID || 
                                            '. Current Balance: $' || v_current_balance || 
                                            ' | Withdrawal Requested: $' || :NEW.Amount);
        END IF;
    ELSE
        -- Handle invalid transaction types
        RAISE_APPLICATION_ERROR(-20004, 'Transaction failed: Invalid TransactionType ' || :NEW.TransactionType || '. Must be ''Deposit'' or ''Withdrawal''.');
    END IF;
END;
/
