-- exercise_1_control_structures/scenario_3.sql
-- Scenario 3: Send reminders to customers whose loans are due within the next 30 days.
--
-- Business Logic:
-- Write a PL/SQL block that fetches all loans due in the next 30 days and prints a 
-- reminder message for each customer.
--
-- Humanized Features:
-- - Uses a clean JOIN between Loans and Customers to access customer names.
-- - Filters loans using a dynamic date range check (EndDate BETWEEN SYSDATE AND SYSDATE + 30).
-- - Outputs a highly readable and personalized customer reminder email/message draft.
-- - Handles empty results gracefully.

DECLARE
    -- Cursor to fetch loans due in the next 30 days along with customer info
    CURSOR c_due_loans IS
        SELECT c.Name, c.CustomerID, l.LoanID, l.LoanAmount, l.EndDate
        FROM Loans l
        JOIN Customers c ON l.CustomerID = c.CustomerID
        WHERE l.EndDate BETWEEN SYSDATE AND (SYSDATE + 30);
        
    v_found BOOLEAN := FALSE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Processing Loan Due Reminders (Next 30 Days) ---');
    
    FOR r_loan IN c_due_loans LOOP
        v_found := TRUE;
        DBMS_OUTPUT.PUT_LINE('--------------------------------------------------');
        DBMS_OUTPUT.PUT_LINE('TO: ' || r_loan.Name || ' (Customer ID: ' || r_loan.CustomerID || ')');
        DBMS_OUTPUT.PUT_LINE('SUBJECT: Loan Repayment Reminder - Loan ID: ' || r_loan.LoanID);
        DBMS_OUTPUT.PUT_LINE('Dear ' || r_loan.Name || ',');
        DBMS_OUTPUT.PUT_LINE('This is a friendly reminder that your loan with ID ' || r_loan.LoanID || 
                             ' of amount $' || TO_CHAR(r_loan.LoanAmount, 'FM999,999.00') || 
                             ' is due on ' || TO_CHAR(r_loan.EndDate, 'YYYY-MM-DD') || '.');
        DBMS_OUTPUT.PUT_LINE('Please ensure sufficient funds are available in your account to facilitate the payment.');
        DBMS_OUTPUT.PUT_LINE('Sincerely,');
        DBMS_OUTPUT.PUT_LINE('The Bank Customer Support Team');
    END LOOP;
    
    IF NOT v_found THEN
        DBMS_OUTPUT.PUT_LINE('--- Info: No loans are due within the next 30 days. ---');
    ELSE
        DBMS_OUTPUT.PUT_LINE('--------------------------------------------------');
        DBMS_OUTPUT.PUT_LINE('--- Process Complete: Reminders generated. ---');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('--- Error: Failed to generate loan reminders. ---');
        DBMS_OUTPUT.PUT_LINE('Error Code: ' || SQLCODE);
        DBMS_OUTPUT.PUT_LINE('Error Message: ' || SQLERRM);
END;
/
