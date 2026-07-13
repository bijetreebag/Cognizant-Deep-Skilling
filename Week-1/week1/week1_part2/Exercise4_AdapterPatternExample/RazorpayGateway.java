/** Adaptee #3: works in paise (smallest currency unit), not rupees. */
public class RazorpayGateway {
    public void pay(long amountInPaise) {
        System.out.println("Charging " + amountInPaise + " paise via Razorpay.");
    }
}
