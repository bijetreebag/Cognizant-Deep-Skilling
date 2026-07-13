public class BuilderTest {
    public static void main(String[] args) {
        Computer basic = new Computer.Builder("Intel i3", "8GB")
                .build();
        System.out.println("Basic config:  " + basic);

        Computer gamingRig = new Computer.Builder("Intel i9", "32GB")
                .storage("2TB NVMe SSD")
                .gpu("NVIDIA RTX 4090")
                .wifi(true)
                .bluetooth(true)
                .build();
        System.out.println("Gaming rig:    " + gamingRig);

        Computer office = new Computer.Builder("AMD Ryzen 5", "16GB")
                .storage("512GB SSD")
                .wifi(true)
                .build();
        System.out.println("Office config: " + office);
    }
}
