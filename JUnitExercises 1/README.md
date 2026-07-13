# JUnit Exercises

A minimal Maven project that demonstrates:

- Setting up JUnit 4.13.2
- Writing basic unit tests
- Using various JUnit assertions
- Applying the Arrange‑Act‑Assert (AAA) pattern
- Using @Before and @After fixtures

## Build & Test

```bash
mvn clean test
```

The command compiles the source code and runs all tests under `src/test/java`.

## Folder layout

```
JUnitExercises/
├─ pom.xml
├─ README.md
├─ src/
│  ├─ main/java/com/example/Calculator.java
│  └─ test/java/com/example/...
```

Feel free to extend the `Calculator` class or add more test cases.
