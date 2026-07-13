public class CommandTest {
    public static void main(String[] args) {
        Light livingRoomLight = new Light("Living Room");
        Light bedroomLight = new Light("Bedroom");

        Command livingRoomOn = new LightOnCommand(livingRoomLight);
        Command livingRoomOff = new LightOffCommand(livingRoomLight);
        Command bedroomOn = new LightOnCommand(bedroomLight);

        RemoteControl remote = new RemoteControl();

        remote.setCommand(livingRoomOn);
        remote.pressButton();

        remote.setCommand(bedroomOn);
        remote.pressButton();

        remote.setCommand(livingRoomOff);
        remote.pressButton();

        System.out.println("\nUndoing last action:");
        remote.pressUndo(); // undoes livingRoomOff -> turns living room light back on
    }
}
