package com.example;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.*;

public class CalculatorAATest {

    private Calculator calculator;

    @Before
    public void setUp() {
        // Arrange: create a fresh Calculator before each test
        calculator = new Calculator();
    }

    @After
    public void tearDown() {
        // Teardown: null out reference (not required but shows pattern)
        calculator = null;
    }

    @Test
    public void testAdditionAAA() {
        // Arrange
        int a = 5;
        int b = 7;
        // Act
        int result = calculator.add(a, b);
        // Assert
        assertEquals("Addition should return sum", 12, result);
    }

    @Test
    public void testDivisionByZeroAAA() {
        // Arrange
        int a = 10;
        int b = 0;
        // Act & Assert
        try {
            calculator.divide(a, b);
            fail("Expected ArithmeticException");
        } catch (ArithmeticException ex) {
            assertEquals("/ by zero", ex.getMessage());
        }
    }
}
