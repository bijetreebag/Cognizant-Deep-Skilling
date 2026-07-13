public class RazorpayAdapter implements PaymentProcessor {
    private final RazorpayGateway razorpayGateway;

    public RazorpayAdapter(RazorpayGateway razorpayGateway) {
        this.razorpayGateway = razorpayGateway;
    }

    @Override
    public void processPayment(double amount) {
        // translate rupees (double) -> paise (long) for the gateway-specific API
        long amountInPaise = Math.round(amount * 100);
        razorpayGateway.pay(amountInPaise);
    }
}
