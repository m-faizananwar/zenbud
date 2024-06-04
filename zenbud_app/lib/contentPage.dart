import 'package:Zenbud/ReminderListPage.dart';
import 'package:Zenbud/screens/home.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'ChatScreen.dart'; // Import the ChatbotPage widget
import 'MusicPlayer.dart'; // Import the MusicPlayerPage widget
import 'ProfilePage.dart';
import 'dashBoard.dart';
import 'pomodoro_clock.dart';
import 'screen_time.dart'; // Import the ScreenTimePage widget

class ContentPage extends StatefulWidget {
  const ContentPage({super.key});
  @override
  ContentPageState createState() => ContentPageState();
}

class ContentPageState extends State<ContentPage> {
  PageController pageController = PageController(initialPage: 2);
  int selectedIndex = 2;

  void changePage(int index) {
    setState(() {
      selectedIndex = index;
    });
    pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Row(
          children: [
            Column(
              children: [
                Text(
                  'ZenBud',
                  style: GoogleFonts.pacifico(
                    fontSize: 25,
                    color: Colors.grey,
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
              ],
            )
          ],
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(),
              child: Text(
                'Menu',
                style: GoogleFonts.raleway(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text(
                'Profile',
                style: GoogleFonts.raleway(),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Profile()),
                ); // Navigate to Profile
              },
            ),
            ListTile(
              leading: Icon(Icons.alarm),
              title: Text(
                'Reminders',
                style: GoogleFonts.raleway(),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReminderListPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.music_note),
              title: Text(
                'Music Player',
                style: GoogleFonts.raleway(),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MusicPlayerPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.timer),
              title: Text(
                'Pomodoro',
                style: GoogleFonts.raleway(),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Pomodoro()),
                );
              },
            ),
          ],
        ),
      ),
      body: PageView(
        controller: pageController,
        children: [
          AlarmPagee(),
          ReminderListPage(),
          DashBoard(),
          ChatScreen(),
          ScreenTimePage(),
        ],
        onPageChanged: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: selectedIndex,
        height: 55.0,
        items: <Widget>[
          Icon(Icons.alarm, size: 18),
          Icon(Icons.notifications_active_outlined, size: 18),
          Icon(Icons.dashboard, size: 18),
          Icon(Icons.message, size: 18),
          Icon(Icons.grading_sharp, size: 18),
        ],
        color: Color(0xFF141218),
        backgroundColor: Colors.black54,
        animationDuration: Duration(milliseconds: 250),
        onTap: (index) {
          changePage(index);
        },
        letIndexChange: (index) => true,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Automatically redirect to the first option of navigation bar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        selectedIndex = 2;
      });
    });
  }
}
