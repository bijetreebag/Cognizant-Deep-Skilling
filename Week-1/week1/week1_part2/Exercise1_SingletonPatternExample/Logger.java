/**
 * Logger.java
 * Singleton Pattern implementation.
 * Ensures only one instance of the Logger exists throughout the application.
 */
public class Logger {

    // The single, shared instance (created lazily and thread-safely)
    private static Logger instance;

    // Private constructor prevents external instantiation
    private Logger() {
        System.out.println("Logger instance created.");
    }

    // Thread-safe lazy initialization using double-checked locking
    public static Logger getInstance() {
        if (instance == null) {
            synchronized (Logger.class) {
                if (instance == null) {
                    instance = new Logger();
                }
            }
        }
        return instance;
    }

    public void log(String message) {
        System.out.println("[LOG] " + message);
    }
}
