/*
QUESTION:
Exercise 6: Configuring Beans with Annotations
*/

import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;

@Repository
class EmployeeRepository {}

@Service
public class Exercise6_ConfiguringBeansWithAnnotations_Solution {
    private final EmployeeRepository repo;
    public Exercise6_ConfiguringBeansWithAnnotations_Solution(EmployeeRepository repo) {
        this.repo = repo;
    }
}
