/**
 * Service class. Depends on the CustomerRepository ABSTRACTION, not a
 * concrete implementation. The dependency is provided (injected) via the
 * constructor rather than being created internally with "new".
 */
public class CustomerService {
    private final CustomerRepository customerRepository;

    // Constructor injection
    public CustomerService(CustomerRepository customerRepository) {
        this.customerRepository = customerRepository;
    }

    public String getCustomerName(String id) {
        return customerRepository.findCustomerById(id);
    }
}
