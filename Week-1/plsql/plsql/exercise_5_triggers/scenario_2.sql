-- exercise_5_triggers/scenario_2.sql
-- Scenario 2: Maintain an audit log for all transactions.
--
-- Business Logic:
-- Write a trigger LogTransaction that inserts a record into an AuditLog table 
-- whenever a transaction is inserted into the Transactions table.
--
-- Humanized Features:
-- - Uses an AFTER INSERT trigger for row level modifications (FOR EACH ROW) since the 
--   transaction must be successfully inserted before we write to the audit log.
-- - Captures essential transaction data using :NEW values.
-- - Explicitly inserts into the AuditLog table created in our schema setup.

CREATE OR REPLACE TRIGGER LogTransaction
AFTER INSERT ON Transactions
FOR EACH ROW
BEGIN
    -- Log the details of the newly inserted transaction
    INSERT INTO AuditLog (
        TransactionID, 
        AccountID, 
        TransactionDate, 
        Amount, 
        TransactionType, 
        LogDate
    )
    VALUES (
        :NEW.TransactionID, 
        :NEW.AccountID, 
        :NEW.TransactionDate, 
        :NEW.Amount, 
        :NEW.TransactionType, 
        SYSDATE
    );
END;
/
