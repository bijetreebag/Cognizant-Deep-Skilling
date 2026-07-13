// Exercise3Test.java
// Exercise 3: Argument Matching
//
// Scenario:
// You need to verify that a method is called with specific arguments.
//
// Steps:
// 1. Create a mock object.
// 2. Call the method with specific arguments.
// 3. Use argument matchers to verify the interaction.

import static org.mockito.Mockito.*;
import static org.mockito.ArgumentMatchers.*;
import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.Test;

public class Exercise3Test {

    @Test
    public void testArgumentMatching() {
        // Step 1: Create a mock object for ExternalApi
        ExternalApi mockApi = mock(ExternalApi.class);

        // Stub using a generic matcher: any integer ID returns a generic response
        when(mockApi.getDataById(anyInt())).thenReturn("Data for any ID");

        // Stub using a specific value: ID 1 returns a specific response
        when(mockApi.getDataById(1)).thenReturn("Data for ID 1");

        // Step 2: Call fetchDataById with a specific argument
        MyService service = new MyService(mockApi);
        String result = service.fetchDataById(1);

        // Assert the specific stub matched correctly
        assertEquals("Data for ID 1", result);

        // Step 3: Verify using argument matchers
        // eq(1) ensures the method was called with exactly the value 1
        verify(mockApi).getDataById(eq(1));
    }

    @Test
    public void testArgumentMatchingWithAnyInt() {
        ExternalApi mockApi = mock(ExternalApi.class);

        // Stub for any integer value
        when(mockApi.getDataById(anyInt())).thenReturn("Generic Data");

        MyService service = new MyService(mockApi);
        String result = service.fetchDataById(99);

        assertEquals("Generic Data", result);

        // Verify the mock was called with any integer
        verify(mockApi).getDataById(anyInt());
    }
}
