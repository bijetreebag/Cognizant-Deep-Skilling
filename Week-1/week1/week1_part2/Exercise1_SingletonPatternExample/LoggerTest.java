/**
 * LoggerTest.java
 * Verifies that only one instance of Logger is created and shared.
 */
public class LoggerTest {
    public static void main(String[] args) {
        Logger logger1 = Logger.getInstance();
        logger1.log("First message from logger1");

        Logger logger2 = Logger.getInstance();
        logger2.log("Second message from logger2");

        // Prove both references point to the same object
        System.out.println("logger1 == logger2 ? " + (logger1 == logger2));

        if (logger1 == logger2) {
            System.out.println("Singleton test PASSED: Only one instance exists.");
        } else {
            System.out.println("Singleton test FAILED: Multiple instances exist.");
        }
    }
}
