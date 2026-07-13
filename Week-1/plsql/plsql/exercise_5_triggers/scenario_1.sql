-- exercise_5_triggers/scenario_1.sql
-- Scenario 1: Automatically update the last modified date.
--
-- Business Logic:
-- Write a trigger UpdateCustomerLastModified that updates the LastModified column 
-- of the Customers table to the current date whenever a customer's record is updated.
--
-- Humanized Features:
-- - Uses a BEFORE UPDATE trigger for row level modifications (FOR EACH ROW).
-- - Sets :NEW.LastModified to SYSDATE automatically.
-- - Avoids infinite recursion since it modifies the :NEW value BEFORE the row is written, 
--   which is the standard, high-performance way to handle audit timestamps in Oracle.

CREATE OR REPLACE TRIGGER UpdateCustomerLastModified
BEFORE UPDATE ON Customers
FOR EACH ROW
BEGIN
    -- Set the last modified timestamp to current date/time
    :NEW.LastModified := SYSDATE;
END;
/
