/*
QUESTION:
Exercise 7: Implementing Constructor and Setter Injection
*/

import org.springframework.beans.factory.annotation.Autowired;

class Dependency {}

public class Exercise7_ConstructorAndSetterInjection_Solution {
    private Dependency depA;
    private Dependency depB;

    // Constructor Injection
    @Autowired
    public Exercise7_ConstructorAndSetterInjection_Solution(Dependency depA) {
        this.depA = depA;
    }

    // Setter Injection
    @Autowired
    public void setDepB(Dependency depB) {
        this.depB = depB;
    }
}
