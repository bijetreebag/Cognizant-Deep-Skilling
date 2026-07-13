package com.example;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ParameterizedLoggingExample {
    private static final Logger logger = LoggerFactory.getLogger(ParameterizedLoggingExample.class);

    public static void main(String[] args) {
        String username = "alice";
        int attempts = 3;
        logger.info("User {} attempted to login {} times", username, attempts);
        double balance = 1234.56;
        logger.debug("Current balance for {} is ${}", username, balance);
    }
}
