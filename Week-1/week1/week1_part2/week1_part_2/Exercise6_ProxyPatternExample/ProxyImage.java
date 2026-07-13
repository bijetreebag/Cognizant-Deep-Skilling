import java.util.HashMap;
import java.util.Map;

/**
 * Proxy. Defers creating (and loading) the RealImage until display() is
 * actually called for the first time (lazy initialization), and caches
 * already-loaded images so repeated display() calls don't reload them.
 */
public class ProxyImage implements Image {
    private final String fileName;
    private RealImage realImage; // null until first use

    // Shared cache across all ProxyImage instances, keyed by file name
    private static final Map<String, RealImage> cache = new HashMap<>();

    public ProxyImage(String fileName) {
        this.fileName = fileName;
    }

    @Override
    public void display() {
        if (realImage == null) {
            if (cache.containsKey(fileName)) {
                System.out.println("Cache hit for '" + fileName + "'.");
                realImage = cache.get(fileName);
            } else {
                realImage = new RealImage(fileName);
                cache.put(fileName, realImage);
            }
        }
        realImage.display();
    }
}
