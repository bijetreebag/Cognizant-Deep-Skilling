// Exercise4Test.java
// Exercise 4: Handling Void Methods
//
// Scenario:
// You need to test a void method that performs some action.
//
// Steps:
// 1. Create a mock object.
// 2. Stub the void method.
// 3. Verify the interaction.

import static org.mockito.Mockito.*;
import static org.mockito.ArgumentMatchers.*;
import org.junit.jupiter.api.Test;

public class Exercise4Test {

    @Test
    public void testVoidMethod() {
        // Step 1: Create a mock object for EmailService
        EmailService mockEmailService = mock(EmailService.class);

        // Step 2: Stub the void method sendEmail() using doNothing()
        // doNothing() is the default for void methods, but it is good practice
        // to make it explicit to show the intent clearly.
        doNothing().when(mockEmailService).sendEmail(anyString(), anyString());

        // Inject the mock into NotificationService and call notifyUser()
        NotificationService service = new NotificationService(mockEmailService);
        service.notifyUser("user@example.com", "Hello!");

        // Step 3: Verify that sendEmail() was called with the correct arguments
        verify(mockEmailService).sendEmail("user@example.com", "Hello!");
    }
}
