# Exercise 2: Factory Method Pattern

A document management system that creates Word, PDF, and Excel documents
without the client code needing to know which concrete class to instantiate.

## Structure
- `Document` — target interface implemented by `WordDocument`, `PdfDocument`, `ExcelDocument`.
- `DocumentFactory` — abstract creator declaring `createDocument()`.
- `WordDocumentFactory`, `PdfDocumentFactory`, `ExcelDocumentFactory` — concrete factories.

## Run
```bash
javac *.java
java FactoryMethodTest
```
