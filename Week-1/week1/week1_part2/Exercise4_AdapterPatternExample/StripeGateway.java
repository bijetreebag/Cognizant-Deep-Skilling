/** Adaptee #1: a third-party gateway with its own incompatible API. */
public class StripeGateway {
    public void makeStripePayment(double amountInDollars) {
        System.out.println("Processing $" + amountInDollars + " via Stripe.");
    }
}
