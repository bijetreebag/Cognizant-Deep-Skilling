/**
 * Real subject. Loading from the "remote server" is simulated as an
 * expensive operation that only happens once, at construction time.
 */
public class RealImage implements Image {
    private final String fileName;

    public RealImage(String fileName) {
        this.fileName = fileName;
        loadFromServer();
    }

    private void loadFromServer() {
        System.out.println("Loading '" + fileName + "' from remote server... (expensive)");
        try {
            Thread.sleep(200); // simulate network latency
        } catch (InterruptedException ignored) {
        }
    }

    @Override
    public void display() {
        System.out.println("Displaying '" + fileName + "'.");
    }
}
