// ExternalApi.java
// Interface representing an external API dependency.
// Used in Exercises 1, 2, 3, 5, and 6.

public interface ExternalApi {

    // Returns a generic data string
    String getData();

    // Returns data based on a given ID
    String getDataById(int id);

    // Sends a notification message (void method)
    void sendNotification(String message);
}
