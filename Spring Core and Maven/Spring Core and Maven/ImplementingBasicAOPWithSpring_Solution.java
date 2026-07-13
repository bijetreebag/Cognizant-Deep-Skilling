/*
QUESTION:
Exercise 8: Implementing Basic AOP with Spring
*/

import org.aspectj.lang.annotation.After;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.stereotype.Component;

@Aspect
@Component
public class Exercise8_ImplementingBasicAOPWithSpring_Solution {
    @After("execution(* com.example..*.*(..))")
    public void logAfter() {
        System.out.println("[AOP] Execution completed.");
    }
}
