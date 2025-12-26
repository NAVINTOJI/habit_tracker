import 'dart:math';

class QuoteService {
  static final List<String> _quotes = [
    "I'm gonna be King of the Pirates!",
    "Power isn't determined by your size, but the size of your heart and dreams!",
    "If you don't take risks, you can't create a future!",
    "I don't want to conquer anything. I just think the guy with the most freedom in this whole ocean is the Pirate King!",
    "Forgetting is like a wound. The wound may heal, but it has already left a scar.",
    "When do you think people die? When they are shot through the heart by the bullet of a pistol? No. When they are ravaged by an incurable disease? No. When they drink a soup made from a poisonous mushroom!? No! It's when... they are forgotten.",
    "The world isn't perfect. But it's there for us, doing the best it can; that's what makes it so damn beautiful.",
    "Discipline is choosing between what you want now and what you want most.",
    "Success is nothing more than a few simple disciplines, practiced every day.",
    "Motivation is what gets you started. Habit is what keeps you going.",
    "Your future is created by what you do today, not tomorrow.",
    "The only way to do great work is to love what you do.",
    "Don't watch the clock; do what it does. Keep going.",
    "The harder you work for something, the greater you'll feel when you achieve it.",
    "Dream bigger. Do bigger.",
    "Don't stop when you're tired. Stop when you're done.",
    "Wake up with determination. Go to bed with satisfaction.",
    "Do something today that your future self will thank you for.",
    "Little things make big days.",
    "It's going to be hard, but hard does not mean impossible.",
    "Don't wait for opportunity. Create it.",
    "Sometimes later becomes never. Do it now.",
    "Great things never come from comfort zones.",
    "Success doesn't just find you. You have to go out and get it.",
    "The key to success is to focus on goals, not obstacles.",
  ];

  String getRandomQuote() {
    final random = Random();
    return _quotes[random.nextInt(_quotes.length)];
  }

  String getMotivationalMessage(int streak) {
    if (streak == 0) {
      return "Every journey begins with a single step. Start your streak today! 🔥";
    } else if (streak < 7) {
      return "You're on fire! Keep the momentum going! 🔥";
    } else if (streak < 30) {
      return "Incredible discipline! You're building unstoppable habits! 💪";
    } else if (streak < 100) {
      return "Legendary dedication! You're becoming the best version of yourself! ⚡";
    } else {
      return "ABSOLUTE LEGEND! Your willpower is unbreakable! 👑";
    }
  }
}
