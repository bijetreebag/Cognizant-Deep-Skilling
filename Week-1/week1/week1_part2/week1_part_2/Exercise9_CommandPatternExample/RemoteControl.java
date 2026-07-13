import java.util.EmptyStackException;
import java.util.Stack;

/** Invoker: holds a command and triggers it, without knowing what it does. */
public class RemoteControl {
    private Command command;
    private final Stack<Command> history = new Stack<>();

    public void setCommand(Command command) {
        this.command = command;
    }

    public void pressButton() {
        if (command == null) {
            throw new IllegalStateException("No command set on the remote.");
        }
        command.execute();
        history.push(command);
    }

    public void pressUndo() {
        try {
            Command lastCommand = history.pop();
            lastCommand.undo();
        } catch (EmptyStackException e) {
            System.out.println("Nothing to undo.");
        }
    }
}
