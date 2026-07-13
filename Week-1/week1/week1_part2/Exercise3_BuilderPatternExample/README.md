# Exercise 3: Builder Pattern

`Computer` is a complex object with required fields (CPU, RAM) and several
optional ones (storage, GPU, Wi-Fi, Bluetooth). The nested `Computer.Builder`
class lets client code assemble a fully configured, immutable `Computer` step
by step using a fluent, chainable API.

## Run
```bash
javac Computer.java BuilderTest.java
java BuilderTest
```
