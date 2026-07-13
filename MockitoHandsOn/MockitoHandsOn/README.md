# Mockito Hands-On Exercises

Week 2 - Unit Testing with Mockito and JUnit 5

## Exercises

| Exercise | Topic |
|---|---|
| Exercise 1 | Mocking and Stubbing |
| Exercise 2 | Verifying Interactions |
| Exercise 3 | Argument Matching |
| Exercise 4 | Handling Void Methods |
| Exercise 5 | Mocking with Multiple Returns |
| Exercise 6 | Verifying Interaction Order |
| Exercise 7 | Void Methods with Exceptions |

## Project Structure

```
MockitoHandsOn/
├── pom.xml
└── src/
    ├── main/java/
    │   ├── ExternalApi.java          (interface - mock target)
    │   ├── MyService.java            (service using ExternalApi)
    │   ├── EmailService.java         (interface with void method)
    │   └── NotificationService.java  (service using EmailService)
    └── test/java/
        ├── Exercise1Test.java   (Mocking and Stubbing)
        ├── Exercise2Test.java   (Verifying Interactions)
        ├── Exercise3Test.java   (Argument Matching)
        ├── Exercise4Test.java   (Void Methods)
        ├── Exercise5Test.java   (Multiple Returns)
        ├── Exercise6Test.java   (Interaction Order)
        └── Exercise7Test.java   (Void Methods with Exceptions)
```

## How to Run

Requires: Java 11+, Maven 3.6+

```bash
mvn test
```
