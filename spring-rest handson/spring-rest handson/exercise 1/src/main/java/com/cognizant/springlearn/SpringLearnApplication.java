package com.cognizant.springlearn;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@SpringBootApplication
public class SpringLearnApplication implements CommandLineRunner {

    private static final Logger LOGGER = LoggerFactory.getLogger(SpringLearnApplication.class);

    public static void main(String[] args) {
        LOGGER.info("Starting SpringLearnApplication");
        SpringApplication.run(SpringLearnApplication.class, args);
        LOGGER.info("SpringLearnApplication finished");
    }

    @Override
    public void run(String... args) throws Exception {
        displayDate();
        displayCountry();
        displayCountries();
    }

    public void displayDate() {
        LOGGER.info("START displayDate");
        ApplicationContext context = new ClassPathXmlApplicationContext("date-format.xml");
        SimpleDateFormat format = context.getBean("dateFormat", SimpleDateFormat.class);
        try {
            Date date = format.parse("31/12/2018");
            LOGGER.debug("Parsed date: {}", date);
        } catch (ParseException e) {
            LOGGER.error("Date parsing failed", e);
        }
        LOGGER.info("END displayDate");
        ((ClassPathXmlApplicationContext) context).close();
    }

    public void displayCountry() {
        LOGGER.info("START displayCountry");
        ApplicationContext context = new ClassPathXmlApplicationContext("country.xml");
        Country country = context.getBean("country", Country.class);
        LOGGER.debug("Country : {}", country);
        // Demonstrate singleton/prototype behavior by retrieving another instance
        Country anotherCountry = context.getBean("country", Country.class);
        LOGGER.debug("Another Country instance hash: {}", System.identityHashCode(anotherCountry));
        LOGGER.info("END displayCountry");
        ((ClassPathXmlApplicationContext) context).close();
    }

    @SuppressWarnings("unchecked")
    public void displayCountries() {
        LOGGER.info("START displayCountries");
        ApplicationContext context = new ClassPathXmlApplicationContext("country.xml");
        List<Country> countryList = (List<Country>) context.getBean("countryList");
        for (Country c : countryList) {
            LOGGER.debug("Country from list: {}", c);
        }
        LOGGER.info("END displayCountries");
        ((ClassPathXmlApplicationContext) context).close();
    }
}
