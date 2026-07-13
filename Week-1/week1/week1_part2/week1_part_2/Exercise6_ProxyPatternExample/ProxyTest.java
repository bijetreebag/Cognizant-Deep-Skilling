public class ProxyTest {
    public static void main(String[] args) {
        Image photo1 = new ProxyImage("vacation.jpg");
        Image photo2 = new ProxyImage("vacation.jpg"); // same file name

        System.out.println("First display of photo1:");
        photo1.display(); // loads from "server"

        System.out.println("\nSecond display of photo1 (should not reload):");
        photo1.display(); // no reload, uses realImage directly

        System.out.println("\nFirst display of photo2 (same file, different proxy):");
        photo2.display(); // hits the cache instead of hitting the "server" again
    }
}
