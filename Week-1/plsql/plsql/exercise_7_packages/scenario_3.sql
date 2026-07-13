-- exercise_7_packages/scenario_3.sql
-- Scenario 3: AccountOperations package specification and body.
--
-- Business Logic:
-- Create a package AccountOperations with:
-- 1. Procedure OpenAccount to open a new account.
-- 2. Procedure CloseAccount to close an account.
-- 3. Function GetTotalBalance to calculate a customer's total balance across all accounts.
--
-- Humanized Features:
-- - Separates package specification (interface) and body (implementation).
-- - Validates that the customer exists before opening a new account.
-- - Enforces business rules on CloseAccount: does not allow closing an account if it 
--   still contains funds (balance must be exactly 0 to close) to protect against accidental loss of funds.
-- - Performs a SUM on the Accounts table for GetTotalBalance, returning 0 if the customer has no accounts.
-- - Traps duplicates, negative starting balances, and invalid account types.

CREATE OR REPLACE PACKAGE AccountOperations AS
    -- Procedure to open a new account
    PROCEDURE OpenAccount(
        p_account_id    IN NUMBER,
        p_customer_id   IN NUMBER,
        p_account_type  IN VARCHAR2, -- 'Savings' or 'Checking'
        p_balance       IN NUMBER
    );

    -- Procedure to close an existing account
    PROCEDURE CloseAccount(
        p_account_id    IN NUMBER
    );

    -- Function to get the total balance of a customer across all their accounts
    FUNCTION GetTotalBalance(
        p_customer_id   IN NUMBER
    ) RETURN NUMBER;
END AccountOperations;
/

CREATE OR REPLACE PACKAGE BODY AccountOperations AS

    -- Implementation of OpenAccount
    PROCEDURE OpenAccount(
        p_account_id    IN NUMBER,
        p_customer_id   IN NUMBER,
        p_account_type  IN VARCHAR2,
        p_balance       IN NUMBER
    ) IS
        v_cust_exists   NUMBER;
        e_invalid_type  EXCEPTION;
        e_neg_balance   EXCEPTION;
        e_cust_not_found EXCEPTION;
    BEGIN
        -- 1. Validations
        IF p_account_type NOT IN ('Savings', 'Checking') THEN
            RAISE e_invalid_type;
        END IF;

        IF p_balance < 0 THEN
            RAISE e_neg_balance;
        END IF;

        SELECT COUNT(*) INTO v_cust_exists
        FROM Customers
        WHERE CustomerID = p_customer_id;

        IF v_cust_exists = 0 THEN
            RAISE e_cust_not_found;
        END IF;

        -- 2. Create the account
        INSERT INTO Accounts (AccountID, CustomerID, AccountType, Balance, LastModified)
        VALUES (p_account_id, p_customer_id, p_account_type, p_balance, SYSDATE);
        
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('AccountOperations.OpenAccount: Successfully opened account ID ' || p_account_id);
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('AccountOperations.OpenAccount: Error - Account ID ' || p_account_id || ' already exists.');
        WHEN e_invalid_type THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('AccountOperations.OpenAccount: Error - Account type must be ''Savings'' or ''Checking''.');
        WHEN e_neg_balance THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('AccountOperations.OpenAccount: Error - Initial balance cannot be negative.');
        WHEN e_cust_not_found THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('AccountOperations.OpenAccount: Error - Customer ID ' || p_customer_id || ' does not exist.');
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('AccountOperations.OpenAccount: Unexpected Error - ' || SQLERRM);
    END OpenAccount;

    -- Implementation of CloseAccount
    PROCEDURE CloseAccount(
        p_account_id    IN NUMBER
    ) IS
        v_balance       NUMBER;
        e_active_balance EXCEPTION;
    BEGIN
        -- 1. Fetch current account balance
        SELECT Balance INTO v_balance
        FROM Accounts
        WHERE AccountID = p_account_id;
        
        -- 2. Enforce that the account balance must be 0 to close
        IF v_balance != 0 THEN
            RAISE e_active_balance;
        END IF;

        -- 3. Delete the account
        DELETE FROM Accounts
        WHERE AccountID = p_account_id;
        
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('AccountOperations.CloseAccount: Successfully closed account ID ' || p_account_id);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('AccountOperations.CloseAccount: Error - Account ID ' || p_account_id || ' not found.');
        WHEN e_active_balance THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('AccountOperations.CloseAccount: Error - Cannot close account ID ' || p_account_id || 
                                 '. It still has an active balance of $' || TO_CHAR(v_balance, 'FM999,999.00') || 
                                 '. Please withdraw all funds first.');
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('AccountOperations.CloseAccount: Unexpected Error - ' || SQLERRM);
    END CloseAccount;

    -- Implementation of GetTotalBalance
    FUNCTION GetTotalBalance(
        p_customer_id   IN NUMBER
    ) RETURN NUMBER IS
        v_total_balance NUMBER;
    BEGIN
        -- Sum up balance from all accounts belonging to customer
        SELECT SUM(Balance) INTO v_total_balance
        FROM Accounts
        WHERE CustomerID = p_customer_id;
        
        RETURN NVL(v_total_balance, 0);
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('AccountOperations.GetTotalBalance: Unexpected Error - ' || SQLERRM);
            RETURN 0;
    END GetTotalBalance;

END AccountOperations;
/
