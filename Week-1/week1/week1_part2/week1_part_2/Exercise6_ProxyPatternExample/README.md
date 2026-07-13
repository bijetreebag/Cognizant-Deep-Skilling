# Exercise 6: Proxy Pattern

`ProxyImage` implements the same `Image` interface as `RealImage` but delays
creating the expensive `RealImage` (which simulates loading from a remote
server) until `display()` is first called. It also keeps a static cache so
that once an image has been loaded by any proxy, subsequent requests for the
same file are served instantly instead of hitting the "server" again.

## Run
```bash
javac *.java
java ProxyTest
```
