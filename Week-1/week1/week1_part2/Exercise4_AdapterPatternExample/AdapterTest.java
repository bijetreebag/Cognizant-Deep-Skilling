import java.util.ArrayList;
import java.util.List;

public class AdapterTest {
    public static void main(String[] args) {
        List<PaymentProcessor> processors = new ArrayList<>();
        processors.add(new StripeAdapter(new StripeGateway()));
        processors.add(new PayPalAdapter(new PayPalGateway()));
        processors.add(new RazorpayAdapter(new RazorpayGateway()));

        // Client code only ever talks to the PaymentProcessor interface
        for (PaymentProcessor processor : processors) {
            processor.processPayment(49.99);
        }
    }
}
