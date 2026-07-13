// Exercise6Test.java
// Exercise 6: Verifying Interaction Order
//
// Scenario:
// You need to ensure that methods are called in a specific order.
//
// Steps:
// 1. Create a mock object.
// 2. Call the methods in a specific order.
// 3. Verify the interaction order.

import static org.mockito.Mockito.*;
import static org.mockito.ArgumentMatchers.*;
import org.junit.jupiter.api.Test;
import org.mockito.InOrder;

public class Exercise6Test {

    @Test
    public void testInteractionOrder() {
        // Step 1: Create a mock object for ExternalApi
        ExternalApi mockApi = mock(ExternalApi.class);

        // Stub the methods
        when(mockApi.getData()).thenReturn("General Data");
        when(mockApi.getDataById(anyInt())).thenReturn("Data by ID");

        // Step 2: Call the methods in a specific order
        MyService service = new MyService(mockApi);
        service.fetchData();          // First call
        service.fetchDataById(10);    // Second call

        // Step 3: Use InOrder to verify the calls happened in the correct sequence
        InOrder inOrder = inOrder(mockApi);
        inOrder.verify(mockApi).getData();         // Must be called first
        inOrder.verify(mockApi).getDataById(10);   // Must be called second
    }

    @Test
    public void testInteractionOrderWithNotification() {
        ExternalApi mockApi = mock(ExternalApi.class);

        when(mockApi.getData()).thenReturn("Data");

        MyService service = new MyService(mockApi);

        // Perform two actions in order
        service.fetchData();
        service.sendNotification("Stock updated");

        // Verify the order: fetchData before sendNotification
        InOrder inOrder = inOrder(mockApi);
        inOrder.verify(mockApi).getData();
        inOrder.verify(mockApi).sendNotification("Stock updated");
    }
}
