/**
 * Abstract decorator. Implements Notifier and wraps another Notifier,
 * delegating to it before/after adding its own behavior.
 */
public abstract class NotifierDecorator implements Notifier {
    protected final Notifier wrappedNotifier;

    protected NotifierDecorator(Notifier wrappedNotifier) {
        this.wrappedNotifier = wrappedNotifier;
    }

    @Override
    public void send(String message) {
        wrappedNotifier.send(message); // delegate first
    }
}
