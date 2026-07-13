/*
QUESTION:
Employee Management System - Implementing CRUD Operations
Write service classes to perform CRUD operations on Employee and Department.
*/
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ImplementingCRUDOperations_Solution {
    @Autowired private EmployeeRepository repo;
    public Employee save(Employee e) { return repo.save(e); }
    public void delete(Long id) { repo.deleteById(id); }
}
