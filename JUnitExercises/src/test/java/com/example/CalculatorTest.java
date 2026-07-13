package com.example;

import org.junit.Before;
import org.junit.After;
import org.junit.Test;
import static org.junit.Assert.*;

public class CalculatorTest {
    private Calculator calc;

    @Before
    public void setUp() {
        calc = new Calculator();
    }

    @After
    public void tearDown() {
        calc = null;
    }

    @Test
    public void testAdd() {
        // Arrange
        int a = 5, b = 7;
        // Act
        int result = calc.add(a, b);
        // Assert
        assertEquals(12, result);
    }

    @Test
    public void testSubtract() {
        assertEquals(3, calc.subtract(10, 7));
    }

    @Test
    public void testMultiply() {
        assertEquals(20, calc.multiply(4, 5));
    }

    @Test(expected = IllegalArgumentException.class)
    public void testDivideByZero() {
        calc.divide(10, 0);
    }

    @Test
    public void testDivide() {
        assertEquals(3, calc.divide(9, 3));
    }
}
