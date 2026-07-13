// Exercise2Test.java
// Exercise 2: Verifying Interactions
//
// Scenario:
// You need to ensure that a method is called with specific arguments.
//
// Steps:
// 1. Create a mock object.
// 2. Call the method with specific arguments.
// 3. Verify the interaction.

import static org.mockito.Mockito.*;
import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.Test;

public class Exercise2Test {

    @Test
    public void testVerifyInteraction() {
        // Step 1: Create a mock object for ExternalApi
        ExternalApi mockApi = mock(ExternalApi.class);

        // Stub getData() so the service can use it
        when(mockApi.getData()).thenReturn("Mock Data");

        // Step 2: Call the service method which internally calls getData()
        MyService service = new MyService(mockApi);
        String result = service.fetchData();

        // Assert the returned value is correct
        assertEquals("Mock Data", result);

        // Step 3: Verify that getData() was called exactly once on the mock
        verify(mockApi).getData();
        verify(mockApi, times(1)).getData();
    }
}
