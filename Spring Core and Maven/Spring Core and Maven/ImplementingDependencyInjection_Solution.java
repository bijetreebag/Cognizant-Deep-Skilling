/*
QUESTION:
Exercise 2: Implementing Dependency Injection
*/

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

interface Service { void serve(); }
@Component class ServiceImpl implements Service { public void serve() { System.out.println("Serving..."); } }

@Component
public class Exercise2_ImplementingDependencyInjection_Solution {
    private final Service service;
    @Autowired public Exercise2_ImplementingDependencyInjection_Solution(Service s) { this.service = s; }
    public void execute() { service.serve(); }
}
