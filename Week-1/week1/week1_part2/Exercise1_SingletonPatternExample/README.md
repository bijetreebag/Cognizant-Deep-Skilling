# Exercise 1: Singleton Pattern

A `Logger` class that guarantees a single shared instance across the application.

## How it works
- The constructor is `private`, so `Logger` cannot be instantiated with `new` from outside the class.
- `getInstance()` is a `public static` method that lazily creates the instance on first call and returns the same instance on every subsequent call.
- Double-checked locking makes the lazy initialization thread-safe without paying a synchronization cost on every call.

## Run
```bash
javac Logger.java LoggerTest.java
java LoggerTest
```

## Expected output
Only one "Logger instance created." line is printed even though `getInstance()` is called twice, and `logger1 == logger2` prints `true`.
