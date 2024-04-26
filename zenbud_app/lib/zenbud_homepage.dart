import 'package:flutter/material.dart';
import 'contentpage.dart';

void main() {
  runApp(const ZenbudHomePage());
}

class ZenbudHomePage extends StatelessWidget {
  const ZenbudHomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZenBud App',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto',
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto',
      ),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
    // Navigate to ContentPage after a certain duration
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ContentPage()),
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: const EdgeInsets.only(left: 16), // Adjust the left padding
          alignment: Alignment.centerLeft, // Align the title to the left
          child: const Text(
            "ZenBud",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20), // Add some space
            Image.asset(
              'assets/leaf.png',
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 10), // Add some space between image and text
            const Text(
              'Your Study Partner',
              style: TextStyle(
                color: Colors.blue, // Set the text color to blue
                fontSize: 30, // Set the font size
                fontWeight: FontWeight.bold, // Set the font weight
              ),
            ),
          ],
        ),
      ),
    );
  }
}
