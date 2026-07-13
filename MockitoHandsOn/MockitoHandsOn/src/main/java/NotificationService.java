// NotificationService.java
// Service class that depends on EmailService.
// Used in Exercises 4 and 7.

public class NotificationService {

    private EmailService emailService;

    public NotificationService(EmailService emailService) {
        this.emailService = emailService;
    }

    // Notifies a user by sending an email
    public void notifyUser(String email, String message) {
        emailService.sendEmail(email, message);
    }
}
