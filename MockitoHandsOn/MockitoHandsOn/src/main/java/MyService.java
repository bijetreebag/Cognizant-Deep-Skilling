// MyService.java
// Service class that depends on ExternalApi.
// Used in Exercises 1, 2, 3, 5, and 6.

public class MyService {

    private ExternalApi api;

    public MyService(ExternalApi api) {
        this.api = api;
    }

    // Fetches generic data from the external API
    public String fetchData() {
        return api.getData();
    }

    // Fetches data from the external API using an ID
    public String fetchDataById(int id) {
        return api.getDataById(id);
    }

    // Sends a notification via the external API
    public void sendNotification(String message) {
        api.sendNotification(message);
    }
}
