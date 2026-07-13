/*
QUESTION:
Employee Management System - Creating Repositories
Create JpaRepository interfaces for Employee and Department entities.
*/
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
interface EmployeeRepository extends JpaRepository<Employee, Long> {}

@Repository
interface DepartmentRepository extends JpaRepository<Department, Long> {}
