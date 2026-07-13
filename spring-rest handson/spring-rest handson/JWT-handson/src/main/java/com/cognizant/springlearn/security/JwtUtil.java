package com.cognizant.springlearn.security;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;

import java.security.Key;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.function.Function;

/**
 * JWT Utility class.
 *
 * JWT Structure (3 Base64-encoded parts separated by dots):
 *   Header.Payload.Signature
 *
 * - Header  : algorithm & token type  → {"alg":"HS256","typ":"JWT"}
 * - Payload : claims (subject, expiry) → {"sub":"user","exp":...}
 * - Signature: HMACSHA256(base64(header)+"."+base64(payload), secret)
 *
 * The token is sent by the client in the Authorization header:
 *   Authorization: Bearer <token>
 */
@Component
public class JwtUtil {

    private static final Logger LOGGER = LoggerFactory.getLogger(JwtUtil.class);

    // Secret key used to sign and verify tokens.
    // In production, load from application.properties / Vault.
    private final Key SECRET_KEY = Keys.secretKeyFor(SignatureAlgorithm.HS256);

    // Token validity: 10 hours (in milliseconds)
    private static final long TOKEN_VALIDITY = 10 * 60 * 60 * 1000L;

    // ─── Token Creation ───────────────────────────────────────────────────────

    /**
     * Creates a JWT token for the given username.
     *
     * Steps:
     *  1. Build claims map (extra claims if needed)
     *  2. Set subject = username
     *  3. Set issuedAt = now
     *  4. Set expiration = now + TOKEN_VALIDITY
     *  5. Sign with HMAC-SHA256 secret key
     *  6. Compact and return as Base64-encoded string
     */
    public String generateToken(String username) {
        LOGGER.info("START generateToken for user: {}", username);
        Map<String, Object> claims = new HashMap<>();
        String token = createToken(claims, username);
        LOGGER.info("END generateToken");
        return token;
    }

    private String createToken(Map<String, Object> claims, String subject) {
        return Jwts.builder()
                .setClaims(claims)
                .setSubject(subject)
                .setIssuedAt(new Date(System.currentTimeMillis()))
                .setExpiration(new Date(System.currentTimeMillis() + TOKEN_VALIDITY))
                .signWith(SECRET_KEY)
                .compact();
    }

    // ─── Token Validation ─────────────────────────────────────────────────────

    /**
     * Validates the token:
     *  - username extracted from token matches the UserDetails username
     *  - token is not expired
     */
    public Boolean validateToken(String token, UserDetails userDetails) {
        LOGGER.info("START validateToken");
        final String username = extractUsername(token);
        boolean valid = username.equals(userDetails.getUsername()) && !isTokenExpired(token);
        LOGGER.info("END validateToken - valid: {}", valid);
        return valid;
    }

    // ─── Token Parsing ────────────────────────────────────────────────────────

    /** Extracts the username (subject claim) from the token. */
    public String extractUsername(String token) {
        return extractClaim(token, Claims::getSubject);
    }

    /** Extracts the expiration date from the token. */
    public Date extractExpiration(String token) {
        return extractClaim(token, Claims::getExpiration);
    }

    /** Generic claim extractor using a resolver function. */
    public <T> T extractClaim(String token, Function<Claims, T> claimsResolver) {
        final Claims claims = extractAllClaims(token);
        return claimsResolver.apply(claims);
    }

    private Claims extractAllClaims(String token) {
        return Jwts.parserBuilder()
                .setSigningKey(SECRET_KEY)
                .build()
                .parseClaimsJws(token)
                .getBody();
    }

    private Boolean isTokenExpired(String token) {
        return extractExpiration(token).before(new Date());
    }
}
