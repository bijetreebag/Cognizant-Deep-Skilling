# Exercise 8: Strategy Pattern

`PaymentContext` holds a `PaymentStrategy` and delegates `checkout()` to it.
`CreditCardPayment`, `PayPalPayment`, and `UpiPayment` are interchangeable
strategies that can be swapped in at runtime via `setStrategy()`, letting the
same checkout flow support multiple payment methods without conditionals.

## Run
```bash
javac *.java
java StrategyTest
```
