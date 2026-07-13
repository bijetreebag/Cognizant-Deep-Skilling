-- exercise_1_control_structures/scenario_2.sql
-- Scenario 2: Promote customers to VIP status based on their balance.
--
-- Business Logic:
-- Write a PL/SQL block that iterates through all customers and sets a flag IsVIP to 'TRUE' 
-- for those with a balance over $10,000.
--
-- Humanized Features:
-- - Uses a cursor-based FOR loop to scan the Customers table.
-- - Performs a conditional UPDATE only if their balance exceeds 10,000 and they aren't already marked as VIP.
-- - Logs VIP status updates to the terminal.
-- - Commits transaction upon success and rolls back on exception.

DECLARE
    -- Cursor to select all customers
    CURSOR c_customers IS
        SELECT CustomerID, Name, Balance, IsVIP
        FROM Customers;
        
    v_updated_count NUMBER := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Starting VIP Promotion Process ---');
    
    FOR r_cust IN c_customers LOOP
        -- Check if balance is over 10,000
        IF r_cust.Balance > 10000 THEN
            IF r_cust.IsVIP = 'FALSE' OR r_cust.IsVIP IS NULL THEN
                UPDATE Customers
                SET IsVIP = 'TRUE',
                    LastModified = SYSDATE
                WHERE CustomerID = r_cust.CustomerID;
                
                v_updated_count := v_updated_count + 1;
                DBMS_OUTPUT.PUT_LINE('Customer ' || r_cust.Name || ' (ID: ' || r_cust.CustomerID || ') promoted to VIP. Balance: $' || r_cust.Balance);
            ELSE
                DBMS_OUTPUT.PUT_LINE('Customer ' || r_cust.Name || ' (ID: ' || r_cust.CustomerID || ') is already a VIP.');
            END IF;
        END IF;
    END LOOP;
    
    IF v_updated_count > 0 THEN
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('--- Success: ' || v_updated_count || ' customer(s) promoted to VIP. Transaction committed. ---');
    ELSE
        DBMS_OUTPUT.PUT_LINE('--- Info: No new customers qualified for VIP promotion. ---');
    END IF;
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('--- Error: VIP promotion process failed. Transaction rolled back. ---');
        DBMS_OUTPUT.PUT_LINE('Error Code: ' || SQLCODE);
        DBMS_OUTPUT.PUT_LINE('Error Message: ' || SQLERRM);
END;
/
