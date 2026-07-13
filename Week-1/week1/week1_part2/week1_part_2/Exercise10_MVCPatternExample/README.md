# Exercise 10: MVC Pattern

- `Student` (Model) holds the data.
- `StudentView` (View) knows only how to display data it's given.
- `StudentController` (Controller) sits in between: it updates the model and
  asks the view to render, so the model and view never talk to each other
  directly.

## Run
```bash
javac *.java
java MVCTest
```
