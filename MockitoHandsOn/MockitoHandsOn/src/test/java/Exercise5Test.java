// Exercise5Test.java
// Exercise 5: Mocking and Stubbing with Multiple Returns
//
// Scenario:
// You need to test a service that depends on an external API with multiple
// return values. The API should return different values on consecutive calls.
//
// Steps:
// 1. Create a mock object for the external API.
// 2. Stub the methods to return different values on consecutive calls.
// 3. Write a test case that uses the mock object.

import static org.mockito.Mockito.*;
import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.Test;

public class Exercise5Test {

    @Test
    public void testMultipleReturnValues() {
        // Step 1: Create a mock object for ExternalApi
        ExternalApi mockApi = mock(ExternalApi.class);

        // Step 2: Stub getData() to return different values on consecutive calls
        // First call  -> "First Call"
        // Second call -> "Second Call"
        // Third call  -> "Third Call"
        when(mockApi.getData())
                .thenReturn("First Call")
                .thenReturn("Second Call")
                .thenReturn("Third Call");

        // Step 3: Call the service method multiple times and check each result
        MyService service = new MyService(mockApi);

        assertEquals("First Call",  service.fetchData());
        assertEquals("Second Call", service.fetchData());
        assertEquals("Third Call",  service.fetchData());

        // After the last stubbed value, Mockito keeps returning the last value
        assertEquals("Third Call",  service.fetchData());

        // Verify the mock was called exactly 4 times in total
        verify(mockApi, times(4)).getData();
    }
}
