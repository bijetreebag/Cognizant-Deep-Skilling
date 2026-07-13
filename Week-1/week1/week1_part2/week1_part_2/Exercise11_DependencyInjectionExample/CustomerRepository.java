/** Repository interface: abstracts away how/where customer data lives. */
public interface CustomerRepository {
    String findCustomerById(String id);
}
