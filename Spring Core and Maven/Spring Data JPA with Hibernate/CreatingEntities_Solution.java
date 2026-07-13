/*
QUESTION:
Employee Management System - Creating Entities
Define JPA entities for Employee and Department with appropriate relationships.
*/
import jakarta.persistence.*;
import java.util.List;

@Entity
class Employee {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String name;
    private String email;
    @ManyToOne @JoinColumn(name = "department_id")
    private Department department;
}

@Entity
class Department {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String name;
    @OneToMany(mappedBy = "department")
    private List<Employee> employees;
}
