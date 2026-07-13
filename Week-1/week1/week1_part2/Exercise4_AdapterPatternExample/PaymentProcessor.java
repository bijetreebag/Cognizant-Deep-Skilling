/** Target interface expected by client code. */
public interface PaymentProcessor {
    void processPayment(double amount);
}
