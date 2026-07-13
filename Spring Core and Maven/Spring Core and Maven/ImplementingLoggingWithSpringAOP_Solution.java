/*
QUESTION:
Exercise 3: Implementing Logging with Spring AOP
*/

import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.springframework.stereotype.Component;

@Aspect
@Component
public class Exercise3_ImplementingLoggingWithSpringAOP_Solution {
    @Before("execution(* com.example.service.*.*(..))")
    public void logBefore() {
        System.out.println("[AOP LOG] Method execution started.");
    }
}
