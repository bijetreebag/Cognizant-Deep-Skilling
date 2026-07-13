-- exercise_4_functions/scenario_2.sql
-- Scenario 2: Compute monthly installment for a loan (EMI).
--
-- Business Logic:
-- Write a function CalculateMonthlyInstallment that takes the loan amount, 
-- interest rate (annual percentage), and loan duration in years as input and 
-- returns the monthly installment amount.
--
-- Formula used:
-- Monthly Installment = [P * r * (1 + r)^n] / [(1 + r)^n - 1]
-- where:
-- P = Principal loan amount (p_loan_amount)
-- r = Monthly interest rate = (p_interest_rate / 12) / 100
-- n = Total number of monthly installments = p_duration_years * 12
--
-- Humanized Features:
-- - Handles the division-by-zero edge case where interest rate is 0% (returns flat rate: P/n).
-- - Validates that loan amount, interest rate, and duration are positive.
-- - Rounds the output to 2 decimal places to represent standard currency format.

CREATE OR REPLACE FUNCTION CalculateMonthlyInstallment (
    p_loan_amount     IN NUMBER,
    p_interest_rate   IN NUMBER, -- Annual Interest Rate (e.g., 5.0 for 5%)
    p_duration_years  IN NUMBER  -- Duration in Years
) RETURN NUMBER IS
    v_monthly_payment NUMBER;
    v_monthly_rate    NUMBER;
    v_total_months    NUMBER;
BEGIN
    -- 1. Input validations
    IF p_loan_amount IS NULL OR p_interest_rate IS NULL OR p_duration_years IS NULL THEN
        RETURN NULL;
    END IF;
    
    IF p_loan_amount <= 0 OR p_interest_rate < 0 OR p_duration_years <= 0 THEN
        RETURN 0;
    END IF;
    
    v_total_months := p_duration_years * 12;
    
    -- 2. Handle 0% interest rate case
    IF p_interest_rate = 0 THEN
        v_monthly_payment := p_loan_amount / v_total_months;
    ELSE
        -- Convert annual percentage rate to monthly decimal rate
        v_monthly_rate := (p_interest_rate / 12) / 100;
        
        -- Standard EMI calculation
        v_monthly_payment := (p_loan_amount * v_monthly_rate * POWER(1 + v_monthly_rate, v_total_months)) /
                             (POWER(1 + v_monthly_rate, v_total_months) - 1);
    END IF;
    
    -- 3. Return rounded to standard currency cents (2 decimals)
    RETURN ROUND(v_monthly_payment, 2);
EXCEPTION
    WHEN OTHERS THEN
        RETURN NULL;
END CalculateMonthlyInstallment;
/
