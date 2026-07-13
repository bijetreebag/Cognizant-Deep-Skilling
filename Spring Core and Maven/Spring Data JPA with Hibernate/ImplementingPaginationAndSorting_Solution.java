/*
QUESTION:
Employee Management System - Implementing Pagination and Sorting
Implement pagination and sorting for employee queries in service layer.
*/
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ImplementingPaginationAndSorting_Solution {
    @Autowired private EmployeeRepository repo;

    public Page<Employee> getEmployeesPagedAndSorted(int page, int size, String sortBy) {
        Pageable pageable = PageRequest.of(page, size, Sort.by(sortBy).ascending());
        return repo.findAll(pageable);
    }
}
