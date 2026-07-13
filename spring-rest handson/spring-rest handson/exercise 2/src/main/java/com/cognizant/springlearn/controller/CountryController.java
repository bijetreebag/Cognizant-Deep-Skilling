package com.cognizant.springlearn.controller;

import com.cognizant.springlearn.Country;
import com.cognizant.springlearn.service.CountryService;
import com.cognizant.springlearn.service.exception.CountryNotFoundException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
public class CountryController {

    private static final Logger LOGGER = LoggerFactory.getLogger(CountryController.class);

    @Autowired
    private CountryService countryService;

    public CountryController() {
        LOGGER.debug("Inside CountryController Constructor.");
    }

    /**
     * GET /country
     * Returns India country details loaded from spring XML configuration.
     */
    @RequestMapping("/country")
    public Country getCountryIndia() {
        LOGGER.info("START getCountryIndia");
        ApplicationContext context = new ClassPathXmlApplicationContext("country.xml");
        Country country = context.getBean("in", Country.class);
        ((ClassPathXmlApplicationContext) context).close();
        LOGGER.info("END getCountryIndia");
        return country;
    }

    /**
     * GET /countries
     * Returns all countries.
     */
    @GetMapping("/countries")
    public List<Country> getAllCountries() {
        LOGGER.info("START getAllCountries");
        List<Country> countries = countryService.getAllCountries();
        LOGGER.info("END getAllCountries");
        return countries;
    }

    /**
     * GET /countries/{code}
     * Returns a specific country based on country code (case-insensitive).
     */
    @GetMapping("/countries/{code}")
    public Country getCountry(@PathVariable String code) throws CountryNotFoundException {
        LOGGER.info("START getCountry - code: {}", code);
        Country country = countryService.getCountry(code);
        LOGGER.info("END getCountry");
        return country;
    }
}
