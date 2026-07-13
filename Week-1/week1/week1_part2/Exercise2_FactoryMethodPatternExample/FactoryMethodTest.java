public class FactoryMethodTest {
    public static void main(String[] args) {
        DocumentFactory wordFactory = new WordDocumentFactory();
        wordFactory.openNewDocument();

        DocumentFactory pdfFactory = new PdfDocumentFactory();
        pdfFactory.openNewDocument();

        DocumentFactory excelFactory = new ExcelDocumentFactory();
        excelFactory.openNewDocument();
    }
}
