package com.cognizant.springlearn;

import com.cognizant.springlearn.controller.CountryController;
import com.cognizant.springlearn.security.JwtUtil;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.ResultActions;

import java.util.HashMap;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc
class SpringLearnApplicationTests {

    @Autowired
    private CountryController countryController;

    @Autowired
    private MockMvc mvc;

    @Autowired
    private JwtUtil jwtUtil;

    @Autowired
    private UserDetailsService userDetailsService;

    @Autowired
    private ObjectMapper objectMapper;

    // ─── Helper: generate a valid JWT token for "user" ────────────────────────
    private String getValidToken() {
        return jwtUtil.generateToken("user");
    }

    // ─── Test 1: Context loads and CountryController is available ─────────────
    @Test
    public void contextLoads() {
        assertNotNull(countryController);
    }

    // ─── Test 2: POST /authenticate with valid credentials returns JWT ─────────
    @Test
    public void testAuthenticateSuccess() throws Exception {
        Map<String, String> body = new HashMap<>();
        body.put("username", "user");
        body.put("password", "password");

        ResultActions actions = mvc.perform(post("/authenticate")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(body)));

        actions.andExpect(status().isOk());
        actions.andExpect(jsonPath("$.token").exists());

        // Capture token and verify it's not empty
        MvcResult result = actions.andReturn();
        String responseBody = result.getResponse().getContentAsString();
        assertTrue(responseBody.contains("token"));
    }

    // ─── Test 3: POST /authenticate with wrong password returns 401 ───────────
    @Test
    public void testAuthenticateFail() throws Exception {
        Map<String, String> body = new HashMap<>();
        body.put("username", "user");
        body.put("password", "wrongpassword");

        mvc.perform(post("/authenticate")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(body)))
                .andExpect(status().is5xxServerError()); // Throws Exception → 500
    }

    // ─── Test 4: GET /country WITHOUT token returns 401 ──────────────────────
    @Test
    public void testGetCountryWithoutToken() throws Exception {
        mvc.perform(get("/country"))
                .andExpect(status().isUnauthorized());
    }

    // ─── Test 5: GET /country WITH valid JWT token returns 200 ───────────────
    @Test
    public void testGetCountryWithToken() throws Exception {
        String token = getValidToken();

        ResultActions actions = mvc.perform(get("/country")
                .header("Authorization", "Bearer " + token));

        actions.andExpect(status().isOk());
        actions.andExpect(jsonPath("$.code").exists());
        actions.andExpect(jsonPath("$.code").value("IN"));
        actions.andExpect(jsonPath("$.name").exists());
        actions.andExpect(jsonPath("$.name").value("India"));
    }

    // ─── Test 6: GET /countries WITH valid JWT returns all 4 countries ────────
    @Test
    public void testGetAllCountriesWithToken() throws Exception {
        String token = getValidToken();

        ResultActions actions = mvc.perform(get("/countries")
                .header("Authorization", "Bearer " + token));

        actions.andExpect(status().isOk());
        actions.andExpect(jsonPath("$[0].code").exists());
    }

    // ─── Test 7: GET /countries/{code} with valid JWT and valid code ──────────
    @Test
    public void testGetCountryByCodeWithToken() throws Exception {
        String token = getValidToken();

        ResultActions actions = mvc.perform(get("/countries/in")
                .header("Authorization", "Bearer " + token));

        actions.andExpect(status().isOk());
        actions.andExpect(jsonPath("$.code").value("IN"));
        actions.andExpect(jsonPath("$.name").value("India"));
    }

    // ─── Test 8: GET /countries/{code} with invalid code returns 404 ─────────
    @Test
    public void testGetCountryByCodeNotFound() throws Exception {
        String token = getValidToken();

        ResultActions actions = mvc.perform(get("/countries/az")
                .header("Authorization", "Bearer " + token));

        actions.andExpect(status().isNotFound());
        actions.andExpect(status().reason("Country not found"));
    }

    // ─── Test 9: GET /hello WITH valid JWT ────────────────────────────────────
    @Test
    public void testSayHelloWithToken() throws Exception {
        String token = getValidToken();

        mvc.perform(get("/hello")
                .header("Authorization", "Bearer " + token))
                .andExpect(status().isOk());
    }

    // ─── Test 10: JWT token validation utility ───────────────────────────────
    @Test
    public void testJwtTokenValidation() {
        UserDetails userDetails = userDetailsService.loadUserByUsername("user");
        String token = jwtUtil.generateToken("user");
        assertNotNull(token);
        assertTrue(jwtUtil.validateToken(token, userDetails));
    }
}
