# Exercise 11: Dependency Injection

`CustomerService` depends on the `CustomerRepository` interface rather than a
concrete class, and that dependency is supplied through the constructor
(constructor injection) instead of being instantiated internally with `new`.
This decouples `CustomerService` from any specific repository implementation,
making it easy to swap in a different repository (or a mock, for testing)
without touching `CustomerService`'s code.

## Run
```bash
javac *.java
java DependencyInjectionTest
```
