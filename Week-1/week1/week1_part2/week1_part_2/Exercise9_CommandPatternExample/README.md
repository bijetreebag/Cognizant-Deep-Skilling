# Exercise 9: Command Pattern

`RemoteControl` (invoker) is decoupled from `Light` (receiver) by the
`Command` interface. `LightOnCommand` and `LightOffCommand` encapsulate a
request as an object, so the remote can execute (and, as a bonus, undo) any
command without knowing anything about how lights work.

## Run
```bash
javac *.java
java CommandTest
```
