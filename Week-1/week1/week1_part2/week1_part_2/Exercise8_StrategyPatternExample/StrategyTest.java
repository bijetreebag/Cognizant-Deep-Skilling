public class StrategyTest {
    public static void main(String[] args) {
        PaymentContext cart = new PaymentContext();

        // Runtime selection #1
        cart.setStrategy(new CreditCardPayment("1234567812345678"));
        cart.checkout(59.99);

        // Runtime selection #2
        cart.setStrategy(new PayPalPayment("aarya@example.com"));
        cart.checkout(24.50);

        // Runtime selection #3
        cart.setStrategy(new UpiPayment("aarya@upi"));
        cart.checkout(12.00);
    }
}
