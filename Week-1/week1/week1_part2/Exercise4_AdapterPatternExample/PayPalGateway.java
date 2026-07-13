/** Adaptee #2: another third-party gateway, different method signature. */
public class PayPalGateway {
    public void sendPayPalPayment(double amountInDollars, String currency) {
        System.out.println("Sending " + amountInDollars + " " + currency + " via PayPal.");
    }
}
