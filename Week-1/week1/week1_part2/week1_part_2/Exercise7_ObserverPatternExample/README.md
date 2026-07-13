# Exercise 7: Observer Pattern

`StockMarket` is a `Stock` (subject) that keeps a list of `Observer`s
(`MobileApp`, `WebApp`) and notifies all of them whenever the price changes
via `setPrice()`. Observers can register and deregister at any time, and each
one decides independently how to react to a price update.

## Run
```bash
javac *.java
java ObserverTest
```
