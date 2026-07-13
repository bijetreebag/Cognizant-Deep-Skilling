import java.util.HashMap;
import java.util.Map;

/** Concrete repository. In real life this would hit a database; here it's an in-memory map. */
public class CustomerRepositoryImpl implements CustomerRepository {
    private final Map<String, String> customers = new HashMap<>();

    public CustomerRepositoryImpl() {
        customers.put("C001", "Aarya Patil");
        customers.put("C002", "Rohan Sharma");
        customers.put("C003", "Meera Iyer");
    }

    @Override
    public String findCustomerById(String id) {
        return customers.getOrDefault(id, "Customer not found");
    }
}
