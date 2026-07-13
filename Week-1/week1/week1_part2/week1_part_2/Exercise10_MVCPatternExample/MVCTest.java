public class MVCTest {
    public static void main(String[] args) {
        // Model
        Student student = new Student("Aarya", "S101", "B");

        // View
        StudentView view = new StudentView();

        // Controller ties Model and View together
        StudentController controller = new StudentController(student, view);

        System.out.println("Initial record:");
        controller.updateView();

        // Update details through the controller only
        controller.setStudentGrade("A");
        controller.setStudentName("Aarya Patil");

        System.out.println("\nAfter update:");
        controller.updateView();
    }
}
