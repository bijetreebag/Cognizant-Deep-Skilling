// Exercise1Test.java
// Exercise 1: Mocking and Stubbing
//
// Scenario:
// You need to test a service that depends on an external API.
// Use Mockito to mock the external API and stub its methods.
//
// Steps:
// 1. Create a mock object for the external API.
// 2. Stub the methods to return predefined values.
// 3. Write a test case that uses the mock object.

import static org.mockito.Mockito.*;
import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.Test;

public class Exercise1Test {

    @Test
    public void testExternalApi() {
        // Step 1: Create a mock object for ExternalApi
        ExternalApi mockApi = mock(ExternalApi.class);

        // Step 2: Stub the getData() method to return a predefined value
        when(mockApi.getData()).thenReturn("Mock Data");

        // Step 3: Inject the mock into MyService and call fetchData()
        MyService service = new MyService(mockApi);
        String result = service.fetchData();

        // Assert that the result matches the stubbed value
        assertEquals("Mock Data", result);
    }
}
