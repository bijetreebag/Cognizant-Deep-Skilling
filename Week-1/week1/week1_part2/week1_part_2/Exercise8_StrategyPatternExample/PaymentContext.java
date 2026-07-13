/** Context: holds a reference to a strategy and delegates the pay() call to it. */
public class PaymentContext {
    private PaymentStrategy strategy;

    public PaymentContext() {
    }

    public PaymentContext(PaymentStrategy strategy) {
        this.strategy = strategy;
    }

    public void setStrategy(PaymentStrategy strategy) {
        this.strategy = strategy;
    }

    public void checkout(double amount) {
        if (strategy == null) {
            throw new IllegalStateException("No payment strategy selected.");
        }
        strategy.pay(amount);
    }
}
