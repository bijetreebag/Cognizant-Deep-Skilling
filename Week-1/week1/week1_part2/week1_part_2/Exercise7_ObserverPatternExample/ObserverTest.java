public class ObserverTest {
    public static void main(String[] args) {
        StockMarket appleStock = new StockMarket("AAPL", 190.00);

        Observer mobile = new MobileApp("Aarya");
        Observer web = new WebApp();

        appleStock.registerObserver(mobile);
        appleStock.registerObserver(web);

        appleStock.setPrice(192.50); // both observers notified

        appleStock.deregisterObserver(web);
        appleStock.setPrice(188.75); // only mobile notified now
    }
}
