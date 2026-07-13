/** View: knows how to render a Student, has no direct knowledge of the Model's internals beyond what's passed in. */
public class StudentView {
    public void displayStudentDetails(String name, String id, String grade) {
        System.out.println("---- Student Record ----");
        System.out.println("ID:    " + id);
        System.out.println("Name:  " + name);
        System.out.println("Grade: " + grade);
        System.out.println("-------------------------");
    }
}
