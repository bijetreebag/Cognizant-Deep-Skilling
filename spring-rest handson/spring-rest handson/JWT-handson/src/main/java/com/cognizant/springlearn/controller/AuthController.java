package com.cognizant.springlearn.controller;

import com.cognizant.springlearn.model.AuthRequest;
import com.cognizant.springlearn.model.AuthResponse;
import com.cognizant.springlearn.security.JwtUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

/**
 * Authentication Controller.
 *
 * Provides the POST /authenticate endpoint.
 *
 * JWT Process Flow:
 *  1. Client sends POST /authenticate with JSON body: { "username": "...", "password": "..." }
 *  2. AuthController authenticates credentials using AuthenticationManager.
 *  3. If valid, generate JWT token using JwtUtil.
 *  4. Return JWT token to client as JSON: { "token": "eyJ..." }
 *  5. Client stores the token (e.g., localStorage).
 *  6. Client sends subsequent requests with: Authorization: Bearer <token>
 *  7. JwtFilter intercepts each request, validates the token, and sets authentication.
 */
@RestController
public class AuthController {

    private static final Logger LOGGER = LoggerFactory.getLogger(AuthController.class);

    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private JwtUtil jwtUtil;

    @Autowired
    private UserDetailsService userDetailsService;

    /**
     * POST /authenticate
     *
     * Accepts username & password, validates credentials,
     * and returns a signed JWT token if authentication succeeds.
     *
     * @param authRequest JSON body with username and password
     * @return JWT token wrapped in AuthResponse
     */
    @PostMapping("/authenticate")
    public ResponseEntity<AuthResponse> authenticate(@RequestBody AuthRequest authRequest)
            throws Exception {
        LOGGER.info("START authenticate - user: {}", authRequest.getUsername());

        try {
            // Authenticate using Spring Security's AuthenticationManager
            authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(
                            authRequest.getUsername(),
                            authRequest.getPassword()
                    )
            );
        } catch (BadCredentialsException e) {
            LOGGER.error("Invalid credentials for user: {}", authRequest.getUsername());
            throw new Exception("Invalid username or password", e);
        }

        // Load user details and generate JWT
        final UserDetails userDetails = userDetailsService.loadUserByUsername(authRequest.getUsername());
        final String token = jwtUtil.generateToken(userDetails.getUsername());

        LOGGER.debug("JWT token generated for user: {}", authRequest.getUsername());
        LOGGER.info("END authenticate");

        return ResponseEntity.ok(new AuthResponse(token));
    }
}
