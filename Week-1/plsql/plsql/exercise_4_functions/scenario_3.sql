-- exercise_4_functions/scenario_3.sql
-- Scenario 3: Verify if an account has sufficient balance.
--
-- Business Logic:
-- Write a function HasSufficientBalance that takes an account ID and an amount 
-- as input and returns a boolean indicating whether the account has at least 
-- the specified amount.
--
-- Humanized Features:
-- - Returns a standard PL/SQL BOOLEAN type.
-- - Performs validation for negative amounts.
-- - Traps NO_DATA_FOUND and returns FALSE (if the account doesn't exist, they don't have sufficient balance).
-- - Includes code commentary describing how to use this within PL/SQL blocks vs. SQL queries (which don't natively support PL/SQL BOOLEAN).

CREATE OR REPLACE FUNCTION HasSufficientBalance (
    p_account_id IN NUMBER,
    p_amount     IN NUMBER
) RETURN BOOLEAN IS
    v_balance    NUMBER;
BEGIN
    -- 1. Validate inputs
    IF p_account_id IS NULL OR p_amount IS NULL OR p_amount < 0 THEN
        RETURN FALSE;
    END IF;
    
    -- 2. Query balance for account
    SELECT Balance INTO v_balance
    FROM Accounts
    WHERE AccountID = p_account_id;
    
    -- 3. Check if balance meets requirement
    IF v_balance >= p_amount THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        -- If account doesn't exist, it has no balance
        RETURN FALSE;
    WHEN OTHERS THEN
        RETURN FALSE;
END HasSufficientBalance;
/
