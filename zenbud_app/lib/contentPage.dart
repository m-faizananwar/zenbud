import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'alarm.dart'; // Import the AlarmClockPage widget
import 'chatbot.dart'; // Import the ChatbotPage widget
import 'reminder.dart'; // Import the RemindersPage widget
import 'musicPlayer.dart'; // Import the MusicPlayerPage widget

class ContentPage extends StatefulWidget {
  const ContentPage({super.key});
  @override
  _ContentPageState createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Content Page'),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          AlarmPage(),
          Chatbotpage(),
          RemindersPage(),
          MusicPlayerPage(),
        ],
      ),
      bottomNavigationBar: GNav(
        gap: 4,
        activeColor: Colors.white,
        iconSize: 24,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        duration: const Duration(milliseconds: 800),
        tabBackgroundColor: Colors.lightBlueAccent,
        tabs: const [
          GButton(
            icon: Icons.alarm,
            text: 'Alarm Clock',
          ),
          GButton(
            icon: Icons.chat,
            text: 'Chatbot',
          ),
          GButton(
            icon: Icons.book,
            text: 'Reminders',
          ),
          GButton(
            icon: Icons.music_note_sharp,
            text: 'Music Player',
          ),
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
