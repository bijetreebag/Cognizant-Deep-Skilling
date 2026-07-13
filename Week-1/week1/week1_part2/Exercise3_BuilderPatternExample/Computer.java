/**
 * Computer.java
 * The complex "product" being built. Has a private constructor that only
 * accepts a Builder, forcing all construction through Computer.Builder.
 */
public class Computer {
    // Required
    private final String cpu;
    private final String ram;
    // Optional
    private final String storage;
    private final String gpu;
    private final boolean hasWifi;
    private final boolean hasBluetooth;

    private Computer(Builder builder) {
        this.cpu = builder.cpu;
        this.ram = builder.ram;
        this.storage = builder.storage;
        this.gpu = builder.gpu;
        this.hasWifi = builder.hasWifi;
        this.hasBluetooth = builder.hasBluetooth;
    }

    @Override
    public String toString() {
        return "Computer{" +
                "cpu='" + cpu + '\'' +
                ", ram='" + ram + '\'' +
                ", storage='" + storage + '\'' +
                ", gpu='" + gpu + '\'' +
                ", hasWifi=" + hasWifi +
                ", hasBluetooth=" + hasBluetooth +
                '}';
    }

    /** Static nested Builder class. */
    public static class Builder {
        private final String cpu;
        private final String ram;
        private String storage = "256GB SSD"; // sensible default
        private String gpu = "Integrated Graphics";
        private boolean hasWifi = false;
        private boolean hasBluetooth = false;

        // CPU and RAM are required, so they're passed into the Builder's constructor
        public Builder(String cpu, String ram) {
            this.cpu = cpu;
            this.ram = ram;
        }

        public Builder storage(String storage) {
            this.storage = storage;
            return this;
        }

        public Builder gpu(String gpu) {
            this.gpu = gpu;
            return this;
        }

        public Builder wifi(boolean hasWifi) {
            this.hasWifi = hasWifi;
            return this;
        }

        public Builder bluetooth(boolean hasBluetooth) {
            this.hasBluetooth = hasBluetooth;
            return this;
        }

        public Computer build() {
            return new Computer(this);
        }
    }
}
