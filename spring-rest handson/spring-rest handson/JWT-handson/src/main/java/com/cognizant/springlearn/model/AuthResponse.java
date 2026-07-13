package com.cognizant.springlearn.model;

/**
 * DTO returned to the client after successful authentication.
 * Contains the generated JWT token.
 *
 * Example response body:
 * {
 *   "token": "eyJhbGciOiJIUzI1NiJ9..."
 * }
 */
public class AuthResponse {

    private String token;

    public AuthResponse(String token) {
        this.token = token;
    }

    public String getToken() { return token; }
    public void setToken(String token) { this.token = token; }
}
