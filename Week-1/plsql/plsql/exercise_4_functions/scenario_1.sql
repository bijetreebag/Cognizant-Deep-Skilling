-- exercise_4_functions/scenario_1.sql
-- Scenario 1: Calculate the age of customers.
--
-- Business Logic:
-- Write a function CalculateAge that takes a customer's date of birth as input 
-- and returns their age in years.
--
-- Humanized Features:
-- - Returns an integer representing the completed years of age.
-- - Employs MONTHS_BETWEEN and TRUNC to ensure exact calendar year boundaries 
--   are respected, matching real-world birthday milestones.
-- - Includes validation logic: returns NULL if DOB is null, or -1 if DOB is in the future.

CREATE OR REPLACE FUNCTION CalculateAge (
    p_dob IN DATE
) RETURN NUMBER IS
    v_age NUMBER;
BEGIN
    -- 1. Input validation
    IF p_dob IS NULL THEN
        RETURN NULL;
    END IF;
    
    IF p_dob > SYSDATE THEN
        -- Future date of birth is invalid
        RETURN -1;
    END IF;
    
    -- 2. Calculate completed years
    v_age := TRUNC(MONTHS_BETWEEN(SYSDATE, p_dob) / 12);
    
    RETURN v_age;
EXCEPTION
    WHEN OTHERS THEN
        -- Return NULL or handle error gracefully in a custom function
        RETURN NULL;
END CalculateAge;
/
