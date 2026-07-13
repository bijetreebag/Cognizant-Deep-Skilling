public class WebApp implements Observer {
    @Override
    public void update(String stockSymbol, double newPrice) {
        System.out.println("[WebApp] Dashboard updated: " + stockSymbol + " = $" + newPrice);
    }
}
