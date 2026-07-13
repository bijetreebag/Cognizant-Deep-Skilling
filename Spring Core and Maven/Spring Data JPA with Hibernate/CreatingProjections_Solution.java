/*
QUESTION:
Employee Management System - Creating Projections
Define interface-based projections for Employee entity to fetch limited fields.
*/
public interface EmployeeProjection {
    String getName();
    String getEmail();
}
