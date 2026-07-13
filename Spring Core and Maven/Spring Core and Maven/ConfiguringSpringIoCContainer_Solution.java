/*
QUESTION:
Exercise 5: Configuring the Spring IoC Container
*/

import org.springframework.context.support.ClassPathXmlApplicationContext;

public class Exercise5_ConfiguringSpringIoCContainer_Solution {
    public static void main(String[] args) {
        // Load IoC container from XML configuration
        ClassPathXmlApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
        System.out.println("IoC Container initialized successfully.");
        context.close();
    }
}
