/**
 * Abstract creator. Declares the factory method that subclasses override
 * to produce a specific kind of Document.
 */
public abstract class DocumentFactory {
    public abstract Document createDocument();

    // A template method that uses the factory method
    public Document openNewDocument() {
        Document doc = createDocument();
        doc.open();
        return doc;
    }
}
