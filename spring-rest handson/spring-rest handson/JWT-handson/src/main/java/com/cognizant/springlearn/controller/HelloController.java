package com.cognizant.springlearn.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * Hello REST Controller (JWT-protected).
 *
 * GET /hello requires a valid JWT in the Authorization header:
 *   Authorization: Bearer <token>
 */
@RestController
public class HelloController {

    private static final Logger LOGGER = LoggerFactory.getLogger(HelloController.class);

    public HelloController() {
        LOGGER.debug("Inside HelloController Constructor.");
    }

    @GetMapping("/hello")
    public String sayHello() {
        LOGGER.info("START sayHello");
        String response = "Hello World!!";
        LOGGER.info("END sayHello");
        return response;
    }
}
