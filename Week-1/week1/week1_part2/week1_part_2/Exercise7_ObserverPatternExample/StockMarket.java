import java.util.ArrayList;
import java.util.List;

/** Concrete subject: tracks a stock's price and notifies observers of changes. */
public class StockMarket implements Stock {
    private final List<Observer> observers = new ArrayList<>();
    private final String symbol;
    private double price;

    public StockMarket(String symbol, double initialPrice) {
        this.symbol = symbol;
        this.price = initialPrice;
    }

    @Override
    public void registerObserver(Observer observer) {
        observers.add(observer);
    }

    @Override
    public void deregisterObserver(Observer observer) {
        observers.remove(observer);
    }

    @Override
    public void notifyObservers() {
        for (Observer observer : observers) {
            observer.update(symbol, price);
        }
    }

    /** Business logic: updating the price triggers notifications. */
    public void setPrice(double newPrice) {
        System.out.println("\n" + symbol + " price changed: " + price + " -> " + newPrice);
        this.price = newPrice;
        notifyObservers();
    }
}
