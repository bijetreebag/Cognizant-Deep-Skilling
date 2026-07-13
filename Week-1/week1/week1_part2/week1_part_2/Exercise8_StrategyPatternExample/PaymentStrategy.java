/** Strategy interface: one algorithm per payment method. */
public interface PaymentStrategy {
    void pay(double amount);
}
