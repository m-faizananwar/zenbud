import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:oops_1/screens/home.dart';

import 'ChatScreen.dart'; // Import the ChatbotPage widget
import 'MusicPlayer.dart'; // Import the MusicPlayerPage widget
import 'pomodoro_clock.dart';
import 'screen_time.dart'; // Import the ScreenTimePage widget

class ContentPage extends StatefulWidget {
  const ContentPage({super.key});
  @override
  ContentPageState createState() => ContentPageState();
}

class ContentPageState extends State<ContentPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zenbud'),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          AlarmPagee(),
          ChatScreen(),
          Pomodoro(),
          MusicPlayerPage(),
          ScreenTimePage(),
        ],
      ),
      bottomNavigationBar: GNav(
        gap: 2,
        activeColor: Colors.white,
        iconSize: 14,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        duration: const Duration(milliseconds: 400),
        tabBackgroundColor: Colors.lightBlueAccent,
        tabs: const [
          GButton(
            icon: Icons.alarm,
            text: 'Alarm Clock',
            textStyle: TextStyle(fontSize: 11),
          ),
          GButton(icon: Icons.chat, text: 'Chatbot', textStyle: TextStyle(fontSize: 11)),
          GButton(icon: Icons.book, text: 'Reminders', textStyle: TextStyle(fontSize: 11)),
          GButton(icon: Icons.music_note_sharp, text: 'Music Player', textStyle: TextStyle(fontSize: 11)),
          GButton(icon: Icons.grading, text: 'Screen Time', textStyle: TextStyle(fontSize: 11)),
        ],
        selectedIndex: _selectedIndex,
        onTabChange: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Automatically redirect to the first option of navigation bar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _selectedIndex = 0;
      });
    });
  }
}
