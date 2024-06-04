import 'package:Zenbud/Quran/screens/home_screen.dart';
import 'package:flutter/material.dart';

class Quran extends StatelessWidget {
  int? index;
  late Function(int) changeIndex;
  Quran({required Function(int) changeindex}) {
    changeIndex = changeindex;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: HomeScreen(),
    );
  }
}
