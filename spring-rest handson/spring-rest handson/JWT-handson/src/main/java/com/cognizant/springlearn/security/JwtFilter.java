package com.cognizant.springlearn.security;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

/**
 * JWT Request Filter (Spring Security Filter).
 *
 * This filter runs ONCE per request (extends OncePerRequestFilter).
 *
 * Process Flow:
 *  1. Extract "Authorization" header from each HTTP request.
 *  2. Check if it starts with "Bearer ".
 *  3. Extract the JWT token (everything after "Bearer ").
 *  4. Extract the username from the token using JwtUtil.
 *  5. If username is valid and no authentication exists in SecurityContext:
 *       a. Load UserDetails from UserDetailsService.
 *       b. Validate the token against UserDetails.
 *       c. Set authentication in the SecurityContext.
 *  6. Continue the filter chain.
 *
 * If the token is missing or invalid, the request proceeds unauthenticated
 * and Spring Security will block it (returning 401/403).
 */
@Component
public class JwtFilter extends OncePerRequestFilter {

    private static final Logger LOGGER = LoggerFactory.getLogger(JwtFilter.class);

    @Autowired
    private UserDetailsService userDetailsService;

    @Autowired
    private JwtUtil jwtUtil;

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain filterChain)
            throws ServletException, IOException {

        LOGGER.debug("START JwtFilter.doFilterInternal for URI: {}", request.getRequestURI());

        final String authorizationHeader = request.getHeader("Authorization");

        String username = null;
        String jwt = null;

        // Step 1 & 2: Check Authorization header for Bearer token
        if (authorizationHeader != null && authorizationHeader.startsWith("Bearer ")) {
            jwt = authorizationHeader.substring(7); // Strip "Bearer " prefix
            username = jwtUtil.extractUsername(jwt);
            LOGGER.debug("JWT extracted for username: {}", username);
        }

        // Step 3-5: Validate token and set authentication
        if (username != null && SecurityContextHolder.getContext().getAuthentication() == null) {
            UserDetails userDetails = this.userDetailsService.loadUserByUsername(username);

            if (jwtUtil.validateToken(jwt, userDetails)) {
                UsernamePasswordAuthenticationToken authToken =
                        new UsernamePasswordAuthenticationToken(
                                userDetails, null, userDetails.getAuthorities());
                authToken.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));

                // Set authentication in Spring Security context
                SecurityContextHolder.getContext().setAuthentication(authToken);
                LOGGER.debug("Authentication set in SecurityContext for user: {}", username);
            }
        }

        // Step 6: Continue filter chain
        filterChain.doFilter(request, response);
        LOGGER.debug("END JwtFilter.doFilterInternal");
    }
}
