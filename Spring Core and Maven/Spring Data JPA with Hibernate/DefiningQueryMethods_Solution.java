/*
QUESTION:
Employee Management System - Defining Query Methods
Define custom query methods in EmployeeRepository using method names and @Query annotation.
*/
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import java.util.List;

interface EmployeeCustomRepo extends JpaRepository<Employee, Long> {
    List<Employee> findByName(String name);
    @Query("SELECT e FROM Employee e WHERE e.email = :email")
    Employee findByEmail(String email);
}
