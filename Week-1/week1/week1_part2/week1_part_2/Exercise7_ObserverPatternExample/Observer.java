/** Observer interface: anything that wants stock updates implements this. */
public interface Observer {
    void update(String stockSymbol, double newPrice);
}
