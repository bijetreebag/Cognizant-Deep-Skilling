package com.cognizant.springlearn.service;

import com.cognizant.springlearn.Country;
import com.cognizant.springlearn.service.exception.CountryNotFoundException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CountryService {

    private static final Logger LOGGER = LoggerFactory.getLogger(CountryService.class);

    /**
     * Returns all countries from country.xml.
     */
    @SuppressWarnings("unchecked")
    public List<Country> getAllCountries() {
        LOGGER.info("START getAllCountries");
        ApplicationContext context = new ClassPathXmlApplicationContext("country.xml");
        List<Country> countryList = (List<Country>) context.getBean("countryList");
        ((ClassPathXmlApplicationContext) context).close();
        LOGGER.info("END getAllCountries");
        return countryList;
    }

    /**
     * Returns a country matching the given code (case-insensitive).
     * Throws CountryNotFoundException if no match is found.
     */
    public Country getCountry(String code) throws CountryNotFoundException {
        LOGGER.info("START getCountry - code: {}", code);
        List<Country> countryList = getAllCountries();
        Country result = countryList.stream()
                .filter(c -> c.getCode().equalsIgnoreCase(code))
                .findFirst()
                .orElseThrow(CountryNotFoundException::new);
        LOGGER.debug("Found country: {}", result);
        LOGGER.info("END getCountry");
        return result;
    }
}
