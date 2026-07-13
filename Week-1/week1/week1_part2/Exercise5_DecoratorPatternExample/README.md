# Exercise 5: Decorator Pattern

`EmailNotifier` is the base notification channel. `SMSNotifierDecorator` and
`SlackNotifierDecorator` wrap any `Notifier` (including other decorators) to
add extra channels dynamically, without modifying `EmailNotifier` or creating
a combinatorial explosion of subclasses.

## Run
```bash
javac *.java
java DecoratorTest
```
