import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

List<String> motivationalQuotes = [
  "The only way to do great work is to love what you do. - Steve Jobs",
  "Success is not the key to happiness. Happiness is the key to success. - Albert Schweitzer",
  "The future belongs to those who believe in the beauty of their dreams. - Eleanor Roosevelt",
  "Don't watch the clock; do what it does. Keep going. - Sam Levenson",
  "Keep your face always toward the sunshine—and shadows will fall behind you. - Walt Whitman",
  "The only limit to our realization of tomorrow is our doubts of today. - Franklin D. Roosevelt",
  "Act as if what you do makes a difference. It does. - William James",
  "Success usually comes to those who are too busy to be looking for it. - Henry David Thoreau",
  "Don't be afraid to give up the good to go for the great. - John D. Rockefeller",
  "I find that the harder I work, the more luck I seem to have. - Thomas Jefferson",
  "Your time is limited, so don't waste it living someone else's life. - Steve Jobs",
  "The best time to plant a tree was 20 years ago. The second best time is now. - Chinese Proverb",
  "You miss 100% of the shots you don’t take. - Wayne Gretzky",
  "It does not matter how slowly you go as long as you do not stop. - Confucius",
  "Believe you can and you're halfway there. - Theodore Roosevelt",
  "The harder you work for something, the greater you'll feel when you achieve it. - Michael Jordan",
  "Dream bigger. Do bigger. - Serena Williams",
  "Don’t stop when you’re tired. Stop when you’re done. - David Goggins",
  "Wake up with determination. Go to bed with satisfaction. - Dwayne Johnson",
  "Do something today that your future self will thank you for. - Sean Patrick Flanery",
  "Little things make big days. - Isabel Marant",
  "It's going to be hard, but hard does not mean impossible. - Roger Federer",
  "Don't wait for opportunity. Create it. - George Bernard Shaw",
  "Sometimes we're tested not to show our weaknesses, but to discover our strengths. - Arnold Schwarzenegger",
  "The key to success is to focus on goals, not obstacles. - Tony Robbins",
  "Dream it. Wish it. Do it. - Richard Branson",
  "Great things never come from comfort zones. - Neale Donald Walsch",
  "Success doesn't just find you. You have to go out and get it. - Amelie Mauresmo",
  "The harder you work for something, the greater you'll feel when you achieve it. - Michael Phelps",
  "Dream bigger. Do bigger. - Oprah Winfrey",
  "Don't stop when you're tired. Stop when you're done. - Ronda Rousey",
  "Wake up with determination. Go to bed with satisfaction. - LeBron James",
  "Do something today that your future self will thank you for. - Jim Kwik",
  "Little things make big days. - Maria Sharapova",
  "It's going to be hard, but hard does not mean impossible. - Kobe Bryant",
  "Don't wait for opportunity. Create it. - Chris Gardner",
  "Sometimes we're tested not to show our weaknesses, but to discover our strengths. - Michael Jordan",
  "The key to success is to focus on goals, not obstacles. - Tony Robbins",
  "Dream it. Wish it. Do it. - Richard Branson",
  "Great things never come from comfort zones. - Neale Donald Walsch",
  "Success doesn't just find you. You have to go out and get it. - Amelie Mauresmo",
  "The harder you work for something, the greater you'll feel when you achieve it. - Michael Phelps",
  "Dream bigger. Do bigger. - Oprah Winfrey",
  "Don't stop when you're tired. Stop when you're done. - Ronda Rousey",
  "Wake up with determination. Go to bed with satisfaction. - LeBron James",
  "Do something today that your future self will thank you for. - Jim Kwik",
  "Little things make big days. - Maria Sharapova",
  "It's going to be hard, but hard does not mean impossible. - Kobe Bryant",
  "Don't wait for opportunity. Create it. - Chris Gardner",
  "Sometimes we're tested not to show our weaknesses, but to discover our strengths. - Arnold Schwarzenegger",
  "The key to success is to focus on goals, not obstacles. - Tony Robbins",
];

class Quote extends Card {
  // Use the current date as a seed for the random number generator
  int seed = DateTime.now().year * 10000 + DateTime.now().month * 100 + DateTime.now().day;
  late Random random;

  Quote() {
    random = Random(seed);
  }




  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: 370,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Quote of the day',
                style: GoogleFonts.outfit(fontSize: 20, color: Colors.grey),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                motivationalQuotes[random.nextInt(motivationalQuotes.length)],
                style: GoogleFonts.raleway(fontSize: 15, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
