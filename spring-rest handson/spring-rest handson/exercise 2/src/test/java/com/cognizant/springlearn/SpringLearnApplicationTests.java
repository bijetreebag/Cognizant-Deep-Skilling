package com.cognizant.springlearn;

import com.cognizant.springlearn.controller.CountryController;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.ResultActions;

import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
class SpringLearnApplicationTests {

    @Autowired
    private CountryController countryController;

    @Autowired
    private MockMvc mvc;

    /**
     * Test 1: Verify that CountryController bean is loaded in the Spring context.
     */
    @Test
    public void contextLoads() {
        assertNotNull(countryController);
    }

    /**
     * Test 2: GET /country - verify HTTP 200 and response body contains
     * code="IN" and name="India".
     */
    @Test
    public void testGetCountry() throws Exception {
        ResultActions actions = mvc.perform(get("/country"));
        actions.andExpect(status().isOk());
        actions.andExpect(jsonPath("$.code").exists());
        actions.andExpect(jsonPath("$.code").value("IN"));
        actions.andExpect(jsonPath("$.name").exists());
        actions.andExpect(jsonPath("$.name").value("India"));
    }

    /**
     * Test 3: GET /countries/{code} with an invalid code - verify HTTP 404
     * and reason "Country not found".
     */
    @Test
    public void testGetCountryException() throws Exception {
        ResultActions actions = mvc.perform(get("/countries/az"));
        actions.andExpect(status().isNotFound());
        actions.andExpect(status().reason("Country not found"));
    }

    /**
     * Test 4: GET /countries - verify all four countries are returned.
     */
    @Test
    public void testGetAllCountries() throws Exception {
        ResultActions actions = mvc.perform(get("/countries"));
        actions.andExpect(status().isOk());
        actions.andExpect(jsonPath("$[0].code").exists());
        actions.andExpect(jsonPath("$[0].code").value("IN"));
    }

    /**
     * Test 5: GET /hello - verify response is "Hello World!!"
     */
    @Test
    public void testSayHello() throws Exception {
        ResultActions actions = mvc.perform(get("/hello"));
        actions.andExpect(status().isOk());
    }
}
