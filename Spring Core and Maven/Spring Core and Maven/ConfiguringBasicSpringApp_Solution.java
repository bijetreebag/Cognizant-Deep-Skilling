/*
QUESTION:
Exercise 1: Configuring a Basic Spring Application
*/

// Spring configuration XML / Annotation setup
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
class AppConfig {
    @Bean
    public String greeting() { return "Hello from Spring IoC!"; }
}

public class Exercise1_ConfiguringBasicSpringApp_Solution {
    public static void main(String[] args) {
        ApplicationContext context = new AnnotationConfigApplicationContext(AppConfig.class);
        String msg = context.getBean("greeting", String.class);
        System.out.println(msg);
    }
}
