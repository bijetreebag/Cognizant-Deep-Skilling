# Exercise 4: Adapter Pattern

Three third-party payment gateways (Stripe, PayPal, Razorpay) each expose a
different, incompatible API. Adapter classes (`StripeAdapter`,
`PayPalAdapter`, `RazorpayAdapter`) wrap each gateway and expose the common
`PaymentProcessor.processPayment(double)` interface, so client code can swap
gateways without changing any calling code.

## Run
```bash
javac *.java
java AdapterTest
```
