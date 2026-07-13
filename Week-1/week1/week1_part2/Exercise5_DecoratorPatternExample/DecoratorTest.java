public class DecoratorTest {
    public static void main(String[] args) {
        System.out.println("-- Email only --");
        Notifier emailOnly = new EmailNotifier();
        emailOnly.send("Server maintenance at 10 PM.");

        System.out.println("\n-- Email + SMS --");
        Notifier emailAndSms = new SMSNotifierDecorator(new EmailNotifier());
        emailAndSms.send("Your order has shipped.");

        System.out.println("\n-- Email + SMS + Slack --");
        Notifier allChannels = new SlackNotifierDecorator(
                new SMSNotifierDecorator(
                        new EmailNotifier()));
        allChannels.send("Production incident detected!");
    }
}
