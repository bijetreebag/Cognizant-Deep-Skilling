// Exercise7Test.java
// Exercise 7: Handling Void Methods with Exceptions
//
// Scenario:
// You need to test a void method that throws an exception.
//
// Steps:
// 1. Create a mock object.
// 2. Stub the void method to throw an exception.
// 3. Verify the interaction.

import static org.mockito.Mockito.*;
import static org.mockito.ArgumentMatchers.*;
import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.Test;

public class Exercise7Test {

    @Test
    public void testVoidMethodThrowsException() {
        // Step 1: Create a mock object for EmailService
        EmailService mockEmailService = mock(EmailService.class);

        // Step 2: Stub the void method sendEmail() to throw an exception
        // For void methods, use doThrow() instead of when().thenThrow()
        doThrow(new RuntimeException("Email service is unavailable"))
                .when(mockEmailService).sendEmail(anyString(), anyString());

        // Inject the mock into NotificationService
        NotificationService service = new NotificationService(mockEmailService);

        // Step 3: Assert that the exception is thrown when notifyUser() is called
        RuntimeException exception = assertThrows(RuntimeException.class, () -> {
            service.notifyUser("user@example.com", "Hello!");
        });

        // Verify the exception message
        assertEquals("Email service is unavailable", exception.getMessage());

        // Verify that sendEmail() was still called (even though it threw an exception)
        verify(mockEmailService).sendEmail("user@example.com", "Hello!");
    }

    @Test
    public void testVoidMethodThrowsExceptionForSpecificArgument() {
        EmailService mockEmailService = mock(EmailService.class);

        // Only throw exception for a specific email address
        doThrow(new IllegalArgumentException("Invalid email address"))
                .when(mockEmailService).sendEmail(eq("bad@address"), anyString());

        NotificationService service = new NotificationService(mockEmailService);

        // Valid email should NOT throw an exception
        assertDoesNotThrow(() -> service.notifyUser("valid@example.com", "Hello!"));

        // Invalid email SHOULD throw an exception
        assertThrows(IllegalArgumentException.class, () -> {
            service.notifyUser("bad@address", "Hello!");
        });
    }
}
