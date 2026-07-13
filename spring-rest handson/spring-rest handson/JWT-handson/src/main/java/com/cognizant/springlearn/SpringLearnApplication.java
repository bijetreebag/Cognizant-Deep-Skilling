package com.cognizant.springlearn;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * Entry point for the Spring Boot JWT Authentication demo application.
 *
 * @SpringBootApplication enables:
 *   - @Configuration  : marks the class as a source of bean definitions
 *   - @EnableAutoConfiguration : auto-configures Spring based on the classpath
 *   - @ComponentScan  : scans for components in the current package and sub-packages
 *
 * SpringApplication.run() bootstraps and launches the embedded Tomcat server.
 */
@SpringBootApplication
public class SpringLearnApplication {

    private static final Logger LOGGER = LoggerFactory.getLogger(SpringLearnApplication.class);

    public static void main(String[] args) {
        LOGGER.info("START - SpringLearnApplication");
        SpringApplication.run(SpringLearnApplication.class, args);
        LOGGER.info("END - SpringLearnApplication started on port 8083");
    }
}
