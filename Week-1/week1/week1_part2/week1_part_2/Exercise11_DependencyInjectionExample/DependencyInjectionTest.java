public class DependencyInjectionTest {
    public static void main(String[] args) {
        // The dependency is created here, at the "composition root",
        // and handed to CustomerService from the outside.
        CustomerRepository repository = new CustomerRepositoryImpl();
        CustomerService customerService = new CustomerService(repository);

        System.out.println(customerService.getCustomerName("C001"));
        System.out.println(customerService.getCustomerName("C002"));
        System.out.println(customerService.getCustomerName("C999")); // not found

        // Because CustomerService depends on the CustomerRepository interface,
        // a different implementation (e.g. a mock or a DB-backed one) could be
        // swapped in here without changing CustomerService at all.
    }
}
